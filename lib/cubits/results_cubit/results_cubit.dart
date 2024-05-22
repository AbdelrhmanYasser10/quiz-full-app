import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../models/results_model.dart';

part 'results_state.dart';

class ResultsCubit extends Cubit<ResultsState> {
  ResultsCubit() : super(ResultsInitial());

  // to use results cubit in specific places
  static ResultsCubit get(context) => BlocProvider.of(context);

  List<ResultsModel> questionsAnswer = [];
  late int userGrade;
  final _database = FirebaseFirestore.instance;
  void getUserResultsForSpecificQuiz({required String quizId ,required String userId}){
    questionsAnswer = [];
    emit(ResultsLoading());
    _database.
    collection("users")
        .doc(userId)
        .collection("results").
    doc(quizId).get().then((value){
      userGrade = value.data()!['grade'];
      _database.collection("users")
          .doc(userId)
          .collection("results").
      doc(quizId).
      collection("questions").
      get().then((value){
        for(var element in value.docs){
          questionsAnswer.add(
            ResultsModel.fromJson(element.data()),
          );
          questionsAnswer.last.question.id = element.id;
        }
        emit(ResultsLoadedSuccessfully());
      }).catchError((error){
        emit(ResultsLoadedWithError());
      });
    }).catchError((error){
      emit(ResultsLoadedWithError());
    });

  }
}
