import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lupus_app/custom_widgets/custom_app_bar.dart';
import 'package:lupus_app/custom_widgets/custom_bottom_bar.dart';
import 'package:lupus_app/entity/profile.dart';
import 'package:lupus_app/screens/login.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../controllers/signup_controller.dart';
import '../custom_widgets/custom_text_field.dart';
import '../shared/file_service.dart';
import 'dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignupController signupController = Get.put(SignupController());

  final TextEditingController nomController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController doctorController = TextEditingController();

  final TextEditingController prenomController = TextEditingController();

  final TextEditingController numTelController = TextEditingController();

  final TextEditingController numDossierController = TextEditingController();

  Profile? profile;
  final _formKey = GlobalKey<FormState>();

  Future<Profile> getProfile() async {
    Profile profileFile = await FileService.getProfile();
    setState(() {
      profile = profileFile;
    });

    if (profile != null) {
      nomController.text = profileFile.nom;
      prenomController.text = profileFile.prenom;
      numTelController.text = profileFile.numTel;
      doctorController.text = profileFile.doctor;
      numDossierController.text = profileFile.numDossier;
      passwordController.text = profileFile.password;
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
      bottomNavigationBar: profile != null ? CustomBottomBar() : null,
      appBar: CustomAppBar(
        title: profile != null ? 'Mes informations' : "Créer un compte",
        isLoggedIn: profile != null ? true : false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    labelText: "Votre Nom",
                    controller: nomController,
                  ),
                  CustomTextField(
                    labelText: "Votre Prenom",
                    controller: prenomController,
                  ),
                  // const CustomTextField(labelText: "Date de naissance"),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(
                        () => Text(
                          DateFormat("dd-MM-yyyy")
                              .format(signupController.selectedDate.value)
                              .toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => signupController.selectDate(context),
                        child: const Text('Date de naissance'),
                      )
                    ],
                  ),
                  CustomTextField(
                    labelText: "Numéro de téléphone",
                    controller: numTelController,
                    keyboardType: TextInputType.number,
                  ),
                  CustomTextField(
                    labelText: "Numéro de Dossier",
                    controller: numDossierController,
                    keyboardType: TextInputType.number,
                  ),
                  CustomTextField(
                    labelText: "Médecin traitant",
                    controller: doctorController,
                    keyboardType: TextInputType.name,
                  ),
                  if (profile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                      child: RichText(
                        text: TextSpan(
                          text: 'Afficher ',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'les Conditions d\'utilisation',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ConditionsPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (profile == null)
                    CustomTextField(
                      labelText: "Mot de passe",
                      controller: passwordController,
                      isPassword: true,
                    ),
                  if (profile == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                        RichText(
                          text: TextSpan(
                            text: 'J\'accepte ',
                            style: const TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'les Conditions d\'utilisation',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ConditionsPage(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                  Container(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: profile == null
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'S\'inscrire',
                                ),
                                Text(
                                  'تسجيل',
                                ),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Modifier',
                                ),
                                Text(
                                  'تعديل',
                                ),
                              ],
                            ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Profile profile = Profile(
                              isLoggedIn: true,
                              doctor: doctorController.text,
                              password: passwordController.text,
                              nom: nomController.text,
                              prenom: prenomController.text,
                              dateNaissance:
                                  signupController.selectedDate.toString(),
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
                              Navigator.pushReplacement(
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
                        }
                      },
                    ),
                  ),

                  if (profile != null && profile?.isLoggedIn == true)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Se déconnecter',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'تسجيل الخروج',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmation'),
                                content: const Text(
                                    'Êtes-vous sûr de vouloir vous déconnecter ?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await FileService.updateProfileIsLogged(
                                          false);
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(), // Replace with your login screen
                                        ),
                                      );
                                    },
                                    child: const Text('Oui'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),

                  if (profile != null && profile?.isLoggedIn == true)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Supprimer mon compte',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'احذف حسابي',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmation'),
                                content: const Text(
                                    'Êtes-vous sûr de vouloir supprimer votre compte ?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // User cancels the deletion
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // User confirms the deletion, call the method to delete the account
                                      await FileService
                                          .deleteAllFilesInDirectory();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(), // Replace with your login screen
                                        ),
                                      );
                                    },
                                    child: const Text('Supprimer'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConditionsPage extends StatelessWidget {
  const ConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Conditions d\'utilisation',
      ),
      bottomNavigationBar: CustomBottomBar(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: WebViewPlus(
          zoomEnabled: true,
          onWebViewCreated: (controller) {
            controller.loadUrl('assets/cgu.html');
          },
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
