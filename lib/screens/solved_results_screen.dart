import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/results_cubit/results_cubit.dart';

import 'body/corss_body.dart';
import 'body/drag_body.dart';
import 'body/mcq_body.dart';
import 'body/mcq_color_body.dart';
import 'body/mcq_differnce_body.dart';
import 'body/puzzle_body.dart';
import 'body/sound_body.dart';

class SolvedResultsScreen extends StatelessWidget {
  const SolvedResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ResultsCubit, ResultsState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ResultsCubit.get(context);
          if(state is ResultsLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(state is ResultsLoadedWithError) {
            return Center(
              child: Text(
                "Error While getting results,try again later",
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  textStyle:const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.black
                  ),

                ),
              ),
            );
          }
          else{
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        "Your grade was ${cubit.userGrade}/${cubit.questionsAnswer.length * 10}",
                        style: GoogleFonts.manrope(
                          textStyle:const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      cubit.userGrade < 50 ? Text(
                        "You have failed in this quiz",
                        style: GoogleFonts.manrope(
                          textStyle:const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                          ),
                        ),
                      ):const SizedBox(),
                      Expanded(
                          child:PageView.builder(
                              itemBuilder: (context, index) {
                                if (cubit.questionsAnswer[index].question.type == "mcq") {
                                  return MCQBody(
                                    question: cubit.questionsAnswer[index].question,
                                    results: cubit.questionsAnswer[index],
                                    fromResult: true,
                                  );
                                } else if (cubit.questionsAnswer[index].question.type == "sound") {
                                  return SoundBody(
                                    question: cubit.questionsAnswer[index].question,
                                    fromResult: true,
                                    results: cubit.questionsAnswer[index],
                                  );
                                } else if (cubit.questionsAnswer[index].question.type == "drag") {
                                  return DragBody(
                                    question: cubit.questionsAnswer[index].question,
                                    results: cubit.questionsAnswer[index],
                                    fromResult: true,
                                  );
                                } else if (cubit.questionsAnswer[index].question.type ==
                                    "crossword") {
                                  return CrossBody(
                                    question: cubit.questionsAnswer[index].question,
                                    fromResult: true,
                                    results: cubit.questionsAnswer[index],
                                  );
                                } else if (cubit.questionsAnswer[index].question.type ==
                                    "puzzle") {
                                  return PuzzleBody(
                                    question: cubit.questionsAnswer[index].question,
                                    fromResult: true,
                                    results: cubit.questionsAnswer[index],
                                  );
                                } else if (cubit.questionsAnswer[index].question.type ==
                                    "mcq_color") {
                                  return MCQColorBody(
                                    question: cubit.questionsAnswer[index].question,
                                    fromResult: true,
                                    results: cubit.questionsAnswer[index],
                                  );
                                } else if(cubit.questionsAnswer[index].question.type=="mcq_difference"){
                                  return MCQDifferenceBody(
                                    question: cubit.questionsAnswer[index].question,
                                    fromResult: true,
                                    results: cubit.questionsAnswer[index],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            itemCount: cubit.questionsAnswer.length,
                          ) ,
                      ),

                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
