
import 'package:fluent_flow/features/onboarding/domain/entities/onboard_response.dart';

class OnBoardModel extends OnBoard{
  
  const OnBoardModel({required bool firstTime}) : super(firstTime: firstTime);

  factory OnBoardModel.fromJson(Map<String, dynamic> json) {
    return OnBoardModel(
      firstTime: json['firstTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstTime': firstTime,
    };
  }

}