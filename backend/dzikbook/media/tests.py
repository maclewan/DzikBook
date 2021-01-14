import tempfile

from PIL import Image
from django.core.files.base import ContentFile
from django.test import TestCase, LiveServerTestCase, override_settings

from .decorators import hash_user
from .models import Photo, ProfilePhoto
from django.contrib.auth.models import User
from .serializers import PhotoSerializer, ProfilePhotoSerializer
from django.urls import reverse
import unittest.mock as mock
from rest_framework.test import APIClient
from django.core.files.uploadedfile import SimpleUploadedFile
from django.utils.six import BytesIO

# Create your tests here.

##################
## models tests ##
##################
from django.conf import settings


class PhotoTestCase(TestCase):
    def setUp(self):
        self.user = User.objects.create(username="test_user", password="test_password")
        data = {
            "user": self.user.id,
            "photo": "photo_url",
        }
        self.photo = Photo.objects.create(**data)

    def tearDown(self):
        Photo.objects.all().delete()

    def test_photo_create(self):
        self.assertTrue(isinstance(self.photo, Photo))
        self.assertEqual(self.photo.user, self.user.id)
        self.assertEqual(self.photo.photo, "photo_url")

    def test_photo_update(self):
        self.photo.photo = "photo_url_updated"
        self.assertEqual(self.photo.photo, "photo_url_updated")

    def test_photo_delete(self):
        id = self.photo.id
        self.photo.delete()
        self.assertFalse(Photo.objects.filter(id=id).exists())


class ProfilePhotoTestCase(TestCase):
    def setUp(self):
        self.user = User.objects.create(username="test_user", password="test_password")
        self.photo = Photo.objects.create(**{'user': self.user.id, 'photo': 'photo_url'})
        self.downsized_photo = Photo.objects.create(**{'user': self.user.id, 'photo': 'downsized_photo_url'})
        data = {
            'user': self.user.id,
            'photo': self.photo.id,
            'downsized_photo': self.downsized_photo.id,
        }
        self.profile_photo = ProfilePhoto.objects.create(**data)

    def tearDown(self):
        ProfilePhoto.objects.all().delete()

    def test_profile_photo_create(self):
        self.assertTrue(isinstance(self.profile_photo, ProfilePhoto))
        self.assertEqual(self.profile_photo.user, self.user.id)
        self.assertEqual(self.profile_photo.photo, self.photo.id)
        self.assertEqual(self.profile_photo.downsized_photo, self.downsized_photo.id)

    def test_profile_photo_update(self):
        self.profile_photo.photo = self.downsized_photo
        self.profile_photo.downsized_photo = self.photo
        self.assertEqual(self.profile_photo.photo, self.downsized_photo)
        self.assertEqual(self.profile_photo.downsized_photo, self.photo)

    def test_profile_photo_delete(self):
        id = self.profile_photo.id
        self.profile_photo.delete()
        self.assertFalse(ProfilePhoto.objects.filter(id=id).exists())


#######################
## serializers tests ##
#######################

class PhotoSerializerTestCase(TestCase):
    def setUp(self):
        self.user = User.objects.create(username="test_user", password="test_password")
        data = {
            "user": self.user.id,
            "photo": "photo_url",
        }
        self.photo = Photo.objects.create(**data)

    def tearDown(self):
        Photo.objects.all().delete()

    def test_photo_serializer_parse(self):
        serializer = PhotoSerializer(self.photo)

        self.assertDictEqual(serializer.data, {'id': self.photo.id,
                                               'user': self.user.id,
                                               'photo': "/storage/photo_url"})


class ProfilePhotoSerializerTestCase(TestCase):
    def setUp(self):
        self.user = User.objects.create(username="test_user", password="test_password")
        self.photo = Photo.objects.create(**{'user': self.user.id, 'photo': 'photo_url'})
        self.downsized_photo = Photo.objects.create(**{'user': self.user.id, 'photo': 'downsized_photo_url'})
        data = {
            'user': self.user.id,
            'photo': self.photo.id,
            'downsized_photo': self.downsized_photo.id,
        }
        self.profile_photo = ProfilePhoto.objects.create(**data)

    def tearDown(self):
        ProfilePhoto.objects.all().delete()

    def test_profile_photo_serializer_parse(self):
        serializer = ProfilePhotoSerializer(self.profile_photo)

        self.assertDictEqual(serializer.data,
                             {
                                 'id': self.profile_photo.id,
                                 'user': self.user.id,
                                 'photo': {'id': self.photo.id,
                                           'user': self.user.id,
                                           'photo': "/storage/photo_url"},
                                 'downsized_photo': {'id': self.downsized_photo.id,
                                                     'user': self.user.id,
                                                     'photo': "/storage/downsized_photo_url"
                                                     }
                             })

    def test_profile_photo_serializer_update(self):
        new_data = {
            'photo': self.downsized_photo.id,
            'downsized_photo': self.photo.id,
        }

        serializer = ProfilePhotoSerializer(data=new_data)
        self.assertTrue(serializer.is_valid(raise_exception=True))

        serializer.update(instance=self.profile_photo, validated_data=new_data)
        updated_serializer = ProfilePhotoSerializer(self.profile_photo)

        self.assertEqual(updated_serializer.data,
                         {'id': self.profile_photo.id,
                          'user': self.user.id,
                          'photo': {'id': self.downsized_photo.id,
                                    'user': self.user.id,
                                    'photo': "/storage/downsized_photo_url"},
                          'downsized_photo': {'id': self.photo.id,
                                              'user': self.user.id,
                                              'photo': "/storage/photo_url"}
                          })


#################
## views tests ##
#################

class PhotoManagementViewTestCase(LiveServerTestCase):
    port = 8081
    server_host = "localhost:" + str(port)

    def setUp(self):
        self.server_host = PhotoManagementViewTestCase.server_host
        self.client = APIClient()
        self.user = User.objects.create(username="user1", password="user1")
        self.user2 = User.objects.create(username="user2", password="user2")
        self.client.credentials(HTTP_Uid=str(self.user.id), HTTP_Flag=hash_user(self.user.id))

        self.photo = Photo.objects.create(**{'user': self.user.id, 'photo': 'photo_url'})
        self.photo2 = Photo.objects.create(**{'user': self.user2.id, 'photo': 'photo_url'})

    def tearDown(self):
        Photo.objects.all().delete()
        User.objects.all().delete()

    def test_photo_management_post(self):
        url = reverse('upload_photo')
        photo = create_image(None)
        photo_file = SimpleUploadedFile('photo.png', photo.getvalue())
        data = {
            "photo": photo_file,
        }
        response = self.client.post(url, data=data)
        self.assertDictEqual(response.data,
                             {
                                 'photo':
                                     {'id': mock.ANY,
                                      'photo': mock.ANY,
                                      'user': self.user.id},
                                 'message': 'Photo uploaded successfully.'
                             })

    def test_photo_management_delete(self):
        url = reverse('photo_management', args=[self.photo.id])
        response = self.client.delete(url)
        self.assertEqual(response.data, {'message': 'Photo deleted successfully.'})

    def test_photo_management_delete_not_yours(self):
        url = reverse('photo_management', args=[self.photo2.id])
        response = self.client.delete(url)
        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.data, "Photo doesn't exist!")


class ProfilePhotoViewTestCase(LiveServerTestCase):
    port = 8081
    server_host = "localhost:" + str(port)

    @override_settings(MEDIA_ROOT=tempfile.TemporaryDirectory(prefix='mediatest').name)
    def setUp(self):
        self.server_host = ProfilePhotoViewTestCase.server_host
        self.client = APIClient()
        self.user = User.objects.create(username="user1", password="user1")
        self.user2 = User.objects.create(username="user2", password="user2")
        self.user3 = User.objects.create(username="user3", password="user3")
        self.client.credentials(HTTP_Uid=str(self.user.id), HTTP_Flag=hash_user(self.user.id))

        self.photo = Photo.objects.create(**{'user': self.user.id, 'photo': 'photo_url'})
        self.downsized_photo = Photo.objects.create(**{'user': self.user.id, 'photo': 'downsized_photo_url'})
        self.photo2 = Photo.objects.create(**{'user': self.user2.id, 'photo': 'photo_url'})

        data = {
            'user': self.user.id,
            'photo': self.photo.id,
            'downsized_photo': self.downsized_photo.id,
        }
        self.profile_photo = ProfilePhoto.objects.create(**data)
        data['user'] = self.user2.id
        self.profile_photo2 = ProfilePhoto.objects.create(**data)

    def tearDown(self):
        ProfilePhoto.objects.all().delete()
        Photo.objects.all().delete()
        User.objects.all().delete()

    @override_settings(MEDIA_ROOT=tempfile.TemporaryDirectory(prefix='mediatest').name)
    def test_sig_in_user_profile_photo_post(self):
        url = reverse('sig_in_user_profile_photo')
        photo = create_image(None)
        photo_file = SimpleUploadedFile('photo.png', photo.getvalue())
        data = {
            "photo": photo_file,
        }
        response = self.client.post(url, data=data)
        self.assertDictEqual(response.data[0],
                             {
                                 'id': mock.ANY,
                                 'user': self.user.id,
                                 'photo': {'id': mock.ANY,
                                           'user': self.user.id,
                                           'photo': mock.ANY,
                                           },
                                 'downsized_photo': {'id': mock.ANY,
                                                     'user': self.user.id,
                                                     'photo': mock.ANY,
                                                     }
                             })

        starting_path = response.data[0]['downsized_photo']['photo']
        index = starting_path.find('/photos/')
        path = settings.MEDIA_ROOT + starting_path[index:]
        downsized_photo = Image.open(path)
        self.assertEqual(downsized_photo.size, (100, 100))

    def test_sig_in_user_profile_photo_get_notexisting(self):
        client = APIClient()
        client.credentials(HTTP_Uid=str(self.user3.id), HTTP_Flag=hash_user(self.user3.id))
        url = reverse('sig_in_user_profile_photo')
        response = client.get(url, format='json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data['photo']['photo'], '/storage/photos/default_profile.png')
        self.assertEqual(response.data['downsized_photo']['photo'], '/storage/photos/default_profile_downscaled.png')

    def test_sig_in_user_profile_photo_get(self):
        url = reverse('sig_in_user_profile_photo')
        response = self.client.get(url, format='json')
        serializer = ProfilePhotoSerializer(self.profile_photo)
        self.assertEqual(response.data, serializer.data)

    def test_sig_in_user_profile_photo_delete(self):
        url = reverse('sig_in_user_profile_id', args=[self.profile_photo.id])
        response = self.client.delete(url)
        self.assertEqual(response.data, {'message': 'Profile photo deleted successfully.'})

    def test_sig_in_user_profile_photo_delete_not_yours(self):
        url = reverse('sig_in_user_profile_id', args=[self.profile_photo2.id])
        response = self.client.delete(url)
        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.data, "Profile photo doesn't exist!")

    def test_sig_in_user_profile_photo_get_not_yours(self):
        url = reverse('profile_photo', args=[self.user2.id])
        response = self.client.get(url, format='json')
        serializer = ProfilePhotoSerializer(self.profile_photo2)
        self.assertEqual(response.data, serializer.data)


def create_image(storage, filename='test_image.png', size=(200, 200),
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