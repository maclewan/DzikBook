from django.contrib.auth.models import User
from rest_framework import serializers
from .models import Comment, Reaction
from wall.models import Post


class CommentSerializer(serializers.Serializer):
    comment_id = serializers.SerializerMethodField('get_comment_id')
    author = serializers.PrimaryKeyRelatedField(read_only=True)
    post = serializers.PrimaryKeyRelatedField(queryset=Post.objects.all())
    content = serializers.CharField(required=True, allow_blank=True)

    def get_comment_id(self, obj):
        return obj.id

    class Meta:
        model = Comment
        fields = ('comment_id', 'author', 'content', 'post')

    def create(self, validated_data):
        """
        Create and return a new `Comment` instance, given the validated data.
        """
        return Comment.objects.create(**validated_data)

    def update(self, instance, validated_data):
        """
        Update and return an existing `Comment` instance, given the validated data.
        """
        instance.content = validated_data.get('content', instance.content)
        instance.save()
        return instance
