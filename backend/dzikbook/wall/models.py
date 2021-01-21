from django.db import models
from datetime import datetime
from enum import Enum
import uuid
from cassandra.cqlengine import columns
from django_cassandra_engine.models import DjangoCassandraModel


class PostTypes(Enum):
    MEDIA = 'media'
    TRAINING = 'training'
    DIET = 'diet'
    TEXT = 'text'


# Create your models here.
class Post(DjangoCassandraModel):
    class Meta:
        get_pk_field = 'id'

    author = columns.Integer(primary_key=True, partition_key=True)
    time = columns.DateTime(primary_key=True, clustering_order="DESC", default=datetime.now)
    id = columns.UUID(primary_key=True, default=uuid.uuid4)
    description = columns.Text()
    visibility = columns.Boolean(default=True)
    type = columns.Ascii()
    photo = columns.Text()
    additional_data = columns.Text()

# class Post(models.Model):
#     author = models.ForeignKey(User, on_delete=models.CASCADE, null=True)
#     description = models.TextField()
#     visibility = models.BooleanField(default=True)
#     timestamp = models.DateTimeField(auto_now_add=True, null=True)
#
#     type = models.CharField(max_length=10, choices=[(tag.name.lower(), tag.value) for tag in PostTypes])
#     photo = models.CharField(max_length=200, null=True, blank=True)
#     additional_data = models.TextField(null=True)
