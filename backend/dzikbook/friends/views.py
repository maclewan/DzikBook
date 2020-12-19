import json
from .constants import SERVER_HOST

import requests
from django.shortcuts import render
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from .decorators import authenticate, hash_user, internal

# create your views here
from .models import Invitation, Relation
from .serializers import InvitationSerializer, RelationSerializer


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

        if not check_if_user_exist(user_id):
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
        id = request.user.id

        if not Invitation.objects.filter(id=invitation_id).exists():
            return Response("No such invitation", status=status.HTTP_404_NOT_FOUND)
        invitation = Invitation.objects.get(id=invitation_id)

        if str(id) not in (str(invitation.sender), str(invitation.receiver)):
            return Response("Wrong invitation id", status=status.HTTP_403_FORBIDDEN)

        return create_relation(invitation)

    @authenticate
    def delete(self, request, invitation_id):
        id = request.user.id

        if not Invitation.objects.filter(id=invitation_id).exists():
            return Response("No such invitation", status=status.HTTP_404_NOT_FOUND)
        invitation = Invitation.objects.get(id=invitation_id)

        if str(id) != str(invitation.receiver):
            return Response("Wrong invitation id", status=status.HTTP_403_FORBIDDEN)

        invitation.delete()
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

    @authenticate
    def delete(self, request, user_id):
        id = request.user.id
        if not check_friendship(user_id, id):
            Response("You are not friends!",status=status.HTTP_403_FORBIDDEN)

        relation = Relation.objects.filter(user1=id, user2=user_id) \
            if Relation.objects.filter(user1=id, user2=user_id).exists() \
            else Relation.objects.filter(user1=user_id, user2=id)

        relation.delete()
        return Response({"message": "Successfully removed user with id: " + str(user_id) + " from friends."})


class SigInUserFriendsView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request):
        id = request.user.id
        friends_list = get_friends_id(id)

        resp = get_user_list(friends_list, request.user.id)

        return Response(resp)


class FriendsView(APIView):
    authentication_classes = []

    @authenticate
    def get(self, request, user_id):
        friends_list = get_friends_id(user_id)

        resp = get_user_list(friends_list, request.user.id)

        return Response(resp)


class FriendsListView(APIView):
    authentication_classes = []

    @internal
    def get(self, request):
        user_id = request.user.id
        friends_list = get_friends_id(user_id)
        return Response({'friends_list' : friends_list})


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
    url = 'http://'+SERVER_HOST+'/users/multi/'
    headers = {"Uid": str(id), "Flag": hash_user(id)}
    r = requests.post(url, data=json.dumps(payload), headers=headers)

    return r.json()


def get_friends_id(user_id):
    friends_list = []
    friends_list.extend(Relation.objects.filter(user1=user_id))
    friends_list.extend(Relation.objects.filter(user2=user_id))

    return list(map(lambda a: a.user2 if str(a.user1) == str(user_id) else a.user1, friends_list))


def check_if_user_exist(user_id):
    url = 'http://'+SERVER_HOST+'/auth/user/' + str(user_id) + '/'
    print(requests.get(url).text)
    if requests.get(url).text == 'true':
        return True
    else:
        return False


def create_relation(invitation):
    data = {
        'user1': invitation.receiver,
        'user2': invitation.sender
    }

    serializer = RelationSerializer(data=data)

    if not serializer.is_valid():
        return Response("Invalid data provided!", status=status.HTTP_400_BAD_REQUEST)

    relation = serializer.create(validated_data=data)
    relation.save()
    invitation.delete()

    # TODO: Notify notification service
    return Response({"message": "Relation created", "relation": serializer.data})
