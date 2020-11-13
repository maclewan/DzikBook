from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Photo, ProfilePhoto
from .serializers import PhotoSerializer, ProfilePhotoSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from django.db import models
from .forms import PhotoForm, ProfilePhotoForm
from django.shortcuts import render
import requests

# create your views here
from .decorators import authenticate


class PhotoManagementView(APIView):
    authentication_classes = []

    @authenticate
    def post(self, request):
        form = PhotoForm(request.POST, request.FILES)
        if form.is_valid():
            user_id = form.cleaned_data['user']
            if not check_if_user_exist(user_id):
                return Response("User with id: " + str(user_id) + " doesn't exist!", status=status.HTTP_404_NOT_FOUND)
            photo = form.save() 
            context = {
                'photo': PhotoSerializer(photo).data,
                'message': 'Photo uploaded successfully.'
            }
            return Response(context)
        else:
            return Response("Could not create photo.", status=status.HTTP_404_NOT_FOUND)

    @authenticate
    def delete(self, request, photo_id):
        try:
            photo = Photo.objects.get(id=photo_id)
            photo.delete()
            context = {'message': 'Photo deleted successfully.'}
        except models.ObjectDoesNotExist:
            return Response("Photo doesn't exist!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)


    @authenticate
    def get(self, request):
        form = PhotoForm()
        context = {"form": form}
        return render(request, "photo_form.html", context)

# Na razie nie używane
class VideoManagementView(APIView):
    authentication_classes = []

    @authenticate
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
            context = {'message': 'Photo deleted successfully.'}
        except models.ObjectDoesNotExist:
            return Response("Photo doesn't exist!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)


class SigInUserProfilePhotoView(APIView):
    authentication_classes = []

    @authenticate
    def post(self, request):
        form = ProfilePhotoForm(request.POST, request.FILES)
        if form.is_valid():
            user_id = form.cleaned_data['user']
            if not check_if_user_exist(user_id):
                return Response("User with id: " + str(user_id) + " doesn't exist!", status=status.HTTP_404_NOT_FOUND)
            profile_photo = form.save() 
            context = {
                'profile_photo': ProfilePhotoSerializer(profile_photo).data,
                'message': 'Profile photo uploaded successfully.'
            }
            return Response(context)
        else:
            return Response("Could not create profile photo.", status=status.HTTP_404_NOT_FOUND)

    @authenticate
    def get(self, request):
        try:
            current_user = request.user
            profile_photos = ProfilePhoto.objects.filter(user=current_user.pk)
            context = {
                'photos': ProfilePhotoSerializer(profile_photos, many=True).data,
                'description': 'Looking great!'
            }
        except:
            return Response("Error, could not retrive logged in user profile photo!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)

    """
    @authenticate
    def get(self, request):
        form = ProfilePhotoForm()
        context = {"form": form}
        return render(request, "profile_photo_form.html", context)
    """

class ProfilePhotoView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, user_id):
        try:
            photo = ProfilePhotoSerializer(ProfilePhoto.objects.get(pk=user_id)).data
            context = {
                'photo': photo,
                'description': ''
            }
        except:
            return Response("Error, could not retrive profile photo with id " + str(user_id) + "!",
                            status=status.HTTP_404_NOT_FOUND)
        return Response(context)


def check_if_user_exist(user_id):
    url = 'http://localhost:8000/auth/user/' + str(user_id) + '/'
    if requests.get(url).text == 'true':
        return True
    else:
        return False