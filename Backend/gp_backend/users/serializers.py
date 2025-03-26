from rest_framework import serializers
from django.contrib.auth.hashers import make_password
from .models import File, Customer, PerformanceMetrics
from django.contrib.auth.models import User

class FileSerializer(serializers.ModelSerializer):
    class Meta:
        model = File
        fields = ['id','video','user_id']
            


class PerformanceMetricsSerializer(serializers.ModelSerializer):
    # video = FileSerializer()
    class Meta:
        model = PerformanceMetrics
        fields = [
            'id',
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
            'user_id'
        ]


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User(
            email=validated_data['email'],
            username=validated_data['username']
        )
        user.set_password(validated_data['password'])
        user.save()
        return user

class CustomerSerializer(serializers.ModelSerializer):
    user = UserSerializer()

    class Meta:
        model = Customer
        fields = ['id', 'user', 'name', 'photo', 'role', 'created', 'updated']

    def create(self, validated_data):
        user_data = validated_data.pop('user')
        user = UserSerializer.create(UserSerializer(), validated_data=user_data)
        customer = Customer.objects.create(user=user, **validated_data)
        return customer
    
    def update(self, instance, validated_data):
        user_data = validated_data.pop('user', None)
        if user_data:
            user = instance.user
            if 'password' in user_data:
                user.set_password(user_data['password'])
            for attr, value in user_data.items():
                setattr(user, attr, value)
            user.save()

        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        return instance