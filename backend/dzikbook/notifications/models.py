from django.db import models
from django.contrib.auth.models import User
from wall.models import Post


# TODO: ustawić żywotność
# TODO: zobaczyć jak z postami
class Notification(models.Model):
    notification_type = models.TextField()
    user = models.IntegerField(null=False, blank=False)
    post = models.IntegerField(null=True, blank=False)
