
from django.contrib.auth.models import User
from rest_framework.views import APIView
from rest_framework.response import Response
from .serializers import RegisterSerializer


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
