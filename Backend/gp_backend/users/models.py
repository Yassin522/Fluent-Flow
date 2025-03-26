from django.db import models
from django.contrib.auth.models import User

#  ------------
# Create your models here.

class Customer(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, null=True)
    name = models.CharField(max_length=255)
    photo = models.FileField(upload_to='photos/', null=True, blank=True)
    role = models.CharField(max_length=255)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.user.email if self.user else self.name


class File(models.Model):
    video = models.FileField(upload_to='videos/', null=True, blank=True)
    user_id = models.ForeignKey(Customer, on_delete= models.CASCADE, null=True)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)
    

class PerformanceMetrics(models.Model):
    transcription = models.TextField(null=True)
    corrected_text = models.TextField(null=True)
    filler_score = models.FloatField(null=True)
    speed_score = models.FloatField(null=True)
    speed_variation_score = models.FloatField(null=True)
    pause_score = models.FloatField(null=True)
    sentence_length_score = models.FloatField(null=True)
    Total_Score = models.FloatField(null=True)
    Unique_Tokens_Count= models.FloatField(null=True)
    Tokens_Count= models.FloatField(null=True)
    Stopwords_Count= models.FloatField(null=True)
    Sentences_Count= models.FloatField(null=True)
    Number_of_grammatical_error= models.FloatField(null=True)
    pdq_score= models.FloatField(null=True)
    gesture_use_score= models.FloatField(null=True)
    gesture_place_score= models.FloatField(null=True)
    gesture_close_percentage= models.FloatField(null=True)
    good_poses_percentage= models.FloatField(null=True)
    bad_poses_percentage_hoh= models.FloatField(null=True)
    good_poses_percentage_hc= models.FloatField(null=True)
    gaze_ratio_percentage= models.FloatField(null=True)
    up_down_ratio_percentage= models.FloatField(null=True)
    eye_gaze_score= models.FloatField(null=True)
    head_gaze_score = models.FloatField(null=True)
    video = models.ForeignKey(File, on_delete=models.CASCADE, null=True, blank=True)
    user_id = models.ForeignKey(Customer, on_delete=models.CASCADE, null=True, blank=True)

    def __str__(self):
        if self.video:
            return f"Performance Metrics for Video ID: {self.video.id}"
        else:
            return "Performance Metrics (no video)"




