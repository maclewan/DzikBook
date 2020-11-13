from django.urls import path
from .views import (
    SigInUserNotificationsView
)

urlpatterns = [
    path('', SigInUserNotificationsView.as_view(), name='notifications_list'),
    path('<int:notification_id>/', SigInUserNotificationsView.as_view(), name='display_notification'),
    path('<int:user_id>/<str:not_type>/', SigInUserNotificationsView.as_view(), name='add_notification')
]


