import requests
from rest_framework.response import Response
from django.contrib.auth.models import User
from rest_framework_simplejwt.tokens import AccessToken


def authenticate(f):
    def validate(*args):
        request = args[1]

        auth = request.headers["Authorization"] if 'Authorization' in request.headers else ''
        url = 'http://localhost:8000/auth/validate/'
        headers = {
            "Authorization": auth}
        r = requests.get(url, headers=headers)
        det = r.json()['detail']
        if not det == 'true':
            return Response(r.json())

        user = get_user(auth.split(" ")[-1])
        request.user = user

        return f(args[0], request)

    return validate


def get_user(token):
    try:
        valid_token = AccessToken(token)
    except:
        return None

    user_id = valid_token.payload['user_id']
    new_user = User()
    new_user.id = user_id
    return new_user
