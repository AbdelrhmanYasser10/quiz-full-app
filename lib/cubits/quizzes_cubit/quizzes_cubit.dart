import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../models/quiz_model.dart';

part 'quizzes_state.dart';

class QuizzesCubit extends Cubit<QuizzesState> {
  QuizzesCubit() : super(QuizzesInitial());

  static QuizzesCubit get(context)=>BlocProvider.of(context);
  List<QuizModel> allQuizzes = [];
  final _database = FirebaseFirestore.instance;
  void getAllQuizzes(){
    emit(GetAllQuizzesLoading());
    _database.collection(
      'quizes'
    ).get().then((value) {
      for(var element in value.docs){
        var quiz = QuizModel.fromMap(element.data());
        quiz.id = element.id;
        allQuizzes.add(quiz);
      }
      emit(GetAllQuizzesSuccess());
    }).catchError((error){
      print(error.toString());
      emit(GetAllQuizzesError());
    });
  }
}
