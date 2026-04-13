from django.db import models

class User(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField()
    password = models.CharField(max_length=100)

class Entry(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    type = models.CharField(max_length=50)   # water, food, sleep, etc.
    value = models.FloatField()              # amount (e.g., 2 glasses)
    extra = models.CharField(max_length=100, blank=True)  # optional (food name etc.)
    date = models.DateField()