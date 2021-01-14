from collections import OrderedDict

from PIL import Image
from django.core.files.base import ContentFile
from django.test import TestCase, Client, LiveServerTestCase
from rest_framework_simplejwt.tokens import Token

from .decorators import hash_user
from .models import Post
from django.contrib.auth.models import User
from .serializers import PostSerializer
from django.urls import reverse
import unittest.mock as mock
from rest_framework.test import APIRequestFactory, APITestCase, APIClient
from django.core.files.uploadedfile import SimpleUploadedFile
from django.utils.six import BytesIO



# Create your tests here.

##################
## models tests ##
##################


class PostTestCase(TestCase):

    def setUp(self):
        self.author = User.objects.create(username="test_user", password="test_password")
        data = {
            "author": author,
            "description": "description"
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


#################
## views tests ##
#################


class PostViewTestCase(LiveServerTestCase):
    port = 8081
    server_host = "localhost:" + str(port)

    def setUp(self):
        self.server_host = PostViewTestCase.server_host
        self.client = APIClient()
        self.user1 = User.objects.create(username="user1", password="user1")
        self.user2 = User.objects.create(username="user2", password="user2")
        self.user3 = User.objects.create(username="user3", password="user3")
        logged_user_id = self.user1.pk
        self.client.credentials(HTTP_Uid=str(logged_user_id), HTTP_Flag=hash_user(logged_user_id))

        data = {
            "author": self.user1,
            "description": "description",
            "type": "text",
        }
        self.post1 = Post.objects.create(**data)
        self.post4 = Post.objects.create(**data)
        data["author"] = self.user2
        self.post2 = Post.objects.create(**data)
        data["author"] = self.user3
        self.post3 = Post.objects.create(**data)

    def tearDown(self):
        Post.objects.all().delete()
        User.objects.all().delete()

    def test_sig_in_user_posts_get_existing(self):
        tested_post = self.post3
        url = reverse('sig_in_user_posts', args=[tested_post.id])
        response = self.client.get(url, format='json')
        serializer = PostSerializer(tested_post)
        self.assertEqual(response.data, serializer.data)

    def test_sig_in_user_posts_get_nonexisting(self):
        url = reverse('sig_in_user_posts', args=[999])
        response = self.client.get(url, format='json')
        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.data, "Post with given id doesn't exist!")

    @mock.patch('wall.constants.SERVER_HOST', server_host)
    def test_sig_in_user_posts_post_image(self):
        url = reverse('sig_in_user_add_post')

        photo = create_image(None)
        photo_file = SimpleUploadedFile('photo.png', photo.getvalue())
        data = {
            "description": "description",
            "additional_data": "additional_data",
            "type": "media",
            "photo": photo_file,
        }
        response = self.client.post(url, data)

        self.assertEqual(int(response.data['author']), self.user1.id)
        self.assertEqual(response.data['description'], 'description')
        self.assertEqual(response.data['type'], 'media')
        self.assertEqual(response.data['additional_data'], 'additional_data')
        self.assertIsNotNone(response.data['photo'])

    def test_sig_in_user_posts_post_nonimage(self):
        url = reverse('sig_in_user_add_post')

        data = {
            "description": "description",
            "additional_data": "additional_data",
            "type": "media",
        }
        response = self.client.post(url, data)

        self.assertEqual(int(response.data['author']), self.user1.id)
        self.assertEqual(response.data['description'], 'description')
        self.assertEqual(response.data['type'], 'media')
        self.assertEqual(response.data['additional_data'], 'additional_data')
        self.assertIsNone(response.data['photo'])

    def test_sig_in_user_posts_put_not_yours(self):
        url = reverse('sig_in_user_posts', args=[self.post3.id])
        data = {
            "author": author,
            "description": "description"
        }
        Post.objects.create(**data)

    def test_translation(self):
        post = Post.objects.get(pk=1)
        serializer = PostSerializer
        self.assertEqual(serializer(post).data,
                         {'post_id': 1, 'author': 1, 'description': "description", 'visibility': True, 'image': None})

    def test_update(self):
        serializer = PostSerializer()
        post = Post.objects.get(pk=1)
        data = {
            "description": "test_description",
            "image": "new_image",
            "visibility": False,
        }
        post = serializer.update(post, validated_data=data)
        self.assertTrue(isinstance(post.author,
                                   User) and post.description == "test_description" and post.visibility and post.image == "new_image")
