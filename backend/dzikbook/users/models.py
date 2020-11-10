from django.db import models
from django.contrib.auth.models import User


# Create your models here.
class UserData(models.Model):
    user = models.IntegerField(unique=True, null=False, blank=False)
    first_name = models.CharField(null=True, blank=False, max_length=40)
    last_name = models.CharField(null=True, blank=False, max_length=40)
    gym = models.TextField(null=True, blank=False)
    additional_data = models.TextField(null=True, blank=False)
