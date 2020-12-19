from django.shortcuts import render
from django.contrib.auth.models import User
from .constants import SERVER_HOST


from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Notification
from .serializers import NotificationSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from django.db import models
import requests

# create your views here
from .decorators import authenticate


class SigInUserNotificationsView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request):
        try:
            current_user = request.user
            notifications_list = Notification.objects.filter(user=current_user.pk)
            context = {'notifications_list':NotificationSerializer(notifications_list, many=True).data}
        except:
            return Response("Error, could not retrive logged in user notifications!", status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        return Response(context)
    
    # TODO: zamienić na aktualizowanie czasu
    @authenticate
    def put(self, request, notification_id):
        try:
            notification = Notification.objects.get(pk = notification_id)
            data = {'notification_type': 'displayed'}
            notification_serializer = NotificationSerializer()
            notification = notification_serializer.update(instance=notification, validated_data=data)
            context = {
                'message':'Notification displayed.',
                'notification':NotificationSerializer(notification).data
                }
            return Response(context)
        except models.ObjectDoesNotExist:
            return Response("Notification doesn't exist!", status=status.HTTP_404_NOT_FOUND)
    # TODO: jak z postami?
    @authenticate
    def post(self, request, user_id, not_type):
        if not check_if_user_exist(user_id):
            return Response("User with id: " + str(user_id) + " doesn't exist!", status=status.HTTP_404_NOT_FOUND)
        try:
            data = {
                "user": user_id,
                "notification_type": not_type,
                "post": None
            }
            notification_serializer = NotificationSerializer()
            notification = notification_serializer.create(data)
            context = {
                "notification": NotificationSerializer(notification).data,
                "message": "Notification successfully created."
                }
            return Response(context)
        except:
            return Response("Could not create Response", status=status.HTTP_500_INTERNAL_SERVER_ERROR)

def check_if_user_exist(user_id):
    url = 'http://'+SERVER_HOST+'/auth/user/' + str(user_id) + '/'
    if requests.get(url).text == 'true':
        return True
    else:
        return False