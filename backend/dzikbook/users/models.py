from django.db import models
from django.contrib.auth.models import User


# Create your models here.
# TODO: override to string
class UserData(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    gym = models.TextField(null=True)
    # TODO: zamieniamy na konkretne dane
    additional_data = models.TextField(null=True)
