from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response

# create your views here

class SigInUserFriendsInvitationsView(APIView):

    def get(self, request):
        invitations_list = []
        context = {'invitations_list':invitations_list}
        return Response(context)

    def post(self, request, user_id):
        context = {'message':'Invitation successfully send.'}
        return Response(context)

    def delete(self, request, user_id):
        context = {'message':'Invitation successfully canceled.'}
        return Response(context)


class SigInUserInvitationsSendView(APIView):

    def get(self, request):
        invitations_list = []
        context = {'invitations_list':invitations_list}
        return Response(context)


class InvitationsManagementView(APIView):

    def post(self, request, invitation_id):
        context = {'message':'Invitation successfully accepted.'}
        return Response(context)
    
    def delete(self, request, invitation_id):
        context = {'message':'Invitation successfully rejected.'}
        return Response(context)


class SigInUserFriendInfo(APIView):
    def get(self, request, user_id):
        context = {
            'relation':'Friends',
            'request_id': '5',
            }
        return Response(context)


class SigInUserFriendsView(APIView):
    def get(self, request):
        friends_list = []
        context = {'friends_list':friends_list}
        return Response(context)


class FriendsView(APIView):
    def get(self, request, user_id):
        friends_list = []
        context = {'friends_list':friends_list}
        return Response(context)