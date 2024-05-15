import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/models/answer_model.dart';
import 'package:new_quiz_full_app/models/question_model.dart';

import '../../cubits/questions_cubit/questions_cubit.dart';

class MCQBody extends StatefulWidget {
  final QuestionModel question;

  const MCQBody({super.key, required this.question});

  @override
  State<MCQBody> createState() => _MCQBodyState();
}

class _MCQBodyState extends State<MCQBody> {
  int? userChoiceIndex;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      widget.question.title,
                      style: GoogleFonts.manrope(
                        textStyle: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              userChoiceIndex = index;
                              cubit.userAddNewAnswer(
                                userAnswer: AnswerModel(
                                  questionId: widget.question.id,
                                  passedByUser: true,
                                  userChoiceIndex: index,
                                ),
                                questions: QuestionsCubit.get(context).questions,
                              );
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 55.0,
                            decoration: BoxDecoration(
                              color: userChoiceIndex == index ? Colors.black : Colors.blueGrey.shade300,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                              child: Text(
                                widget.question.answers[index],
                                style: GoogleFonts.manrope(
                                    textStyle: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color:userChoiceIndex == index ? Colors.white : Colors.black
                                    )
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 20.0,
                        );
                      },
                      itemCount: widget.question.answers.length,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ); // UI
  }
}
