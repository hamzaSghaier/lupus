import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_app/custom_widgets/custom_app_bar.dart';
import 'package:hospital_app/custom_widgets/custom_bottom_bar.dart';
import 'package:intl/intl.dart';

import '../controllers/signup_controller.dart';
import '../custom_widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignupController signupController = Get.put(SignupController());

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController numTelController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController numDossierController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      appBar: const CustomAppBar(
        title: 'Mes informations',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              CustomTextField(
                labelText: "Nom",
                controller: nomController,
              ),
              CustomTextField(
                labelText: "Prenom",
                controller: prenomController,
              ),
              // const CustomTextField(labelText: "Date de naissance"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                    () => Text(
                      DateFormat("dd-MM-yyyy")
                          .format(signupController.selectedDate.value)
                          .toString(),
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => signupController.selectDate(context),
                    child: const Text('Date de naissance'),
                  )
                ],
              ),
              CustomTextField(
                labelText: "Mot de passe",
                controller: passwordController,
              ),
              CustomTextField(
                labelText: "Num Tel",
                controller: numTelController,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                labelText: "Num Dossier",
                controller: numDossierController,
                keyboardType: TextInputType.number,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Conditions d\'utilisation'),
                  Obx(
                    () => Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary,
                      ),
                      value: signupController.isChecked.value,
                      onChanged: (newValue) =>
                          signupController.onChanged(newValue!),
                    ),
                  ),
                ],
              ),

              Container(
                height: 80,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('S\'inscrire'),
                  onPressed: () {
                    signupController.createProfile(
                        nomController.text,
                        prenomController.text,
                        numTelController.text,
                        passwordController.text);
                  },
                ),
              ),
              SizedBox(height: 40,)
            ],
          ),
        ),
      ),
    );
  }
}
