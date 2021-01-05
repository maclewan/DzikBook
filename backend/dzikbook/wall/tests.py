from collections import OrderedDict

from django.test import TestCase, Client, LiveServerTestCase
from rest_framework_simplejwt.tokens import Token

from .models import Post
from django.contrib.auth.models import User
from .serializers import PostSerializer
from django.urls import reverse
import unittest.mock as mock
from rest_framework.test import APIRequestFactory, APITestCase, APIClient


# Create your tests here.

##################
## models tests ##
##################

class PostTestCase(TestCase):

    def setUp(self):
        self.author = User.objects.create(username="test_user", password="test_password")
        data = {
            "author": self.author,
            "description": "description",
            "type": "media",
            "photo": "photo_url",
            "additional_data": "additional_data",
        }
        self.post = Post.objects.create(**data)

    def tearDown(self):
        Post.objects.all().delete()

    def test_post_create(self):
        self.assertTrue(isinstance(self.post, Post))
        self.assertEqual(self.post.author, self.author)
        self.assertEqual(self.post.description, "description")
        self.assertEqual(self.post.type, "media")
        self.assertEqual(self.post.photo, "photo_url")
        self.assertEqual(self.post.additional_data, "additional_data")
        self.assertEqual(self.post.visibility, True)

    def test_post_update(self):
        self.post.description = "description_updated"
        self.post.type = "text"
        self.post.photo = "photo_url_updated"
        self.post.additional_data = "additional_data_updated"
        starting_timestamp = self.post.timestamp

        self.assertNotEqual(self.post.description, "description")
        self.assertNotEqual(self.post.type, "media")
        self.assertNotEqual(self.post.photo, "photo_url")
        self.assertNotEqual(self.post.additional_data, "additional_data")

        self.assertEqual(self.post.description, "description_updated")
        self.assertEqual(self.post.type, "text")
        self.assertEqual(self.post.photo, "photo_url_updated")
        self.assertEqual(self.post.additional_data, "additional_data_updated")

        self.assertEqual(self.post.timestamp, starting_timestamp)  # timestamp shouldnt update

    def test_post_delete(self):
        id = self.post.id
        self.post.delete()
        self.assertFalse(Post.objects.filter(id=id).exists())


#######################
## serializers tests ##
#######################

class PostSerializerTestCase(TestCase):
    def setUp(self):
        self.author = User.objects.create(username="test_user", password="test_password")
        data = {
            "author": self.author,
            "description": "description",
            "type": "media",
            "photo": "photo_url",
            "additional_data": "additional_data",
        }
        self.post = Post.objects.create(**data)

    def tearDown(self):
        Post.objects.all().delete()

    def test_post_serializer_parse(self):
        serializer = PostSerializer(self.post)

        self.assertDictEqual(serializer.data, {'post_id': self.post.id,
                                               'author': self.author.id,
                                               'description': 'description',
                                               'additional_data': "additional_data",
                                               'visibility': True,
                                               'photo': "photo_url",
                                               'type': 'media',
                                               'timestamp': mock.ANY})

    def test_post_serializer_update(self):
        new_data = {
            "author": self.author,
            "description": "description_updated",
            "visibility": True,
            "type": "text",
            "photo": "photo_url_updated",
            "additional_data": "additional_data_updated",
        }
        starting_timestamp = self.post.timestamp

        serializer = PostSerializer(data=new_data)
        self.assertTrue(serializer.is_valid(raise_exception=True))

        serializer.update(instance=self.post, validated_data=new_data)
        updated_serializer = PostSerializer(self.post)

        self.assertNotEqual(updated_serializer.data,
                            {
                                'post_id': self.post.id,
                                'author': self.author.id,
                                'description': 'description',
                                'additional_data': "additional_data",
                                'visibility': True,
                                'photo': "photo_url",
                                'type': 'media',
                                'timestamp': mock.ANY
                            })

        self.assertEqual(updated_serializer.data,
                         {
                             'post_id': self.post.id,
                             'author': self.author.id,
                             'description': 'description_updated',
                             'additional_data': "additional_data_updated",
                             'visibility': True,
                             'photo': "photo_url_updated",
                             'type': 'media',  # this cant be changed
                             'timestamp': mock.ANY,
                         })

        self.assertEqual(self.post.timestamp, starting_timestamp)  # timestamp shouldnt update


#######################
## views tests ##
#######################
def mocked_requests_friendslist(*args):
    return {'friends_list': [2]}


class PostViewTestCase(LiveServerTestCase):
    port = 8081

    def setUp(self):
        self.client = APIClient()
        self.user1 = User.objects.create(username="user1", password="user1")
        self.user2 = User.objects.create(username="user2", password="user2")
        self.user3 = User.objects.create(username="user3", password="user3")
        self.client.force_authenticate(user=self.user1)

        data = {
            "author": self.user1,
            "description": "description",
            "type": "text",
        }
        self.post1 = Post.objects.create(**data)
        data["author"] = self.user2
        self.post2 = Post.objects.create(**data)
        data["author"] = self.user3
        self.post3 = Post.objects.create(**data)

    def tearDown(self):
        Post.objects.all().delete()
        User.objects.all().delete()

    @mock.patch('wall.constants.SERVER_HOST', "localhost:" + str(port))
    def test_sig_in_user_posts_list(self):
        url = reverse('sig_in_user_posts_list')
        response = self.client.get(url, format='json')
        self.assertDictEqual(dict(response.data[0]), {'post_id': self.post1.id,
                                                      'author': self.user1.id,
                                                      'description': 'description',
                                                      'additional_data': None,
                                                      'visibility': True,
                                                      'photo': None,
                                                      'type': 'text',
                                                      'timestamp': mock.ANY})

    # @mock.patch('wall.views.requests.get')
    # def test_main_wall(self, mocked_get):
    #     mocked_get.return_value = mock.Mock(status_code=201, json= lambda: {'friends_list': [3]})
    #     url = reverse('main_wall')
    #     response = self.client.get(url, format='json')
    #     print(response.data)

    @mock.patch('wall.constants.SERVER_HOST', "localhost:" + str(port))
    @mock.patch('friends.constants.SERVER_HOST', "localhost:" + str(port))
    def test_main_wall(self):
        url = reverse('main_wall')
        response = self.client.get(url, format='json')
        # print(response.data)
        # self.assertDictEqual(response.data, {})
