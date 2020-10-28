from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from django.contrib.auth.decorators import login_required
from rest_framework import status
from django.http import QueryDict
from .models import Comment, Reaction
from django.db import models
from rest_framework.permissions import IsAuthenticated
from .serializers import CommentSerializer


# create your views here

class CommentsView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, post_id):
        try:
            comments_list = Comment.objects.filter(post=post_id)
            context = CommentSerializer(comments_list, many=True).data
        except:
            return Response("Error during posting a comment!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)

    def post(self, request, post_id):
        try:
            data = {
                "post": post_id,
                "author": request.user,
                "content": request.POST.get('description', ''),
            }
            comment_serializer = CommentSerializer()
            comment = comment_serializer.create(validated_data=data)
            comment.save()
            return Response(CommentSerializer(comment).data)
        except:
            return Response("Error!", status=status.HTTP_404_NOT_FOUND)

    def delete(self, request, comment_id):
        try:
            comment = Comment.objects.get(pk=comment_id, author=request.user)
            comment.delete()
            return Response({"message": "Comment deleted"})
        except models.ObjectDoesNotExist:
            return Response("Comment doesn't exist!", status=status.HTTP_404_NOT_FOUND)

    # TODO: Put zmieniona ścieżka
    def put(self, request, comment_id):
        try:
            comment = Comment.objects.get(pk=comment_id, author=request.user)
            data = {
                "content": request.POST.get('description', ''),
            }
            comment_serializer = CommentSerializer()
            comment = comment_serializer.update(instance=comment, validated_data=data)
            return Response(CommentSerializer(comment).data)
        except models.ObjectDoesNotExist:
            return Response("Comment doesn't exist!", status=status.HTTP_404_NOT_FOUND)


class ReactionsView(APIView):

    def get(self, request, post_id):
        reactions_list = []
        context = {'reactions_list': reactions_list}
        return Response(context)

    def post(self, request, post_id):
        context = {'message': 'Reaction successdully added.'}
        return Response(context)

    def delete(self, request, post_id):
        context = {'message': 'Reaction successfully deleted.'}
        return Response(context)
