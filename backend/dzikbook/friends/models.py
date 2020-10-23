from django.db import models
from django.contrib.auth.models import User

# Create your models here.
# TODO: override to string
class Invitation(models.Model):

    sender = models.ForeignKey(User, on_delete=models.CASCADE)
    receiver = models.ForeignKey(User, on_delete=models.CASCADE)
    time_stamp = models.TimeField(auto_now=True)

class Relation(models.Model):

    user1 = models.ForeignKey(User, on_delete = models.CASCADE)
    user2 = models.ForeignKey(User, on_delete = models.CASCADE)