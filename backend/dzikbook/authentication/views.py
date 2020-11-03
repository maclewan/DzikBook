from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import AccessToken
from rest_framework_simplejwt.views import TokenObtainPairView

from .serializers import RegisterSerializer, LogoutPossibleTokenObtainPairSerializer


# Create your views here.

class RegisterView(APIView):

    def post(self, request):
        try:
            data = {
                "email": request.POST.get('email'),
                "first_name": request.POST.get('first_name'),
                "last_name": request.POST.get('last_name'),
                "password": request.POST.get('password')
            }

            duplicate_users = User.objects.filter(email=data.get("email"))
            if not len(duplicate_users) == 0:
                raise Exception('This email is already registered')

            serializer = RegisterSerializer(data=data)
            if serializer.is_valid():
                user = serializer.save()
                print(user)
            else:
                raise Exception('Problem with data validation')

            return Response("User Created Successfully. Now login to get your token")
        except Exception as e:
            return Response({str(e)})


class ResetPasswordView(APIView):

    def post(self, request):
        context = {'message': 'Passord successfully changed. Check mail.'}
        return Response(context)


class DeleteAccountView(APIView):

    def delete(self, request):
        context = {'message': 'Account successfully deleted.'}
        return Response(context)


class LogoutPossibleTokenObtainPairView(TokenObtainPairView):
    serializer_class = LogoutPossibleTokenObtainPairSerializer


class ValidateUserView(APIView):
    permission_classes = [IsAuthenticated, ]

    def get(self, request):
        try:
            valid_token = AccessToken(request.headers['Authorization'].split(" ")[-1])
            user_id = valid_token.payload['user_id']
        except:
            user_id = -1

        return Response({
            'user_id': user_id
        })
