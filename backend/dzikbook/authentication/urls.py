from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
    TokenVerifyView,
)
from django.urls import path
from .views import (
    RegisterView,
    ResetPasswordView,
    DeleteAccountView
)

# TODO: /account zamiast /delete
urlpatterns = [

    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    #to delete later:
    path('api/token/verify/', TokenVerifyView.as_view(), name='token_verify'),
    path('register/', RegisterView.as_view(), name='register'),
    path('reset/', ResetPasswordView.as_view(), name='reset_password'),
    path('delete/', DeleteAccountView.as_view(), name='delete_account')


]