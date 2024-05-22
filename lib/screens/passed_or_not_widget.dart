import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PassedOrNotWidget extends StatelessWidget {
  final bool pass;
  const PassedOrNotWidget({super.key,required this.pass});

  @override
  Widget build(BuildContext context) {
    return pass ? Text(
      "Passed Successfully",
      style: GoogleFonts.manrope(
          textStyle:const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          )
      ),
    ):Text(
      "You not solved this puzzle",
      style: GoogleFonts.manrope(
          textStyle:const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          )
      ),
    );
  }
}
