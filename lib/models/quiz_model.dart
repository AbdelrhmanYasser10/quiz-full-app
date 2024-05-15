class QuizModel{
  late String id;
  late String name;

  QuizModel.fromMap(Map<String,dynamic> map){
    name = map['name'];
  }
}