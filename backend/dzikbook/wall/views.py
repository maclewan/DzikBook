import requests
from django.contrib.auth.models import User
from django.shortcuts import render
import wall.constants as constants


from django.db import models
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from base64 import b64encode

from .models import Post
from .serializers import PostSerializer

# create your views here
from .decorators import authenticate, hash_user


class SigInUserPostsView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, post_id):
        try:
            post = Post.objects.filter(id=post_id).first()
            if post is None:
                raise Exception()
            context = PostSerializer(post).data
        except Exception as e:
            return Response("Post with given id doesn't exist!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)

    @authenticate
    def post(self, request):
        data = {
            "author": request.user.id,
            "description": request.POST.get('description', ''),
            "additional_data": request.POST.get('additional_data', ''),
            "visibility": request.POST.get('visibility', 1),
            "type": request.POST.get('type', 'text')
        }

        if request.FILES:
            user_id = str(request.user.id)
            headers = {"Uid": user_id, "Flag": hash_user(user_id)}
            files = {'photo': list(request.FILES.values())[0]}

            try:
                response = requests.post('http://'+constants.SERVER_HOST+'/media/photo/', headers=headers, files=files)
                response_json = response.json()
            except Exception as e:
                return Response("Internal server error!", status=status.HTTP_500_INTERNAL_SERVER_ERROR)

            if 'photo' not in response_json:
                return Response(response.content, status=response.status_code)

            image_path = response_json['photo']['photo']
            data['photo'] = image_path

        post_serializer = PostSerializer()
        post = post_serializer.create(validated_data=data)
        post.save()
        return Response(PostSerializer(post).data)

    @authenticate
    def put(self, request, post_id):
        try:
            post = Post.objects.filter(id=post_id, author=request.user.id).first()
            if post is None:
                raise models.ObjectDoesNotExist
            data = {}

            description = request.POST.get('description', None)
            if description is not None:
                data['description'] = description

            additional_data = request.POST.get('additional_data', None)
            if additional_data is not None:
                data['additional_data'] = additional_data

            if request.FILES:
                user_id = str(request.user.id)
                headers = {"Uid": user_id, "Flag": hash_user(user_id)}
                files = {'photo': list(request.FILES.values())[0]}

                try:
                    response = requests.post('http://'+constants.SERVER_HOST+'/media/photo/', headers=headers, files=files)
                    response_json = response.json()
                except Exception:
                    return Response("Internal server error!", status=status.HTTP_500_INTERNAL_SERVER_ERROR)

                if 'photo' not in response_json:
                    return Response(response.content, status=response.status_code)

                image_path = response_json['photo']['photo']
                data['photo'] = image_path

            post_serializer = PostSerializer()
            post = post_serializer.update(instance=post, validated_data=data)
            return Response(PostSerializer(post).data)
        except models.ObjectDoesNotExist:
            return Response("Post doesn't exist!", status=status.HTTP_404_NOT_FOUND)

    @authenticate
    def delete(self, request, post_id):
        try:
            post = Post.objects.filter(id=post_id, author=request.user.id).first()
            if post is None:
                raise models.ObjectDoesNotExist
            post.delete()
            return Response({"message": "Post deleted"})
        except models.ObjectDoesNotExist:
            return Response("Post doesn't exist!", status=status.HTTP_404_NOT_FOUND)


# board section
class SigInUserPostsListView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request):
        posts = Post.objects.filter(author=request.user.id)
        # posts = posts.order_by('-time')
        type = request.GET.get('type', None)
        offset = int(request.GET.get('offset', 0))
        amount = int(request.GET.get('amount', 10))

        if type is not None:
            posts = posts.filter(type=type)

        posts = sorted(posts, key=lambda p: p.time, reverse=True)
        posts = posts[offset:offset + amount]

        context = PostSerializer(posts, many=True).data
        return Response(context)


class PostsListView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, user_id):
        posts = Post.objects.filter(author=user_id)
        # posts = posts.order_by('-time')
        offset = int(request.GET.get('offset', 0))
        amount = int(request.GET.get('amount', 10))
        type = request.GET.get('type', None)
        if type is not None:
            posts = posts.filter(type=type)

        posts = sorted(posts, key=lambda p: p.time, reverse=True)
        posts = posts[offset:offset + amount]
        context = PostSerializer(posts, many=True).data
        return Response(context)


# Main wall

class MainWallListView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request):
        user_id = str(request.user.id)

        headers = {"Uid": user_id, "Flag": hash_user(user_id)}
        try:
            response = requests.get(f'http://'+constants.SERVER_HOST+'/friends/id_list/', headers=headers)
            response_json = response.json()
        except Exception as e:
            return Response("Internal server error!", status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        if 'friends_list' not in response_json:
            return Response(response.content, status=response.status_code)

        friends_id_list = list(response_json['friends_list'])

        friends_id_list.append(user_id)
        users_list = [int(id) for id in friends_id_list]
        all_posts = Post.objects.filter(author__in=users_list)  # .order_by('-time')

        type = request.GET.get('type', None)
        offset = int(request.GET.get('offset', 0))
        amount = int(request.GET.get('amount', 10))

        if type is not None:
            all_posts = all_posts.filter(type=type)

        all_posts = sorted(all_posts, key=lambda p: p.time, reverse=True)
        all_posts = all_posts[offset:offset + amount]
        context = PostSerializer(all_posts, many=True).data
        return Response(context)
