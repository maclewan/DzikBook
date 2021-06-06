from rest_framework import serializers
from .models import Photo, ProfilePhoto


class PhotoSerializer(serializers.ModelSerializer):
    id = serializers.SerializerMethodField('get_photo_id')
    def get_photo_id(self, obj):
        return obj.id


    class Meta:
        model = Photo
        fields = ['id', 'photo', 'user']

class ProfilePhotoSerializer(serializers.ModelSerializer):
    id = serializers.SerializerMethodField('get_profile_photo_id')
    photo = serializers.SerializerMethodField('get_photo')
    downsized_photo = serializers.SerializerMethodField('get_downsized_photo')

    def get_profile_photo_id(self, obj):
        return obj.id

    def get_photo(self, obj):
        return PhotoSerializer(Photo.objects.filter(id=obj.photo).first()).data

    def get_downsized_photo(self, obj):
        return PhotoSerializer(Photo.objects.filter(id=obj.downsized_photo).first()).data

    class Meta:
        model = ProfilePhoto
        fields = ['id', 'downsized_photo', 'photo', 'user']