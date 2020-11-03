from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response

# create your views here
from .decorators import authenticate


class PhotoManagementView(APIView):
    authentication_classes = []

    @authenticate
    def post(self, request):
        context = {
            'photo_id': '5',
            'message': 'Photo uploaded successfully.'
        }
        return Response(context)

    @authenticate
    def delete(self, request, photo_id):
        photo = None
        context = {'message': 'Photo deleted successfully.'}
        return Response(context)


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
        video = None
        context = {'message': 'Video deleted successfully.'}
        return Response(context)


class SigInUserProfilePhotoView(APIView):
    authentication_classes = []

    @authenticate
    def post(self, request):
        context = {
            'photo_id': '5',
            'message': 'Profile photo uploaded successfully.'
        }
        return Response(context)

    @authenticate
    def get(self, request):
        photo = None
        context = {
            'photo': photo,
            'description': 'Looking great!'
        }
        return Response(context)


class ProfilePhotoView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, user_id):
        photo = None
        context = {
            'photo': photo,
            'description': ''
        }
        return Response(context)
