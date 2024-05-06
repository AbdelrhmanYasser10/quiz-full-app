import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_quiz_full_app/models/answer_model.dart';
import 'package:new_quiz_full_app/models/question_model.dart';

import '../../cubits/app_cubit.dart';

class SoundBody extends StatefulWidget {
  final QuestionModel question;

  const SoundBody({super.key, required this.question});

  @override
  State<SoundBody> createState() => _SoundBodyState();
}

class _SoundBodyState extends State<SoundBody> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  int? activeIndex;

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
                    IconButton(
                      onPressed: () {
                        assetsAudioPlayer.open(
                          Audio(widget.question.title),
                        );
                        assetsAudioPlayer.play();
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
                              );
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: activeIndex == index ? Colors.black : Colors.blueGrey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(widget.question.answers[index]),
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
    );
  }
}
