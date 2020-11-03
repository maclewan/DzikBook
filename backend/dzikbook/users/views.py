import requests
from django.shortcuts import render
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework_simplejwt.authentication import JWTAuthentication

from .decorators import authenticate
from .models import UserData


# create your views here


class SignedInUserDataView(APIView):
    """
    Get this user data
    """
    authentication_classes = []

    @authenticate
    def get(self, request):

        context = {
            'user_id': request.user.id,
        }
        return Response(context)

    @authenticate
    def post(self, request):
        user_data = None
        context = {'message': 'Data successfully updated'}
        return Response(context)


class UserDataView(APIView):

    @authenticate
    def get(self, request, id):
        user_data = None
        context = {'user_data': user_data}
        return Response(context)


class SearchView(APIView):

    @authenticate
    def get(self, request):
        print(request.GET)
        users_list = []
        context = {'users_list': users_list}
        return Response(context)
