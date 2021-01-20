from datetime import datetime
from django.contrib.auth.models import User
# from time_uuid import time_uuid
import uuid
from cassandra.cqlengine import columns
from django_cassandra_engine.models import DjangoCassandraModel


class Comment(DjangoCassandraModel):
    id = columns.UUID(primary_key=True, partition_key=True, default=uuid.uuid4)
    post = columns.UUID()
    author = columns.Integer()
    content = columns.Text()
    time = columns.DateTime(primary_key=True, clustering_order="ASC", default=datetime.now)


class Reaction(DjangoCassandraModel):
    id = columns.UUID(primary_key=True, partition_key=True, default=uuid.uuid4)
    post = columns.UUID()
    giver = columns.Integer()
