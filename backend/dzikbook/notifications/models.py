from django.db import models


# TODO: ustawić żywotność
# TODO: zobaczyć jak z postami
class Notification(models.Model):
    notification_type = models.TextField()
    user = models.IntegerField(null=False, blank=False)
    sender = models.IntegerField(null=False, blank=False, default="1")
    post = models.UUIDField(null=True, blank=False)


class Device(models.Model):
    user = models.IntegerField(null=False, blank=False)
    token = models.TextField(null=True, blank=False)
