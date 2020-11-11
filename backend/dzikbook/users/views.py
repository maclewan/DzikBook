import json

import requests
from django.db import models
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response

from .decorators import authenticate, hash_user
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
        url = 'http://localhost:8000/friends/' + str(id) + '/'
        headers = {"Uid": str(request.user.id), "Flag": hash_user(request.user.id)}
        r = requests.get(url, headers=headers)
        r = r.json()

        try:
            if r['relation'] == 'Friends':
                # If user are friends
                user_data = UserData.objects.get(user=id)
                context = UserDataSerializer(user_data, many=False).data

                return Response(context)
            else:
                # If not
                user_data = UserData.objects.get(user=id)
                context = {
                    'first_name': user_data.first_name,
                    'last_name': user_data.last_name
                }

                return Response(context)

        except models.ObjectDoesNotExist:
            return Response("User data doesnt exist!", status=status.HTTP_404_NOT_FOUND)


class SearchView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request):

        key = request.GET.get('key', '')
        value = request.GET.get('value', '')
        amount = int(request.GET.get('amount', ''))
        offset = int(request.GET.get('offset', ''))

        if '' in (key, amount, offset, value):
            return Response("Wrong argument set (key, amount, offset).",
                            status=status.HTTP_422_UNPROCESSABLE_ENTITY)
        if key not in ('gym', 'name'):
            return Response("Wrong search key (gym, name).",
                            status=status.HTTP_422_UNPROCESSABLE_ENTITY)
        if (not amount > 0) or (not offset >= 0):
            return Response("Wrong numeric argument, provide numbers > 0.",
                            status=status.HTTP_406_NOT_ACCEPTABLE)

        user_data_list = []
        if key == 'gym':

            user_data_list.extend(list(UserData.objects.filter(gym__iexact=value)))
            user_data_list.extend(list(UserData.objects.filter(gym__icontains=value)))

        elif key == 'name':
            names_list = value.split(' ')
            last_name = names_list[len(names_list) - 1]
            first_name = names_list[0]

            user_data_list.extend(
                list(UserData.objects.filter(first_name__iexact=first_name, last_name__iexact=last_name)))
            user_data_list.extend(list(UserData.objects.filter(last_name__iexact=last_name)))
            user_data_list.extend(list(UserData.objects.filter(last_name__icontains=last_name)))

        user_data_list = list(set(user_data_list))
        context = list(map(lambda u: {
            'user_id': u.user,
            'first_name': u.first_name,
            'last_name': u.last_name,
            'gym': u.gym
        }, user_data_list))

        # Apply offset and amount filters
        count = len(context)
        context = \
            [] if count <= offset else \
            context[offset:count] if count <= offset + amount \
            else context[offset:offset+amount]


        context = {'users_list': context}
        return Response(context)
