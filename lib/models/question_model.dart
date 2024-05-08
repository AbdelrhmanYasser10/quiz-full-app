class QuestionModel{

  late int id;
  late String title;
  late String type; // mcq , sound, drag
  late List<String> answers;

  // can be null
  Map<String,bool>? dragChecker;
  int? correctAnswerIndex;
  List<List<String>>? crossWordQuestion;

  QuestionModel({
  required this.id,
  required this.title,
  required this.type,
  required this.answers,
  this.crossWordQuestion,
  this.dragChecker,
  this.correctAnswerIndex,
  });

}