import requests
from rest_framework.response import Response
from django.contrib.auth.models import User


def authenticate(f):
    def validate(*args, **kwargs):
        request = args[1]

        auth = request.headers["Authorization"] if 'Authorization' in request.headers else ''
        url = 'http://127.0.0.1:8000/auth/validate/'
        headers = {"Authorization": auth}
        r = requests.get(url, headers=headers)
        try:
            id = r.json()['user_id']
        except:
            return Response(r.json())

        request.user = get_user(id)

        return f(*args, **kwargs)

    return validate


def get_user(id):
    new_user = User()
    new_user.id = id
    return new_user
