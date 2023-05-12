import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_app/screens/signup.dart';

import '../custom_widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // logo goes here
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
            child: const FlutterLogo(
              size: 40,
            ),
          ),
          CustomTextField(
            labelText: "Login",
            controller: loginController,
          ),
          CustomTextField(
            labelText: "Password",
            controller: passwordController,
          ),
          Container(
            height: 80,
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Log In'),
              onPressed: () {},
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Mot de passe oublie?',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.to(() => SignUpScreen());
            },
            child: Text(
              'Pas de compte?',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
