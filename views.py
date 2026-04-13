from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import User, Entry

@api_view(['POST'])
def register(request):
    User.objects.create(**request.data)
    return Response({"message": "User created"})

@api_view(['POST'])
def add_entry(request):
    Entry.objects.create(**request.data)
    return Response({"message": "Entry added"})

@api_view(['GET'])
def get_entries(request):
    entries = Entry.objects.all().values()
    return Response(entries)