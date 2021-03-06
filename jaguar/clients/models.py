from django.db import models

# Create your models here.
class Clients(models.Model):
    name = models.CharField(max_length=100, unique=True)
    createdAt = models.DateTimeField(auto_now_add=True)
    updatedAt = models.DateTimeField(null=True, blank=True)
    isDeleted = models.BooleanField(default=False)

    def __str__(self):
        return self.name