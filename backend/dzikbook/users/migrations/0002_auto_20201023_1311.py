# Generated by Django 3.0.5 on 2020-10-23 11:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='userdata',
            name='home_gym',
        ),
        migrations.AddField(
            model_name='userdata',
            name='additional_data',
            field=models.TextField(null=True),
        ),
        migrations.AddField(
            model_name='userdata',
            name='gym',
            field=models.TextField(null=True),
        ),
    ]
