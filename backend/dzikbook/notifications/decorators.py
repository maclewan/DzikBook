import hashlib
import requests
from django.contrib.auth.models import User
from rest_framework import status
from rest_framework.response import Response


def authenticate(f):
    def validate(*args, **kwargs):
        request = args[1]

        if 'Flag' in request.headers:
            # If service will communicate just with another service

            try:
                id = request.headers["Uid"]
                flag = request.headers["Flag"]

                if not valid_hash(flag, id):
                    raise Exception

            except Exception as e:
                return Response("Not authorised!", status=status.HTTP_401_UNAUTHORIZED)

        else:
            # Is user will communicate with service
            auth = request.headers["Authorization"] if 'Authorization' in request.headers else ''
            url = 'http://127.0.0.1:8000/auth/validate/'
            headers = {"Authorization": auth}
            r = requests.get(url, headers=headers)

            try:
                id = r.json()['user_id']
            except Exception:
                return Response(r.json())

        request.user = get_user(id)

        return f(*args, **kwargs)

    return validate


def get_user(id):
    new_user = User()
    new_user.id = id
    return new_user


def valid_hash(flag, uid):
    text = 'stonoga' + str(uid)
    h = hashlib.sha256(str(text).encode('utf-8'))
    return flag == h.hexdigest()


def hash_user(uid):
    text = 'stonoga' + str(uid)
    h = hashlib.sha256(str(text).encode('utf-8'))
    return h.hexdigest()
