// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lupus_app/constants/colors.dart';
import 'package:lupus_app/custom_widgets/custom_app_bar.dart';
import 'package:lupus_app/custom_widgets/custom_bottom_bar.dart';
import 'package:lupus_app/entity/symptome.dart';
import 'package:lupus_app/shared/file_service.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _DataModel {
  _DataModel(this.day, this.value);

  final String day;
  final double value;
}

class _StatisticsState extends State<Statistics> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<_DataModel>> getFatigue() async {
    List<SymptomeData> fatigue = await FileService.getBilans("fatigue.txt");
    return fatigue
        .map((e) => _DataModel(
            e.date.toIso8601String(), double.parse(e.value.toString())))
        .toList();
  }

  Future<List<_DataModel>> getArthralgies() async {
    List<SymptomeData> fatigue = await FileService.getBilans("arthralgies.txt");
    return fatigue
        .map((e) => _DataModel(
            e.date.toIso8601String(), double.parse(e.value.toString())))
        .toList();
  }

  Future<List<_DataModel>> getAutonomie() async {
    List<SymptomeData> fatigue = await FileService.getBilans("autonomie.txt");
    return fatigue
        .map((e) => _DataModel(
            e.date.toIso8601String(), double.parse(e.value.toString())))
        .toList();
  }

  Future<List<_DataModel>> getHumeur() async {
    List<SymptomeData> fatigue = await FileService.getBilans("humeur.txt");
    return fatigue
        .map((e) => _DataModel(
            e.date.toIso8601String(), double.parse(e.value.toString())))
        .toList();
  }

  Future<List<_DataModel>> getSommeil() async {
    List<SymptomeData> fatigue = await FileService.getBilans("sommeil.txt");
    return fatigue
        .map((e) => _DataModel(
            e.date.toIso8601String(), double.parse(e.value.toString())))
        .toList();
  }

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
              FutureBuilder(
                  future: getFatigue(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ChartWidget(
                        titleAr: 'درجة التعب',
                        titleFr: 'La fatigue',
                        data: snapshot.data,
                      );
                    } else {
                      return const Center(
                          child: Text(
                        "Pas de données disponibles !",
                      ));
                    }
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              FutureBuilder(
                  future: getArthralgies(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ChartWidget(
                        titleAr: 'ألم مفصلي',
                        titleFr: 'Les arthralgies',
                        data: snapshot.data,
                      );
                    } else {
                      return const Text("Pas de données disponibles !");
                    }
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              FutureBuilder(
                  future: getAutonomie(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ChartWidget(
                        titleAr: 'نشاط يومي',
                        titleFr: 'L’autonomie',
                        data: snapshot.data,
                      );
                    } else {
                      return const Text("Pas de données disponibles !");
                    }
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              FutureBuilder(
                  future: getHumeur(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ChartWidget(
                        titleAr: 'المزاج',
                        titleFr: 'Humeur',
                        data: snapshot.data,
                      );
                    } else {
                      return const Text("Pas de données disponibles !");
                    }
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              FutureBuilder(
                  future: getSommeil(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ChartWidget(
                        titleAr: '  جودة نومك',
                        titleFr: 'Sommeil',
                        data: snapshot.data,
                      );
                    } else {
                      return const Text("Pas de données disponibles !");
                    }
                  }),
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
