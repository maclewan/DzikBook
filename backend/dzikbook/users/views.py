from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response

# create your views here

# TODO: można jeden widok do obu rodzajów usera
class SignedInUserDataView(APIView):

    def get(self, request):
        user_data = None
        context = {'user data':user_data}
        return Response(context)
    
    def post(self, request):
        
        user_data = None
        context = {'message':'Data successfully updated'}
        return Response(context)

class UserDataView(APIView):

    def get(self, request, id):
        user_data = None
        context = {'user data':user_data}
        return Response(context)

# TODO: może jako jeden widok
class SearchByNameView(APIView):
    
    def get(self, request, user_name):

        users_list = []
        context = {'users list':users_list}
        return Response(context)

class SearchByGymView(APIView):
    
    def get(self, request, gym):

        users_list = []
        context = {'users list':users_list}
        return Response(context)