from rest_framework import serializers
from .models import Invitation, Relation
import datetime


class InvitationSerializer(serializers.Serializer):
    id = serializers.IntegerField(required=False)
    sender = serializers.IntegerField(required=True)
    receiver = serializers.IntegerField(required=True)
    time_stamp = serializers.DateTimeField(default=datetime.datetime.now)

    class Meta:
        model = Invitation
        fields = ('id', 'sender', 'receiver')

    def create(self, validated_data):
        """
        Create and return a new `Invitation` instance, given the validated data.
        """
        return Invitation.objects.create(**validated_data)

    def update(self, instance, validated_data):
        pass


class RelationSerializer(serializers.Serializer):
    id = serializers.IntegerField(required=False)
    user1 = serializers.IntegerField(required=True)
    user2 = serializers.IntegerField(required=True)

    class Meta:
        model = Relation
        fields = ('id', 'user1', 'user2')

    def create(self, validated_data):
        """
        Create and return a new `Relation` instance, given the validated data.
        """
        return Relation.objects.create(**validated_data)

