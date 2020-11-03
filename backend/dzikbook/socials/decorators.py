import requests
from rest_framework.response import Response
from django.contrib.auth.models import User
from rest_framework.request import Request
from rest_framework_simplejwt.tokens import AccessToken


def authenticate(f):
    def validate(*args, **kwargs):
        if type(args[1] == Request):
            request = args[1]
            auth = request.headers["Authorization"] if 'Authorization' in request.headers else ''
            url = 'http://localhost:8000/auth/validate/'
            headers = {"Authorization": auth}
            r = requests.get(url, headers=headers)

            try:
                id = r.json()['user_id']
            except:
                return Response(r.json())

            args[1].user = get_user(id)
        return f(*args, **kwargs)

    return validate


def get_user(id):
    new_user = User()
    new_user.id = id
    return new_user
