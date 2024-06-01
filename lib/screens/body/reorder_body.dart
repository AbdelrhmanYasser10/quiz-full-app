import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/models/question_model.dart';
import 'package:new_quiz_full_app/screens/passed_or_not_widget.dart';

import '../../cubits/questions_cubit/questions_cubit.dart';
import '../../models/answer_model.dart';
import '../../models/results_model.dart';

class ReorderBody extends StatefulWidget {
  final QuestionModel question;
  final bool fromResult;
  final ResultsModel? results;
  const ReorderBody(
      {super.key,
      required this.question,
      this.fromResult = false,
      this.results});

  @override
  State<ReorderBody> createState() => _ReorderBodyState();
}

class _ReorderBodyState extends State<ReorderBody> {
  final _scrollController = ScrollController();
  final _gridViewKey = GlobalKey();
  List<String> _animals = [];

  int _time = 5;
  bool _start = false;
  Timer? time;
  bool _isFinished = false;

  void startTimer() {
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      _time = _time - 1;
    });
  }

  void restart() {
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
    _animals = widget.question.answers;
    restart();
  }

  @override
  Widget build(BuildContext context) {
    final generatedChildren = List.generate(
      _animals.length,
      (index) => Container(
        key: Key(_animals.elementAt(index)),
        child: Image.network(
          _animals.elementAt(index),
        ),
      ),
    );

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        if (!widget.fromResult) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: _start
                    ? Column(
                        children: [
                          Expanded(
                            child: ReorderableBuilder(
                              enableDraggable: true,
                              scrollController: _scrollController,
                              onDragStarted: () {
                                print("Start Dragging");
                              },
                              onDragEnd: () {
                                print("End Dragging");
                              },
                              onReorder: (List<OrderUpdateEntity>
                                  orderUpdateEntities) {
                                print(orderUpdateEntities.length);
                                for (final orderUpdateEntity
                                    in orderUpdateEntities) {
                                  final animal = _animals
                                      .removeAt(orderUpdateEntity.oldIndex);
                                  _animals.insert(
                                      orderUpdateEntity.newIndex, animal);
                                }
                                setState(() {});
                              },
                              enableScrollingWhileDragging: true,
                              builder: (children) {
                                return Center(
                                  key: _gridViewKey,
                                  child: GridView(
                                    controller: _scrollController,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 8,
                                    ),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: children,
                                  ),
                                );
                              },
                              children: generatedChildren,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // to check if answered before
                              bool pass = true;
                              for (int i = 0; i < _animals.length; i++) {
                                if (_animals[i] !=
                                    widget.question.correctReorderedList![i]) {
                                  pass = false;
                                  break;
                                }
                              }
                              cubit.userAddNewAnswer(
                                userAnswer: AnswerModel(
                                  questionId: widget.question.id,
                                  passedByUser: pass,
                                ),
                                questions:
                                    QuestionsCubit.get(context).questions,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20.0),
                                child: Center(
                                  child: Text(
                                    "Confirm Answers",
                                    style: GoogleFonts.manrope(
                                      textStyle: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : GridView.builder(
                        itemCount: widget.question.correctReorderedList!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.question.correctReorderedList![index],
                          );
                        },
                      ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        itemCount: widget.question.correctReorderedList!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.question.correctReorderedList![index],
                          );
                        },
                      ),
                    ),
                    PassedOrNotWidget(pass: widget.results!.pass!),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
