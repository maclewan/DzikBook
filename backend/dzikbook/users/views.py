from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response

# create your views here

class SignedInUserDataView(APIView):

    def get(self, request):
        user_data = None
        context = {'user_data':user_data}
        return Response(context)
    
    def post(self, request):
        
        user_data = None
        context = {'message':'Data successfully updated'}
        return Response(context)

class UserDataView(APIView):

    def get(self, request, id):
        user_data = None
        context = {'user_data':user_data}
        return Response(context)

class SearchView(APIView):
    
    def get(self, request):
        print(request.GET)
        users_list = []
        context = {'users_list':users_list}
        return Response(context)