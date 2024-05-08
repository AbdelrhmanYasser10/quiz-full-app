import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/screens/body/corss_body.dart';
import 'package:new_quiz_full_app/screens/body/drag_body.dart';
import 'package:new_quiz_full_app/screens/body/mcq_body.dart';
import 'package:new_quiz_full_app/screens/body/puzzle_body.dart';
import 'package:new_quiz_full_app/screens/body/sound_body.dart';
import 'package:new_quiz_full_app/screens/results_screen.dart';

import '../data/data.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is QuizFinished) {
          AppCubit.get(context).calculateUserResults(); // final grades
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const ResultsScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0.0,
            title: Text(
              "Quiz 1",
              style: GoogleFonts.manrope(
                textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
          body: Column(
            children: [
              CircularCountDownTimer(
                duration: cubit.duration,
                initialDuration: 0,
                controller: cubit.controller,
                width: MediaQuery.of(context).size.width / 7,
                height: MediaQuery.of(context).size.height / 7,
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
                  cubit.timeOutFunction();
                },
                timeFormatterFunction: (defaultFormatterFunction, duration) {
                  return Function.apply(defaultFormatterFunction, [duration]);
                },
              ),
              Expanded(
                child: PageView.builder(
                  controller: cubit.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (quiz1[index].type == "mcq") {
                      return MCQBody(
                        question: quiz1[index],
                      );
                    } else if (quiz1[index].type == "sound") {
                      return SoundBody(
                        question: quiz1[index],
                      );
                    } else if (quiz1[index].type == "drag") {
                      return DragBody(
                        question: quiz1[index],
                      );
                    } else if (quiz1[index].type == "crossword") {
                      return CrossBody(
                        question: quiz1[index],
                      );
                    } else if (quiz1[index].type == "puzzle") {
                      return PuzzleBody(
                        question: quiz1[index],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                  itemCount: quiz1.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
