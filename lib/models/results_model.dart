import 'package:new_quiz_full_app/models/question_model.dart';

class ResultsModel{
  late QuestionModel question;
  int? userChoiceIndex;
  bool? pass;

  ResultsModel.fromJson(Map<String,dynamic> json){
    question = QuestionModel.fromMap(json);
    userChoiceIndex = json['userChoice'];
    pass = json['pass'];
  }
}