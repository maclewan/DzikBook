from django.test import TestCase, Client
from .models import Post
from django.contrib.auth.models import User
from .serializers import PostSerializer


# Create your tests here.

##################
## models tests ##
##################

class PostTestCase(TestCase):

    def setUp(self):
        author = User.objects.create(username="test_user", password="test_password")
        data = {
            "author": author,
            "description": "description"
        }
        Post.objects.create(**data)

    def test_create_post(self):
        post = Post.objects.get(pk=1)
        self.assertTrue(isinstance(post, Post))
        self.assertTrue(isinstance(post.author, User) and post.description == "description" and post.visibility)


#######################
## serializers tests ##
#######################

class PostSerializerTestCase(TestCase):

    def setUp(self):
        author = User.objects.create(username="test_user", password="test_password")
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
