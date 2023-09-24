import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_app/custom_widgets/custom_app_bar.dart';
import 'package:hospital_app/custom_widgets/custom_bottom_bar.dart';
import 'package:hospital_app/entity/profile.dart';
import 'package:intl/intl.dart';

import '../controllers/signup_controller.dart';
import '../custom_widgets/custom_text_field.dart';
import '../shared/file_service.dart';
import 'dashboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignupController signupController = Get.put(SignupController());

  final TextEditingController nomController = TextEditingController();

  final TextEditingController prenomController = TextEditingController();

  final TextEditingController numTelController = TextEditingController();

  final TextEditingController numDossierController = TextEditingController();

  Profile? profile;

  Future<Profile> getProfile() async {
    Profile profileFile = await FileService.getProfile();

    setState(() {
      profile = profileFile;
    });

    if (profile != null) {
      nomController.text = profileFile.nom;
      prenomController.text = profileFile.prenom;
      numTelController.text = profileFile.numTel;
      numDossierController.text = profileFile.numDossier;
    }

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
                  child: profile == null
                      ? const Text('S\'inscrire')
                      : const Text("Modifier"),
                  onPressed: () {
                    Profile profile = Profile(
                        nom: nomController.text,
                        prenom: prenomController.text,
                        dateNaissance: signupController.selectedDate.toString(),
                        numTel: numTelController.text,
                        numDossier: numDossierController.text);

                    signupController.createProfile(profile);

                    AwesomeDialog(
                      context: context,
                      animType: AnimType.leftSlide,
                      headerAnimationLoop: false,
                      dialogType: DialogType.success,
                      showCloseIcon: true,
                      title: ' ',
                      desc:
                          'Vous avez été inscrit avec succès \n لقد تم تسجيلك بنجاح',
                      btnOkOnPress: () {
                        debugPrint('OnClcik');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DashboardScreen(), // Replace with your DashboardScreen widget
                          ),
                        );
                      },
                      btnOkIcon: Icons.check_circle,
                      onDismissCallback: (type) {
                        debugPrint('Dialog Dissmiss from callback $type');
                      },
                    ).show();
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
