from django.contrib import admin
from .models import File, Customer, PerformanceMetrics
# Register your models here.

# admin.site.register(File)
# admin.site.register(Customer)
# admin.site.register(PerformanceMetrics)

@admin.register(Customer)
class CustomerAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'role', 'photo', 'created', 'updated')
    search_fields = ('name', 'role')

@admin.register(File)
class FileAdmin(admin.ModelAdmin):
    list_display = ('id','video','user_id', 'created', 'updated')

@admin.register(PerformanceMetrics)
class PerformanceMetricsAdmin(admin.ModelAdmin):
    list_display = ('id',
            'transcription',
            'corrected_text',
            'filler_score',
            'speed_score',
            'speed_variation_score',
            'pause_score',
            'sentence_length_score',
            'Total_Score',
            'Unique_Tokens_Count',
            'Tokens_Count',
            'Stopwords_Count',
            'Sentences_Count',
            'Number_of_grammatical_error',
            'pdq_score',
            'gesture_use_score',
            'gesture_place_score',
            'gesture_close_percentage',
            'good_poses_percentage',
            'bad_poses_percentage_hoh',
            'good_poses_percentage_hc',
            'gaze_ratio_percentage',
            'up_down_ratio_percentage',
            'eye_gaze_score',
            'head_gaze_score',
            'video',
            'user_id')
    # list_display = ('id', 'speed_pace', 'voice_variation', 'pausing', 'filler_words', 'grammar', 'language_variation', 'script', 'eye_contact_head_gaze','gesture_use', 'video', 'user_id')