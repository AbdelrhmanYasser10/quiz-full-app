import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:new_quiz_full_app/cubits/questions_cubit/questions_cubit.dart';

import 'package:new_quiz_full_app/screens/quiz_body_consumer.dart';
import 'package:new_quiz_full_app/screens/results_screen.dart';


class QuizScreen extends StatelessWidget {
  final String quizId;
  const QuizScreen({super.key , required this.quizId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is QuizFinished) {
          AppCubit.get(context).calculateUserResults(
            questions: QuestionsCubit.get(context).questions,
            quizId: quizId,
            userId: FirebaseAuth.instance.currentUser!.uid,
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
          body: const QuizBodyConsumer(),
        );
      },
    );
  }
}
