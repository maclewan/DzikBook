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



# create your views here
from .decorators import authenticate


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
            if Reaction.objects.filter(post=post_id, giver=request.user).exists():
                return Response("Reaction already exists!", status=status.HTTP_404_NOT_FOUND)
            data = {
                "giver": request.user,
                "post": post_id,
            }
            reaction_serializer = ReactionSerializer()
            reaction = reaction_serializer.create(validated_data=data)
            reaction.save()
            return Response(ReactionSerializer(reaction).data)
        except Exception as e:
            print(e)
            return Response("Error!", status=status.HTTP_404_NOT_FOUND)

    @authenticate
    def delete(self, request, post_id):
        try:
            reaction = Reaction.objects.filter(post=post_id, giver=request.user)
            reaction.delete()
            return Response({"message": "Reaction deleted"})
        except models.ObjectDoesNotExist:
            return Response("Reaction doesn't exist!", status=status.HTTP_404_NOT_FOUND)


class CommentsView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, post_id):
        try:
            comments_list = Comment.objects.filter(post=post_id)
            context = CommentSerializer(comments_list, many=True).data
        except:
            return Response("Error during loading a comment!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)

    @authenticate
    def post(self, request, post_id):
        try:
            data = {
                "post": post_id,
                "author": request.user,
                "content": request.POST.get('content', ''),
            }
            comment_serializer = CommentSerializer()
            comment = comment_serializer.create(validated_data=data)
            comment.save()
            return Response(CommentSerializer(comment).data)
        except:
            return Response("Error during posting a comment!", status=status.HTTP_404_NOT_FOUND)

    @authenticate
    def delete(self, request, comment_id):
        try:
            comment = Comment.objects.get(pk=comment_id, author=request.user)
            comment.delete()
            return Response({"message": "Comment deleted"})
        except models.ObjectDoesNotExist:
            return Response("Comment doesn't exist!", status=status.HTTP_404_NOT_FOUND)

    @authenticate
    def put(self, request, comment_id):
        try:
            comment = Comment.objects.get(pk=comment_id, author=request.user)
            data = {
                "content": request.POST.get('content', ''),
            }
            comment_serializer = CommentSerializer()
            comment = comment_serializer.update(instance=comment, validated_data=data)
            return Response(CommentSerializer(comment).data)
        except models.ObjectDoesNotExist:
            return Response("Comment doesn't exist!", status=status.HTTP_404_NOT_FOUND)
