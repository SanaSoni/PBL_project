from django.urls import path
from .views import register, add_entry

urlpatterns = [
    path('register/', register),
    path('add-entry/', add_entry),
]

path('get-entries/', get_entries),