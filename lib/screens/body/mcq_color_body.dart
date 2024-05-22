import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/app_cubit.dart';
import '../../cubits/questions_cubit/questions_cubit.dart';
import '../../models/answer_model.dart';
import '../../models/question_model.dart';

class MCQColorBody extends StatefulWidget {
  final QuestionModel question;

  const MCQColorBody({super.key,required this.question});

  @override
  State<MCQColorBody> createState() => _MCQColorBodyState();
}

class _MCQColorBodyState extends State<MCQColorBody> {
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
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange,
                          width: 1.0
                        ),
                      ),
                      child: Image.network(
                        widget.question.title,
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
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
                            decoration: BoxDecoration(
                              color: userChoiceIndex == index ? Colors.black : Colors.blueGrey.shade300,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.orange,
                                width: 1.0,
                              ),
                            ),
                            child: Image.network(widget.question.answers[index],fit: BoxFit.fill,),
                          ),
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
