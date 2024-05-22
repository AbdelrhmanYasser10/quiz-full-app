import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../models/question_model.dart';

part 'questions_state.dart';

class QuestionsCubit extends Cubit<QuestionsState> {
  QuestionsCubit() : super(QuestionsInitial());
  List<QuestionModel> questions = [];
  final _database = FirebaseFirestore.instance;

  static QuestionsCubit get(context)=>BlocProvider.of(context);

  void getQuestionsData({required String quizId}) {
    emit(GetDataLoading());
    questions = [];
    _database.
    collection('quizes')
        .doc(
        quizId
    ).
    collection('questions').
    get().
    then((value) {
      for (var element in value.docs) {
        var question =  QuestionModel.fromMap(element.data());
        question.id = element.id;
        questions.add(question);
      }
      emit(GetDataSuccessfully());
    }).catchError((error) {
      print(error.toString());
      emit(GetDataError());
    });
  }
}
