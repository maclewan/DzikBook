from django import forms 
from .models import Photo, ProfilePhoto

class PhotoForm(forms.ModelForm): 
  
    class Meta: 
        model = Photo 
        fields = ['photo', 'user']


class ProfilePhotoForm(forms.ModelForm): 
  
    class Meta: 
        model = ProfilePhoto
        fields = ['original_photo', 'profile_photo', 'user']