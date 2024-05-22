import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/questions_cubit/questions_cubit.dart';
import 'package:new_quiz_full_app/cubits/quizzes_cubit/quizzes_cubit.dart';
import 'package:new_quiz_full_app/cubits/results_cubit/results_cubit.dart';
import 'package:new_quiz_full_app/screens/quiz_screen.dart';
import 'package:new_quiz_full_app/screens/solved_results_screen.dart';

class AllQuizzesScreen extends StatelessWidget {
  final bool isPlay;
  const AllQuizzesScreen({super.key,required this.isPlay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "All Available Quizzes",
          style: GoogleFonts.manrope(
            textStyle: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: BlocConsumer<QuizzesCubit, QuizzesState>(
        listener: (context, state) {
          if (state is GetSolvedQuizzesError) {

            if(isPlay) {
              QuestionsCubit.get(context).getQuestionsData(
                quizId: state.quizId,
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) {
                  return QuizScreen(
                    quizId: state.quizId,
                  );
                }),
              );
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Not Solved Before"),
                backgroundColor: Colors.red,
              ));
            }
          } else if(state is GetSolvedQuizzesSuccess) {
            if(isPlay) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Solved Before"),
                backgroundColor: Colors.red,
              ));
            }
            else{
              ResultsCubit.get(context).getUserResultsForSpecificQuiz(
                  quizId: state.quizId,
                  userId: FirebaseAuth.instance.currentUser!.uid,
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) {
                  return const SolvedResultsScreen();
                }),
              );
            }
          }
        },
        builder: (context, state) {
          var cubit = QuizzesCubit.get(context);
          if (state is GetAllQuizzesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetAllQuizzesSuccess) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 5.0,
              ),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {

                      // to check if answered before
                      cubit.checkUserSolvedThisQuizBefore(
                        quizId: cubit.allQuizzes[index].id,
                        userId: FirebaseAuth.instance.currentUser!.uid,
                      );

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20.0),
                        child: Center(
                          child: Text(
                            cubit.allQuizzes[index].name,
                            style: GoogleFonts.manrope(
                              textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 20.0,
                  );
                },
                itemCount: cubit.allQuizzes.length,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 5.0,
              ),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {

                      // to check if answered before
                      cubit.checkUserSolvedThisQuizBefore(
                        quizId: cubit.allQuizzes[index].id,
                        userId: FirebaseAuth.instance.currentUser!.uid,
                      );

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20.0),
                        child: Center(
                          child: Text(
                            cubit.allQuizzes[index].name,
                            style: GoogleFonts.manrope(
                              textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 20.0,
                  );
                },
                itemCount: cubit.allQuizzes.length,
              ),
            );
          }
        },
      ),
    );
  }
}
