import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:new_quiz_full_app/models/question_model.dart';

class ReorderBody extends StatefulWidget {
  final QuestionModel question;
  const ReorderBody({super.key, required this.question});

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

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: _start
              ? ReorderableBuilder(
                  scrollController: _scrollController,
                  onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
                    for (final orderUpdateEntity in orderUpdateEntities) {
                      final animal =
                          _animals.removeAt(orderUpdateEntity.oldIndex);
                      _animals.insert(orderUpdateEntity.newIndex, animal);
                    }
                    setState(() {});

                  },
                  builder: (children) {
                    return GridView(
                      key: _gridViewKey,
                      controller: _scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 8,
                      ),
                      children: children,
                    );
                  },
                  children: generatedChildren,
                )
              : GridView.builder(
                  itemCount: widget.question.correctReorderedList!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
  }

}
