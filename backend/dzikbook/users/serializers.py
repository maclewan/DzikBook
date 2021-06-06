from rest_framework import serializers
from .models import UserData, DetailsData


class UserDataSerializer(serializers.Serializer):
    user = serializers.IntegerField(required=True, allow_null=False)
    first_name = serializers.CharField(required=True, allow_blank=True)
    last_name = serializers.CharField(required=True, allow_blank=True)
    gym = serializers.CharField(required=True, allow_blank=True)
    birth_date = serializers.DateField(required=True, format="%d/%m/%Y", allow_null=True)
    sex = serializers.CharField(required=True, allow_blank=True)
    job = serializers.CharField(required=True, allow_blank=True)
    additional_data = serializers.CharField(required=True, allow_blank=True)

    class Meta:
        model = UserData
        fields = ('user', 'first_name', 'last_name', 'gym', 'birth_date', 'sex', 'job', 'additional_data')

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
        instance.birth_date = validated_data.get('birth_date', instance.birth_date)
        instance.sex = validated_data.get('sex', instance.sex)
        instance.job = validated_data.get('job', instance.job)
        instance.additional_data = validated_data.get('additional_data', instance.additional_data)

        instance.save()
        return instance


class DetailsDataSerializer(serializers.Serializer):
    user = serializers.IntegerField(required=True, allow_null=False)
    workout_plans = serializers.CharField(required=True, allow_blank=True)
    diet_plans = serializers.CharField(required=True, allow_blank=True)

    class Meta:
        model = DetailsData
        fields = ('user', 'workout_plans', 'diet_plans')

    def create(self, validated_data):
        """
        Create and return a new `DetailsData` instance, given the validated data.
        """
        return DetailsData.objects.create(**validated_data)

    def update(self, instance, validated_data):
        """
        Update and return an existing `DetailsData` instance, given the validated data.
        """
        instance.workout_plans = validated_data.get('workout_plans', instance.workout_plans)
        instance.diet_plans = validated_data.get('diet_plans', instance.diet_plans)

        instance.save()
        return instance
