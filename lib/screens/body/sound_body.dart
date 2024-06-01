import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_quiz_full_app/models/answer_model.dart';
import 'package:new_quiz_full_app/models/question_model.dart';

import '../../cubits/app_cubit.dart';
import '../../cubits/questions_cubit/questions_cubit.dart';
import '../../models/results_model.dart';

class SoundBody extends StatefulWidget {
  final QuestionModel question;
  final bool fromResult;
  final ResultsModel? results;
  const SoundBody(
      {super.key,
      required this.question,
      this.fromResult = false,
      this.results});

  @override
  State<SoundBody> createState() => _SoundBodyState();
}

class _SoundBodyState extends State<SoundBody> {
  final player = AudioPlayer();
  int? activeIndex;

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }
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
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: ()async {
                          await player.play(UrlSource(widget.question.title));
                        },
                        icon: const Icon(
                          Icons.volume_up,
                          color: Colors.black,
                        ),
                        iconSize: 72.0,
                      ),
                      const Text(
                        "Press here to hear sound",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                activeIndex = index;
                                cubit.userAddNewAnswer(
                                  userAnswer: AnswerModel(
                                    questionId: widget.question.id,
                                    passedByUser: true,
                                    userChoiceIndex: index,
                                  ),
                                  questions:
                                  QuestionsCubit
                                      .get(context)
                                      .questions,
                                );
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: activeIndex == index
                                    ? Colors.black
                                    : Colors.blueGrey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child:
                              Image.network(widget.question.answers[index]),
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
        }else{
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: ()async {
                          await player.play(UrlSource(widget.question.title));
                        },
                        icon: const Icon(
                          Icons.volume_up,
                          color: Colors.black,
                        ),
                        iconSize: 72.0,
                      ),
                      const Text(
                        "Press here to hear sound",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: getCorrectColor(index),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:
                            Image.network(widget.question.answers[index]),
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

        }
      },
    );
  }
  Color getCorrectColor(int index){
    if(widget.results!.userChoiceIndex != null){
      if(widget.results!.userChoiceIndex! == widget.results!.question.correctAnswerIndex  && widget.results!.userChoiceIndex! == index){
        return Colors.green;
      }
      else{
        if(widget.results!.question.correctAnswerIndex == index){
          return Colors.green;
        }
        else if(index == widget.results!.userChoiceIndex!){
          return Colors.red;
        }
        else{
          return Colors.blueGrey.shade300;
        }
      }
    }
    else{
      if(index == widget.results!.question.correctAnswerIndex!){
        return Colors.green;
      }
      else{
        return Colors.blueGrey.shade300;
      }
    }
  }
}
