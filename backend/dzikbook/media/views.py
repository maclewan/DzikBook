from django.contrib.auth.models import User
from django.core.files.base import ContentFile
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
from PIL import Image
import uuid
import os
from io import BytesIO
from django.core.files.uploadedfile import InMemoryUploadedFile

# create your views here
from .decorators import authenticate


class PhotoManagementView(APIView):
    authentication_classes = []

    @authenticate
    def post(self, request):
        form = PhotoForm(request.POST, request.FILES)
        if not form.is_valid():
            return Response("Invalid form, please provide an image!", status=status.HTTP_415_UNSUPPORTED_MEDIA_TYPE)

        form.instance.user = request.user.id
        photo = form.save()
        context = {
            'photo': PhotoSerializer(photo).data,
            'message': 'Photo uploaded successfully.'
        }
        return Response(context)

    @authenticate
    def delete(self, request, photo_id):
        try:
            photo = Photo.objects.get(id=photo_id, user=request.user.id)
            photo.delete()
            context = {'message': 'Photo deleted successfully.'}
        except models.ObjectDoesNotExist:
            return Response("Photo doesn't exist!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)


class SigInUserProfilePhotoView(APIView):
    authentication_classes = []

    @authenticate
    def post(self, request):
        response = PhotoManagementView().post(request)
        if 'photo' not in response.data:  # if error occured
            return response

        original_photo_id = response.data['photo']['id']
        photo = request.FILES['photo']
        photo = Image.open(photo.file)
        downsized_photo = photo.resize((100, 100))

        in_memory_file = image_to_inmemory(downsized_photo)

        request.FILES['photo'] = in_memory_file
        response_downsized = PhotoManagementView().post(request)

        if 'photo' not in response_downsized.data:  # if error occured
            return response_downsized

        downsized_photo_id = response_downsized.data['photo']['id']

        original_photo = Photo.objects.get(pk=original_photo_id)
        downsized_photo = Photo.objects.get(pk=downsized_photo_id)

        profile_photo = ProfilePhoto.objects.create(photo=original_photo,
                                                    downsized_photo=downsized_photo,
                                                    user=request.user.pk)
        try:
            old_profile_photo = ProfilePhoto.objects.filter(user=request.user.pk)
            old_profile_photo.delete()
        except ProfilePhoto.DoesNotExist:
            pass

        profile_photo.save()

        context = {
            'photo': ProfilePhotoSerializer(profile_photo).data,
            'message': 'Photo uploaded successfully.'
        }
        return Response(context)

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
            return Response("Error, could not retrive logged in user profile photos!",
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        return Response(context)

    @authenticate
    def delete(self, request, profile_photo_id):
        try:
            profile_photo = ProfilePhoto.objects.get(id=profile_photo_id, user=request.user.id)
            profile_photo.delete()
            context = {'message': 'Profile photo deleted successfully.'}
        except models.ObjectDoesNotExist:
            return Response("Profile photo doesn't exist!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)


class ProfilePhotoView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, user_id):
        try:
            photo = ProfilePhotoSerializer(ProfilePhoto.objects.get(user=user_id)).data
            context = {
                'photo': photo,
                'description': ''
            }
        except:
            return Response("Error, could not retrive profile photo with id " + str(user_id) + "!",
                            status=status.HTTP_404_NOT_FOUND)
        return Response(context)


def image_to_inmemory(photo):
    path = os.path.join(os.path.abspath(""), 'storage', 'thumbnails')

    while True:
        filename = uuid.uuid4().hex + '.png'
        full_path = os.path.join(path, filename)
        if not os.path.isfile(full_path):
            break

    photo_io = BytesIO()
    photo.save(fp=photo_io, format='PNG')
    photo_file = ContentFile(photo_io.getvalue())

    photo_file = InMemoryUploadedFile(photo_file, None, filename, 'image/png',
                                      photo_file.tell, None)

    return photo_file


def check_if_user_exist(user_id):
    url = 'http://localhost:8000/auth/user/' + str(user_id) + '/'
    if requests.get(url).text == 'true':
        return True
    else:
        return False
