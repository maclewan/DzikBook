from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response

# create your views here

class SigInUserFriendsInvitationsView(APIView):

    def get(self, request):
        invitations_list = []
        context = {'Invitations received list':invitations_list}
        return Response(context)

    def post(self, request, user_id):
        context = {'message':'Invitation successfully send.'}
        return Response(context)

    # TODO: może request_id?
    def delete(self, request, user_id):
        context = {'message':'Invitation successfully canceled.'}
        return Response(context)

class SigInUserInvitationsSendView(APIView):

    def get(self, request):
        invitations_list = []
        context = {'invitations list':invitations_list}
        return Response(context)

class InvitationsManagementView(APIView):

    def post(self, request, invitation_id):
        context = {'message':'Invitation successfully accepted.'}
        return Response(context)
    
    # TODO: zmieniłem Post na Delete
    def delete(self, request, invitation_id):
        context = {'message':'Invitation successfully rejected.'}
        return Response(context)

# TODO: zmień nazwę, koniecznie
class SigInUserAreYouFriendsView(APIView):
    def get(self, request, user_id):
        context = {'message':'Yes.'}
        return Response(context)

class SigInUserFriendsView(APIView):
    def get(self, request):
        friends_list = []
        context = {'friends list':friends_list}
        return Response(context)

class FriendsView(APIView):
    def get(self, request, user_id):
        friends_list = []
        context = {'friends list':friends_list}
        return Response(context)