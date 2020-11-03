from django.db import models
from wall.models import Post
from django.contrib.auth.models import User


class Comment(models.Model):
    #post = models.ForeignKey(Post, on_delete=models.CASCADE)
    post = models.IntegerField()
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    content = models.TextField()


class Reaction(models.Model):
    # post = models.ForeignKey(Post, on_delete=models.CASCADE)
    post = models.IntegerField()
    giver = models.ForeignKey(User, on_delete=models.CASCADE)
