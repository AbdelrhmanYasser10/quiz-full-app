class UserModel{
  late String id;
  late String? email;
  late String username;
  late bool finishedAll;

  UserModel.fromMap(Map<String ,dynamic> map){
    id = map['id'];
    email = map['email'];
    username = map['username'];
    finishedAll = map['finishedAll'];
  }
}