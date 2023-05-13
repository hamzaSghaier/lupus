import 'package:flutter/material.dart';
import 'package:hospital_app/constants/colors.dart';
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
  _DataModel('Mercredi', 12),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(children: [
              const TitleOfSlider(
                titleAr: 'درجة التعب',
                titleFr: 'La fatigue',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SfSparkBarChart.custom(
                color: pink,
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => data1[index].day,
                yValueMapper: (int index) => data1[index].value,
                dataCount: data1.length,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              const TitleOfSlider(
                titleAr: 'ألم مفصلي',
                titleFr: 'Les arthralgies',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SfSparkBarChart.custom(
                color: pink,
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => data2[index].day,
                yValueMapper: (int index) => data2[index].value,
                dataCount: data2.length,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              const TitleOfSlider(
                titleAr: 'نشاط يومي',
                titleFr: 'L’autonomie',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SfSparkBarChart.custom(
                color: pink,
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => data3[index].day,
                yValueMapper: (int index) => data3[index].value,
                dataCount: data3.length,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              const TitleOfSlider(
                titleAr: 'المزاج',
                titleFr: 'Humeur',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SfSparkBarChart.custom(
                color: pink,
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => data4[index].day,
                yValueMapper: (int index) => data4[index].value,
                dataCount: data4.length,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              const TitleOfSlider(
                titleAr: '  جودة نومك',
                titleFr: 'Sommeil',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SfSparkBarChart.custom(
                color: pink,
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => data5[index].day,
                yValueMapper: (int index) => data5[index].value,
                dataCount: data5.length,
              ),
            ]),
          ),
        ),
      ),
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
