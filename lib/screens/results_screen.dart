import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/cubits/questions_cubit/questions_cubit.dart';

import '../generated/l10n.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0.0,
            title: Text(
              S.of(context).your_result,
              style: GoogleFonts.manrope(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
          ),
          body: Center(
            child: Text(
              "${cubit.grade}/${QuestionsCubit.get(context).questions.length * 10}",
              style: GoogleFonts.manrope(
                textStyle:const TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )
              ),
            ),
          ),
        );
      },
    );
  }
}
