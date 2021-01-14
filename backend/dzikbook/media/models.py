from django.db import models
from django.contrib.auth.models import User


# Create your models here
# TODO: to string
class Photo(models.Model):
    photo = models.ImageField(upload_to='photos')
    user = models.IntegerField(null=False, blank=False, default=-1)


class ProfilePhoto(models.Model):
    photo = models.IntegerField(null=False, blank=False, default=-1)
    downsized_photo = models.IntegerField(null=False, blank=False, default=-1)
    user = models.IntegerField(null=False, blank=False, default=-1, unique=True)
