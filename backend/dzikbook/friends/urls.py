from django.urls import path
from .views import (
    SigInUserFriendsInvitationsView,
    SigInUserInvitationsSentView,
    InvitationsManagementView,
    SigInUserFriendsView,
    FriendsView,
    FriendsListView,
    SigInUserFriendInfo,
)

urlpatterns = [
    path('request/<int:user_id>/', SigInUserFriendsInvitationsView.as_view(), name='manage_friend_invitations'),
    path('request/', SigInUserFriendsInvitationsView.as_view(), name='sig_in_user_invitations_received'),
    path('requests/sent/', SigInUserInvitationsSentView.as_view(), name='sig_in_user_invitations_send'),
    path('request/manage/<int:invitation_id>/', InvitationsManagementView.as_view(), name='manage_invitation'),
    path('<int:user_id>/', SigInUserFriendInfo.as_view(), name='friendship_status'),
    path('list/', SigInUserFriendsView.as_view(), name='sig_in_user_friends'),
    path('list/<int:user_id>/', FriendsView.as_view(), name='friends'),
    path('id_list/', FriendsListView.as_view(), name='friends_id_list'),
]


