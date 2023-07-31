// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hospital_app/constants/colors.dart';
import 'package:hospital_app/custom_widgets/custom_app_bar.dart';
import 'package:hospital_app/custom_widgets/custom_bottom_bar.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

List<_DataModel> data1 = [
  _DataModel('Lundi', 35),
  _DataModel('Mardi', 28),
  _DataModel('Mercredi', 28),
  _DataModel('Mercredi', 25),
  _DataModel('Mercredi', 21),
  _DataModel('Mercredi', 18),
];

List<_DataModel> data2 = [
  _DataModel('Lundi', 8),
  _DataModel('Mardi', 28),
  _DataModel('Mercredi', 45),
];
List<_DataModel> data3 = [
  _DataModel('Lundi', 27),
  _DataModel('Mardi', 33),
  _DataModel('Mercredi', 11),
  _DataModel('Mardi', 6),
  _DataModel('Mardi', 10),
];
List<_DataModel> data4 = [
  _DataModel('Lundi', 3),
  _DataModel('Mardi', 10),
  _DataModel('Mercredi', 22),
  _DataModel('jeudi', 12),
  _DataModel('Mercredi', 15),
  _DataModel('Mercredi', 22),
  _DataModel('Mercredi', 11),
  _DataModel('Mercredi', 32),
  _DataModel('Mercredi', 23),
  _DataModel('Mercredi', 21),
  _DataModel('Mercredi', 42),
  _DataModel('Mercredi', 11),
];
List<_DataModel> data5 = [
  _DataModel('Lundi', 1),
  _DataModel('Mardi', 4),
  _DataModel('Mercredi', 8),
];

class _DataModel {
  _DataModel(this.day, this.value);

  final String day;
  final double value;
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      appBar: const CustomAppBar(
        title: 'Suivi',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(children: [
              ChartWidget(
                titleAr: 'درجة التعب',
                titleFr: 'La fatigue',
                data: data1,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ChartWidget(
                titleAr: 'ألم مفصلي',
                titleFr: 'Les arthralgies',
                data: data2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ChartWidget(
                titleAr: 'نشاط يومي',
                titleFr: 'L’autonomie',
                data: data3,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ChartWidget(
                titleAr: 'المزاج',
                titleFr: 'Humeur',
                data: data4,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ChartWidget(
                titleAr: '  جودة نومك',
                titleFr: 'Sommeil',
                data: data5,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class ChartWidget extends StatelessWidget {
  var data, titleAr, titleFr;

  ChartWidget({super.key, this.titleAr, this.titleFr, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(
          color: const Color.fromRGBO(232, 232, 232, 1),
          width: 2,
        ),
      ),
      child: Column(children: [
        TitleOfSlider(
          titleAr: titleAr,
          titleFr: titleFr,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        SfSparkAreaChart.custom(
          color: pink.withAlpha(128),
          labelDisplayMode: SparkChartLabelDisplayMode.all,
          xValueMapper: (int index) => data[index].day,
          yValueMapper: (int index) => data[index].value,
          dataCount: data.length,
          borderColor: Colors.purple[300],
          axisLineColor: Colors.transparent,
          trackball: const SparkChartTrackball(
              activationMode: SparkChartActivationMode.longPress),
        ),
      ]),
    );
  }
}

class TitleOfSlider extends StatelessWidget {
  const TitleOfSlider({
    super.key,
    required this.titleFr,
    required this.titleAr,
  });
  final String titleFr;
  final String titleAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            titleFr,
            style: const TextStyle(
                color: Color(0xFF6f7478),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          Text(
            titleAr,
            style: const TextStyle(
                color: Color(0xFF6f7478),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
