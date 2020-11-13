from django.db import models
from django.contrib.auth.models import User


# Create your models here
# TODO: to string
class Photo(models.Model):
    photo = models.ImageField(upload_to='photos')
    user = models.IntegerField(null=False, blank=False)


class ProfilePhoto(models.Model):
    original_photo = models.OneToOneField(Photo, on_delete=models.CASCADE)
    profile_photo = models.ImageField(upload_to='profile_photos')
