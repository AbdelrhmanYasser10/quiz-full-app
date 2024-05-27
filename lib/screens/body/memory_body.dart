import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/models/question_model.dart';

import '../../cubits/questions_cubit/questions_cubit.dart';
import '../../models/answer_model.dart';

class MemoryQuizBody extends StatefulWidget {
  final QuestionModel question;
  const MemoryQuizBody({super.key ,required this.question});

  @override
  State<MemoryQuizBody> createState() => _MemoryQuizBodyState();
}

class _MemoryQuizBodyState extends State<MemoryQuizBody> {
  List<GlobalKey<FlipCardState>> keys = [];
  List<bool> _cardFlips = [];

  int previousIndex = -1;
  int _time = 5;
  bool _flip = false;
  bool _start = false;
  bool _wait = false;
  Timer? time;
  bool _isFinished = false;

  Widget getItem(int index){
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: const[
          BoxShadow(
            color: Colors.black45,
            blurRadius: 2,
            spreadRadius: 0.8,
            offset: Offset(2.0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Image.network(widget.question.answers[index]),
    );
  }

  void startTimer(){
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      _time = _time - 1;
    });
  }

  void restart(){
    startTimer();
    Future.delayed(
      const Duration(seconds: 6),
      () {
        setState(() {
          _start = true; // to start the game
          time!.cancel();
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    for(int i = 0 ; i < widget.question.answers.length; i++){
      keys.add(GlobalKey<FlipCardState>());
      _cardFlips.add(true);
    }
    restart();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    var cubit = AppCubit.get(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: GridView.builder(
            itemCount: widget.question.answers.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.question.crossAxisCount!,
            ),
            itemBuilder: (context, index) {
              if(_start){
                return FlipCard(
                    key: keys[index],
                    onFlip: () {
                      if(!_flip){
                        _flip = true;
                        previousIndex = index;
                      }
                      else{
                        _flip =false;
                        if(previousIndex != index){
                          if(widget.question.answers[previousIndex] != widget.question.answers[index]){
                            _wait = true;
                            Future.delayed(
                              Duration(milliseconds: 1500),
                              () {
                                keys[previousIndex].currentState!.toggleCard();
                                previousIndex = index;
                                keys[previousIndex].currentState!.toggleCard();
                                Future.delayed(
                                  Duration(milliseconds: 1500),
                                  () {
                                    _wait = false;
                                  },
                                );
                              },
                            );
                          }
                          else{
                            _cardFlips[previousIndex] = false;
                            _cardFlips[index] = false;
                            if(_cardFlips.every((element) => element == false)){
                              Future.delayed(
                                const Duration(milliseconds: 160),
                                () {
                                  setState(() {
                                    _isFinished  = true;
                                    _start =false;
                                    cubit.userAddNewAnswer(
                                      userAnswer: AnswerModel(
                                        questionId: widget.question.id,
                                        passedByUser: true,
                                      ),
                                      questions:
                                      QuestionsCubit.get(context).questions,
                                    );
                                  });
                                  // add to jump to next question
                                },
                              );
                            }
                          }
                        }
                      }
                    },
                  flipOnTouch: _wait ?false :_cardFlips[index],
                  direction: FlipDirection.HORIZONTAL,
                    front: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const[
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 3,
                            spreadRadius: 0.8,
                            offset: Offset(2, 1),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          "assets/images/quest.png"
                        ),
                      ),
                    ),
                    back: getItem(index),
                );
              }
              else{
                return getItem(index);
              }
            },
          ),
        ),
      ),
    );
  },
);
  }
}
