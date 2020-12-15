from django.test import TestCase, Client
from .models import Comment, Reaction
from django.contrib.auth.models import User
from .serializers import CommentSerializer, ReactionSerializer
from .views import ReactionsView, CommentsView
from rest_framework.test import APIRequestFactory, force_authenticate

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
        Comment.objects.create(**data)

    def test_create_comment(self):
        comment = Comment.objects.get(pk=1)
        self.assertTrue(isinstance(comment, Comment))
        self.assertTrue(comment.post == 5 and isinstance(comment.author, User) and comment.content == "content")


class ReactionTestCase(TestCase):

    def setUp(self):
        giver = User.objects.create(username="test_user", password="test_password")
        data = {
            "post":5,
            "giver":giver
        }
        Reaction.objects.create(**data)

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

#TODO: Problemy z autentykacją JWT
"""
class ReactionsViewTestCase(TestCase):

    def setUp(self):
        giver = User.objects.create(username="test_user", password="test_password")
        data = {
            "post":5,
            "giver":giver
        }
        Reaction.objects.create(**data)

    def log_in(self):
        client = Client()
        response = client.post('/auth/login/', {'username': 'test_user', 'password': 'test_password'})
        print(response)

    def test_get(self):
        user = User.objects.get(username='test_user')
        factory = APIRequestFactory()
        view = ReactionsView.as_view()
        request = factory.get('/socials/reactions/5/')
        force_authenticate(request)
        response = view(request, user)
        print(response)
        #response = client.get("/socials/comments/post/5/")
        #print(response)
"""