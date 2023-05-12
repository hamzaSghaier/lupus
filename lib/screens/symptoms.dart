import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_app/controllers/symptoms_controller.dart';
import 'package:hospital_app/custom_widgets/custom_bottom_bar.dart';
import 'package:hospital_app/custom_widgets/custom_slider.dart';

class SymptomsScreen extends StatelessWidget {
  SymptomsScreen({super.key});

  final List<String> symptoms = [
    "Fatigue",
    "Arthralgies",
    "Autonomie(Vie Quotidienne)",
    "Humeur (Echelle Visages)",
    "Activité physique (nombre de pas)"
  ];

  final SymptomsController symptomsController = Get.put(SymptomsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       bottomNavigationBar: CustomBottomBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSlider(
              sliderName: symptoms[0],
              sliderValue: symptomsController.fatigue.value,
            ),
            CustomSlider(
              sliderName: symptoms[1],
              sliderValue: symptomsController.arthralgies.value,
            ),
            CustomSlider(
              sliderName: symptoms[2],
              sliderValue: symptomsController.autonomie.value,
            ),
            CustomSlider(
              sliderName: symptoms[3],
              sliderValue: symptomsController.humeur.value,
            ),
            CustomSlider(
              sliderName: symptoms[4],
              sliderValue: symptomsController.activitePhysique.value,
            ),
          ],
        ),
      ),
    );
  }
}
