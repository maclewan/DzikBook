from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Notification
from .serializers import NotificationSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from django.db import models

# create your views here

class SigInUserNotificationsView(APIView):
    # permission_classes = (IsAuthenticated,)

    def get(self, request):
        try:
            current_user = request.user
            notifications_list = Notification.objects.filter(user=current_user.pk)
            context = {'notifications_list':NotificationSerializer(notifications_list, many=True).data}
        except:
            return Response("Error, could not retrive logged in user notifications!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)
    
    # TODO: zamienić na aktualizowanie czasu
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
        except models.ObjectDoesNotExist:
            return Response("Notification doesn't exist!", status=status.HTTP_404_NOT_FOUND)
        return Response(context)
