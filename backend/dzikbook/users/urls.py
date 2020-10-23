from django.urls import path
from .views import (
    SignedInUserDataView,
    UserDataView,
    SearchByNameView,
    SearchByGymView
)

urlpatterns = [

    path('data/', SignedInUserDataView.as_view(), name='sig_in_user_data'),
    path('data/<int:id>/', UserDataView.as_view(), name='user_data'),
    path('search/name/<str:user_name>/', SearchByNameView.as_view(), name='search_by_name'),
    path('search/gym/<str:gym>/', SearchByGymView.as_view(), name='search_by_gym')

]


