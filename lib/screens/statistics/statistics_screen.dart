// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lupus_app/constants/colors.dart';
import 'package:lupus_app/custom_widgets/custom_bottom_bar.dart';
import 'package:lupus_app/entity/symptome.dart';
import 'package:lupus_app/shared/file_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

  final ScrollController _scrollController = ScrollController();

  Future<List<_DataModel>> getFatigue() async {
    List<SymptomeData> fatigue = await FileService.getSymptomes("fatigue.txt");
    return fatigue
        .map((e) => _DataModel(DateFormat('dd-MM-yyyy').format(e.date),
            double.parse(e.value.toString())))
        .toList();
  }

  Future<List<_DataModel>> getArthralgies() async {
    List<SymptomeData> fatigue =
        await FileService.getSymptomes("arthralgies.txt");
    return fatigue
        .map((e) => _DataModel(DateFormat('dd-MM-yyyy').format(e.date),
            double.parse(e.value.toString())))
        .toList();
  }

  Future<List<_DataModel>> getAutonomie() async {
    List<SymptomeData> fatigue =
        await FileService.getSymptomes("autonomie.txt");
    return fatigue
        .map((e) => _DataModel(DateFormat('dd-MM-yyyy').format(e.date),
            double.parse(e.value.toString())))
        .toList();
  }

  Future<List<_DataModel>> getHumeur() async {
    List<SymptomeData> fatigue = await FileService.getSymptomes("humeur.txt");
    return fatigue
        .map((e) => _DataModel(DateFormat('dd-MM-yyyy').format(e.date),
            double.parse(e.value.toString())))
        .toList();
  }

  Future<List<_DataModel>> getSommeil() async {
    List<SymptomeData> fatigue = await FileService.getSymptomes("sommeil.txt");
    return fatigue
        .map((e) => _DataModel(DateFormat('dd-MM-yyyy').format(e.date),
            double.parse(e.value.toString())))
        .toList();
  }

  Future<String> getRemarques() async {
    List<Remarque> remarques = await FileService.getRemarques();
    String textResult = "";
    for (var rq in remarques) {
      textResult += "${DateFormat('dd-MM-yyyy').format(rq.date)}\n";
      String list = "• ${rq.value.split("\n").join("\n• ")}";
      textResult += list;
      textResult += "\n__________\n";
    }
    return textResult;
  }

  List<String> autonomie = [
    'Peu d\'activité \n   نشاط قليل',
    'Intermédiaire \n  نشاط وسط',
    'Normale \n  نشاط عادي'
  ];

  List<String> sommeil = [
    'Mauvaise \n سيئة',
    'Moyenne \n  متوسطة',
    'Bonne \n  جيدة'
  ];

  List<String> humeur = ['Terrible', 'Mauvais', 'Moyen', 'Bon', 'Génial'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      // appBar: const CustomAppBar(
      //   title: 'Suivi',
      //   isLoggedIn: false,
      // ),
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
                        values: autonomie,
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
                        values: humeur,
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
                        values: sommeil,
                      );
                    } else {
                      return const Text("Pas de données disponibles !");
                    }
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              FutureBuilder(
                  future: getRemarques(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
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
                          child: Column(
                            children: [
                              const TitleOfSlider(
                                titleAr: 'ملاحظات',
                                titleFr: 'Remarques',
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              RawScrollbar(
                                thumbVisibility: true,
                                thumbColor: Colors.pink[100],
                                thickness: 3,
                                trackColor: Colors.pink[50],
                                trackVisibility: true,
                                controller: _scrollController,
                                child: TextFormField(
                                  scrollController: _scrollController,
                                  scrollPhysics: const ScrollPhysics(),
                                  controller: TextEditingController(
                                      text: snapshot.data),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                  maxLines: 10,
                                  // (("•")
                                  //         .allMatches(snapshot.data ?? "")
                                  //         .length)
                                  //     .round() +
                                  enabled: true,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
                          ));
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
  List<String>? values;

  ChartWidget({super.key, this.titleAr, this.titleFr, this.data, this.values});

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
      child: Column(
        children: [
          TitleOfSlider(
            titleAr: titleAr,
            titleFr: titleFr,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          SfCartesianChart(
            enableAxisAnimation: true,
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: NumericAxis(
              interactiveTooltip: const InteractiveTooltip(),
              desiredIntervals: values?.length ?? 10,
              labelFormat: '{value}',
              anchorRangeToVisiblePoints: true,
              maximum: values?.length.toDouble() ?? 11,
              labelAlignment: LabelAlignment.center,
              axisLabelFormatter: (AxisLabelRenderDetails details) {
                return values == null
                    ? ChartAxisLabel(details.value.toInt().toString(),
                        const TextStyle(color: Colors.black))
                    : ChartAxisLabel(values![details.value.toInt()],
                        const TextStyle(color: Colors.black));
              },
            ),
            series: <CartesianSeries>[
              AreaSeries<_DataModel, String>(
                color: pink.withAlpha(128),
                markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.diamond,
                    borderWidth: 1,
                    borderColor: pink.withAlpha(20)),
                dataSource: data,
                xValueMapper: (data, _) => data.day,
                yValueMapper: (data, _) => data.value,
              )
            ],
          ),
        ],
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
