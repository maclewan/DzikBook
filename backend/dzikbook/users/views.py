import json

from django.db import models
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response

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
        try:
            user_id = request.user.id
            user_data = UserData.objects.get(user=user_id)
            context = UserDataSerializer(user_data, many=False).data

            return Response(context)
        except models.ObjectDoesNotExist:
            return Response("User data doesnt exist!", status=status.HTTP_404_NOT_FOUND)


    @authenticate
    def post(self, request):
        try:
            user_id = request.user.id

            data = json.loads(json.dumps(request.POST))
            data['user'] = user_id

            data_serializer = UserDataSerializer(data=data)

            if not data_serializer.is_valid():
                return Response("Invalid data provided!", status=status.HTTP_400_BAD_REQUEST)

            data_serializer.create(validated_data=data)
            return Response(data_serializer.data)

        except Exception as e:
            print(e)
            return Response("Error during posting a comment, record already exists!", status=status.HTTP_409_CONFLICT)

    @authenticate
    def put(self, request):
        try:
            user_id = request.user.id
            user_data = UserData.objects.get(user=user_id)

            data = json.loads(json.dumps(request.POST))
            data['user'] = user_id

            data_serializer = UserDataSerializer(data=data)

            if not data_serializer.is_valid():
                return Response("Invalid data provided!", status=status.HTTP_400_BAD_REQUEST)

            user_data = data_serializer.update(instance=user_data, validated_data=data)

        except models.ObjectDoesNotExist:
            return Response("User data doesnt exist!", status=status.HTTP_404_NOT_FOUND)

        context = {'message': 'Data successfully updated', 'user_data': UserDataSerializer(user_data).data}
        return Response(context)

    @authenticate
    def delete(self, request):
        try:
            user_id = request.user.id
            UserData.objects.get(user=user_id).delete()

        except models.ObjectDoesNotExist:
            return Response("User data doesnt exist!", status=status.HTTP_404_NOT_FOUND)

        context = {'message': 'Data successfully deleted'}
        return Response(context)


class UserDataView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, id):
        #if in friends, get data, if not, get only

        context = {'user_data': 'xd'}
        return Response(context)


class SearchView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request):
        print(request.GET)
        users_list = []
        context = {'users_list': users_list}
        return Response(context)
