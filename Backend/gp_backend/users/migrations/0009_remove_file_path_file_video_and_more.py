# Generated by Django 5.0 on 2024-07-06 09:51

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0008_alter_file_user_id'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='file',
            name='path',
        ),
        migrations.AddField(
            model_name='file',
            name='video',
            field=models.FileField(blank=True, null=True, upload_to='videos/'),
        ),
        migrations.AddField(
            model_name='performancemetrics',
            name='user_id',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to='users.customer'),
        ),
    ]
