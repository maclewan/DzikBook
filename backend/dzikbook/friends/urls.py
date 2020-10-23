from django.urls import path
from .views import (
    SigInUserFriendsInvitationsView,
    SigInUserInvitationsSendView,
    InvitationsManagementView,
    SigInUserFriendsView,
    FriendsView,
    SigInUserAreYouFriendsView
)
# TODO: accept, request albo zmieniamy widok albo jeden url i oddzielnie post, get
urlpatterns = [
    path('request/<int:user_id>/', SigInUserFriendsInvitationsView.as_view(), name='manage_friend_invitations'),
    path('requests/', SigInUserFriendsInvitationsView.as_view(), name='sig_in_user_invitations_received'),
    path('requests/send/', SigInUserInvitationsSendView.as_view(), name='sig_in_user_invitations_send'),
    path('request/accept/<int:invitation_id>/', InvitationsManagementView.as_view(), name='accept_invitation'),
    path('request/reject/<int:invitation_id>/', InvitationsManagementView.as_view(), name='reject_invitation'),
    path('<int:user_id>/', SigInUserAreYouFriendsView.as_view(), name='are_you_friends'),
    path('list/', SigInUserFriendsView.as_view(), name='sig_in_user_friends'),
    path('list/<int:user_id>/', FriendsView.as_view(), name='friends')

]


