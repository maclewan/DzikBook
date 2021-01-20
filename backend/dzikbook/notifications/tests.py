from unittest import mock

import requests
from django.contrib.auth.models import User
from django.test import TestCase, LiveServerTestCase
from django.urls import reverse
from rest_framework.test import RequestsClient, APITestCase
from rest_framework.test import APIClient

from .decorators import hash_user
from .models import Notification
from .serializers import NotificationSerializer

from collections import OrderedDict
import json

# Create your tests here.

##################
## models tests ##
##################

class NotificationTestCase(TestCase):

    def setUp(self):
        data = {
            "post": 5,
            "user": 2,
            "notification_type": "test_type"
        }
        self.notification = Notification.objects.create(**data)

    def tearDown(self):
        Notification.objects.all().delete()

    def test_create_notification(self):
        self.assertTrue(isinstance(self.notification, Notification))
        self.assertEqual(self.notification.post, 5)
        self.assertEqual(self.notification.user, 2)
        self.assertEqual(self.notification.notification_type, "test_type")


#######################
## serializers tests ##
#######################


class NotificationSerializerTestCase(TestCase):

    def setUp(self):
        data = {
            "post":5,
            "user":2,
            "notification_type":"test_type"
        }
        self.notification = Notification.objects.create(**data)
    
    def tearDown(self):
        Notification.objects.all().delete()

    def test_translation(self):
        serializer = NotificationSerializer(self.notification)
        self.assertEqual(serializer.data, {'id': self.notification.id, 'notification_type': self.notification.notification_type, 'user': self.notification.user, 'post': self.notification.post})
        
    def test_update(self):
        # Only type should change
        new_data = {
            "post":0,
            "user":0,
            "notification_type":"test_update_type"
        }

        serializer = NotificationSerializer(data=new_data)
        self.assertTrue(serializer.is_valid(raise_exception=True))

        serializer.update(instance=self.notification, validated_data=new_data)
        updated_serializer = NotificationSerializer(self.notification)
        self.assertEqual(updated_serializer.data,
        {
            'id': self.notification.id,
            'notification_type': 'test_update_type',
            'user': 2,
            'post': 5
        })


#################
## views tests ##
#################

class SigInUserNotificationsViewTestCase(LiveServerTestCase):
    port = 8081
    server_host = "localhost:" + str(port)

    def setUp(self):
        self.server_host = SigInUserNotificationsViewTestCase.server_host
        self.client = APIClient()
        self.user1 = User.objects.create(username='user1', password='user1')
        self.user2 = User.objects.create(username='user2', password='user2')
        self.client.credentials(HTTP_Uid=str(self.user1.id), HTTP_Flag=hash_user(self.user1.id))

        self.notification1 = Notification.objects.create(**{'post': 1, 'user': self.user1.id, 'notification_type': 'type1'})
        self.notification2 = Notification.objects.create(**{'post': 1, 'user': self.user2.id, 'notification_type': 'type1'})
        self.notification3 = Notification.objects.create(**{'post': 2, 'user': self.user1.id, 'notification_type': 'type2'})

    def tearDown(self):
        Notification.objects.all().delete()
        User.objects.all().delete()
    
    def test_notifications_list_get(self):
        url = reverse('notifications_list')
        response = self.client.get(url)
        # Convert ordered dict to dict
        self.assertEqual(json.loads(json.dumps(response.data)),{
            'notifications_list':[
                {'id': self.notification1.id, 'notification_type': self.notification1.notification_type, 'user': self.notification1.user, 'post': self.notification1.post},
                {'id': self.notification3.id, 'notification_type': self.notification3.notification_type, 'user': self.notification3.user, 'post': self.notification3.post},
            ]
        })
    
    def test_display_notification_put(self):
        # Positive case
        url = reverse('display_notification', args=[self.notification1.id])
        response = self.client.put(url)
        self.assertEqual(response.data, {
            'message': 'Notification displayed.',
            'notification': {
                'id': self.notification1.id,
                'notification_type': 'displayed',
                'user': self.notification1.user,
                'post': self.notification1.post
                }
            })
        # Negative case
        url = reverse('display_notification', args=[0])
        response = self.client.put(url)
        self.assertEqual(response.data, "Notification doesn't exist!")
        self.assertEqual(response.status_code, 404)

    @mock.patch('notifications.constants.SERVER_HOST', server_host)
    def test_add_notification_post(self):
        test_type = "test_add_notification_type"
        # Positive case
        url = reverse('add_notification', args=[self.user1.id, test_type])
        response = self.client.post(url)
        self.assertEqual(response.data, {
            'notification': {
                'id': mock.ANY,
                'notification_type': 'test_add_notification_type',
                'user': self.user1.id,
                'post': None
                },
            'message': 'Notification successfully created.'
            })
        # Negative case, user doesn't exist 
        url = reverse('add_notification', args=[0, test_type])
        response = self.client.post(url)
        self.assertEqual(response.data, "User with id: 0 doesn't exist!")
        self.assertEqual(response.status_code, 404)
    """
    @mock.patch('notifications.constants.SERVER_HOST', server_host)
    @mock.patch('.serializers.NotificationSerializer', None)
    def test_add_notification_post_exception(self):
        # Negative case two error rise
        url = reverse('add_notification', args=[self.user1.id, None])
        response = self.client.post(url)
        self.assertEqual(response.data, "User with id: 0 doesn't exist!")
    """