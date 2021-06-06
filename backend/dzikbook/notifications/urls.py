from django.urls import path
from .views import (
    SigInUserNotificationsView, RegisterDeviceView
)

urlpatterns = [
    path('', SigInUserNotificationsView.as_view(), name='notifications_list'),
    path('<int:notification_id>/', SigInUserNotificationsView.as_view(), name='display_notification'),
    path('', SigInUserNotificationsView.as_view(), name='add_notification'),
    path('register_device/', RegisterDeviceView.as_view(), name='register_device')
]


