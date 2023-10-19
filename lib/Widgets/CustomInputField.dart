import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;

  CustomInputField({
    Key? key,
    required this.label,
    required this.controller,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.black),
    );

    return TextField(
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.blue,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }
}
