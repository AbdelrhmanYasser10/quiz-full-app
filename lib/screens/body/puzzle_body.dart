import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/models/answer_model.dart';
import 'package:new_quiz_full_app/models/question_model.dart';

class PuzzleBody extends StatefulWidget {
  final QuestionModel question;
  const PuzzleBody({super.key, required this.question});

  @override
  State<PuzzleBody> createState() => _PuzzleBodyState();
}

class _PuzzleBodyState extends State<PuzzleBody> {
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
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      widget.question.title,
                      style: GoogleFonts.manrope(
                          textStyle:const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 0,
                          crossAxisSpacing: 0,

                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data = widget.question.dragChecker!.keys
                              .elementAt(index);
                          bool isDragged = widget.question.dragChecker![data]!;
                          return DragTarget<String>(
                            builder: (context, candidateData, rejectedData) {
                              return Stack(
                                children: [
                                  Image.asset(
                                    widget.question.answers[index],
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.contain,
                                  ),
                                  isDragged ? const SizedBox():Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.black26,
                                  )
                                ],
                              );
                            },
                            onWillAcceptWithDetails: (details) {
                              print(details.data);
                              return details.data ==
                                  widget.question.dragChecker!.keys
                                      .elementAt(index);
                            },
                            onAcceptWithDetails: (details) {
                              var value = widget.question.dragChecker!.keys
                                  .elementAt(index);
                              widget.question.dragChecker![value] = true;
                              bool finished = true;
                              // loop on keys
                              // الغرض هنا اثبات عكس اللي فرضناه ان اليوزر خلص كل حاجه
                              for (var element
                              in widget.question.dragChecker!.keys) {
                                if (widget.question.dragChecker![element] ==
                                    false) {
                                  finished = false;
                                }
                              }
                              if (finished) {
                                cubit.userAddNewAnswer(
                                  userAnswer: AnswerModel(
                                    questionId: widget.question.id,
                                    passedByUser: true,
                                  ),
                                );
                              }
                              setState(() {});
                            },
                          );
                        },
                        itemCount: widget.question.answers.length,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        var data = widget.question.dragChecker!.keys.elementAt(index);
                        bool isDraggedSuccessfully = widget.question.dragChecker![data]!;
                        return Draggable<String>(
                          data: data,
                          childWhenDragging:Image.asset(
                            widget.question.answers[index],
                            color: Colors.grey,
                            width: 120,
                            height: 120,
                          ),
                          feedback: Image.asset(
                            widget.question.answers[index],
                            width: 120,
                            height: 120,
                          ),
                          child: isDraggedSuccessfully ? const SizedBox() : Image.asset(
                            widget.question.answers[index],
                            width: 120,
                            height: 120,
                          ),
                        );
                      },
                      itemCount: widget.question.dragChecker!.keys.length,
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
