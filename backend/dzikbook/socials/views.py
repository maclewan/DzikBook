from cassandra.cqlengine.query import DoesNotExist
from django.shortcuts import render
from .constants import SERVER_HOST
from rest_framework.views import APIView
from rest_framework.response import Response
from django.contrib.auth.decorators import login_required
from rest_framework import status
from django.http import QueryDict
from .models import Comment, Reaction
from django.db import models
from rest_framework.permissions import IsAuthenticated
from .serializers import CommentSerializer, ReactionSerializer
import requests
import constants
from .decorators import authenticate, hash_user


# create your views here


class ReactionsView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, post_id):
        try:
            reactions_list = Reaction.objects.filter(post=post_id)
            context = ReactionSerializer(reactions_list, many=True).data
        except:
            return Response("Error during reading reactions!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)

    @authenticate
    def post(self, request, post_id):
        try:
            if Reaction.objects.filter(post=post_id, giver=request.user.id).exists():
                return Response("Reaction already exists!", status=status.HTTP_404_NOT_FOUND)
            data = {
                "giver": request.user.id,
                "post": post_id,
            }
            reaction_serializer = ReactionSerializer()
            reaction = reaction_serializer.create(validated_data=data)
            reaction.save()
            try:
                author_id = get_author_id(request.user.id, post_id)
                # Avoid notifying yourself
                if author_id != request.user.id:
                    notify("like", author_id, request.user.id, post=post_id)
            except:
                pass
            return Response(ReactionSerializer(reaction).data)
        except Exception as e:
            return Response("Error!", status=status.HTTP_404_NOT_FOUND)

    @authenticate
    def delete(self, request, post_id):
        try:
            reaction = Reaction.objects.filter(post=post_id, giver=request.user.id).first()
            if reaction is None:
                raise DoesNotExist
            reaction.delete()
            return Response({"message": "Reaction deleted"})
        except DoesNotExist:
            return Response("Reaction doesn't exist!", status=status.HTTP_404_NOT_FOUND)


class CommentsView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, post_id):
        try:
            comments_list = Comment.objects.filter(post=post_id)
            context = CommentSerializer(comments_list, many=True).data
            # for i, comment in enumerate(context):
            #     comment['id'] = i
        except:
            return Response("Error during loading a comment!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)

    @authenticate
    def post(self, request, post_id):
        try:
            data = {
                "post": post_id,
                "author": request.user.id,
                "content": request.POST.get('content', ''),
            }
            comment_serializer = CommentSerializer()
            comment = comment_serializer.create(validated_data=data)
            comment.save()
            try:
                author_id = get_author_id(request.user.id, post_id)
                # Avoid notifying yourself
                if author_id != request.user.id:
                    notify("comment", author_id, request.user.id, post=post_id)
            except:
                pass
            return Response(CommentSerializer(comment).data)
        except:
            return Response("Error during posting a comment!", status=status.HTTP_404_NOT_FOUND)

    @authenticate
    def delete(self, request, comment_id):
        try:
            comment = Comment.objects.filter(id=comment_id, author=request.user.id).first()
            if comment is None:
                raise DoesNotExist
            comment.delete()
            return Response({"message": "Comment deleted"})
        except DoesNotExist:
            return Response("Comment doesn't exist!", status=status.HTTP_404_NOT_FOUND)

    @authenticate
    def put(self, request, comment_id):
        try:
            comment = Comment.objects.filter(author=request.user.id, id=comment_id).first()
            if comment is None:
                raise models.ObjectDoesNotExist
            data = {
                "content": request.POST.get('content', ''),
            }
            comment_serializer = CommentSerializer()
            comment = comment_serializer.update(instance=comment, validated_data=data)
            return Response(CommentSerializer(comment).data)
        except models.ObjectDoesNotExist:
            return Response("Comment doesn't exist!", status=status.HTTP_404_NOT_FOUND)


def notify(not_type, user, this_user, post=None):
    payload = {
        'notification_type': not_type,
        'user': user,
        'sender': this_user,
        'post': post
    }

    # Send request to users service
    url = 'http://' + constants.SERVER_HOST + '/notifications/'

    headers = {"Uid": str(this_user), "Flag": hash_user(this_user)}
    r = requests.post(url, data=payload, headers=headers)
    return r.json()


def get_author_id(this_user, post_id):
    # Send request to users service
    url = 'http://' + constants.SERVER_HOST + '/wall/post/' + str(post_id) + '/'

    headers = {"Uid": str(this_user), "Flag": hash_user(this_user)}
    response = requests.get(url, headers=headers)
    return response.json()["author"]
