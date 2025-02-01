import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lupus_app/constants/colors.dart';
import 'package:lupus_app/custom_widgets/custom_app_bar.dart';
import 'package:lupus_app/custom_widgets/custom_bottom_bar.dart';
import 'package:lupus_app/entity/profile.dart';
import 'package:lupus_app/screens/login.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

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
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController numTelController = TextEditingController();
  final TextEditingController numDossierController = TextEditingController();
  Profile? profile;
  final _formKey = GlobalKey<FormState>();

  Future<Profile> getProfile() async {
    try {
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
    } catch (e) {
      debugPrint('Error loading profile: $e');
      return Profile(
        isLoggedIn: false,
        doctor: '',
        password: '',
        nom: '',
        prenom: '',
        dateNaissance: DateTime.now().toString(),
        numTel: '',
        numDossier: '',
      );
    }
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  void dispose() {
    nomController.dispose();
    passwordController.dispose();
    doctorController.dispose();
    prenomController.dispose();
    numTelController.dispose();
    numDossierController.dispose();
    super.dispose();
  }

  void _showSuccessDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: ' ',
      desc: 'Vous avez été inscrit avec succès \n لقد تم تسجيلك بنجاح',
      btnOkOnPress: () {
        debugPrint('OnClick');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dismiss from callback $type');
      },
    ).show();
  }

  void _handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        Profile newProfile = Profile(
          isLoggedIn: true,
          doctor: doctorController.text,
          password: passwordController.text,
          nom: nomController.text,
          prenom: prenomController.text,
          dateNaissance: signupController.selectedDate.toString(),
          numTel: numTelController.text,
          numDossier: numDossierController.text,
        );

        await signupController.createProfile(newProfile);
        _showSuccessDialog(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildAlertDialog(
          context,
          'Confirmation\nتأكيد',
          'Êtes-vous sûr de vouloir vous déconnecter ?\nهل أنت متأكد أنك تريد تسجيل الخروج؟',
          () async {
            try {
              await FileService.updateProfileIsLogged(false);
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildAlertDialog(
          context,
          'Confirmation\nتأكيد',
          'Êtes-vous sûr de vouloir supprimer votre compte ?\nهل أنت متأكد أنك تريد حذف حسابك؟',
          () async {
            try {
              await FileService.deleteAllFilesInDirectory();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildAlertDialog(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Annuler | إلغاء",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: pink,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
          onPressed: onConfirm,
          child: const Text(
            "Confirmer | تأكيد",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final horizontalPadding = size.width * 0.05;
    final verticalPadding = size.height * 0.02;
    final double baseTextSize = isSmallScreen ? 14 : 16;
    final double buttonTextSize = isSmallScreen ? 16 : 18;

    return Scaffold(
      bottomNavigationBar: profile != null ? CustomBottomBar() : null,
      appBar: CustomAppBar(
        title: profile != null
            ? 'Mes informations\nمعلوماتي'
            : "Créer un compte\nإنشاء حساب",
        isLoggedIn: profile != null,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFormFields(baseTextSize),
                        if (profile != null) _buildConditionsText(baseTextSize),
                        if (profile == null) ...[
                          _buildPasswordField(baseTextSize),
                          _buildTermsCheckbox(baseTextSize),
                        ],
                        const SizedBox(height: 20),
                        // Action buttons with updated styling
                        _buildSubmitButton(size, buttonTextSize),
                        if (profile != null && profile!.isLoggedIn) ...[
                          const SizedBox(height: 30), // Added space
                          _buildLogoutButton(size, buttonTextSize),
                          _buildDeleteAccountButton(size, buttonTextSize),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormFields(double baseTextSize) {
    return Column(
      children: [
        _buildResponsiveTextField(
          "Votre Nom | اللقب",
          nomController,
          baseTextSize,
        ),
        _buildResponsiveTextField(
          "Votre Prénom | الاسم",
          prenomController,
          baseTextSize,
        ),
        _buildDateSelector(baseTextSize),
        _buildResponsiveTextField(
          "Numéro de téléphone | رقم الهاتف",
          numTelController,
          baseTextSize,
          keyboardType: TextInputType.number,
        ),
        _buildResponsiveTextField(
          "Numéro de Dossier | رقم الملف",
          numDossierController,
          baseTextSize,
          keyboardType: TextInputType.number,
        ),
        _buildResponsiveTextField(
          "Médecin traitant | الطبيب المعالج",
          doctorController,
          baseTextSize,
        ),
      ],
    );
  }

  Widget _buildResponsiveTextField(
    String label,
    TextEditingController controller,
    double textSize, {
    TextInputType? keyboardType,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomTextField(
        labelText: label,
        controller: controller,
        keyboardType: keyboardType,
        isPassword: isPassword,
      ),
    );
  }

  Widget _buildDateSelector(double textSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Container(
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                DateFormat("dd-MM-yyyy")
                    .format(signupController.selectedDate.value)
                    .toString(),
                style:
                    TextStyle(fontSize: textSize, fontWeight: FontWeight.w300),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => signupController.selectDate(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Date de naissance\nتاريخ الميلاد',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: textSize),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(double textSize) {
    return _buildResponsiveTextField(
      "Mot de passe | كلمة المرور",
      passwordController,
      textSize,
      isPassword: true,
    );
  }

  Widget _buildTermsCheckbox(double textSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Obx(
            () => Transform.scale(
              scale: textSize / 14,
              child: Checkbox(
                value: signupController.isChecked.value,
                onChanged: (value) => signupController.onChanged(value!),
                checkColor: Colors.white,
                fillColor: WidgetStateProperty.all(Colors.black),
              ),
            ),
          ),
          Expanded(
            child: _buildTermsText(textSize),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsText(double textSize) {
    return RichText(
      text: TextSpan(
        text: 'J\'accepte ',
        style: TextStyle(color: Colors.black, fontSize: textSize),
        children: [
          TextSpan(
            text: 'les Conditions d\'utilisation | شروط الاستخدام',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: textSize,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ConditionsPage(isloggedIn: false),
                  ),
                );
              },
          ),
        ],
      ),
    );
  }

  Widget _buildConditionsText(double textSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RichText(
        text: TextSpan(
          text: 'Afficher ',
          style: TextStyle(color: Colors.black, fontSize: textSize),
          children: [
            TextSpan(
              text: 'les Conditions d\'utilisation | شروط الاستخدام',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: textSize,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ConditionsPage(isloggedIn: true),
                    ),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(Size size, double textSize) {
    final isNewUser = profile == null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(size.width * 0.8, 50),
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: isNewUser ? Colors.green : Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => _handleSubmit(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isNewUser ? 'Enregistrer' : 'Modifier',
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              isNewUser ? 'تسجيل' : 'تعديل',
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(Size size, double textSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(size.width * 0.8, 50),
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.red),
          ),
        ),
        onPressed: () => _showLogoutDialog(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Se déconnecter',
              style: TextStyle(
                color: Colors.red,
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              'خروج',
              style: TextStyle(
                color: Colors.red,
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton(Size size, double textSize) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(size.width * 0.8, 50),
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.red),
          ),
        ),
        onPressed: () => _showDeleteAccountDialog(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Supprimer mon compte',
              style: TextStyle(
                color: Colors.red,
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              'احذف حسابي',
              style: TextStyle(
                color: Colors.red,
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConditionsPage extends StatelessWidget {
  const ConditionsPage({super.key, required this.isloggedIn});
  final bool isloggedIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Conditions d\'utilisation\nشروط الاستخدام',
      ),
      bottomNavigationBar: isloggedIn ? CustomBottomBar() : null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.03,
          ),
          child: WebViewPlus(
            zoomEnabled: true,
            onWebViewCreated: (controller) {
              controller.loadUrl('assets/cgu.html');
            },
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
