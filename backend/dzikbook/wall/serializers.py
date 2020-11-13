from rest_framework import serializers
from .models import Post


class PostSerializer(serializers.Serializer):
    post_id = serializers.SerializerMethodField('get_post_id')
    author = serializers.PrimaryKeyRelatedField(read_only=True)
    description = serializers.CharField(required=True, allow_blank=True)
    visibility = serializers.BooleanField()
    image = serializers.CharField()

    def get_post_id(self, obj):
        return obj.pk

    class Meta:
        model = Post
        fields = ('post_id', 'author', 'description', 'visibility', 'image')

    def create(self, validated_data):
        """
        Create and return a new `Comment` instance, given the validated data.
        """
        return Post.objects.create(**validated_data)

    def update(self, instance, validated_data):
        """
        Update and return an existing `Comment` instance, given the validated data.
        """
        instance.description = validated_data.get('description', instance.description)
        instance.image = validated_data.get('image', instance.image)
        instance.save()
        return instance
