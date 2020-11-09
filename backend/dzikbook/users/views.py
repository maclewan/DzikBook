import json

import requests
from django.core import serializers
from django.http.response import JsonResponse
from rest_framework import status
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework_simplejwt.authentication import JWTAuthentication

from .decorators import authenticate
from .models import UserData


# create your views here
from .serializers import UserDataSerializer


class SignedInUserDataView(APIView):
    """
    Get this user data
    """
    authentication_classes = []

    @authenticate
    def get(self, request):
        user_id = request.user.id
        user_data = list(UserData.objects.filter(user=user_id).values())

        return JsonResponse(user_data, safe=False)

    @authenticate
    def post(self, request):
        try:
            user_id = request.user.id
            if UserData.objects.filter(user=user_id).exists():\
                return Response("UserData already exists!", status=status.HTTP_409_CONFLICT)

            data = json.loads(json.dumps(request.POST))
            data['user'] = user_id

            data_serializer = UserDataSerializer(data=data)

            if not data_serializer.is_valid():
                return Response("Invalid data provided!", status=status.HTTP_400_BAD_REQUEST)

            data_serializer.create(validated_data=data)

            return Response(data_serializer.data)

        except Exception as e:
            return Response("Error during posting a comment!", status=status.HTTP_409_CONFLICT)

    @authenticate
    def put(self, request):
        user_data = None
        context = {'message': 'Data successfully updated'}
        return Response(context)


class UserDataView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, id):
        user_data = None
        context = {'user_data': user_data}
        return Response(context)


class SearchView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request):
        print(request.GET)
        users_list = []
        context = {'users_list': users_list}
        return Response(context)
