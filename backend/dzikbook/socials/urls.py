from django.urls import path
from .views import (
    CommentsView,
    ReactionsView
)

urlpatterns = [
    path('comments/post/<uuid:post_id>/', CommentsView.as_view(), name='post_comments'),
    path('comments/<uuid:comment_id>/', CommentsView.as_view(), name='comments_management'),
    path('reactions/<uuid:post_id>/', ReactionsView.as_view(), name='reactions'),
]


