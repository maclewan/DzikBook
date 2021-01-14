from rest_framework import serializers
from .models import PostTypes, Post


class PostSerializer(serializers.Serializer):
    post_id = serializers.SerializerMethodField('get_post_id')
    author = serializers.PrimaryKeyRelatedField(read_only=True)
    description = serializers.CharField(required=True, allow_blank=True)
    additional_data = serializers.CharField(allow_blank=True, allow_null=True)
    visibility = serializers.BooleanField()
    photo = serializers.CharField(allow_blank=True)
    type = serializers.ChoiceField(choices=[(tag.name.lower(), tag.value) for tag in PostTypes])
    timestamp = serializers.DateTimeField(required=False)

    def get_post_id(self, obj):
        return obj.pk

    class Meta:
        model = Post
        fields = ('post_id', 'author', 'description', 'visibility', 'photo', 'type', 'timestamp', 'additional_data')

    def create(self, validated_data):
        """
        Create and return a new `Post` instance, given the validated data.
        """
        return Post.objects.create(**validated_data)

    def update(self, instance, validated_data):
        """
        Update and return an existing `Post` instance, given the validated data.
        """
        instance.description = validated_data.get('description', instance.description)
        instance.additional_data = validated_data.get('additional_data', instance.additional_data)
        instance.photo = validated_data.get('photo', instance.photo)
        instance.save()
        return instance
