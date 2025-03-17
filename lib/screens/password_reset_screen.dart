import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tulup/constants/colors.dart';
import 'package:tulup/custom_widgets/custom_app_bar.dart';
import 'package:tulup/custom_widgets/custom_text_field.dart';
import 'package:tulup/entity/profile.dart';
import 'package:tulup/shared/file_service.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController dossierController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  Profile? matchedProfile;
  bool showPasswordField = false;

  void validateInfo() async {
    Profile? found = await FileService.getProfileForPasswordRecovery(
        phoneController.text.trim(), dossierController.text.trim());

    if (found != null) {
      setState(() {
        matchedProfile = found;
        showPasswordField = true;
      });
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Votre compte n'a pas été trouvé !\nلم يتم العثور على حسابك!",
        desc: "Vérifiez vos informations.\nتحقق من معلوماتك",
        btnOkOnPress: () {},
      ).show();
    }
  }

  void updatePassword() async {
    if (matchedProfile != null) {
      matchedProfile = Profile(
        nom: matchedProfile!.nom,
        prenom: matchedProfile!.prenom,
        dateNaissance: matchedProfile!.dateNaissance,
        numTel: matchedProfile!.numTel,
        numDossier: matchedProfile!.numDossier,
        password: newPasswordController.text,
        isLoggedIn: matchedProfile!.isLoggedIn,
        doctor: matchedProfile!.doctor,
      );

      await FileService.updateProfile(
          matchedProfile!); // You need to implement this

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: "Succès",
        desc: "Mot de passe modifié avec succès\nتم تغيير كلمة المرور بنجاح",
        btnOkOnPress: () {
          Navigator.pop(context); // Go back to login
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Récupération de compte\nإستعادة الحساب',
        isLoggedIn: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                    'Pour pouvoir récupérer votre compte vous devez introduire les informations suivantes\nلإستعادة حسابك يجب عليك إدخال المعلومات التالية',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14)),
              ),
              CustomTextField(
                labelText: "Numéro de téléphone | رقم الهاتف",
                controller: phoneController,
                keyboardType: TextInputType.phone,
                isDisabled: showPasswordField,
              ),
              CustomTextField(
                labelText: "Numéro de Dossier | رقم الملف",
                controller: dossierController,
                keyboardType: TextInputType.number,
                isDisabled: showPasswordField,
              ),
              if (showPasswordField) ...[
                CustomTextField(
                  labelText: "Nouveau mot de passe | كلمة السر الجديدة",
                  controller: newPasswordController,
                  keyboardType: TextInputType.text,
                  isPassword: true,
                ),
              ],
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showPasswordField
                        ? Colors.green
                        : seedColor.withAlpha(200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size.fromHeight(
                        MediaQuery.of(context).size.height * 0.12),
                  ),
                  onPressed: showPasswordField ? updatePassword : validateInfo,
                  child: showPasswordField
                      ? Text(
                          'Enregistrer\nحفظ',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        )
                      : Text(
                          'Valider\nتحقق',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
