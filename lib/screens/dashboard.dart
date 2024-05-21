import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lupus_app/custom_widgets/custom_app_bar.dart';
import 'package:lupus_app/custom_widgets/custom_bottom_bar.dart';
import 'package:lupus_app/screens/bilan/bilan_screen.dart';
import 'package:lupus_app/screens/bilan/widgets/user_info.dart';
import 'package:lupus_app/screens/medicaments.dart';
import 'package:lupus_app/screens/signup.dart';
import 'package:lupus_app/screens/symptoms.dart';

import '../entity/profile.dart';
import '../shared/file_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Profile? profile;

  Future<Profile> getProfile() async {
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

  String _calculateBirthYear() {
    String? dateOfBirth = profile?.dateNaissance;
    print("DATE OF BIRTH: $dateOfBirth");
    String ageString = "";

    if (dateOfBirth != null) {
      int yearOfBirth = int.tryParse(dateOfBirth.substring(0, 4)) ?? 0;
      DateTime now = DateTime.now();
      int currentYear = now.year;
      int age = currentYear - yearOfBirth;
      ageString = age.toString();
    }

    return ageString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      appBar: const CustomAppBar(
        title: 'Lupus Suivi',
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            UserInfo(
              mediaQuery: MediaQuery.of(context),
              name: "${profile?.nom} ${profile?.prenom}",
              gender: "",
              age: _calculateBirthYear(),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HomeButton(
                        image: 'assets/Rectangle-2.png',
                        onPressed: () {
                          Get.to(MedicamentsScreen());
                        },
                        title: 'Medicament',
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      HomeButton(
                        image: 'assets/Rectangle-3.png',
                        onPressed: () {
                          Get.to(const SymptomsScreen());
                        },
                        title: 'Symptome',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HomeButton(
                        image: 'assets/Rectangle.png',
                        onPressed: () {
                          Get.to(const BilanScreen());
                        },
                        title: 'Bilan',
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      HomeButton(
                        image: 'assets/Rectangle-1.png',
                        onPressed: () {
                          Get.to(const SignUpScreen());
                        },
                        title: 'Profil',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({
    super.key,
    required this.title,
    required this.image,
    required this.onPressed,
  });
  final String title;
  final String image;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 229, 245, 1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              width: 3, color: const Color.fromRGBO(255, 180, 252, 1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image SVG at the top
            Image.asset(
              image,
            ),
            const SizedBox(height: 10),
            // Title at the bottom
            Text(
              title,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
