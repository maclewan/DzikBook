import datetime
import json
from copy import copy

import requests
from django.test import TestCase
from django.test.client import Client
from rest_framework.test import APIRequestFactory, RequestsClient, APIClient, APITestCase

from .constants import SERVER_HOST
from .decorators import hash_user
from .models import UserData, DetailsData
from django.contrib.auth.models import User
from .serializers import DetailsDataSerializer, UserDataSerializer
from .utils import convert_bdate


class UserDataTestCase(TestCase):

    def setUp(self):
        data = {
            'user': 1,
            'gym': "test_gym",
            'additional_data': "test_add_data",
            'first_name': 'test_name',
            'last_name': 'test_last_name',
            'sex': 'test_sex',
            'job': 'test_job',
            'birth_date': "1900-01-01"
        }

        UserData.objects.create(**data)

    def test_create_user_data(self):
        user_data = UserData.objects.get(pk=1)
        self.assertTrue(isinstance(user_data, UserData))
        self.assertTrue(
            user_data.user == 1 and user_data.gym == "test_gym" and user_data.birth_date == datetime.date(1900, 1, 1))

    def test_user_data_serializer(self):
        user_data = UserData.objects.get(pk=1)
        serializer = UserDataSerializer(user_data)
        self.assertEqual(
            serializer.data,
            {
                'user': 1,
                'gym': "test_gym",
                'additional_data': "test_add_data",
                'first_name': 'test_name',
                'last_name': 'test_last_name',
                'sex': 'test_sex',
                'job': 'test_job',
                'birth_date': "01/01/1900"
            }
        )

    def test_update_user_data(self):
        user_data = UserData.objects.get(pk=1)

        new_data = {
            'user': 1,
            'gym': "test_gym_updated",
            'additional_data': "test_add_data_updated",
            'first_name': 'test_name',
            'last_name': 'test_last_name',
            'sex': 'test_sex',
            'job': 'test_job',
            'birth_date': "1969-01-01"
        }
        serializer = UserDataSerializer(data=new_data)

        self.assertTrue(serializer.is_valid())

        serializer.update(instance=user_data, validated_data=new_data)

        updated_user_data = UserData.objects.get(pk=1)
        new_serializer = UserDataSerializer(updated_user_data)

        self.assertNotEqual(
            new_serializer.data,
            {
                'user': 1,
                'gym': "test_gym_updated",
                'additional_data': "test_add_data_updated",
                'first_name': 'test_name',
                'last_name': 'test_last_name',
                'sex': 'test_sex',
                'job': 'test_job',
                'birth_date': "01/01/1900"
            }
        )

        self.assertEqual(
            new_serializer.data,
            {
                'user': 1,
                'gym': "test_gym_updated",
                'additional_data': "test_add_data_updated",
                'first_name': 'test_name',
                'last_name': 'test_last_name',
                'sex': 'test_sex',
                'job': 'test_job',
                'birth_date': "01/01/1969"
            }
        )


class DetailsDataTestCase(TestCase):

    def setUp(self):
        data = {
            'user': 1,
            'workout_plans': "test_workouts",
            'diet_plans': "test_diet_plans",
        }

        DetailsData.objects.create(**data)

    def test_create_details_data(self):
        user_data = DetailsData.objects.get(pk=1)
        self.assertTrue(isinstance(user_data, DetailsData))
        self.assertTrue(
            user_data.user == 1 and user_data.workout_plans == "test_workouts" and user_data.diet_plans == "test_diet_plans")

    def test_details_data_serializer(self):
        user_data = DetailsData.objects.get(pk=1)
        serializer = DetailsDataSerializer(user_data)
        self.assertEqual(
            serializer.data,
            {
                'user': 1,
                'workout_plans': "test_workouts",
                'diet_plans': "test_diet_plans",
            }
        )

    def test_update_details_data(self):
        user_data = DetailsData.objects.get(pk=1)

        new_data = {
            'user': 1,
            'workout_plans': "test_workouts_updated",
            'diet_plans': "test_diet_plans_updated",
        }
        serializer = DetailsDataSerializer(data=new_data)

        self.assertTrue(serializer.is_valid())

        serializer.update(instance=user_data, validated_data=new_data)

        updated_user_data = DetailsData.objects.get(pk=1)
        new_serializer = DetailsDataSerializer(updated_user_data)

        self.assertNotEqual(
            new_serializer.data,
            {
                'user': 1,
                'workout_plans': "test_workouts",
                'diet_plans': "test_diet_plans",
            }
        )

        self.assertEqual(
            new_serializer.data,
            {
                'user': 1,
                'workout_plans': "test_workouts_updated",
                'diet_plans': "test_diet_plans_updated",
            }
        )


class UtilsTestCase(TestCase):

    def test_convert_bdate(self):
        date = '01/02/2021'
        self.assertEqual(convert_bdate(date), '2021-02-01')
        self.assertNotEqual(convert_bdate(date), date)
        self.assertEqual(convert_bdate('bad_date_format'), False)


class ViewsTestCase(APITestCase):

    def setUp(self):
        self.data = {
            'user': 1,
            'gym': "test_gym",
            'additional_data': "test_add_data",
            'first_name': 'test_name',
            'last_name': 'test_last_name',
            'sex': 'test_sex',
            'job': 'test_job',
            'birth_date': '01/01/1900'
        }

        self.client = RequestsClient()
        self.client.headers = {"Uid": str(1), "Flag": hash_user(1)}

    def test_signed_in_user_data(self):
        response = self.client.post('http://testserver/users/data/', self.data)
        self.assertEqual(response.json(), self.data)

        response = self.client.get('http://testserver/users/data/')
        self.assertEqual(response.json(), self.data)

        updated_data = copy(self.data)
        updated_data['birth_date'] = '01/01/1969'

        response = self.client.put('http://testserver/users/data/', updated_data)
        self.assertNotEqual(response.json()['user_data'], self.data)
        self.assertEqual(response.json()['user_data'], updated_data)

        self.client.delete('http://testserver/users/data/')
        response = self.client.get('http://testserver/users/data/')
        self.assertNotEqual(response.json(), updated_data)
        self.assertEqual(response.json(), "User data doesn't exist!")
