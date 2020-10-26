from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response

# create your views here

class SigInUserNotificationsView(APIView):

    def get(self, request):
        notifications_list = []
        context = {'notifications_list':notifications_list}
        return Response(context)
    
    def put(self, request, notification_id):
        context = {'message':'Notification displayed.'}
        return Response(context)
