from django.shortcuts import render
from rest_framework import generics
from .models import User
from .models import File, Customer, PerformanceMetrics
from django.contrib.auth.models import User
from .serializers import FileSerializer, UserSerializer, CustomerSerializer, PerformanceMetricsSerializer
from rest_framework.decorators import api_view,  authentication_classes, permission_classes, parser_classes
from rest_framework.authtoken.models import Token
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.response import Response
from rest_framework import status
from rest_framework.authentication import SessionAuthentication, TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404
from .Utils.ParallelProcessing import get_results, get_and_process_only_text
import time
from django.conf import settings
from django.shortcuts import redirect
import os
import requests
from django.http import JsonResponse
# Create your views here.
class UserListCreate(generics.ListCreateAPIView):
    print("I AM HERE")
    queryset = User.objects.all()
    serializer_class = UserSerializer

# USERS
@api_view(['POST'])
def login(request):
    print(request.data)
    user = get_object_or_404(User, email=request.data['email'])
    if not user.check_password(request.data['password']):
        return Response({"error" : "wrong password"}, status=status.HTTP_404_NOT_FOUND)

    token, created = Token.objects.get_or_create(user=user)
    customer = get_object_or_404(Customer, user=user)
    customer_serializer = CustomerSerializer(instance=customer)

    return Response({"customer": customer_serializer.data, "token": token.key}, status=status.HTTP_200_OK)

@api_view(['POST'])
def register(request):
    print(request.data)
    serializer = CustomerSerializer(data= request.data)
    if serializer.is_valid():
        customer = serializer.save()
        user = customer.user
        token = Token.objects.create(user=user)
        return Response({"user": serializer.data,"token": token.key}, status=status.HTTP_201_CREATED)
    print(serializer.errors)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_history(request, user_id):
    # Ensure the user exists
    user = get_object_or_404(Customer, pk=user_id)
    
    # Retrieve all performance metrics associated with the user
    performance_metrics = PerformanceMetrics.objects.filter(user_id=user)
    performance_metrics_data = PerformanceMetricsSerializer(performance_metrics, many=True).data

    # Manually add video details for each performance metrics record
    for metric in performance_metrics_data:
        video_id = metric['video']
        video = get_object_or_404(File, pk=video_id)
        video_data = FileSerializer(video).data
        metric['video'] = video_data

    return Response(performance_metrics_data, status=status.HTTP_200_OK)

@api_view(['GET', 'DELETE', 'PUT'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def customer_details(request, id):
    customer = get_object_or_404(Customer, pk=id)
    
    if request.method == 'GET':
        serializer = CustomerSerializer(customer)
        return Response(serializer.data)
    
    elif request.method == 'PUT':
        data = request.data.copy()
        
        # Check if only password is being updated
        if 'password' in data:
            user = customer.user
            user.set_password(data['password'])
            user.save()
            return Response({"message": "Password updated successfully"}, status=status.HTTP_200_OK)
        
        serializer = CustomerSerializer(customer, data=data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        customer.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

@api_view(['POST'])
@parser_classes([MultiPartParser, FormParser])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def upload_photo(request, id):
    customer = get_object_or_404(Customer, pk=id)
    
    if 'photo' not in request.FILES:
        return Response({"error": "No photo provided"}, status=status.HTTP_400_BAD_REQUEST)
    
    customer.photo = request.FILES['photo']
    customer.save()
    
    serializer = CustomerSerializer(customer)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
@parser_classes([MultiPartParser, FormParser])
def upload_file_and_create_metrics(request):
    # Extract user_id from request data
    user_id = request.data.get('user_id')
    
    if not user_id:
        return Response({"error": "user_id is required"}, status=status.HTTP_400_BAD_REQUEST)
    
    # Ensure user exists
    user = get_object_or_404(Customer, pk=user_id)

    # Handle file upload
    print(request.data)
    if 'video' not in request.FILES:
        return Response({"error": "No video provided"}, status=status.HTTP_400_BAD_REQUEST)
    
    file_data = {
        'video': request.FILES['video'],
        'user_id': user_id
    }

    file_serializer = FileSerializer(data=file_data)
    if file_serializer.is_valid():
        file = file_serializer.save()
        video_path = file.video.path
        print('vid path', video_path)
        file_name = f'{user_id}_{int(time.time())}'
        response = get_results(video_path, file_name)
        if not response['status_ok']:
            return JsonResponse({"error": response['error']}, status=status.HTTP_400_BAD_REQUEST)
        results = response['data']
        # Create PerformanceMetrics with constant values
        additional_data = {
            'video' : file.id, 
            'user_id': user_id
        }
        print(additional_data)
        result = results
        result = {**result, **additional_data}
        performance_metrics_serializer = PerformanceMetricsSerializer(data=result)
        if performance_metrics_serializer.is_valid():
            performance_metrics_serializer.save()
            file= get_object_or_404(File, pk=file.id)
            file_serializer = FileSerializer(file)
            # Custom response formatting
            custom_response = {
                'video_id': file.id,
                "video": file_serializer.data,
                'user_id': user_id,
                'transcription': result.get('transcription', ''),
                'script_scores': {
                    'Total Score': result.get('Total_Score'),
                    'Unique Tokens Count': result.get('Unique_Tokens_Count'),
                    'Tokens Count': result.get('Tokens_Count'),
                    'Stopwords Count': result.get('Stopwords_Count'),
                    'Sentences Count': result.get('Sentences_Count'),
                    'Number of grammatical error': result.get('Number_of_grammatical_error'),
                    'corrected text': result.get('corrected_text'),
                },
                'voice_scores': {
                    'filler_score': result.get('filler_score'),
                    'speed_score': result.get('speed_score'),
                    'speed_variation_score': result.get('speed_variation_score'),
                    'pause_score': result.get('pause_score'),
                    'sentence_length_score': result.get('sentence_length_score'),
                    'pdq_score': result.get('pdq_score'),
                },
                'movement_scores': {
                    'gesture_use_score': result.get('gesture_use_score'),
                    'gesture_place_score': result.get('gesture_place_score'),
                    'gesture_close_percentage': result.get('gesture_close_percentage'),
                    'good_poses_percentage': result.get('good_poses_percentage'),
                    'bad_poses_percentage_hoh': result.get('bad_poses_percentage_hoh'),
                    'good_poses_percentage_hc': result.get('good_poses_percentage_hc'),
                    'gaze_ratio_percentage': result.get('gaze_ratio_percentage'),
                    'up_down_ratio_percentage': result.get('up_down_ratio_percentage'),
                    'eye_gaze_score': result.get('eye_gaze_score'),
                    'head_gaze_score': result.get('head_gaze_score'),
                }
            }

            return Response(custom_response, status=status.HTTP_201_CREATED)
        else:
            file.delete()  # Clean up the uploaded file if metrics creation fails
            return Response(performance_metrics_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    return Response(file_serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# def upload_file_and_create_metrics(request):
#     # Extract user_id from request data
#     user_id = request.data.get('user_id')
    
#     if not user_id:
#         return Response({"error": "user_id is required"}, status=status.HTTP_400_BAD_REQUEST)
    
#     # Ensure user exists
#     user = get_object_or_404(Customer, pk=user_id)

#     # Handle file upload
#     print(request.data)
#     if 'video' not in request.FILES:
#         return Response({"error": "No video provided"}, status=status.HTTP_400_BAD_REQUEST)
    
#     file_data = {
#         'video': request.FILES['video'],
#         'user_id': user_id
#     }

#     file_serializer = FileSerializer(data=file_data)
#     if file_serializer.is_valid():
#         file = file_serializer.save()
#         video_path = file.video.path
#         print('vid path', video_path)
#         file_name = f'{user_id}_{int(time.time())}'
#         response = get_results(video_path, file_name)
#         if not response['status_ok']:
#             return Response({"error": response['error']}, status=status.HTTP_400_BAD_REQUEST)
#         results = response['data']
#         # Create PerformanceMetrics with constant values
#         additional_data = {
#             'video' : file.id, 
#             'user_id': user_id
#         }
#         print(additional_data)
#         result = results
#         result = {**result, **additional_data}
#         performance_metrics_serializer = PerformanceMetricsSerializer(data=result)
#         if performance_metrics_serializer.is_valid():
#             performance_metrics_serializer.save()
#             return Response({
#                 'file': file_serializer.data,
#                 # 'performance_metrics': result
#                 'performance_metrics': performance_metrics_serializer.data
#             }, status=status.HTTP_201_CREATED)
#         else:
#             file.delete()  # Clean up the uploaded file if metrics creation fails
#             return Response(performance_metrics_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#     return Response(file_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def evaluate_text_only(request):
    # Extract user_id from request data
    user_id = request.data.get('user_id')
    
    if not user_id:
        return Response({"error": "user_id is required"}, status=status.HTTP_400_BAD_REQUEST)
    
    # Ensure user exists
    user = get_object_or_404(Customer, pk=user_id)
    
    file_data = {
        'video': None,
        'user_id': user_id
    }

    file_serializer = FileSerializer(data=file_data)
    if file_serializer.is_valid():
        file = file_serializer.save()
        # video_path = file.video.path
        # print('vid path', video_path)
        file_name = f'{user_id}_{int(time.time())}'
        response = get_and_process_only_text(request.data["Text"])
        if not response['status_ok']:
            return Response({"error": response['error']}, status=status.HTTP_400_BAD_REQUEST)
        results = response['data']
        # Create PerformanceMetrics with constant values
        additional_data = {
            'video' : file.id, 
            'user_id': user_id
        }
        print(additional_data)
        result = results
        result = {**result, **additional_data}
        performance_metrics_serializer = PerformanceMetricsSerializer(data=result)
        if performance_metrics_serializer.is_valid():
            performance_metrics_serializer.save()
            return Response({
                'file': file_serializer.data,
                # 'performance_metrics': result
                'performance_metrics': performance_metrics_serializer.data
            }, status=status.HTTP_201_CREATED)
        else:
            file.delete()  # Clean up the uploaded file if metrics creation fails
            return Response(performance_metrics_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    return Response(file_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_user_videos(request, user_id):
    # Ensure the user exists
    user = get_object_or_404(Customer, pk=user_id)
    
    # Retrieve all files associated with the user
    files = File.objects.filter(user_id=user)
    serializer = FileSerializer(files, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['GET'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def file_score(request, video_id):
    # Ensure the user exists
    metrics = get_object_or_404(PerformanceMetrics, video=video_id)
    file= get_object_or_404(File, pk=video_id)
    
    # Retrieve all files associated with the user
    metrics_serializer = PerformanceMetricsSerializer(metrics)
    file_serializer = FileSerializer(file)
    response_data = {
            **metrics_serializer.data,
            **file_serializer.data,
        }
    return Response(response_data)

@api_view(['GET'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_history(request, user_id):
    # Ensure the user exists
    user = get_object_or_404(Customer, pk=user_id)
    
    # Retrieve all performance metrics associated with the user
    performance_metrics = PerformanceMetrics.objects.filter(user_id=user)
    performance_metrics_data = PerformanceMetricsSerializer(performance_metrics, many=True).data

    # Manually add video details for each performance metrics record
    for metric in performance_metrics_data:
        video_id = metric['video']
        video = get_object_or_404(File, pk=video_id)
        video_data = FileSerializer(video).data
        metric['video'] = video_data

    return Response(performance_metrics_data, status=status.HTTP_200_OK)

# @api_view(['GET'])
# @authentication_classes([SessionAuthentication, TokenAuthentication])
# @permission_classes([IsAuthenticated])
# def get_all_files(request):
#     files = File.objects.filter(user_id=request.user.id)
#     serializer = FileSerializer(files, many = True)
#     return Response({ "files" : serializer.data})

@api_view(['POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def create_file(request):
    request.data["user_id"] = request.user.id
    serializer = FileSerializer(data = request.data)
    if serializer.is_valid():
        # serializer.data["user_id"] = request.user.id
        serializer.save()
        return Response(serializer.data, status = status.HTTP_201_CREATED)
    return Response(serializer.errors, status= status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'DELETE', 'PUT'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def file_details(request, id):

    try:
        file = File.objects.get(pk=id)

    except File.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'GET':
        serializer = FileSerializer(file)
        return Response(serializer.data)
    
    elif request.method == 'PUT':
        serializer = FileSerializer(file, data= request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status= status.HTTP_200_OK)
        return Response(serializer.errors, status= status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        file.delete()
        return Response(status= status.HTTP_204_NO_CONTENT)
    


# TODO at last
@api_view(['GET'])
def test(request):
    print('in test')
    # # access_token = request.session.get('access_token')
    # # print(access_token)
    # # if not access_token:    
    # return redirect('/dropbox-auth')
    # return Response({'test':'ok'})

def dropbox_auth(request):
    print('in auth')
    url = f'https://www.dropbox.com/oauth2/authorize?client_id={settings.DROPBOX_CLIENT_ID}&redirect_uri={settings.DROPBOX_REDIRECT_URI}&response_type=code'
    print(url)
    return redirect(url)

def dropbox_callback(request):
    print('in callback')
    code = request.GET.get('code')
    print(code)
    if not code:
        return JsonResponse({'error': 'No code provided'}, status=400)

    token_url = 'https://api.dropboxapi.com/oauth2/token'
    data = {
        'code': code,
        'grant_type': 'authorization_code',
        'client_id': settings.DROPBOX_CLIENT_ID,
        'client_secret': settings.DROPBOX_CLIENT_SECRET,
        'redirect_uri': settings.DROPBOX_REDIRECT_URI
    }
    response = requests.post(token_url, data=data)
    token_info = response.json()

    if 'access_token' in token_info:
        os.environ['DROPBOX_ACCESS_TOKEN'] = token_info['access_token']
        access_token = token_info['access_token']
        # add to .env file
        env_file_path = '.env'
        with open(env_file_path, 'r') as f:
            lines = f.readlines()
        lines = [line for line in lines if not line.startswith("DROPBOX_ACCESS_TOKEN=")]
        lines.append(f'DROPBOX_ACCESS_TOKEN="{access_token}"\n')
        with open(env_file_path, 'w') as f:
            f.writelines(lines)
        return JsonResponse(token_info)
    else:
        return JsonResponse(token_info, status=400)