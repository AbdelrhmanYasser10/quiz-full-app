import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/cubits/questions_cubit/questions_cubit.dart';

import 'package:new_quiz_full_app/screens/quiz_body_consumer.dart';
import 'package:new_quiz_full_app/screens/results_screen.dart';


class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is QuizFinished) {
          AppCubit.get(context).calculateUserResults(
            questions: QuestionsCubit.get(context).questions
          ); // final grades
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const ResultsScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
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
          body: QuizBodyConsumer(),
        );
      },
    );
  }
}
