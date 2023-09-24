import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_app/entity/profile.dart';

import '../shared/file_service.dart';

class SignupController extends GetxController {
  var isChecked = false.obs;
  var selectedDate = DateTime.now().obs;
  var profile = Profile(
          nom: "", prenom: "", dateNaissance: "", numTel: "", numDossier: "")
      .obs;

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

  Future<void> createProfile(Profile profile) async {
    try {
      final jsonProfile =
          jsonEncode(profile.toJson()); // Convert Profile to JSON string
      await FileService.writeProfileFile("profile.txt", jsonProfile);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
