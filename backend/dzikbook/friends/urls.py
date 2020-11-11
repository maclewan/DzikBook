from django.urls import path
from .views import (
    SigInUserFriendsInvitationsView,
    SigInUserInvitationsSendView,
    InvitationsManagementView,
    SigInUserFriendsView,
    FriendsView,
    SigInUserFriendInfo
)

urlpatterns = [
    path('request/<int:user_id>/', SigInUserFriendsInvitationsView.as_view(), name='manage_friend_invitations'),
    path('requests/', SigInUserFriendsInvitationsView.as_view(), name='sig_in_user_invitations_received'),
    path('requests/send/', SigInUserInvitationsSendView.as_view(), name='sig_in_user_invitations_send'),
    path('request/manage/<int:invitation_id>/', InvitationsManagementView.as_view(), name='manage_invitation'),
    path('<int:user_id>/', SigInUserFriendInfo.as_view(), name='friendship_status'),
    path('list/', SigInUserFriendsView.as_view(), name='sig_in_user_friends'),
    path('list/<int:user_id>/', FriendsView.as_view(), name='friends')
]


