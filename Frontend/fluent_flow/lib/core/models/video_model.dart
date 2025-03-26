class Video {
  int? id;
  String? videoUrl;
  String? transcription;

  // Script scores
  double? scriptTotalScore;
  int? uniqueTokensCount;
  int? tokensCount;
  int? stopWordsCount;
  int? sentencesCount;
  double? grammarScore;
  double? sentenceLengthScore;
  String? correctedText;

  // Voice scores
  double? fillerWordsScore;
  double? speedPaceScore;
  double? voiceVariationScore;
  double? pauseScore;
  double? vocalVariationScore;

  // Gestures scores
  double? gestureUseScore;
  double? gesturePlaceScore;
  double? gestureClosePercentage;
  double? goodPosesPercentage;
  double? badPosesPercentageHandsOnHips;
  double? badPosesPercentageHandsCrossed;
  double? gazeRatioPercentage;
  double? eyeGazeScore;
  double? headGazeScore;

  // Constructor
  Video({
    this.id,
    this.videoUrl,
    this.transcription,
    this.scriptTotalScore,
    this.uniqueTokensCount,
    this.tokensCount,
    this.stopWordsCount,
    this.sentencesCount,
    this.grammarScore,
    this.correctedText,
    this.fillerWordsScore,
    this.speedPaceScore,
    this.voiceVariationScore,
    this.pauseScore,
    this.sentenceLengthScore,
    this.vocalVariationScore,
    this.gestureUseScore,
    this.gesturePlaceScore,
    this.gestureClosePercentage,
    this.goodPosesPercentage,
    this.badPosesPercentageHandsOnHips,
    this.badPosesPercentageHandsCrossed,
    this.gazeRatioPercentage,
    this.eyeGazeScore,
    this.headGazeScore,
  });

  // Method to update from JSON
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['video_id'],
      videoUrl: json['video']['video'],
      transcription: json['transcription'],
      scriptTotalScore: json['script_scores']['Total Score']?.toDouble(),
      uniqueTokensCount: json['script_scores']['Unique Tokens Count'],
      tokensCount: json['script_scores']['Tokens Count'],
      stopWordsCount: json['script_scores']['Stopwords Count'],
      sentencesCount: json['script_scores']['Sentences Count'],
      grammarScore: json['script_scores']['Number of grammatical error'],
      correctedText: json['script_scores']['corrected text'],
      fillerWordsScore: json['voice_scores']['filler_score']?.toDouble(),
      speedPaceScore: json['voice_scores']['speed_score']?.toDouble(),
      voiceVariationScore: json['voice_scores']['speed_variation_score']?.toDouble(),
      pauseScore: json['voice_scores']['pause_score']?.toDouble(),
      sentenceLengthScore: json['voice_scores']['sentence_length_score']?.toDouble(),
      vocalVariationScore: json['voice_scores']['pdq_score']?.toDouble(),
      gestureUseScore: json['movement_scores']['gesture_use_score']?.toDouble(),
      // gestureUseScore: 3.2,
      gesturePlaceScore: json['movement_scores']['gesture_place_score']?.toDouble(),
      gestureClosePercentage: json['movement_scores']['gesture_close_percentage']?.toDouble(),
      goodPosesPercentage: json['movement_scores']['good_poses_percentage']?.toDouble(),
      badPosesPercentageHandsOnHips: json['movement_scores']['bad_poses_percentage_hoh']?.toDouble(),
      badPosesPercentageHandsCrossed: json['movement_scores']['good_poses_percentage_hc']?.toDouble(),
      gazeRatioPercentage: json['movement_scores']['gaze_ratio_percentage']?.toDouble(),
      eyeGazeScore: json['movement_scores']['eye_gaze_score']?.toDouble(),
      headGazeScore: json['movement_scores']['head_gaze_score']?.toDouble(),
    );
  }
  factory Video.fromJsonX(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      videoUrl: json['video'].toString(),
      transcription: json['transcription'],
      scriptTotalScore: json['Total_Score']?.toDouble(),
      uniqueTokensCount: json['Unique_Tokens_Count']?.toDouble(),
      tokensCount: json['Tokens_Count']?.toDouble(),
      stopWordsCount: json['Stopwords_Count']?.toDouble(),
      sentencesCount: json['Sentences_Count']?.toDouble(),
      grammarScore: json['Number_of_grammatical_error']?.toDouble(),
      correctedText: json['corrected_text'],
      fillerWordsScore: json['filler_score']?.toDouble(),
      speedPaceScore: json['speed_score']?.toDouble(),
      voiceVariationScore: json['speed_variation_score']?.toDouble(),
      pauseScore: json['pause_score']?.toDouble(),
      sentenceLengthScore: json['sentence_length_score']?.toDouble(),
      vocalVariationScore: json['pdq_score']?.toDouble(),
      gestureUseScore: json['gesture_use_score']?.toDouble(),
      // gestureUseScore: 3.2,
      gesturePlaceScore: json['gesture_place_score']?.toDouble(),
      gestureClosePercentage: json['gesture_close_percentage']?.toDouble(),
      goodPosesPercentage: json['good_poses_percentage']?.toDouble(),
      badPosesPercentageHandsOnHips: json['bad_poses_percentage_hoh']?.toDouble(),
      badPosesPercentageHandsCrossed: json['good_poses_percentage_hc']?.toDouble(),
      gazeRatioPercentage: json['gaze_ratio_percentage']?.toDouble(),
      eyeGazeScore: json['eye_gaze_score']?.toDouble(),
      headGazeScore: json['head_gaze_score']?.toDouble(),
    );
  }


  // Method to convert the Video object to a Map
  Map<String, dynamic> toMap() {
    return {
      // 'video_id': id,
      // 'video_url': videoUrl,
      // 'transcription': transcription,
      // 'script_scores': {
        'Total Score': scriptTotalScore,
        'Unique Tokens Count': uniqueTokensCount,
        'Tokens Count': tokensCount,
        'Stopwords Count': stopWordsCount,
        'Sentences Count': sentencesCount,
        'grammar score': grammarScore,
        'corrected text': correctedText,
      // },
      // 'voice_scores': {
        'filler_score': fillerWordsScore,
        'speed_score': speedPaceScore,
        'speed_variation_score': voiceVariationScore,
        'pause_score': pauseScore,
        'sentence_length_score': sentenceLengthScore,
        'pdq_score': vocalVariationScore,
      // },
      // 'movement_scores': {
        'gesture_use_score': gestureUseScore,
        'gesture_place_score': gesturePlaceScore,
        'gesture_close_percentage': gestureClosePercentage,
        'good_poses_percentage': goodPosesPercentage,
        'bad_poses_percentage_hoh': badPosesPercentageHandsOnHips,
        'good_poses_percentage_hc': badPosesPercentageHandsCrossed,
        'gaze_ratio_percentage': gazeRatioPercentage,
        'eye_gaze_score': eyeGazeScore,
        'head_gaze_score': headGazeScore,
      // },
    };
  }
}
