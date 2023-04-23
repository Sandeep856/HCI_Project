import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String hinttext;
  late final Function(String) onChanged;
  final Function(String) onSubmitted;
  final TextInputAction textInputAction;
  final bool isPasswordField;

  Input({
    required this.hinttext,
    required this.onChanged,
    required this.onSubmitted,
    required this.textInputAction,
    required this.isPasswordField,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        cursorHeight: 25,
        cursorColor: Colors.blue,
        obscureText: isPasswordField,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hinttext.toString(),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 24.0,
          ),
        ),
      ),
    );
  }
}
