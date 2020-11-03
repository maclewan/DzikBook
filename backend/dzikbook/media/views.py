from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Photo, ProfilePhoto
from .serializers import PhotoSerializer, ProfilePhotoSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from django.db import models

# create your views here
from .decorators import authenticate


class PhotoManagementView(APIView):
    # permission_classes = (IsAuthenticated,)
    # TODO: dopytać jak wygląda zdjęcie które dostajemy
    def post(self, request):
        context = {
            'photo_id': '5',
            'message': 'Photo uploaded successfully.'
        }
        return Response(context)

    @authenticate
    def delete(self, request, photo_id):
        try:
            photo = Photo.objects.get(id=photo_id)
            photo.delete()
            context = {'message':'Photo deleted successfully.'}
        except models.ObjectDoesNotExist:
            return Response("Photo doesn't exist!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)


class VideoManagementView(APIView):
    # permission_classes = (IsAuthenticated,)

    def post(self, request):
        context = {
            'video_id': '5',
            'message': 'Video uploaded successfully.'
        }
        return Response(context)

    @authenticate
    def delete(self, request, video_id):
        try:
            photo = Photo.objects.get(id=video_id)
            photo.delete()
            context = {'message':'Photo deleted successfully.'}
        except models.ObjectDoesNotExist:
            return Response("Photo doesn't exist!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)


class SigInUserProfilePhotoView(APIView):
    # permission_classes = (IsAuthenticated,)
    # TODO: dopytać jak wygląda zdjęcie które dostajemy
    def post(self, request):
        context = {
            'photo_id': '5',
            'message': 'Profile photo uploaded successfully.'
        }
        return Response(context)

    @authenticate
    def get(self, request):
        try:
            current_user = request.user
            photo = ProfilePhotoSerializer(ProfilePhoto.objects.get(pk=current_user.pk)).data
            context = {
                'photo':photo,
                'description':'Looking great!'
            }
        except:
            return Response("Error, could not retrive logged in user profile photo!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)


class ProfilePhotoView(APIView):
    # permission_classes = (IsAuthenticated,)

    @authenticate
    def get(self, request, user_id):
        try:
            photo = ProfilePhotoSerializer(ProfilePhoto.objects.get(pk=user_id)).data
            context = {
                'photo':photo,
                'description':''
            }
        except:
            return Response("Error, could not retrive profile photo with id " + str(user_id) + "!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)