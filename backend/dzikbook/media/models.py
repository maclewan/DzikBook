from django.db import models
from django.contrib.auth.models import User


# Create your models here
# TODO: to string
class Photo(models.Model):
    photo = models.ImageField(upload_to='photos')
    user = models.IntegerField(null=False, blank=False, default=-1)


class ProfilePhoto(models.Model):
    photo = models.ForeignKey(Photo, on_delete=models.CASCADE, related_name='profile_photo_original')
    downsized_photo = models.ForeignKey(Photo, on_delete=models.CASCADE, related_name='profile_photo_downsized')
    user = models.IntegerField(null=False, blank=False, default=-1, unique=False)
