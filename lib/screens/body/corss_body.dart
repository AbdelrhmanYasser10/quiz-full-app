import 'package:crossword/components/line_decoration.dart';
import 'package:crossword/crossword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/cubits/questions_cubit/questions_cubit.dart';
import 'package:new_quiz_full_app/models/answer_model.dart';
import 'package:new_quiz_full_app/models/question_model.dart';

class CrossBody extends StatefulWidget {
  final QuestionModel question;

  const CrossBody({super.key, required this.question});

  @override
  State<CrossBody> createState() => _CrossBodyState();
}

class _CrossBodyState extends State<CrossBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
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
                Expanded(
                  child: Crossword(
                    letters: widget.question.crossWordQuestion!,
                    spacing: const Offset(
                        25, 30
                    ),
                    drawCrossLine: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    acceptReversedDirection: true,
                    textStyle: GoogleFonts.manrope(
                        textStyle: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        )
                    ),
                    lineDecoration: const LineDecoration(
                      correctColor: Colors.yellow,
                      incorrectColor: Colors.yellow,
                    ),
                    onLineDrawn: (words) {
                      if (words.isNotEmpty) {
                        cubit.userAddNewAnswer(
                            userAnswer: AnswerModel(
                                questionId: widget.question.id,
                                passedByUser: words[0] == widget.question.answers[0],
                            ),
                          questions: QuestionsCubit.get(context).questions,
                        );
                      }
                    },
                    hints: widget.question.answers,
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
