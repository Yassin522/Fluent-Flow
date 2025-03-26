// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:fluent_flow/core/cache/cache_helper.dart';
import 'package:fluent_flow/core/const/api.dart';
import 'package:fluent_flow/core/entities/user.dart';
import 'package:fluent_flow/core/models/user_model.dart';
import 'package:fluent_flow/core/models/video_model.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluent_flow/get_it_init.dart' as getit;
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';

class FluentCubit extends Cubit<FluentState> {
  final CacheHelper cacheHelper = getit.getIt<CacheHelper>();
  VideoPlayerController? controller;
  bool showControls = false;
  Map<String, double>? performanceMetrics;
  final Dio _dio = Dio();

  FluentCubit() : super(FluentInitial());

  static FluentCubit get(context) => BlocProvider.of(context);

  User user = const User(
      name: "User Name",
      role: "teacher",
      id: -1,
      email: "email",
      imageUrl: "imageUrl");

  Future<void> getLocalUser() async {
    emit(GetUserLoadingState());
    try {
      user = await cacheHelper.getSavedUser();
      log(user.toString());
      emit(GetUserSuccessState(user: user));
    } catch (e) {
      GetUserErrorState(message: e.toString());
    }
  }

  Future<void> updateUser(String name, String role) async {
    emit(UpdateUserLoadingState());
    log(cacheHelper.getData(key: 'token'));
    log(user.id.toString());
    try {
      final body = {
        "name": name,
        "role": role,
      };
      var response = await http.put(
        Uri.parse('$IP_PORT/api/users/details/${user.id}'),
        body: body,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Token ${cacheHelper.getData(key: 'token')}'
        },
      );
      log(response.statusCode.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        emit(const UpdateUserSuccessState());
        var updatedUser = UserModel.fromJson(json.decode(response.body));
        cacheHelper.saveUser(user: updatedUser);
        user = updatedUser;
      } else {
        throw Exception("Error in updating user info");
      }
    } catch (error) {
      print(error);
      emit(UpdateUserErrorState(message: error.toString()));
    }
  }

  Future<void> changePassword(String password) async {
    emit(ChangePasswordLoadingState());
    log(cacheHelper.getData(key: 'token'));
    log(user.id.toString());
    try {
      final body = {
        "password": password,
      };
      var response = await http.put(
        Uri.parse('$IP_PORT/api/users/details/password/${user.id}'),
        body: body,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Token ${cacheHelper.getData(key: 'token')}'
        },
      );
      log(response.statusCode.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        emit(const ChangePasswordSuccessState());
      } else {
        throw Exception("Error in updating user info");
      }
    } catch (error) {
      emit(ChangePasswordErrorState(message: error.toString()));
    }
  }

  Future<void> addPhoto(String? fileName, Uint8List? fileBytes) async {
    emit(ChangePasswordLoadingState());
    if (fileBytes != null) {
      try {
        var request = http.MultipartRequest(
            'POST', Uri.parse('$IP_PORT/api/users/${user.id}/upload_photo'));
        request.files.add(http.MultipartFile.fromBytes(
          'photo',
          fileBytes,
          filename: fileName,
        ));
        request.headers['Accept'] = 'application/json';
        request.headers['Authorization'] =
            'Token ${cacheHelper.getData(key: 'token')}';
        var response = await request.send();

        log(response.statusCode.toString());
        log(response.toString());
        var responseBody = await http.Response.fromStream(response);

        if (response.statusCode == 200) {
          print('File uploaded successfully.');
          emit(const ChangePasswordSuccessState());
          var updatedUser = UserModel.fromJson(json.decode(responseBody.body));
          cacheHelper.saveUser(user: updatedUser);
          user = updatedUser;
        } else {
          print('File upload failed with status: ${response.statusCode}');
          emit(const ChangePasswordErrorState(message: "File upload failed"));
        }
      } catch (e) {
        print('File upload failed: $e');
        emit(ChangePasswordErrorState(message: e.toString()));
      }
    }
  }

  double scoreLanguageVariation(totalTokens, uniqueTokens){
    double  ratio = uniqueTokens / totalTokens;
    if (ratio >= 0.5) {
      return 0.0;
    }
    else if (ratio <= 0.15) {
      return 5.0;
    }
    else{
      double score = 4 - ((ratio - 0.15) / (0.5 - 0.15)) * 3;
      return score;
    }
  }

  List<List<double>> gesturesScores = [];
  List<List<double>> gesturesAnalytics = [];
  List<List<double>> voiceScores = [];
  List<List<double>> scriptScores = [];
  List<List<double>> scriptAnalytics = [];

  Future<void> getScores() async {
    emit(GetScoresLoadingState());
    try {
      var response = await http.get(
        Uri.parse('$IP_PORT/api/files/get_history/${user.id}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Token ${cacheHelper.getData(key: 'token')}'
        },
      );

      log(user.id.toString());
      log(cacheHelper.getData(key: 'token'));
      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        //gestures
        List<double> gestureUseScoreList = [];
        List<double> gesturePlaceScoreList = [];
        List<double> gestureClosePercentageList = [];
        List<double> goodPosesPercentageList = [];
        List<double> badPosesPercentageHOHList = [];
        List<double> badPosesPercentageHcList = [];
        List<double> gazeRatioPercentageList = [];
        List<double> eyeGazeScoreList = [];
        List<double> headGazeScoreList = [];

        //voice
        List<double> fillerScoreList = [];
        List<double> speedScoreList = [];
        List<double> speedVariationScoreList = [];
        List<double> pauseScoreList = [];
        List<double> sentenceLengthScoreList = [];
        List<double> pdqScoreList = [];

        //script
        List<double> totalScoreScriptList = [];
        List<double> languageVariationScriptList = [];
        List<double> uniqueTokensCountList = [];
        List<double> tokensCountList = [];
        List<double> stopwordsCountList = [];
        List<double> sentencesCountList = [];
        List<double> grammarList = [];

        for (var videoScore in data) {
          if(videoScore["video"]["video"] != null && videoScore["video"]["video"].toString().isNotEmpty){
          
            gestureUseScoreList.add(videoScore['gesture_use_score']);
            gesturePlaceScoreList.add(videoScore['gesture_place_score']);
            gestureClosePercentageList.add(videoScore['gesture_close_percentage']);
            goodPosesPercentageList.add(videoScore['good_poses_percentage']);
            badPosesPercentageHOHList.add(videoScore['bad_poses_percentage_hoh']);
            badPosesPercentageHcList.add(videoScore['good_poses_percentage_hc']);
            gazeRatioPercentageList.add(videoScore['gaze_ratio_percentage']);
            eyeGazeScoreList.add(videoScore['eye_gaze_score']);
            headGazeScoreList.add(videoScore['head_gaze_score']);
            
            fillerScoreList.add(videoScore['filler_score']);
            speedScoreList.add(videoScore['speed_score']);
            speedVariationScoreList.add(videoScore['speed_variation_score']);
            pauseScoreList.add(videoScore['pause_score']);
            sentenceLengthScoreList.add(videoScore['sentence_length_score']);
            pdqScoreList.add(videoScore['pdq_score']);

            int x = videoScore['Tokens_Count'];
            int y = videoScore['Unique_Tokens_Count'];
            totalScoreScriptList.add(videoScore['Total_Score']);
            languageVariationScriptList.add(scoreLanguageVariation(x, y));
            uniqueTokensCountList.add(videoScore['Unique_Tokens_Count']);
            tokensCountList.add(videoScore['Tokens_Count']);
            stopwordsCountList.add(videoScore['Stopwords_Count']);
            sentencesCountList.add(videoScore['Sentences_Count']);
            grammarList.add(videoScore['Number_of_grammatical_error']);
          }
        }

        gesturesScores = [
          gestureUseScoreList,
          eyeGazeScoreList,
          headGazeScoreList,
        ];

        gesturesAnalytics = [
          gesturePlaceScoreList,
          gestureClosePercentageList,
          goodPosesPercentageList,
          badPosesPercentageHOHList,
          badPosesPercentageHcList,
          gazeRatioPercentageList,
        ];

        voiceScores = [
          fillerScoreList,
          speedScoreList,
          speedVariationScoreList,
          pauseScoreList,
          pdqScoreList,
        ];

        scriptScores = [
          totalScoreScriptList,
          languageVariationScriptList,
        ];

        scriptAnalytics = [
          uniqueTokensCountList,
          tokensCountList,
          stopwordsCountList,
          sentencesCountList,
          grammarList,
        ];

        emit(const GetScoresSuccessState());
      } else {
        emit(const GetScoresErrorState(message: "Failed to retrieve data"));
      }
    } catch (e) {
      emit(GetScoresErrorState(message: e.toString()));
    }
  }

  List<Video> videos = [];

  Future<void> getVideos() async {
    emit(GetVideosLoadingState());
    videos = [];
    
    try {
      var response = await http.get(
        Uri.parse('$IP_PORT/api/files/${user.id}/videos'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Token ${cacheHelper.getData(key: 'token')}'
        },
      );

      log(user.id.toString());
      log(cacheHelper.getData(key: 'token'));
      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        for (var video in data) {
          if(video["video"] != null && video["video"].toString().isNotEmpty){
            videos.add(Video(id: video['id'], videoUrl: video["video"]));
          }
        }

        emit(const GetVideosSuccessState());
      } else {
        emit(const GetVideosErrorState(message: "Failed to retrieve data"));
      }
    } catch (e) {
      emit(GetVideosErrorState(message: e.toString()));
    }
  }

  Video? videoScore;

  Future<void> getVideoScores(Video video) async {
    emit(GetVideoScoresLoadingState());
    try {
      var response = await http.get(
        Uri.parse('$IP_PORT/api/files/video_score/${video.id}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Token ${cacheHelper.getData(key: 'token')}'
        },
      );

      log(user.id.toString());
      log(cacheHelper.getData(key: 'token'));
      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic data = json.decode(response.body);

        videoScore = Video.fromJsonX(data);
        log(videoScore!.transcription!);
        emit(const GetVideoScoresSuccessState());
      } else {
        emit(const GetVideoScoresErrorState(message: "Failed to retrieve data"));
      }
    } catch (e) {
      emit(GetVideoScoresErrorState(message: e.toString()));
    }
  }

  void logoutLocal() {
    emit(LogoutLocalLoadingState());
    // Add logout logic here if necessary
  }

  Future<void> pickVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      PlatformFile file = result.files.first;

      final bytes = file.bytes;
      if (bytes != null) {
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final videoFile = html.File([bytes], file.name);

        final newController = VideoPlayerController.networkUrl(Uri.parse(url));
        await newController.initialize();
        newController.play();

        controller?.dispose();
        controller = newController;

        emit(VideoPickedState(controller: controller, videoFile: videoFile));
      }
    }
  }

  void showControlsfun() {
    showControls = true;
    emit(ShowControlsState());
  }

  void hideControls() {
    showControls = false;
    emit(HideControlsState());
  }

  Future<void> evaluateVideo(html.File videoFile) async {
    emit(EvaluateVideoLoadingState());
    user = await cacheHelper.getSavedUser();
    log(user.toString());
    print(videoFile);

    try {
      final token = cacheHelper.getData(key: 'token');
      final formData = FormData();

      final reader = html.FileReader();
      reader.readAsArrayBuffer(videoFile);

      await reader.onLoadEnd.first;

      final Uint8List videoBytes = reader.result as Uint8List;

      formData.files.add(MapEntry(
        'video',
        MultipartFile.fromBytes(
          videoBytes,
          filename: videoFile.name,
        ),
      ));

      formData.fields.add(MapEntry('user_id', user.id.toString()));

      log('FormData user_id: ${user.id.toString()}');
      log('FormData video: ${videoFile.name}');
      log('Token: $token');

      final response = await _dio.post(
        '$IP_PORT/api/files/create',
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );

      print(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // final dynamic data = json.decode();

        videoScore = Video.fromJson(response.data);
        log(videoScore!.videoUrl!);
        log(videoScore!.transcription!);
        log(videoScore!.id!.toString()); 
        
        emit(const EvaluateVideoSuccessState());
      } else {
        log('Error response: ${response.data}');
        emit(EvaluateVideoErrorState(
            message: 'Failed to evaluate video: ${response.statusCode}'));
      }
    } catch (e) {
      log('Exception: $e');
      emit(EvaluateVideoErrorState(message: e.toString()));
    }
  }

  void toggleVideo() {
    if (controller != null) {
      if (controller!.value.isPlaying) {
        controller!.pause();
      } else {
        controller!.play();
      }
      emit(VideoToggledState(controller: controller));
    }
  }

  String? oldText;
  String? correctedText;
  double? totalScore;
  double? uniqueTokensCount;
  double? tokensCount;
  double? stopWordsCount;
  double? sentencesCount;
  double? numberOfGrammaticalError;
  
  Future<void> evaluateScript(String text) async {
    emit(EvaluateScriptLoadingState());

    try{
      final body = {
        "Text": text,
        "user_id": "${user.id}",
      };
      var response = await http.post(
        Uri.parse('$IP_PORT/api/files/evaluatetext'),
        body: body,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Token ${cacheHelper.getData(key: 'token')}'
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.body);
        dynamic data = json.decode(response.body);
        oldText = text;
        correctedText = data["performance_metrics"]["corrected_text"];
        totalScore = data["performance_metrics"]["Total_Score"];
        uniqueTokensCount = data["performance_metrics"]["Unique_Tokens_Count"];
        tokensCount = data["performance_metrics"]["Tokens_Count"];
        stopWordsCount = data["performance_metrics"]["Stopwords_Count"];
        sentencesCount = data["performance_metrics"]["Sentences_Count"];
        numberOfGrammaticalError = data["performance_metrics"]["Number_of_grammatical_error"];
        emit(const EvaluateScriptSuccessState());
      } else {
        throw Exception("Error");
      }
    }catch(e){
        emit(EvaluateScriptErrorState(message: e.toString()));
    }
  }
}
