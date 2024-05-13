import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
          body: Stack(
            children: [
              Center(
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
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: GridView.builder(
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 0,
                                     crossAxisSpacing: 0,
                                  childAspectRatio: 10/9,

                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var data = widget.question.dragChecker!.keys
                                      .elementAt(index);
                                  bool isDragged = widget.question.dragChecker![data]!;
                                  return Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: DragTarget<String>(
                                      builder: (context, candidateData, rejectedData) {
                                        return Opacity(
                                          opacity: isDragged? 1 : 0.5,
                                          child: Image.asset(
                                            widget.question.answers[index],
                                            fit: BoxFit.fill,
                                          ),
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
                                    ),
                                  );
                                },
                                itemCount: widget.question.answers.length,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      child: ListView.separated(

                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 20.0,
                          );
                        },
                        itemBuilder: (context, index) {
                          var data = widget.question.dragChecker!.keys.elementAt(index);
                          bool isDraggedSuccessfully = widget.question.dragChecker![data]!;
                          return Draggable<String>(
                            data: data,
                            childWhenDragging:Image.asset(
                              widget.question.answers[index],
                              color: Colors.grey,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            feedback: Image.asset(
                              widget.question.answers[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            child: isDraggedSuccessfully ? const SizedBox() : Image.asset(
                              widget.question.answers[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        itemCount: widget.question.dragChecker!.keys.length,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
