import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lupus_app/constants/colors.dart';
import 'package:lupus_app/entity/profile.dart';
import 'package:lupus_app/screens/dashboard.dart';
import 'package:lupus_app/screens/signup.dart';
import 'package:lupus_app/shared/file_service.dart';

import '../custom_widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController loginController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  login(context) async {
    try {
      Profile? profile = await FileService.getProfileByLogin(
          loginController.text, passwordController.text);
      if (profile != null) {
        Get.to(const DashboardScreen());
      } else {
        AwesomeDialog(
                dialogType: DialogType.error,
                btnOkOnPress: () {
                  debugPrint('OnClcik');
                },
                btnOkIcon: Icons.check_circle,
                context: context,
                headerAnimationLoop: false,
                desc: "Verifier votre login !",
                title: "Login Incorrect !")
            .show();
      }
    } catch (e) {
      AwesomeDialog(
              btnOkOnPress: () {
                debugPrint('OnClcik');
              },
              btnOkIcon: Icons.check_circle,
              dialogType: DialogType.error,
              context: context,
              headerAnimationLoop: false,
              desc: "Verifier votre login !",
              title: "Login Incorrect !")
          .show();
    }
  }

  Profile? profile;

  Future<Profile?> getProfile() async {
    Profile profileFile = await FileService.getProfile();
    setState(() {
      profile = profileFile;
    });
    return profileFile;
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.05,
                      top: MediaQuery.of(context).size.height * 0.1,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15), // Image border
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(38), // Image radius
                        child: Image.asset(
                          "assets/lupus-icon.png",
                          width: 64,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                Text(
                  "Bienvenue !\n! مرحبا",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.deepPurple.withOpacity(0.5)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                CustomTextField(
                  labelText: "Identifiant",
                  controller: loginController,
                ),
                CustomTextField(
                  labelText: "Mot de passe",
                  controller: passwordController,
                  isPassword: true,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(
                          MediaQuery.of(context).size.height * 0.1),
                    ),
                    child: const Text('Se connecter'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login(context);
                      }
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'mot de passe oublié ?',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                if (profile == null)
                  TextButton(
                    onPressed: () {
                      Get.to(() => const SignUpScreen());
                    },
                    child: Text(
                      'Pas de compte ?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
