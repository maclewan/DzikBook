from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response

# create your views here

class PhotoManagementView(APIView):

    def post(self, request):
        context = {
            'photo_id':'5',
            'message':'Photo uploaded successfully.'
        }
        return Response(context)
    
    def delete(self, request, photo_id):
        photo = None
        context = {'message':'Photo deleted successfully.'}
        return Response(context)

class VideoManagementView(APIView):
    
    def post(self, request):
        context = {
            'video_id':'5',
            'message':'Video uploaded successfully.'
        }
        return Response(context)
    
    def delete(self, request, video_id):
        video = None
        context = {'message':'Video deleted successfully.'}
        return Response(context)

class SigInUserProfilePhotoView(APIView):
    
    def post(self, request):
        context = {
            'photo_id':'5',
            'message':'Profile photo uploaded successfully.'
        }
        return Response(context)
    
    def get(self, request):
        photo = None
        context = {
            'photo':photo,
            'description':'Looking great!'
        }
        return Response(context)

class ProfilePhotoView(APIView):

    def get(self, request, user_id):
        photo = None
        context = {
            'photo':photo,
            'description':''
        }
        return Response(context)