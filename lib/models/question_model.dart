import 'dart:convert';

class QuestionModel{

  late String id;
  late String title;
  late String type; // mcq , sound, drag
  late List<String> answers;

  // can be null
  Map<String,bool>? dragChecker;
  int? correctAnswerIndex;
  List<List<String>>? crossWordQuestion;
  List<String>? patternImages;
  String? correctPatternKey;

  QuestionModel({
  required this.id,
  required this.title,
  required this.type,
  required this.answers,
  this.crossWordQuestion,
  this.dragChecker,
  this.correctAnswerIndex,
  this.correctPatternKey,
  this.patternImages,
  });

  QuestionModel.fromMap(Map<String,dynamic> json){

    title = json['title'];
    answers = [];
    json['answers'].forEach((element){
      answers.add(element);
    });
    type = json['type'];
    if(type == "drag"){
      answers.shuffle();
    }
    if(json['dragChecker'] !=null) {
      dragChecker = {};
      json['dragChecker'].keys.forEach((element) {
        dragChecker![element] = false;
      });
    }
    correctAnswerIndex = json['correctAnswerIndex'];
    if(type == 'crossword'){
      crossWordQuestion = [

      ];

      json['crossWordQuestion'].keys.forEach((element){
       var data = jsonDecode(json['crossWordQuestion'][element]);
       List<String> fullData = [];
       data.forEach((v){
         fullData.add(v);
       });
       crossWordQuestion!.add(fullData);
      });
    }
    patternImages = json['patternImages'];
    correctPatternKey = json['patternCorrectKey'];
  }

  Map<String,dynamic> toMap(){
    Map<String,String> crossWordMap= {};
    if(crossWordQuestion != null) {
      for (int i = 0 ; i < crossWordQuestion!.length;i++) {
        crossWordMap['row${i+1}'] = jsonEncode(crossWordQuestion![i]);
      }
    }
    return {
      'title':title,
      'type':type,
      'answers':answers,
      'dragChecker':dragChecker,
      'correctAnswerIndex':correctAnswerIndex,
      'crossWordQuestion': crossWordMap.isEmpty ? null : crossWordMap,
      'patternImages':patternImages,
      'patternCorrectKey':correctPatternKey,
    };
  }

}