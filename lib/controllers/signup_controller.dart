import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunlup/entity/profile.dart';

import '../shared/file_service.dart';

class SignupController extends GetxController {
  var isChecked = false.obs;
  var selectedDate = DateTime.now().obs;
  var profile = Profile(
          isLoggedIn: false,
          password: "",
          nom: "",
          prenom: "",
          dateNaissance: "",
          numTel: "",
          doctor: "",
          numDossier: "")
      .obs;

  void onChanged(bool newValue) => isChecked.value = newValue;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            textTheme: const TextTheme(
              headlineMedium: TextStyle(fontSize: 15.0), // Selected date text
              titleMedium: TextStyle(fontSize: 16.0), // Calendar header text
              bodyMedium: TextStyle(fontSize: 14.0), // Calendar days
            ),
          ),
          child: child!,
        );
      },
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
