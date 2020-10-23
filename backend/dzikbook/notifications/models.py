from django.db import models
from django.contrib.auth.models import User

# Create your models here.
# TODO: ustawić żywotność
class Notification(models.Model):
    notification_type = models.TextField()
    user = models.ForeignKey(User, null=True, on_delete=models.CASCADE)
    # TODO: post
    #post = models.ForeignKey(Post, null=True, on_delete=models.CASCADE)