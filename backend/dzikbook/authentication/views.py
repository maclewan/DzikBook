from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response

# Create your views here.

class RegisterView(APIView):

    def post(self, request):

        context = {'message': 'Successfully registered'}
        return Response(context)

# TODO: do usunięcia
class LoginView(APIView):

    pass

class ResetPasswordView(APIView):

    def post(self, request):

        context = {'message': 'Passord successfully changed. Check mail.'}
        return Response(context)

class DeleteAccountView(APIView):

    def delete(self, request):

        context = {'message': 'Account successfully deleted.'}
        return Response(context)

