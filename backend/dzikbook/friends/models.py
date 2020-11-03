from django.db import models
from django.contrib.auth.models import User


# Create your models here.
# TODO: override to string
class Invitation(models.Model):
    sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name="sender", default=-1)
    receiver = models.ForeignKey(User, on_delete=models.CASCADE, related_name="receiver", default=-1)
    time_stamp = models.DateTimeField(auto_now=True)


class Relation(models.Model):
    user1 = models.ForeignKey(User, on_delete=models.CASCADE, related_name='user1', default=-1)
    user2 = models.ForeignKey(User, on_delete=models.CASCADE, related_name='user2', default=-1)
