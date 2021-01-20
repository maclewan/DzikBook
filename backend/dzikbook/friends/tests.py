import datetime
import json
from copy import copy
from unittest import mock

import requests
from django.contrib.auth.models import User
from django.test import TestCase, LiveServerTestCase
from rest_framework.test import RequestsClient, APITestCase, APIClient

from .decorators import hash_user
from .models import Invitation, Relation
from .serializers import InvitationSerializer, RelationSerializer


# Create your tests here.
from .views import create_relation, get_friends_id, check_if_sent, get_invitation_id, check_friendship, \
    check_invitations


class InvitationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'sender': 1,
            'receiver': 2
        }

        Invitation.objects.create(**self.data)

    def test_create_invitation(self):
        invitation = Invitation.objects.get(pk=1)
        self.assertTrue(isinstance(invitation, Invitation))
        self.assertTrue(
            invitation.sender == 1 and invitation.receiver == 2)

    def test_invitation_serializer(self):
        invitation = Invitation.objects.get(pk=1)
        serializer = InvitationSerializer(invitation)

        self.assertEqual(serializer.data['sender'], 1)
        self.assertEqual(serializer.data['receiver'], 2)


class RelationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'user1': 1,
            'user2': 2,
        }

        Relation.objects.create(**self.data)

    def test_create_invitation(self):
        relation = Relation.objects.get(pk=1)
        self.assertTrue(isinstance(relation, Relation))
        self.assertTrue(
            relation.user1 == 1 and relation.user2 == 2)

    def test_invitation_serializer(self):
        relation = Relation.objects.get(pk=1)
        serializer = RelationSerializer(relation)

        self.assertEqual(serializer.data['user1'], 1)
        self.assertEqual(serializer.data['user2'], 2)


@mock.patch('friends.constants.SERVER_HOST', "localhost:8081")
@mock.patch('users.constants.SERVER_HOST', "localhost:8081")
@mock.patch('authentication.constants.SERVER_HOST', "localhost:8081")
@mock.patch('notifications.constants.SERVER_HOST', "localhost:8081")
class ViewsTestCase(LiveServerTestCase):
    port = 8081

    def setUp(self):
        self.invitation1 = {
            'sender': 6,
            'receiver': 1
        }
        self.invitation2 = {
            'sender': 3,
            'receiver': 1
        }

        self.client = APIClient()
        self.client.credentials(HTTP_Uid=str(1), HTTP_Flag=hash_user(1))

        self.client2 = APIClient()
        self.client2.credentials(HTTP_Uid=str(2), HTTP_Flag=hash_user(2))

        Invitation.objects.create(**self.invitation1)
        Invitation.objects.create(**self.invitation2)
        Relation.objects.create(**{'user1': 1, 'user2': 4})

        # user_data
        Relation.objects.create(**{'user1': 2, 'user2': 38})
        Relation.objects.create(**{'user1': 2, 'user2': 39})
        client38 = APIClient()
        client38.credentials(HTTP_Uid=str(38), HTTP_Flag=hash_user(38))

        client39 = APIClient()
        client39.credentials(HTTP_Uid=str(39), HTTP_Flag=hash_user(39))

        data38 = {
            'gym': "Gym for 38",
            'additional_data': "none",
            'first_name': "user 38",
            'last_name': 'lanem 38',
            'sex': "m",
            'job': "-",
            'birth_date': "02/02/1938",
        }

        data39 = {
            'gym': "Gym for 39",
            'additional_data': "none",
            'first_name': "user 39",
            'last_name': 'lanem 39',
            'sex': "m",
            'job': "-",
            'birth_date': "02/02/1939",
        }

        r1 = client38.post('http://testserver/users/data/', data38)
        r2 = client39.post('http://testserver/users/data/', data39)




    def test_get_signed_in_user_invitations(self):
        respond = self.client.get('http://testserver/friends/request/')
        self.assertTrue(respond.json()['invitations_list'][0]['sender'] ==6, respond.json()['invitations_list'][1]['sender']==3)

    def test_post_invitation(self):
        respond = self.client.post('http://testserver/friends/request/1/')
        self.assertEqual(respond.json(), "Don't be a loser")

        respond = self.client.post('http://testserver/friends/request/4/')
        self.assertEqual(respond.json(), "Already friends!")

        respond = self.client.post('http://testserver/friends/request/3/')
        self.assertEqual(respond.json(), "There is already one invitation!")

        respond = self.client.post('http://testserver/friends/request/5/')
        self.assertEqual(respond.json(), "No such user in db!")

    def test_get_sent_invitations(self):

        invitation3 = {
            'sender': 1,
            'receiver': 21
        }
        invitation4 = {
            'sender': 1,
            'receiver': 5
        }


        Invitation.objects.create(**invitation3)
        Invitation.objects.create(**invitation4)


        respond = self.client.get('http://testserver/friends/requests/sent/')

        list = respond.json()['invitations_list']
        self.assertTrue(list[0]['receiver'] == 21 and list[1]['receiver'] == 5)

    def test_manage_invitations_and_friendship_status(self):

        invitation3 = {
            'sender': 21,
            'receiver': 1
        }
        invitation4 = {
            'sender': 2,
            'receiver': 1
        }
        invitation5 = {
            'sender': 1,
            'receiver': 33
        }


        Invitation.objects.create(**invitation3)
        Invitation.objects.create(**invitation4)
        Invitation.objects.create(**invitation5)


        # Accepting
        respond = self.client.get('http://testserver:8081/friends/2/')
        request_id1 = 18
        self.assertEqual(respond.json(), {'relation': 'Request received', 'request_id': request_id1})

        respond = self.client.post('http://testserver:8081/friends/request/manage/99/')
        self.assertEqual(respond.json(), 'No such invitation')

        respond = self.client.post(f'http://testserver:8081/friends/request/manage/{request_id1}/')
        self.assertEqual(respond.json(), {'message': 'Relation created', 'relation': {'user1': 1, 'user2': 2}})

        respond = self.client.get('http://testserver:8081/friends/2/')
        self.assertEqual(respond.json(), {'relation': 'Friends', 'request_id': None})

        # Rejecting
        respond = self.client.get('http://testserver:8081/friends/21/')
        request_id2 = 17
        self.assertEqual(respond.json(), {'relation': 'Request received', 'request_id': request_id2})

        respond = self.client.delete(f'http://testserver:8081/friends/request/manage/{request_id2}/')
        self.assertEqual(respond.json(), {'message': 'Invitation successfully rejected.'})

        respond = self.client.get('http://testserver:8081/friends/21/')
        self.assertEqual(respond.json(), {'relation': 'Not Friends', 'request_id': None})

        respond = self.client.get('http://testserver:8081/friends/33/')
        self.assertEqual(respond.json(), {'relation': 'Request sent', 'request_id': 19})

        # Deleting from friends
        respond = self.client.delete('http://testserver:8081/friends/2/')
        self.assertEqual(respond.json(), {'message': 'Successfully removed user with id: 2 from friends.'})

        respond = self.client.get('http://testserver:8081/friends/2/')
        self.assertEqual(respond.json(), {'relation': 'Not Friends', 'request_id': None})

    def test_friends_list(self):
        respond = self.client2.get('http://testserver:8081/friends/list/')
        self.assertEqual(respond.json(), {'user_data_list': [{'user_id': 38, 'first_name': 'user 38', 'last_name': 'lanem 38'}, {'user_id': 39, 'first_name': 'user 39', 'last_name': 'lanem 39'}]})

    def test_someones_friends_list(self):
        respond = self.client.get('http://testserver:8081/friends/list/2/')
        self.assertEqual(respond.json(), {'user_data_list': [{'user_id': 38, 'first_name': 'user 38', 'last_name': 'lanem 38'}, {'user_id': 39, 'first_name': 'user 39', 'last_name': 'lanem 39'}]})

    def test_friends_id_list(self):
        respond = self.client.get('http://testserver:8081/friends/id_list/')
        self.assertEqual(respond.json(), {'friends_list': [4]})


@mock.patch('friends.constants.SERVER_HOST', "localhost:8081")
@mock.patch('users.constants.SERVER_HOST', "localhost:8081")
@mock.patch('authentication.constants.SERVER_HOST', "localhost:8081")
@mock.patch('notifications.constants.SERVER_HOST', "localhost:8081")
class TestUtils(LiveServerTestCase):
    port = 8081

    def setUp(self):
        pass

    def test_create_relation(self):
        invitation = Invitation.objects.create(**{
            'sender': 1,
            'receiver': 2
        })

        create_relation(invitation)
        relation = list(Relation.objects.all())[0]
        self.assertTrue(relation.user1 == 2 and relation.user2 == 1)

    def test_get_friends_ids(self):
        Relation.objects.create(**{'user1': 2, 'user2': 38})
        Relation.objects.create(**{'user1': 1, 'user2': 39})
        Relation.objects.create(**{'user1': 2, 'user2': 40})

        list = get_friends_id(2)
        self.assertEqual(list, [38, 40])

    def test_check_if_sent(self):
        res = check_if_sent(1, 2)
        self.assertFalse(res)
        Invitation.objects.create(**{'sender': 1, 'receiver': 2})
        res = check_if_sent(1, 2)
        self.assertTrue(res)

    def test_get_invitation_id(self):
        invitation = Invitation.objects.create(**{'sender': 1, 'receiver': 2})
        res1 = get_invitation_id(1, 2)
        res2 = get_invitation_id(2, 1)
        self.assertEqual(res1, invitation.id)
        self.assertEqual(res1, res2)

    def test_check_friendship(self):
        res = check_friendship(1, 2)
        self.assertFalse(res)
        Relation.objects.create(**{'user1': 1, 'user2': 2})

        res1 = check_friendship(1, 2)
        res2 = check_friendship(2, 1)
        self.assertTrue(res1)
        self.assertEqual(res1, res2)

    def test_check_invitations(self):
        res = check_invitations(1, 2)
        self.assertFalse(res)

        Invitation.objects.create(**{'sender': 1, 'receiver': 2})
        res1 = check_invitations(1, 2)
        res2 = check_invitations(2, 1)
        self.assertTrue(res1, 1)
        self.assertEqual(res1, res2)
