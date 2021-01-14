from django import forms
from .models import Photo, ProfilePhoto


class PhotoForm(forms.ModelForm):
    class Meta:
        model = Photo
        fields = ['photo']


class ProfilePhotoForm(forms.ModelForm):
    class Meta:
        model = ProfilePhoto
        fields = ['photo', 'downsized_photo']