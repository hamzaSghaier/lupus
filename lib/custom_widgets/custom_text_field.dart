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
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (isPassword) {
              return 'Mot de passe obligatoire !';
            }
            return 'Champ obligatoire !';
          }
          return null;
        },
        controller: controller,
        obscureText: isPassword,
        style: Theme.of(context).textTheme.bodySmall,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          labelText: labelText,
        ),
      ),
    );
  }
}
