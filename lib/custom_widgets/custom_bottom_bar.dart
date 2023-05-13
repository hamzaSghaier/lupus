import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_app/screens/bilan/bilan_screen.dart';
import 'package:hospital_app/screens/dashboard.dart';
import 'package:hospital_app/screens/medicaments.dart';
import 'package:hospital_app/screens/symptoms.dart';

import '../controllers/bottom_navigation_bar_controller.dart';

class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({
    super.key,
  });

  final bottomNavigationBarController =
      Get.put(BottomNavigationBarController());

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      style: TabStyle.fixed,
      items: const [
        TabItem(
          icon: Icons.menu,
        ),
        TabItem(
          icon: Icons.dashboard,
        ),
        TabItem(
          icon: Icons.fastfood_sharp,
        ),
      ],
      initialActiveIndex: bottomNavigationBarController.selectedIndex.value,
      onTap: (index) {
        bottomNavigationBarController.selectedIndex.value = index;

        if (bottomNavigationBarController.selectedIndex.value == 1) {
          Get.to(const DashboardScreen());
        } else if (bottomNavigationBarController.selectedIndex.value == 0) {
          Get.to(SymptomsScreen());
        } else if (bottomNavigationBarController.selectedIndex.value == 2) {
          Get.to(const BilanScreen());
        }
      },
      backgroundColor: const Color.fromRGBO(252, 78, 130, 1),
    );
  }
}
