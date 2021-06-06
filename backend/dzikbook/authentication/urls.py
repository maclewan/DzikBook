from django.contrib.auth.views import PasswordResetView, PasswordChangeDoneView, PasswordResetConfirmView, \
    PasswordResetCompleteView
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
    TokenVerifyView,
)
from django.urls import path
from .views import (
    RegisterView,
    ValidateUserView,
    DeleteAccountView, LogoutPossibleTokenObtainPairView, ExistsUserView
)

# TODO: /account zamiast /delete
urlpatterns = [

    #done
    path('login/', LogoutPossibleTokenObtainPairView.as_view(), name='token_obtain_pair'),
    #done
    path('login/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    #done
    path('register/', RegisterView.as_view(), name='register'),
    #done
    #run: python3 -m smtpd -n -c DebuggingServer localhost:1025
    path('reset/', PasswordResetView.as_view(), name='reset_password'),
    path('reset/confirm/<uidb64>/<token>/', PasswordResetConfirmView.as_view(), name='password_reset_confirm'),
    path('reset/done/', PasswordChangeDoneView.as_view(), name='password_reset_done'),
    path('reset/complete/$', PasswordResetCompleteView.as_view(), name='password_reset_complete'),
    #done
    path('validate/', ValidateUserView.as_view(), name='validate_user'),
    #done
    path('user/<int:id>/', ExistsUserView.as_view(), name='check_if_user_exists'),

    #todo
    path('delete/', DeleteAccountView.as_view(), name='delete_account'),



]