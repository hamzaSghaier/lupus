import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/file_service.dart';

class SignupController extends GetxController {
  var isChecked = false.obs;
  var selectedDate = DateTime.now().obs;
  var profile = {
    "nom": "",
    "prenom": "",
    "numTel": "",
    "password": "",
    "dateNaissance": "",
  }.obs;

  void onChanged(bool newValue) => isChecked.value = newValue;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = DateTime(picked.year, picked.month, picked.day);
    }
  }

  Future<void> createProfile(
      String nom, String prenom, String numTel, String password) async {
    profile["nom"] = nom;
    profile["prenom"] = prenom;
    profile["numTel"] = numTel;
    profile["password"] = password;
    profile["dateNaissance"] = selectedDate.value.toString();

    await FileService.writeFile("profile.txt", profile.toString());
  }
}
