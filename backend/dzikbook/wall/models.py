from django.db import models
from django.contrib.auth.models import User


# Create your models here.
class Post(models.Model):
    author = models.ForeignKey(User, on_delete=models.CASCADE, null=True)
    description = models.TextField()
    visibility = models.BooleanField(default=True)

    #image = models.ForeignKey(Photo, blank=True, null=True, on_delete=models.SET_NULL)
    image = models.CharField(max_length=200, null=True, blank=True)
    # TODO: wymyslec sensowny sposob na trzymanie roznych typow wpisow
    content = models.TextField(null=True)
