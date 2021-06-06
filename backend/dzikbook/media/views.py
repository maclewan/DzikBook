from django.contrib.auth.models import User
from .constants import SERVER_HOST

from django.core.files.base import ContentFile
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Photo, ProfilePhoto
from .serializers import PhotoSerializer, ProfilePhotoSerializer
from rest_framework import status
from django.db import models
from .forms import PhotoForm
from PIL import Image
import uuid
import os
from io import BytesIO
from django.core.files.uploadedfile import InMemoryUploadedFile

# create your views here
from .decorators import authenticate, internal


class PhotoManagementView(APIView):
    authentication_classes = []

    @internal
    def post(self, request):
        response = save_inmemory_image(request)
        return response

    @internal
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
        response = save_inmemory_image(request)
        if 'photo' not in response.data:  # if error occured
            return response

        original_photo_id = response.data['photo']['id']
        photo = request.FILES['photo']
        photo = Image.open(photo.file)
        downsized_photo = photo.resize((100, 100))

        in_memory_file = image_to_inmemory(downsized_photo)

        request.FILES['photo'] = in_memory_file
        response_downsized = save_inmemory_image(request)

        if 'photo' not in response_downsized.data:  # pragma: no cover
            return response_downsized

        downsized_photo_id = response_downsized.data['photo']['id']

        profile_photo = ProfilePhoto(photo=original_photo_id,
                                     downsized_photo=downsized_photo_id,
                                     user=request.user.pk)

        old_profile_photo = ProfilePhoto.objects.filter(user=request.user.pk)

        if old_profile_photo.exists():
            old_profile_photo.delete()

        profile_photo.save()

        context = ProfilePhotoSerializer(profile_photo).data,

        return Response(context)

    @authenticate
    def get(self, request):
        current_user = request.user
        profile_photo = ProfilePhoto.objects.filter(user=current_user.pk).first()  # None if not found
        if profile_photo is None:
            photo = Photo()
            downsized_photo = Photo()
            photo.photo = "photos/default_profile.png"
            downsized_photo.photo = "photos/default_profile_downscaled.png"
            context = {'id': None,
                       'photo': PhotoSerializer(photo).data,
                       'downsized_photo': PhotoSerializer(downsized_photo).data,
                       'user': current_user.id}
        else:
            context = ProfilePhotoSerializer(profile_photo).data
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
        profile_photo = ProfilePhoto.objects.filter(user=user_id).first()  # None if not found
        if profile_photo is None:
            photo = Photo()
            downsized_photo = Photo()
            photo.photo = "photos/default_profile.png"
            downsized_photo.photo = "photos/default_profile_downscaled.png"
            context = {'id': None,
                       'photo': PhotoSerializer(photo).data,
                       'downsized_photo': PhotoSerializer(downsized_photo).data,
                       'user': user_id}
        else:
            context = ProfilePhotoSerializer(profile_photo).data
        return Response(context)


def save_inmemory_image(request):
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


def image_to_inmemory(photo):
    path = os.path.join(os.path.abspath(""), 'storage', 'photos')
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
