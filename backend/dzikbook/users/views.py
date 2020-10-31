from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework_simplejwt.authentication import JWTAuthentication

from .models import UserData


# create your views here

class SignedInUserDataView(APIView):
    """
    Get this user data
    """
    def get(self, request):
        # user_data = UserData.objects.filter(user = )
        jwt_object = JWTAuthentication()
        token = request.headers.get('Token')
        validated_token = jwt_object.get_validated_token(token)
        user = jwt_object.get_user(validated_token)
        print(user)
        context = {
            'username': request.user.pk
        }
        return Response(context)

    def post(self, request):
        user_data = None
        context = {'message': 'Data successfully updated'}
        return Response(context)


class UserDataView(APIView):

    def get(self, request, id):
        user_data = None
        context = {'user_data': user_data}
        return Response(context)


class SearchView(APIView):

    def get(self, request):
        print(request.GET)
        users_list = []
        context = {'users_list': users_list}
        return Response(context)
