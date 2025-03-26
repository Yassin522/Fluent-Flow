from django.urls import path
from .views import UserListCreate
from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static
from . import views

urlpatterns = [
    path('api/login', views.login),
    path('api/register', views.register),
    path('api/users/details/<int:id>', views.customer_details),
    path('api/users/details/password/<int:id>', views.customer_details),
    path('api/users/<int:id>/upload_photo', views.upload_photo),
    path('api/files/<int:user_id>/videos', views.get_user_videos),
    path('api/files/create', views.upload_file_and_create_metrics),
    path('api/files/evaluatetext', views.evaluate_text_only),
    path('api/files/get_history/<int:user_id>', views.get_history),
    path('api/files/<int:id>', views.file_details),
    path('api/files/video_score/<int:video_id>', views.file_score),
    path('api/test', views.test),
    path('dropbox-auth', views.dropbox_auth, name='dropbox_auth'),
    path('dropbox-auth-finish', views.dropbox_callback, name='dropbox-auth-finish')
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)