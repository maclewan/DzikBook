from django.urls import path
from .views import (
    PhotoManagementView,
    ProfilePhotoView,
    SigInUserProfilePhotoView
)

urlpatterns = [
    path('photo/', PhotoManagementView.as_view(), name='upload_photo'),
    path('photo/<int:photo_id>/', PhotoManagementView.as_view(), name='photo_management'),
    path('profile/', SigInUserProfilePhotoView.as_view(), name='sig_in_user_profile_photo'),
    path('profile/<int:profile_photo_id>/', SigInUserProfilePhotoView.as_view(), name='sig_in_user_profile_id'),
    path('profile/user/<int:user_id>/', ProfilePhotoView.as_view(), name='profile_photo')
]


