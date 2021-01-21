from datetime import datetime
# from time_uuid import time_uuid
import uuid
from cassandra.cqlengine import columns
from django_cassandra_engine.models import DjangoCassandraModel


class Comment(DjangoCassandraModel):
    class Meta:
        get_pk_field = 'id'
    post = columns.UUID(primary_key=True, partition_key=True)
    time = columns.DateTime(primary_key=True, clustering_order="ASC", default=datetime.now)
    id = columns.UUID(primary_key=True, default=uuid.uuid4)
    author = columns.Integer()
    content = columns.Text()


class Reaction(DjangoCassandraModel):
    class Meta:
        get_pk_field = 'id'
    post = columns.UUID(primary_key=True, partition_key=True)
    id = columns.UUID(primary_key=True, default=uuid.uuid4)
    giver = columns.Integer()
