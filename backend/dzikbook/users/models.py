from django.db import models


# Create your models here.
class UserData(models.Model):
    user = models.IntegerField(unique=True, null=False, blank=False)
    first_name = models.CharField(null=True, blank=False, max_length=40)
    last_name = models.CharField(null=True, blank=False, max_length=40)
    gym = models.TextField(null=True, blank=False)
    birth_date = models.DateField(null=True, blank=False)
    sex = models.CharField(null=True, blank=False, max_length=25)
    job = models.CharField(null=True, blank=False, max_length=40)
    additional_data = models.TextField(null=True, blank=False)
