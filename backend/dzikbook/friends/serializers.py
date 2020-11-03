from rest_framework import serializers
from .models import Invitation, Relation
import datetime


class InvitationSerializer(serializers.Serializer):
    sender = serializers.PrimaryKeyRelatedField(read_only=True, required=True)
    receiver = serializers.PrimaryKeyRelatedField(read_only=True, required=True)
    time_stamp = serializers.DateTimeField(default=datetime.datetime.now)

    class Meta:
        model = Invitation
        fields = ('sender', 'receiver')

    def create(self, validated_data):
        """
        Create and return a new `Invitation` instance, given the validated data.
        """
        return Invitation.objects.create(**validated_data)

    def update(self, instance, validated_data):
        pass


class RelationSerializer(serializers.Serializer):
    user1 = serializers.PrimaryKeyRelatedField(read_only=True, required=True)
    user2 = serializers.PrimaryKeyRelatedField(read_only=True, required=True)

    class Meta:
        model = Relation
        fields = ('user1', 'user2')

    def create(self, validated_data):
        """
        Create and return a new `Relation` instance, given the validated data.
        """
        return Relation.objects.create(**validated_data)

    def update(self, instance, validated_data):
        pass
