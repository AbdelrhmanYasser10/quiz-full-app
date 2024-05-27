import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/models/question_model.dart';

class PatternBody extends StatefulWidget {
  final QuestionModel question;

  const PatternBody({Key? key, required this.question}) : super(key: key);

  @override
  State<PatternBody> createState() => _PatternBodyState();
}

class _PatternBodyState extends State<PatternBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
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
                      height: 120,
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return Image.network(
                              widget.question.patternImages![index]
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              width: 10.0,
                            );
                          },
                          itemCount: widget.question.patternImages!.length + 1,
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
