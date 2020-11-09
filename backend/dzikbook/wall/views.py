from django.contrib.auth.models import User
from django.shortcuts import render
from django.db import models
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from base64 import b64encode

from .models import Post
from .serializers import PostSerializer

# create your views here
from .decorators import authenticate


class SigInUserPostsView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, post_id):
        try:
            post = Post.objects.get(pk=post_id)
            context = PostSerializer(post).data
        except Exception as e:
            print(e)
            return Response("Post with given id doesn't exist!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)

    @authenticate
    def post(self, request):
        try:
            data = {
                "author": request.user,
                "description": request.POST.get('description', ''),
                "visibility": request.POST.get('visibility', 1),
            }

            if request.FILES:
                img = list(request.FILES.values())[0].read()  # select the first image
                img_b64 = b64encode(img)

                # TODO make a request to the image microservice which returns image_id
                image_path = 'path from image microservice'
                data['image'] = image_path

            post_serializer = PostSerializer()
            post = post_serializer.create(validated_data=data)
            post.save()
            return Response(PostSerializer(post).data)
        except Exception as e:
            print(e)
            return Response("Error!", status=status.HTTP_404_NOT_FOUND)

    @authenticate
    def put(self, request, post_id):
        try:
            post = Post.objects.get(pk=post_id, author=request.user)
            data = {}

            description = request.POST.get('description', None)
            if description is not None:
                data['description'] = description

            if request.FILES:
                img = list(request.FILES.values())[0].read()  # select the first image
                img_b64 = b64encode(img)

                # TODO make a request to the image microservice which returns image_id
                image_path = 'edited path from image microservice'
                data['image'] = image_path

            print(post)
            print(data)
            post_serializer = PostSerializer()
            post = post_serializer.update(instance=post, validated_data=data)
            return Response(PostSerializer(post).data)
        except models.ObjectDoesNotExist:
            return Response("Post doesn't exist!", status=status.HTTP_404_NOT_FOUND)

    @authenticate
    def delete(self, request, post_id):
        try:
            post = Post.objects.filter(pk=post_id, author=request.user)
            post.delete()
            return Response({"message": "Post deleted"})
        except models.ObjectDoesNotExist:
            return Response("Post doesn't exist!", status=status.HTTP_404_NOT_FOUND)


# board section
class SigInUserPostsListView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request):
        try:
            post = Post.objects.filter(author=request.user)
            context = PostSerializer(post, many=True).data
        except Exception as e:
            print(e)
            return Response("Post with given id doesn't exist!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)


class PostsListView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, user_id):
        try:
            post = Post.objects.filter(author=User(pk=user_id))
            context = PostSerializer(post, many=True).data
        except Exception as e:
            print(e)
            return Response("User with given id doesn't exist!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)
