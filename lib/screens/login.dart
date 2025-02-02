import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulup/constants/colors.dart';
import 'package:tulup/entity/profile.dart';
import 'package:tulup/screens/dashboard.dart';
import 'package:tulup/screens/signup.dart';
import 'package:tulup/shared/file_service.dart';

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
        //Get.to(const DashboardScreen());
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        AwesomeDialog(
                dialogType: DialogType.error,
                btnOkOnPress: () {
                  debugPrint('OnClcik');
                },
                btnOkIcon: Icons.check_circle,
                context: context,
                headerAnimationLoop: false,
                desc: "Verifier votre login !\nتحقق من تسجيل الدخول الخاص بك!",
                title: "Login Incorrect !\nتسجيل الدخول غير صحيح!")
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
              desc: "Verifier votre login !\nتحقق من تسجيل الدخول الخاص بك!",
              title: "Login Incorrect !\nتسجيل الدخول غير صحيح!")
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
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      top: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15), // Image border
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(38), // Image radius
                        child: Image.asset(
                          "assets/lupus-icon.png",
                          width: 40,
                          height: 40,
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
                  labelText: "Numéro de téléphone | رقم الهاتف",
                  controller: loginController,
                  keyboardType: TextInputType.phone,
                ),
                CustomTextField(
                  labelText: "Mot de passe | كلمة المرور",
                  controller: passwordController,
                  isPassword: true,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: seedColor.withAlpha(200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size.fromHeight(
                          MediaQuery.of(context).size.height * 0.12),
                    ),
                    child: const Text(
                      'Se connecter\nتسجيل الدخول',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login(context);
                      }
                    },
                  ),
                ),
                // TextButton(
                //   onPressed: () {},
                //   child: Text(
                //     'mot de passe oublié ?\nنسيت كلمة المرور؟',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(color: Colors.grey[600]),
                //   ),
                // ),
                if (profile == null)
                  TextButton(
                    onPressed: () {
                      Get.to(() => const SignUpScreen());
                    },
                    child: Text(
                      'Pas de compte ?\nليس لديك حساب؟',
                      textAlign: TextAlign.center,
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
