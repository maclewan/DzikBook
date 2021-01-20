from unittest import mock

import requests
from django.contrib.auth.models import User
from django.test import TestCase, LiveServerTestCase
from django.urls import reverse
from rest_framework.test import RequestsClient, APITestCase
from rest_framework.test import APIClient
import uuid
from .decorators import hash_user
from .models import Comment, Reaction
from .serializers import CommentSerializer, ReactionSerializer

from collections import OrderedDict
import json


# Create your tests here.

##################
## models tests ##
##################

class CommentTestCase(TestCase):

    def setUp(self):
        author = User.objects.create(username="test_user", password="test_password")
        self.data = {
            "post": uuid.uuid4(),
            "author": author.id,
            "content": "content"
        }
        self.comment = Comment.objects.create(**self.data)

    def tearDown(self):
        User.objects.all().delete()

        for comment in Comment.objects.all():
            comment.delete()

    def test_create_comment(self):
        self.assertTrue(isinstance(self.comment, Comment))
        self.assertTrue(self.comment.post == self.data['post']
                        and isinstance(self.comment.author, int)
                        and self.comment.content == "content")


class ReactionTestCase(TestCase):

    def setUp(self):
        giver = User.objects.create(username="test_user", password="test_password")
        self.data = {
            "post": uuid.uuid4(),
            "giver": giver.id
        }
        self.reaction = Reaction.objects.create(**self.data)

    def tearDown(self):
        User.objects.all().delete()
        for reaction in Reaction.objects.all():
            reaction.delete()

    def test_create_reaction(self):
        self.assertTrue(isinstance(self.reaction, Reaction))
        self.assertTrue(isinstance(self.reaction.giver, int))


#######################
## serializers tests ##
#######################

class CommentSerializerTestCase(TestCase):

    def setUp(self):
        author = User.objects.create(username="test_user", password="test_password")
        self.data = {
            "post": uuid.uuid1(),
            "author": author.id,
            "content": "content"
        }
        self.comment = Comment.objects.create(**self.data)

    def tearDown(self):
        User.objects.all().delete()
        for comment in Comment.objects.all():
            comment.delete()

    def test_translation(self):
        serializer = CommentSerializer
        self.assertEqual(serializer(self.comment).data, {'comment_id': str(self.comment.id), 'author': 1,
                                                         'post': str(self.data['post']), 'content': 'content'})

    def test_creation(self):
        serializer = CommentSerializer()
        author = User.objects.create(username="test_user2", password="test_password")
        self.data = {
            "post": uuid.uuid4(),
            "author": author.id,
            "content": "test_content"
        }
        comment = serializer.create(validated_data=self.data)
        self.assertTrue(isinstance(comment, Comment))
        self.assertEquals(str(comment.post), str(self.data['post']))
        self.assertTrue(isinstance(comment.author, int))
        self.assertEquals(comment.content, "test_content")

    def test_update(self):
        serializer = CommentSerializer()
        comment = self.comment
        data = {
            "post": uuid.uuid4(),
            "content": "test_content",
        }
        comment = serializer.update(comment, validated_data=data)
        self.assertNotEqual(comment.post, data['post'])
        self.assertTrue(isinstance(comment.author, int))
        self.assertEquals(comment.content, "test_content")


class ReactionSerializerTestCase(TestCase):

    def setUp(self):
        self.giver = User.objects.create(username="test_user", password="test_password")
        data = {
            "post": uuid.uuid4(),
            "giver": self.giver.id,
        }
        self.reaction = Reaction.objects.create(**data)

    def tearDown(self):
        User.objects.all().delete()

        for reaction in Reaction.objects.all():
            reaction.delete()

    def test_translation(self):
        serializer = ReactionSerializer
        self.assertEqual(serializer(self.reaction).data, {'user_id': self.giver.id})

    def test_creation(self):
        serializer = ReactionSerializer()
        giver = User.objects.create(username="test_user2", password="test_password")
        data = {
            "post": uuid.uuid4(),
            "giver": giver.id,
        }
        reaction = serializer.create(validated_data=data)
        self.assertTrue(isinstance(reaction, Reaction))
        self.assertEquals(reaction.post, data['post'])
        self.assertTrue(isinstance(reaction.giver, int))


#################
## views tests ##
#################

class ReactionsViewTestCase(LiveServerTestCase):
    port = 8081
    server_host = "localhost:" + str(port)

    def setUp(self):
        self.server_host = ReactionsViewTestCase.server_host
        self.client = APIClient()
        self.user1 = User.objects.create(username='user1', password='user1')
        self.user2 = User.objects.create(username='user2', password='user2')
        self.client.credentials(HTTP_Uid=str(self.user1.id), HTTP_Flag=hash_user(self.user1.id))

        post1_id = uuid.uuid4()
        post2_id = uuid.uuid4()
        self.reaction1 = Reaction.objects.create(**{'post': post1_id, 'giver': self.user2.id})
        self.reaction2 = Reaction.objects.create(**{'post': post1_id, 'giver': self.user1.id})
        self.reaction3 = Reaction.objects.create(**{'post': post2_id, 'giver': self.user2.id})

    def tearDown(self):
        for reaction in Reaction.objects.all():
            reaction.delete()
        User.objects.all().delete()

    def test_reactions_get(self):
        # Positive case
        url = reverse('reactions', args=[self.reaction1.post])
        response = self.client.get(url, format='json')
        response_json = response.json()
        self.assertTrue(len(response_json), 2)
        self.assertIn({'user_id': self.user2.id}, response_json)
        self.assertIn({'user_id': self.user1.id}, response_json)

    def test_reactions_post(self):
        # Positive case
        url = reverse('reactions', args=[self.reaction3.post])
        response = self.client.post(url)
        self.assertEqual(response.data, {'user_id': self.user1.id})
        # Negative case
        url = reverse('reactions', args=[self.reaction1.post])
        response = self.client.post(url)
        self.assertEqual(response.data, 'Reaction already exists!')

    def test_reactions_delete(self):
        # Positive case
        url = reverse('reactions', args=[self.reaction1.post])
        response = self.client.delete(url)
        self.assertEqual(response.data, {"message": "Reaction deleted"})
        # Negative case
        url = reverse('reactions', args=[self.reaction1.post])
        response = self.client.delete(url)
        self.assertEqual(response.data, "Reaction doesn't exist!")


# post_comments
class CommentsViewTestCase(LiveServerTestCase):
    port = 8081
    server_host = "localhost:" + str(port)

    def setUp(self):
        self.server_host = ReactionsViewTestCase.server_host
        self.client = APIClient()
        self.user1 = User.objects.create(username='user1', password='user1')
        self.user2 = User.objects.create(username='user2', password='user2')
        self.client.credentials(HTTP_Uid=str(self.user1.id), HTTP_Flag=hash_user(self.user1.id))

        post1_id = uuid.uuid4()
        post2_id = uuid.uuid4()
        self.comment1 = Comment.objects.create(**{'post': post1_id, 'author': self.user2.id, 'content': "comment1"})
        self.comment2 = Comment.objects.create(**{'post': post1_id, 'author': self.user1.id, 'content': "comment2"})
        self.comment3 = Comment.objects.create(**{'post': post2_id, 'author': self.user2.id, 'content': "comment3"})

    def tearDown(self):
        for comment in Comment.objects.all():
            comment.delete()
        User.objects.all().delete()

    def test_post_comments_get(self):
        url = reverse('post_comments', args=[self.comment1.post])
        response = self.client.get(url, format='json')
        # Convert ordered dict to dict
        self.maxDiff = None
        self.assertListEqual(response.json(),
                             [
                                 {'comment_id': str(self.comment1.id), 'author': self.comment1.author,
                                  'post': self.comment1.post, 'content': self.comment1.content},
                                 {'comment_id': str(self.comment2.id), 'author': self.comment2.author,
                                  'post': self.comment2.post, 'content': self.comment2.content}
                             ]
                             )
#
    def test_post_comments_post(self):
        url = reverse('post_comments', args=[self.comment1.post])
        test_context = 'test post'
        # Ony context should matter
        data = {
            'content': test_context,
            'post': uuid.uuid4(),
            'author': self.user1.id
            }
        response = self.client.post(url, data)
        self.assertEqual(response.data, {'comment_id': mock.ANY, 'author': str(self.user1.id), 'post': dat['post'], 'content': test_context})
#
#     def test_comments_management_put(self):
#         # Positive case
#         url = reverse('comments_management', args=[self.comment2.id])
#         test_context = "test put"
#         # Ony context should matter
#         data = {
#             'content': test_context,
#             'post': self.comment2.post + 1,
#             'author': self.user1.id - 1
#             }
#         response = self.client.put(url, data)
#         self.assertEqual(response.data, {'comment_id': self.comment2.id, 'author': self.user1.id, 'post': self.comment2.post, 'content': test_context})
#         # Negative case, sign in user not an author
#         url = reverse('comments_management', args=[self.comment1.id])
#         response = self.client.put(url, data)
#         self.assertEqual(response.data, "Comment doesn't exist!")
#
#     def test_comments_management_delete(self):
#         # Negative case one, comment doesn't exists
#         url = reverse('comments_management', args=[0])
#         response = self.client.delete(url)
#         self.assertEqual(response.data, "Comment doesn't exist!")
#         self.assertEqual(response.status_code, 404)
#         # Negative case two, sign in user not an author
#         url = reverse('comments_management', args=[self.comment1.id])
#         response = self.client.delete(url)
#         self.assertEqual(response.data, "Comment doesn't exist!")
#         self.assertEqual(response.status_code, 404)
#         # Positive case
#         url = reverse('comments_management', args=[self.comment2.id])
#         response = self.client.delete(url)
#         self.assertEqual(response.data, {'message': 'Comment deleted'})
