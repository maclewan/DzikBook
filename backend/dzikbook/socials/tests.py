from unittest import mock

import requests
from django.contrib.auth.models import User
from django.test import TestCase, LiveServerTestCase
from django.urls import reverse
from rest_framework.test import RequestsClient, APITestCase
from rest_framework.test import APIClient

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
        data = {
            "post":5,
            "author":author,
            "content":"content"
        }
        self.comment = Comment.objects.create(**data)

    def tearDown(self):
        User.objects.all().delete()
        Comment.objects.all().delete()

    def test_create_comment(self):
        self.assertTrue(isinstance(self.comment, Comment))
        self.assertTrue(self.comment.post == 5 and isinstance(self.comment.author, User) and self.comment.content == "content")


class ReactionTestCase(TestCase):

    def setUp(self):
        giver = User.objects.create(username="test_user", password="test_password")
        data = {
            "post":5,
            "giver":giver
        }
        Reaction.objects.create(**data)

    def tearDown(self):
        User.objects.all().delete()
        Reaction.objects.all().delete()

    def test_create_reaction(self):
        reaction = Reaction.objects.get(pk=1)
        self.assertTrue(isinstance(reaction, Reaction))
        self.assertTrue(reaction.post == 5 and isinstance(reaction.giver, User))


#######################
## serializers tests ##
#######################

class CommentSerializerTestCase(TestCase):

    def setUp(self):
        author = User.objects.create(username="test_user", password="test_password")
        data = {
            "post":5,
            "author":author,
            "content":"content"
        }
        Comment.objects.create(**data)
    
    def tearDown(self):
        User.objects.all().delete()
        Comment.objects.all().delete()

    def test_translation(self):
        comment = Comment.objects.get(pk=1)
        serializer = CommentSerializer
        self.assertEqual(serializer(comment).data, {'comment_id': 1, 'author': 1, 'post': 5, 'content': 'content'})

    def test_creation(self):
        serializer = CommentSerializer()
        author = User.objects.create(username="test_user2", password="test_password")
        data = {
            "post":3,
            "author":author,
            "content":"test_content"
        }
        comment = serializer.create(validated_data=data)
        self.assertTrue(isinstance(comment, Comment))
        self.assertTrue(comment.post == 3 and isinstance(comment.author, User) and comment.content == "test_content")
    
    def test_update(self):
        serializer = CommentSerializer()
        comment = Comment.objects.get(pk=1)
        data = {
            "post":3,
            "content":"test_content"
        }
        comment = serializer.update(comment, validated_data=data)
        self.assertTrue(comment.post == 5 and isinstance(comment.author, User) and comment.content == "test_content")


class ReactionSerializerTestCase(TestCase):
    
    def setUp(self):
        giver = User.objects.create(username="test_user", password="test_password")
        data = {
            "post":5,
            "giver":giver
        }
        Reaction.objects.create(**data)
    
    def tearDown(self):
        User.objects.all().delete()
        Reaction.objects.all().delete()

    def test_translation(self):
        reaction = Reaction.objects.get(pk=1)
        serializer = ReactionSerializer
        self.assertEqual(serializer(reaction).data, {'user_id':1})

    def test_creation(self):
        serializer = ReactionSerializer()
        giver = User.objects.create(username="test_user2", password="test_password")
        data = {
            "post":3,
            "giver":giver,
        }
        reaction = serializer.create(validated_data=data)
        self.assertTrue(isinstance(reaction, Reaction))
        self.assertTrue(reaction.post == 3 and isinstance(reaction.giver, User))


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

        self.reaction1 = Reaction.objects.create(**{'post': 1, 'giver': self.user2})
        self.reaction2 = Reaction.objects.create(**{'post': 1, 'giver': self.user1})
        self.reaction3 = Reaction.objects.create(**{'post': 2, 'giver': self.user2})

    def tearDown(self):
        Reaction.objects.all().delete()
        User.objects.all().delete()
    
    def test_reactions_get(self):
        # Positive case
        url = reverse('reactions', args=[self.reaction1.post])
        response = self.client.get(url, format='json')
        self.assertListEqual(response.data, [OrderedDict([('user_id', self.user2.id)]), OrderedDict([('user_id', self.user1.id)])])

    def test_reactions_post(self):
        # Positive case
        url = reverse('reactions', args=[self.reaction3.post])
        response = self.client.post(url)
        self.assertEqual(response.data, {'user_id': str(self.user1.id)})
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

        self.comment1 = Comment.objects.create(**{'post': 1, 'author': self.user2, 'content': "comment1"})
        self.comment2 = Comment.objects.create(**{'post': 1, 'author': self.user1, 'content': "comment2"})
        self.comment3 = Comment.objects.create(**{'post': 2, 'author': self.user2, 'content': "comment3"})

    def tearDown(self):
        Comment.objects.all().delete()
        User.objects.all().delete()

    def test_post_comments_get(self):
        url = reverse('post_comments', args=[self.comment1.post])
        response = self.client.get(url, format='json')
        # Convert ordered dict to dict
        self.assertListEqual(json.loads(json.dumps(response.data)), 
        [
            {'comment_id': self.comment1.id, 'author': self.comment1.author.id, 'post': self.comment1.post, 'content': self.comment1.content},
            {'comment_id': self.comment2.id, 'author': self.comment2.author.id, 'post': self.comment2.post, 'content': self.comment2.content}
        ]
        )
    
    def test_post_comments_post(self):
        url = reverse('post_comments', args=[self.comment1.post])
        test_context = 'test post'
        # Ony context should matter
        data = {
            'content': test_context,
            'post': self.comment1.post + 1,
            'author': self.user1.id - 1
            }
        response = self.client.post(url, data)
        self.assertEqual(response.data, {'comment_id': mock.ANY, 'author': str(self.user1.id), 'post': self.comment1.post, 'content': test_context})

    def test_comments_management_put(self):
        # Positive case
        url = reverse('comments_management', args=[self.comment2.id])
        test_context = "test put"
        # Ony context should matter
        data = {
            'content': test_context,
            'post': self.comment2.post + 1,
            'author': self.user1.id - 1
            }
        response = self.client.put(url, data)
        self.assertEqual(response.data, {'comment_id': self.comment2.id, 'author': self.user1.id, 'post': self.comment2.post, 'content': test_context})
        # Negative case, sign in user not an author
        url = reverse('comments_management', args=[self.comment1.id])
        response = self.client.put(url, data)
        self.assertEqual(response.data, "Comment doesn't exist!")

    def test_comments_management_delete(self):
        # Negative case one, comment doesn't exists
        url = reverse('comments_management', args=[0])
        response = self.client.delete(url)
        self.assertEqual(response.data, "Comment doesn't exist!")
        self.assertEqual(response.status_code, 404)
        # Negative case two, sign in user not an author
        url = reverse('comments_management', args=[self.comment1.id])
        response = self.client.delete(url)
        self.assertEqual(response.data, "Comment doesn't exist!")
        self.assertEqual(response.status_code, 404)
        # Positive case
        url = reverse('comments_management', args=[self.comment2.id])
        response = self.client.delete(url)
        self.assertEqual(response.data, {'message': 'Comment deleted'})
