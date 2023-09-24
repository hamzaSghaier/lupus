import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.labelText,
      required this.controller,
      this.keyboardType,
      this.isPassword = false});

  final String labelText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: keyboardType != null
          ? TextField(
              keyboardType: keyboardType,
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.0),
                ),
                labelText: labelText,
              ),
            )
          : TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.0),
                ),
                labelText: labelText,
              ),
            ),
    );
  }
}
