import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/models/question_model.dart';

import '../../cubits/questions_cubit/questions_cubit.dart';
import '../../models/answer_model.dart';

class PatternBody extends StatefulWidget {
  final QuestionModel question;

  const PatternBody({Key? key, required this.question}) : super(key: key);

  @override
  State<PatternBody> createState() => _PatternBodyState();
}

class _PatternBodyState extends State<PatternBody> {
  bool _isDragged = false;
  String userChoiceImage = "";
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
                    SizedBox(
                      width: double.infinity,
                      height: 75,
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            if(index < widget.question.patternImages!.length) {
                              return Image.network(
                                  widget.question.patternImages![index],
                                height: 75,
                              );
                            }
                            else{
                              return DragTarget<String>(
                                onAcceptWithDetails: (details) {
                                  _isDragged = true;
                                  userChoiceImage = details.data;
                                  setState(() {});
                                },
                                onWillAcceptWithDetails: (details) {
                                  if(details.data == widget.question.correctPatternKey!){
                                    cubit.userAddNewAnswer(
                                      userAnswer: AnswerModel(
                                        questionId: widget.question.id,
                                        passedByUser: true,
                                      ),
                                      questions: QuestionsCubit
                                          .get(context)
                                          .questions,
                                    );
                                  }
                                  else{
                                    //solved wrongly
                                    cubit.userAddNewAnswer(
                                      userAnswer: AnswerModel(
                                        questionId: widget.question.id,
                                        passedByUser: false,
                                      ),
                                      questions: QuestionsCubit
                                          .get(context)
                                          .questions,
                                    );
                                  }

                                  return true;
                                },
                                builder: (context, candidateData, rejectedData) => _isDragged  ? Image.network(
                                  userChoiceImage,
                                  height: 75,
                                ):Container(
                                  height: 75,
                                  width: 75,
                                  color: Colors.blueGrey,
                                ),
                              );
                            }
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              width: 10.0,
                            );
                          },
                          itemCount: widget.question.patternImages!.length + 1,
                          scrollDirection: Axis.horizontal, // <----->
                      ),
                    ),
                    const SizedBox(
                      height: 120.0,
                    ),
                    Center(
                      child: SizedBox(
                        height: 75,
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if(_isDragged && widget.question.answers[index] == userChoiceImage){
                              return const SizedBox();
                            }
                            return Draggable<String>(
                                data: widget.question.answers[index],
                                childWhenDragging: Image.network(
                                  widget.question.answers[index],
                                  height: 75,
                                  color: Colors.grey,
                                ),
                                feedback: Image.network(
                                  widget.question.answers[index],
                                  height: 90,
                                ),
                                child: Image.network(
                                    widget.question.answers[index],
                                  height: 75,
                                ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              width: 10.0,
                            );
                          },
                          itemCount: widget.question.answers.length,
                          scrollDirection: Axis.horizontal, // <----->
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
