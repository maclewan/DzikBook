from django.urls import path
from .views import (
    CommentsView,
    ReactionsView
)

urlpatterns = [
    path('comments/post/<int:post_id>/', CommentsView.as_view(), name='post_comments'),
    path('comments/<int:comment_id>/', CommentsView.as_view(), name='comments_management'),
    path('reactions/<int:post_id>/', ReactionsView.as_view(), name='reactions'),
]


