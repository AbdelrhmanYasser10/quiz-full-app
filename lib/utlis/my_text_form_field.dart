import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final String?Function(String?) validator;
  final bool enabled;
  const MyTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.icon,
    this.isPassword = false,
    required this.validator,
    this.enabled = true,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  late bool isSecure;

  @override
  void initState() {
    super.initState();
    isSecure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      obscureText: isSecure,
      controller: widget.controller,
      style: GoogleFonts.manrope(
        textStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: Colors.white,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: Colors.white,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: Colors.white,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: Colors.white,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: Colors.white,
          ),
        ),
        prefixIcon: Icon(
          widget.icon,
          color: Colors.white,
        ),
        hintText: widget.hintText,
        hintStyle: GoogleFonts.manrope(
          textStyle: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade200,
          ),
        ),
        suffixIcon: widget.isPassword ? IconButton(
          onPressed: (){
            isSecure = !isSecure;
            setState(() {});
          },
          icon: Icon(
            isSecure ? Icons.visibility_off_outlined:Icons.visibility_outlined,
            color: Colors.white,
          ),
        ) : null,
      ),
      validator: widget.validator,
    );
  }
}
