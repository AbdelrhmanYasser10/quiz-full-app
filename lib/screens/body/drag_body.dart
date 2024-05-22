import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/models/answer_model.dart';
import 'package:new_quiz_full_app/models/question_model.dart';

import '../../cubits/questions_cubit/questions_cubit.dart';
import '../../models/results_model.dart';
import '../passed_or_not_widget.dart';

class DragBody extends StatefulWidget {
  final QuestionModel question;
  final bool fromResult;
  final ResultsModel? results;
  const DragBody({super.key, required this.question ,this.fromResult = false,this.results});

  @override
  State<DragBody> createState() => _DragBodyState();
}

class _DragBodyState extends State<DragBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        if(!widget.fromResult) {
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
                            textStyle: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.blueGrey.shade300,
                        ),
                        child: GridView.builder(
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var data = widget.question.dragChecker!.keys
                                .elementAt(index);
                            bool isDragged = widget.question
                                .dragChecker![data]!;
                            return DragTarget<String>(
                              builder: (context, candidateData, rejectedData) {
                                return Image.network(
                                  widget.question.answers[index],
                                  color: isDragged ? null : Colors.black,
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
                                    questions: QuestionsCubit
                                        .get(context)
                                        .questions,
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
                          var data = widget.question.dragChecker!.keys
                              .elementAt(index);
                          bool isDraggedSuccessfully = widget.question
                              .dragChecker![data]!;
                          return Draggable<String>(
                            data: data,
                            childWhenDragging: Image.network(
                              widget.question.answers[index],
                              color: Colors.grey,
                            ),
                            feedback: Image.network(
                              widget.question.answers[index],
                            ),
                            child: isDraggedSuccessfully
                                ? const SizedBox()
                                : Image.network(
                              widget.question.answers[index],
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
        }
        else{
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
                            textStyle: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.blueGrey.shade300,
                        ),
                        child: GridView.builder(
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {

                            return Image.network(
                              widget.question.answers[index],
                            );
                          },
                          itemCount: widget.question.answers.length,
                        ),
                      ),
                      PassedOrNotWidget(
                        pass: widget.results!.pass!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
