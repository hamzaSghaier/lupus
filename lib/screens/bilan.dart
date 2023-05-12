import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hospital_app/custom_widgets/custom_bottom_bar.dart';

class Bilan extends StatelessWidget {
  const Bilan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( bottomNavigationBar: CustomBottomBar(),body :  Center(child:  Container(child: Text("Bilan"),)));
  }
}