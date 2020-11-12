import json

import requests
from django.shortcuts import render
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from .decorators import authenticate, hash_user

# create your views here
from .models import Invitation, Relation
from .serializers import InvitationSerializer


class SigInUserFriendsInvitationsView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request):

        id = request.user.id
        invitations_list = []
        invitations_list.extend(Invitation.objects.filter(receiver=id))
        context = {'invitations_list': InvitationSerializer(invitations_list, many=True).data}
        return Response(context)

    @authenticate
    def post(self, request, user_id):
        id = request.user.id

        if str(id) == str(user_id):
            return Response("Don't be a loser", status=status.HTTP_451_UNAVAILABLE_FOR_LEGAL_REASONS)

        if check_friendship(id, user_id):
            return Response("Already friends!", status=status.HTTP_208_ALREADY_REPORTED)

        if check_invitations(id, user_id):
            return Response("There is already one invitation!", status=status.HTTP_208_ALREADY_REPORTED)

        # Check if user exists
        url = 'http://localhost:8000/auth/user/' + str(user_id) + '/'
        if requests.get(url).text == 'false':
            return Response("No such user in db!", status=status.HTTP_422_UNPROCESSABLE_ENTITY)

        data = {
            'sender': id,
            'receiver': user_id
        }

        serializer = InvitationSerializer(data=data)

        if not serializer.is_valid():
            return Response("Invalid data provided!", status=status.HTTP_400_BAD_REQUEST)

        invit = serializer.create(validated_data=data)
        invit.save()

        context = {
            'message': 'Invitation successfully send.',
            'invitation_id': invit.id
        }
        return Response(context)

    @authenticate
    def delete(self, request, user_id):
        id = request.user.id
        invit_list = Invitation.objects.filter(sender=id, receiver=user_id)
        if len(invit_list) == 0:
            return Response("No such invitation!", status=status.HTTP_404_NOT_FOUND)

        invit_list.delete()

        context = {'message': 'Invitation successfully deleted.'}
        return Response(context)


class SigInUserInvitationsSentView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request):
        id = request.user.id

        invitations_list = []
        invitations_list.extend(Invitation.objects.filter(sender=id))
        context = {'invitations_list': InvitationSerializer(invitations_list, many=True).data}
        return Response(context)


class InvitationsManagementView(APIView):
    authentication_classes = []

    @authenticate
    def post(self, request, invitation_id):
        context = {'message': 'Invitation successfully accepted.'}
        return Response(context)

    @authenticate
    def delete(self, request, invitation_id):
        context = {'message': 'Invitation successfully rejected.'}
        return Response(context)


class SigInUserFriendInfo(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, user_id):
        id = request.user.id

        (request_id, relation) = \
            (None, 'Just you') if str(id) == str(user_id) \
                else (None, 'Friends') if check_friendship(id, user_id) \
                else (get_invitation_id(id, user_id), 'Request sent') if check_if_sent(id, user_id) \
                else (get_invitation_id(id, user_id), 'Request received') if check_if_sent(user_id, id) \
                else (None, 'Not Friends')

        context = {
            'relation': relation,
            'request_id': request_id,
        }
        return Response(context)


class SigInUserFriendsView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request):
        id = request.user.id
        friends_list = []
        friends_list.extend(Relation.objects.filter(user1=id))
        friends_list.extend(Relation.objects.filter(user2=id))

        friends_list = list(map(lambda a: a.user2 if str(a.user1) == str(id) else a.user1, friends_list))

        resp = get_user_list(friends_list, request.user.id)

        return Response(resp)


class FriendsView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, user_id):
        friends_list = []
        friends_list.extend(Relation.objects.filter(user1=user_id))
        friends_list.extend(Relation.objects.filter(user2=user_id))

        friends_list = list(map(lambda a: a.user2 if str(a.user1) == str(user_id) else a.user1, friends_list))

        resp = get_user_list(friends_list, request.user.id)

        return Response(resp)


def check_friendship(user1, user2):
    return Relation.objects.filter(user1=user1, user2=user2).exists() or \
           Relation.objects.filter(user2=user1, user1=user2).exists()


def check_invitations(user1, user2):
    return check_if_sent(user1, user2) or check_if_sent(user2, user1)


def get_invitation_id(user1, user2):
    invit_list = []
    invit_list.extend(Invitation.objects.filter(sender=user1, receiver=user2))
    invit_list.extend(Invitation.objects.filter(sender=user2, receiver=user1))
    return list(invit_list)[0].id


def check_if_sent(user1, user2):
    return Invitation.objects.filter(sender=user1, receiver=user2).exists()


def get_user_list(friends_list, id):
    payload = {'id_list': friends_list}

    # Send request to users service
    url = 'http://localhost:8000/users/multi/'
    headers = {"Uid": str(id), "Flag": hash_user(id)}
    r = requests.post(url, data=json.dumps(payload), headers=headers)

    return r.json()


def check_if_user_exist():
    pass
