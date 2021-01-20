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


def raise_exception(*args, **kwargs):
    raise Exception('error')

def make_mocked_request(**kwargs):
    def mocked_request(*args2, **kwargs2):
        return mock.Mock(**kwargs)
    return mocked_request



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


# #################
# ## views tests ##
# #################


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
        }
        data['type'] = "text"
        self.post1 = Post.objects.create(**data)

        data['type'] = "media"
        self.post4 = Post.objects.create(**data)

        data['type'] = "media"
        data["author"] = self.user2
        self.post2 = Post.objects.create(**data)

        data['type'] = "text"
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

    @mock.patch('wall.constants.SERVER_HOST', server_host)
    @mock.patch('requests.post', raise_exception)
    def test_sig_in_user_posts_post_image_internal_error(self):
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
        self.assertEqual(response.status_code, 500)
        self.assertEqual(response.data, "Internal server error!")

    @mock.patch('wall.constants.SERVER_HOST', server_host)
    @mock.patch('requests.post', make_mocked_request(
        **{
            'json.return_value': [],
            'content': "Couldn't upload your photo!",
            'status_code': 500,
        }
    ))
    def test_sig_in_user_posts_post_image_upload_photo_error(self):
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
        self.assertEqual(response.status_code, 500)
        self.assertEqual(response.data, "Couldn't upload your photo!")

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
            "description": "description_updated",
            "additional_data": "additional_data_updated",
            "type": "text",
        }
        response = self.client.put(url, data)
        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.data, "Post doesn't exist!")

    @mock.patch('wall.constants.SERVER_HOST', server_host)
    def test_sig_in_user_posts_put(self):
        url = reverse('sig_in_user_posts', args=[self.post1.id])

        photo = create_image(None)
        photo_file = SimpleUploadedFile('photo.png', photo.getvalue())
        data = {
            "description": "description_updated",
            "additional_data": "additional_data_updated",
            "type": "media",
            "photo": photo_file,
        }
        response = self.client.put(url, data)
        self.assertEqual(int(response.data['author']), self.user1.id)
        self.assertEqual(response.data['description'], 'description_updated')
        self.assertEqual(response.data['type'], 'text')  # type cannot be modified
        self.assertEqual(response.data['additional_data'], 'additional_data_updated')
        self.assertIsNotNone(response.data['photo'])

    @mock.patch('wall.constants.SERVER_HOST', server_host)
    @mock.patch('requests.post', raise_exception)
    def test_sig_in_user_posts_put_internal_error(self):
        url = reverse('sig_in_user_posts', args=[self.post1.id])

        photo = create_image(None)
        photo_file = SimpleUploadedFile('photo.png', photo.getvalue())
        data = {
            "description": "description_updated",
            "additional_data": "additional_data_updated",
            "type": "media",
            "photo": photo_file,
        }
        response = self.client.put(url, data)
        self.assertEqual(response.status_code, 500)
        self.assertEqual(response.data, "Internal server error!")

    @mock.patch('wall.constants.SERVER_HOST', server_host)
    @mock.patch('requests.post', make_mocked_request(
        **{
            'json.return_value': [],
            'content': "Couldn't upload your photo!",
            'status_code': 500,
        }
    ))
    def test_sig_in_user_posts_post_put_upload_photo_error(self):
        url = reverse('sig_in_user_posts', args=[self.post1.id])

        photo = create_image(None)
        photo_file = SimpleUploadedFile('photo.png', photo.getvalue())
        data = {
            "description": "description_updated",
            "additional_data": "additional_data_updated",
            "type": "media",
            "photo": photo_file,
        }
        response = self.client.put(url, data)
        self.assertEqual(response.status_code, 500)
        self.assertEqual(response.data, "Couldn't upload your photo!")

    def test_sig_in_user_posts_delete(self):
        url = reverse('sig_in_user_posts', args=[self.post1.id])
        response = self.client.delete(url)
        self.assertEqual(response.data, {'message': 'Post deleted'})

    def test_sig_in_user_posts_delete_not_yours(self):
        url = reverse('sig_in_user_posts', args=[self.post3.id])
        response = self.client.delete(url)
        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.data, "Post doesn't exist!")

    def test_sig_in_user_posts_list_get(self):
        url = reverse('sig_in_user_posts_list')
        response = self.client.get(url, format='json')
        self.assertEqual(len(response.data), 2)
        self.assertIn(response.data[0]['post_id'], [self.post1.id, self.post4.id])
        self.assertIn(response.data[1]['post_id'], [self.post1.id, self.post4.id])

        response = self.client.get(url, {'amount': 1, 'offset': 1}, format='json')
        self.assertEqual(len(response.data), 1)

        response = self.client.get(url, {'type': 'media'}, format='json')
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['post_id'], self.post4.id)


    def test_sig_in_user_posts_list_get_empty(self):
        url = reverse('sig_in_user_posts_list')
        user_id = 999
        client = APIClient()
        client.credentials(HTTP_Uid=str(user_id), HTTP_Flag=hash_user(user_id))
        response = client.get(url, format='json')
        self.assertEqual(len(response.data), 0)

    def test_post_list_get(self):
        url = reverse('posts_list', args=[self.user3.id])
        response = self.client.get(url, format='json')
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['post_id'], self.post3.id)

        response = self.client.get(url, {"type": "media"}, format='json')
        self.assertEqual(len(response.data), 0)

    @mock.patch('wall.constants.SERVER_HOST', server_host)
    @mock.patch('friends.constants.SERVER_HOST', server_host)
    @mock.patch('friends.views.notify', mock.Mock())
    def test_main_wall_list_get(self):
        url = reverse('main_wall')
        client2 = APIClient()
        client2.credentials(HTTP_Uid=str(self.user2.id), HTTP_Flag=hash_user(self.user2.id))

        client3 = APIClient()
        client3.credentials(HTTP_Uid=str(self.user3.id), HTTP_Flag=hash_user(self.user3.id))

        response_invitation = client2.post(
            'http://' + self.server_host + '/friends/request/' + str(self.user3.id) + '/')
        invitation_id = response_invitation.data['invitation_id']

        client3.post('http://' + self.server_host + '/friends/request/manage/' + str(invitation_id) + '/')

        response = client3.get(url, format='json')
        self.assertEqual(len(response.data), 2)
        self.assertIn(response.data[0]['post_id'], [self.post2.id, self.post3.id])
        self.assertIn(response.data[1]['post_id'], [self.post2.id, self.post3.id])

        response = client3.get(url, {'type': 'media'}, format='json')
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['post_id'], self.post2.id)

    @mock.patch('requests.get', raise_exception)
    def test_main_wall_list_get_internal_error(self):
        url = reverse('main_wall')
        response = self.client.get(url, format='json')
        self.assertEqual(response.status_code, 500)
        self.assertEqual(response.data, "Internal server error!")

    @mock.patch('wall.constants.SERVER_HOST', server_host)
    @mock.patch('requests.get', make_mocked_request(
        **{
            'json.return_value': [],
            'content': "Couldn't get friends data!",
            'status_code': 500,
        }
    ))
    def test_main_wall_list_get_friends_error(self):
        url = reverse('main_wall')
        response = self.client.get(url, format='json')
        self.assertEqual(response.status_code, 500)
        self.assertEqual(response.data, "Couldn't get friends data!")


def create_image(storage, filename='test_image.png', size=(100, 100),
                 image_mode='RGB', image_format='PNG'):
    """
    Generate a test image, returning the filename that it was saved as.
    If ``storage`` is ``None``, the BytesIO containing the image data
    will be passed instead.
    """
    data = BytesIO()
    with Image.new(image_mode, size) as img:
        img.save(data, image_format)
    data.seek(0)
    if not storage:
        return data
    image_file = ContentFile(data.read())
    storage_file = storage.save(filename, image_file)
    return storage_file
