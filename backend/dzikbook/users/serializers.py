from rest_framework import serializers
from .models import UserData


class UserDataSerializer(serializers.Serializer):
    first_name = serializers.CharField(required=True, allow_blank=True)
    last_name = serializers.CharField(required=True, allow_blank=True)
    user = serializers.IntegerField(required=True, allow_null=False)
    gym = serializers.CharField(required=True, allow_blank=True)
    # TODO: ewentualnie zmieniamy na konkretne
    additional_data = serializers.CharField(required=True, allow_blank=False)

    class Meta:
        model = UserData
        fields = ('user', 'first_name', 'last_name', 'gym', 'additional_data',)

    def create(self, validated_data):
        """
        Create and return a new `UserData` instance, given the validated data.
        """
        return UserData.objects.create(**validated_data)

    def update(self, instance, validated_data):
        """
        Update and return an existing `UserData` instance, given the validated data.
        """
        instance.first_name = validated_data.get('first_name', instance.first_name)
        instance.last_name = validated_data.get('last_name', instance.last_name)
        instance.gym = validated_data.get('gym', instance.gym)
        instance.additional_data = validated_data.get('additional_data', instance.additional_data)
        instance.save()
        return instance
