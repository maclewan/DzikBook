from django.db import models
from django.contrib.auth.models import User
from enum import Enum


class PostTypes(Enum):
    MEDIA = 'media'
    TRAINING = 'training'
    DIET = 'diet'
    TEXT = 'text'


# Create your models here.
class Post(models.Model):
    author = models.ForeignKey(User, on_delete=models.CASCADE, null=True)
    description = models.TextField()
    visibility = models.BooleanField(default=True)
    timestamp = models.DateTimeField(auto_now_add=True, null=True)

    type = models.CharField(max_length=10, choices=[(tag, tag.value) for tag in PostTypes])
    photo = models.CharField(max_length=200, null=True, blank=True)
    additional_data = models.TextField(null=True)
