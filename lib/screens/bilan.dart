import 'package:flutter/material.dart';
import 'package:lupus_app/custom_widgets/custom_bottom_bar.dart';

class Bilan extends StatelessWidget {
  const Bilan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomBottomBar(),
        body: Center(
            child: Container(
          child: const Text("Bilan"),
        )));
  }
}
