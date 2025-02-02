// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  CustomSlider(
      {super.key, required this.sliderName, required this.sliderValue});

  final String sliderName;
  double sliderValue;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: widget.sliderValue,
          onChanged: (value) {
            setState(() {
              widget.sliderValue = value;
            });
          },
          min: 0,
          max: 5,
          divisions: 5,
          label: widget.sliderValue.round().toString(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
