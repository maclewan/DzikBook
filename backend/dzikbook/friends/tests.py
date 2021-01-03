import datetime
import json
from copy import copy

from django.test import TestCase
from rest_framework.test import RequestsClient, APITestCase

from .decorators import hash_user
from .models import Invitation, Relation
from .serializers import InvitationSerializer, RelationSerializer


# Create your tests here.
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

#todo: views tests


