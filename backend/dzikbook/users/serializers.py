from rest_framework import serializers
from .models import UserData


class UserDataSerializer(serializers.Serializer):
    user = serializers.PrimaryKeyRelatedField(read_only=True)
    gym = serializers.CharField(required=True, allow_blank=True)
    # TODO: ewentualnie zmieniamy na konkretne
    additional_data = serializers.JSONField(required=True, allow_blank=False)

    class Meta:
        model = UserData
        fields = ('user', 'gym', 'additional_data')

    def create(self, validated_data):
        """
        Create and return a new `UserData` instance, given the validated data.
        """
        return UserData.objects.create(**validated_data)

    def update(self, instance, validated_data):
        """
        Update and return an existing `UserData` instance, given the validated data.
        """
        instance.gym = validated_data.get('gym', instance.content)
        instance.additional_data = validated_data.get('additional_data', instance.content)
        instance.save()
        return instance
