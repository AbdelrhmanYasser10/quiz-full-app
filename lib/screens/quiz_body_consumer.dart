import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/cubits/questions_cubit/questions_cubit.dart';

import 'body/corss_body.dart';
import 'body/drag_body.dart';
import 'body/mcq_body.dart';
import 'body/puzzle_body.dart';
import 'body/sound_body.dart';

class QuizBodyConsumer extends StatelessWidget {
  const QuizBodyConsumer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuestionsCubit, QuestionsState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var questionCubit = QuestionsCubit.get(context);
        if(state is GetDataLoading){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else if(state is GetDataSuccessfully) {
          return Column(
            children: [
              CircularCountDownTimer(
                duration: cubit.duration,
                initialDuration: 0,
                controller: cubit.controller,
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 7,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 7,
                ringColor: Colors.grey[300]!,
                fillColor: Colors.black,
                backgroundColor: Colors.black,
                strokeWidth: 10.0,
                strokeCap: StrokeCap.round,
                textStyle: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textFormat: CountdownTextFormat.S,
                isReverse: true,
                isReverseAnimation: false,
                isTimerTextShown: true,
                autoStart: true,
                onComplete: () {
                  cubit.timeOutFunction(
                    questions: questionCubit.questions,
                  );
                },
                timeFormatterFunction:
                    (defaultFormatterFunction, duration) {
                  return Function.apply(
                      defaultFormatterFunction, [duration]);
                },
              ),
              Expanded(
                child: PageView.builder(
                  controller: cubit.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    print(questionCubit.questions.length);
                    if (questionCubit.questions[index].type == "mcq") {
                      return MCQBody(
                        question: questionCubit.questions[index],
                      );
                    } else if (questionCubit.questions[index].type == "sound") {
                      return SoundBody(
                        question: questionCubit.questions[index],
                      );
                    } else if (questionCubit.questions[index].type == "drag") {
                      return DragBody(
                        question: questionCubit.questions[index],
                      );
                    } else
                    if (questionCubit.questions[index].type == "crossword") {
                      return CrossBody(
                        question: questionCubit.questions[index],
                      );
                    } else
                    if (questionCubit.questions[index].type == "puzzle") {
                      return PuzzleBody(
                        question: questionCubit.questions[index],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                  itemCount: questionCubit.questions.length,
                ),
              ),
            ],
          );
        }
        else{
          return const SizedBox();
        }
      },
    );
  }
}
