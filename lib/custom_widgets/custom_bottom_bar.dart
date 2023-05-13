import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_app/screens/bilan/bilan_screen.dart';
import 'package:hospital_app/screens/dashboard.dart';
import 'package:hospital_app/screens/info_lupus.dart';
import 'package:hospital_app/screens/medicaments.dart';
import 'package:hospital_app/screens/statistics/statistics_screen.dart';
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
      style: TabStyle.reactCircle,
      activeColor: Color.fromRGBO(255, 180, 252, 0.6),
      items: const [
        TabItem(
          icon: Icon(Icons.info_outline,size: 20,color: Colors.white,),
          
        ),
        TabItem(
          icon: Icon(Icons.dashboard,size: 20,color: Colors.white,),
        ),
        TabItem(
          icon: Icon(Icons.bar_chart_outlined,size:20,color: Colors.white,),
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
          Get.to(const Statistics());
        }
      },
      backgroundColor: const Color.fromRGBO(252, 78, 130, 1),
    );
  }
}
