import 'package:flutter/material.dart';
import 'package:hospital_app/custom_widgets/custom_bottom_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      body: const Center(
        child: Text('Dashboard'),
      ),
    );
  }
}
