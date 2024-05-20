import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/questions_cubit/questions_cubit.dart';
import 'package:new_quiz_full_app/cubits/quizzes_cubit/quizzes_cubit.dart';
import 'package:new_quiz_full_app/screens/quiz_screen.dart';

class AllQuizzesScreen extends StatelessWidget {
  const AllQuizzesScreen({super.key});

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
                color: Colors.black
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: BlocConsumer<QuizzesCubit, QuizzesState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit=  QuizzesCubit.get(context);
          if(state is GetAllQuizzesLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(state is GetAllQuizzesSuccess) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 5.0,
              ),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        QuestionsCubit.get(context).getQuestionsData(
                          quizId: cubit.allQuizzes[index].id,
                        );
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_){
                              return  QuizScreen(
                                quizId: cubit.allQuizzes[index].id,
                              );
                            }),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                             horizontal: 10,
                            vertical: 20.0
                          ),
                          child: Center(
                            child: Text(
                              cubit.allQuizzes[index].name,
                              style: GoogleFonts.manrope(
                                textStyle: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
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
          }else{
            return const SizedBox();
          }
        },
      ),
    );
  }
}
