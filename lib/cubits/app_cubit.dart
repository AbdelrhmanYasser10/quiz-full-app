import 'package:bloc/bloc.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:new_quiz_full_app/models/question_model.dart';

import '../models/answer_model.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context)=>BlocProvider.of(context);

  PageController pageController = PageController();
  List<AnswerModel> userAnswers = [];

  var _database = FirebaseFirestore.instance;


  //Counter
  int duration = 10;
  CountDownController controller = CountDownController();

  // grade
  int grade = 0;

  void userAddNewAnswer({required AnswerModel userAnswer , required List<QuestionModel> questions}){
    userAnswers.add(userAnswer);
    timeOutFunction(questions: questions);
    emit(AddNewAnswer());
  }


  void timeOutFunction({required List<QuestionModel> questions}){
    if(pageController.page!.round() == questions.length - 1 ){
      controller.pause();
     emit(QuizFinished());
    }
    else {
      duration = 60;
      controller.restart();
      pageController.nextPage(
        duration: const Duration(seconds: 1),
        curve: Curves.linear,
      );
      emit(TimeOutState());
    }
  }

  void calculateUserResults({
    required List<QuestionModel> questions,
    required String quizId,
    required String userId,
  }){
    print(questions.length);
    print(userAnswers.length);
    Map<String, bool> checkUserSolution = {};
    for(var element in questions){
      checkUserSolution[element.id] = false;
    }
    for(var element in userAnswers){
      checkUserSolution[element.questionId] = true;
    }
    //grade only
    for(var element in questions){
      for (var userAnswer in userAnswers){
        if(element.id == userAnswer.questionId){
          // sound or mcq
          if(userAnswer.userChoiceIndex != null){
            if(userAnswer.userChoiceIndex! == element.correctAnswerIndex){
              grade +=10;
            }
          }
          else if(userAnswer.passedByUser){
            grade += 10;
          }
        }
      }
    }

    for(var element in checkUserSolution.keys){
      Map<String,dynamic> questionMap = {};
      //true
      if(checkUserSolution[element]!){
        for(var question in questions){
          if(question.id == element){
            questionMap = question.toMap();
            for(var userAnswer  in userAnswers){
              if(element == userAnswer.questionId){
                //mcq , sound
                if(userAnswer.userChoiceIndex != null){
                  questionMap['userChoice'] = userAnswer.userChoiceIndex!;
                }
                // pass
                else
                {
                  questionMap['pass'] = userAnswer.passedByUser;
                }
                break;
              }
            }
            break;
          }
        }

      }
      else {
        for (var question in questions) {
          if (question.id == element) {
            questionMap = question.toMap();
            questionMap['pass'] = false;
            break;
          }
        }
      }
      _database.
      collection('users')
          .doc(userId)
          .collection('results')
          .doc(quizId)
          .collection("questions")
          .doc(element).
      set(questionMap).then((value){
        print("Added successfully");
      });
    }
    _database.
    collection("users")
    .doc(userId)
    .collection("results")
    .doc(quizId).set({
      'grade':grade,
      // todo:: the problem message,
      'problem': grade < 50 ? "":null,
    }).then((value) {
      emit(ResultsCalculated());
    });

  }




}
