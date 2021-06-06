from django.urls import path
from .views import (
    SigInUserPostsView,
    SigInUserPostsListView,
    PostsListView,
    MainWallListView,
)

urlpatterns = [
    path('post/<int:post_id>/', SigInUserPostsView.as_view(), name='sig_in_user_posts'),
    path('post/', SigInUserPostsView.as_view(), name='sig_in_user_add_post'),
    path('', SigInUserPostsListView.as_view(), name='sig_in_user_posts_list'),
    path('main/', MainWallListView.as_view(), name='main_wall'),
    path('<int:user_id>/', PostsListView.as_view(), name='posts_list')
]


