import 'package:bloc/bloc.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
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



  //Counter
  int duration = 60;
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

  void calculateUserResults({required List<QuestionModel> questions}){
    for(var element in userAnswers){
     if(element.userChoiceIndex != null){
       //mcq or sound
       // --> check on correct answer
       for(var rootQuestions in questions){
         if(element.questionId == rootQuestions.id){
           if(element.userChoiceIndex == rootQuestions.correctAnswerIndex){
             grade+=10;
             break;
           }
         }
       }
     }
     else{
       if(element.passedByUser){
         grade +=10;
       }
     }
    }
    emit(ResultsCalculated());
  }




}
