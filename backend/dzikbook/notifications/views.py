import json

from django.shortcuts import render
from django.contrib.auth.models import User
import notifications.constants as constants

from rest_framework.views import APIView
from rest_framework.response import Response

from .constants import FCM_DJANGO_SETTINGS
from .models import Notification, Device
from .serializers import NotificationSerializer, DeviceSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from django.db import models
import requests

# create your views here
from .decorators import authenticate, internal, hash_user


class RegisterDeviceView(APIView):
    authentication_classes = []

    @authenticate
    def post(self, request):
        user = request.user
        data = json.loads(json.dumps(request.POST))
        data['user'] = user.id

        serializer = DeviceSerializer(data=data)
        if not serializer.is_valid():
            return Response("Invalid data provided!", status=status.HTTP_400_BAD_REQUEST)

        device = serializer.create(validated_data=data)
        device_token = device.token
        if Device.objects.filter(token=device_token).exists():
            return Response("Invalid data provided!", status=status.HTTP_400_BAD_REQUEST)
        
        device.save()
        return Response(serializer.data, status=status.HTTP_202_ACCEPTED)

    @authenticate
    def delete(self, request):
        device_token = request.POST.get('deviceToken', None)
        if device_token is None:
            return Response("Device token not provided!", status=status.HTTP_400_BAD_REQUEST)
        
        devices = Device.objects.filter(token=device_token, user=request.user.id)
        devices.delete()
        return Response("Device uninstalled successfully", status=status.HTTP_202_ACCEPTED)
      


class SigInUserNotificationsView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request):
        try:
            current_user = request.user
            notifications_list = list(Notification.objects.filter(user=current_user.pk))

            to_return = []
            for n in notifications_list:
                not_type = n.notification_type
                name = get_user_name(n.sender)


                if not_type == 'invitation_send':
                    title = 'Zaproszenie'
                    body = f'Użytkownik {name} wysłał Ci zaproszenie'
                elif not_type == 'invitation_accepted':
                    title = 'Zaproszenie zaakceptowane'
                    body = f'Użytkownik {name} zaakceptował twoje zaproszenie'
                elif not_type == 'comment':
                    title = 'Skomentowano Twój post'
                    body = f'Użytkownik {name} skomentował twój post'
                elif not_type == 'like':
                    title = 'Zadzikowano Twój post'
                    body = f'Użytkownik {name} zadzikował twój post'

                to_return.append(
                    {
                        'notification_type': n.notification_type,
                        'sender': n.sender,
                        'title': title,
                        'body': body,
                        'post': n.post
                    }
                )

        except:
            return Response("Error, could not retrive logged in user notifications!",
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        return Response(to_return)

    # TODO: zamienić na aktualizowanie czasu
    @authenticate
    def put(self, request, notification_id):
        try:
            notification = Notification.objects.get(pk=notification_id)
            data = {'notification_type': 'displayed'}
            notification_serializer = NotificationSerializer()
            notification = notification_serializer.update(instance=notification, validated_data=data)
            context = {
                'message': 'Notification displayed.',
                'notification': NotificationSerializer(notification).data
            }
            return Response(context)
        except models.ObjectDoesNotExist:
            return Response("Notification doesn't exist!", status=status.HTTP_404_NOT_FOUND)

    @authenticate
    def post(self, request):
        # todo try except
        data = json.loads(json.dumps(request.POST))

        if not check_if_user_exist(data['user']):
            return Response("User with id: " + str(data['user']) + " doesn't exist!", status=status.HTTP_404_NOT_FOUND)

        notification_serializer = NotificationSerializer(data=data)

        if not notification_serializer.is_valid():
            return Response("Invalid data provided!", status=status.HTTP_400_BAD_REQUEST)

        notification = notification_serializer.create(validated_data=data)
        notification.save()

        push_notification(data['user'], data['sender'], data['notification_type'])

        return Response(notification_serializer.data)


def check_if_user_exist(user_id):
    url = 'http://' + constants.SERVER_HOST + '/auth/user/' + str(user_id) + '/'
    if requests.get(url).text == 'true':
        return True
    else:
        return False


def get_user_name(user_id):
    url = 'http://' + constants.SERVER_HOST + '/users/basic/' + str(user_id) + '/'
    headers = {"Uid": str(user_id), "Flag": hash_user(user_id)}
    r = requests.get(url, headers=headers)
    return f"{r.json()['first_name']} {r.json()['last_name']}"


def push_notification(user: int, sender: int, not_type: str):
    sender_name = get_user_name(sender)

    if not_type == 'invitation_send':
        title = 'Zaproszenie'
        body = f'Użytkownik {sender_name} wysłał Ci zaproszenie'
    elif not_type == 'invitation_accepted':
        title = 'Zaproszenie'
        body = f'Użytkownik {sender_name} zaakceptował twoje zaproszenie'
    elif not_type == 'comment':
        title = 'Komentarz'
        body = f'Użytkownik {sender_name} skomentował twój post'
    elif not_type == 'like':
        title = 'Dzik'
        body = f'Użytkownik {sender_name} zadzikował twój post'
    else:
        print('Notification type not recognized')
        return

    url = FCM_DJANGO_SETTINGS.get('FCM_URL')
    headers = {
        'Authorization': FCM_DJANGO_SETTINGS.get('FCM_SERVER_KEY'),
        'Content-Type': 'application/json'
    }

    try:
        devices = list(Device.objects.filter(user=int(user)))
    except Device.DoesNotExist:

        devices = []

    devices_tokens = [d.token for d in devices]

    codes = []
    for device_token in devices_tokens:
        if device_token is None:
            continue
        print('Pushing not fot device: '+device_token)
        request_body = {
            'to': device_token,
            'collapse_key': 'New Message from macieks computer',
            'priority': 'high',
            'notification': {
                'title': title,
                'body': body
            }
        }

        a = requests.post(url=url, headers=headers, data=json.dumps(request_body))

        codes.append(a.status_code)

    return codes
