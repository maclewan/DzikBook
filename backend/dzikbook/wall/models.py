from django.db import models
from media.models import Photo


# Create your models here.
class Post(models.Model):
    description = models.TextField()
    visibility = models.BooleanField(default=True)
    image = models.ForeignKey(Photo, null=True, on_delete=models.SET_NULL)
    # TODO: wymyslec sensowny sposob na trzymanie roznych typow wpisow
    content = models.TextField(null=True)
