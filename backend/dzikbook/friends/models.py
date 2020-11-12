from django.db import models


# Create your models here.
class Invitation(models.Model):
    sender = models.IntegerField(null=False, blank=False)
    receiver = models.IntegerField(null=False, blank=False)
    time_stamp = models.DateTimeField(auto_now=True)


class Relation(models.Model):
    user1 = models.IntegerField(null=False, blank=False)
    user2 = models.IntegerField(null=False, blank=False)
    time_stamp = models.DateTimeField(auto_now=True)
