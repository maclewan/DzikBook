from django.urls import path
from .views import (
    SignedInUserDataView,
    UserDataView,
    SearchView, MultipleUsersDataView, CreateNewUserView, BasicUserDataView
)

urlpatterns = [
    path('data/', SignedInUserDataView.as_view(), name='sig_in_user_data'),
    path('data/<int:id>/', UserDataView.as_view(), name='user_data'),
    path('basic/<int:id>/', BasicUserDataView.as_view(), name='basic_user_data'),
    path('search/', SearchView.as_view(), name='search'),
    #Internal
    path('multi/', MultipleUsersDataView.as_view(), name='multiple_user_data'),
    path('data/new/', CreateNewUserView.as_view(), name='new_user_data')
]


