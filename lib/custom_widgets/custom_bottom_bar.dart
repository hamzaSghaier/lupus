import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lupus_app/constants/colors.dart';
import 'package:lupus_app/screens/dashboard.dart';
import 'package:lupus_app/screens/info_lupus.dart';
import 'package:lupus_app/screens/statistics/suivi_screen.dart';

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
      style: TabStyle.reactCircle,
      activeColor: seedColor,
      items: const [
        TabItem(
          icon: Icon(
            Icons.info_outline,
            size: 20,
            color: Colors.white,
          ),
        ),
        TabItem(
          icon: Icon(
            Icons.dashboard,
            size: 20,
            color: Colors.white,
          ),
        ),
        TabItem(
          icon: Icon(
            Icons.bar_chart_outlined,
            size: 20,
            color: Colors.white,
          ),
        ),
      ],
      initialActiveIndex: bottomNavigationBarController.selectedIndex.value,
      onTap: (index) {
        bottomNavigationBarController.selectedIndex.value = index;

        if (bottomNavigationBarController.selectedIndex.value == 1) {
          Get.to(const DashboardScreen());
        } else if (bottomNavigationBarController.selectedIndex.value == 0) {
          Get.to(const InfoLupusScreen());
        } else if (bottomNavigationBarController.selectedIndex.value == 2) {
          Get.to(const SuiviScreen());
        }
      },
      backgroundColor: seedColor.withOpacity(0.5),
    );
  }
}
