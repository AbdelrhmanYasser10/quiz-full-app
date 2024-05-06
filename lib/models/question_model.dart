class QuestionModel{

  late int id;
  late String title;
  late String type; // mcq , sound, drag
  late List<String> answers;

  // can be null
  Map<String,bool>? dragChecker;
  int? correctAnswerIndex;

  QuestionModel({
  required this.id,
  required this.title,
  required this.type,
  required this.answers,
  this.dragChecker,
  this.correctAnswerIndex,
  });

}