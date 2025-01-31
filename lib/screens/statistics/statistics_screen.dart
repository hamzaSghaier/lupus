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
  final ScrollController _scrollController = ScrollController();
  String selectedChart = 'fatigue'; // Default selected chart

  // Chart visibility states
  Map<String, bool> chartVisibility = {
    'fatigue': true,
    'arthralgies': false,
    'humeur': false,
    'autonomie': false,
    'sommeil': false,
  };

  @override
  void initState() {
    super.initState();
  }

  void toggleChart(String chartName) {
    setState(() {
      chartVisibility.forEach((key, value) {
        chartVisibility[key] = key == chartName;
      });
      selectedChart = chartName;
    });
  }

  Future<List<_DataModel>> getChartData(String filename) async {
    List<SymptomeData> data = await FileService.getSymptomes("$filename.txt");
    return data.where((e) => e.value.toString().isNotEmpty).map((e) {
      // Parse and validate the value
      double value;
      try {
        value = double.parse(e.value.toString());

        // Clamp values based on the chart type
        if (filename == 'humeur') {
          value = value.clamp(0, 4); // 5 values (0 to 4)
        } else if (filename == 'autonomie' || filename == 'sommeil') {
          value = value.clamp(0, 2); // 3 values (0 to 2)
        } else {
          value = value.clamp(0, 10); // Default range for other charts
        }
      } catch (e) {
        value = 0; // Default value if parsing fails
      }

      return _DataModel(DateFormat('dd-MM-yyyy').format(e.date), value);
    }).toList();
  }

  Future<String> getRemarques() async {
    List<Remarque> remarques = await FileService.getRemarques();
    String textResult = "";
    for (var rq in remarques) {
      if (rq.value.isNotEmpty) textResult += "${DateFormat('dd-MM-yyyy').format(rq.date)}\n";
      String list = (rq.value.isEmpty || rq.value.trim() == "") ? "" : "• ${rq.value.split("\n").join("\n• ")}";
      textResult += list;
      if (rq.value.isNotEmpty) textResult += "\n__________\n";
    }
    return textResult;
  }

  List<String> autonomie = ['Peu d\'activité \n   نشاط قليل', 'Intermédiaire \n  نشاط وسط', 'Normale \n  نشاط عادي'];
  List<String> sommeil = ['Mauvaise \n سيئة', 'Moyenne \n  متوسطة', 'Bonne \n  جيدة'];
  List<String> humeur = ['Terrible', 'Mauvais', 'Moyen', 'Bon', 'Génial'];

  Widget buildChartButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChartButton(
            title: 'La fatigue',
            titleAr: 'درجة التعب',
            isSelected: selectedChart == 'fatigue',
            onTap: () => toggleChart('fatigue'),
          ),
          ChartButton(
            title: 'Les arthralgies',
            titleAr: 'ألم مفصلي',
            isSelected: selectedChart == 'arthralgies',
            onTap: () => toggleChart('arthralgies'),
          ),
          ChartButton(
            title: 'Humeur',
            titleAr: 'المزاج',
            isSelected: selectedChart == 'humeur',
            onTap: () => toggleChart('humeur'),
          ),
          ChartButton(
            title: 'L\'autonomie',
            titleAr: 'نشاط يومي',
            isSelected: selectedChart == 'autonomie',
            onTap: () => toggleChart('autonomie'),
          ),
          ChartButton(
            title: 'Sommeil',
            titleAr: 'جودة نومك',
            isSelected: selectedChart == 'sommeil',
            onTap: () => toggleChart('sommeil'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              children: [
                buildChartButtons(),
                const SizedBox(height: 20),
                if (chartVisibility['fatigue']!)
                  FutureBuilder(
                    future: getChartData('fatigue'),
                    builder: (context, snapshot) => buildChart(
                      snapshot,
                      'درجة التعب',
                      'La fatigue',
                    ),
                  ),
                if (chartVisibility['arthralgies']!)
                  FutureBuilder(
                    future: getChartData('arthralgies'),
                    builder: (context, snapshot) => buildChart(
                      snapshot,
                      'ألم مفصلي',
                      'Les arthralgies',
                    ),
                  ),
                if (chartVisibility['humeur']!)
                  FutureBuilder(
                    future: getChartData('humeur'),
                    builder: (context, snapshot) => buildChart(
                      snapshot,
                      'المزاج',
                      'Humeur',
                      values: humeur,
                    ),
                  ),
                if (chartVisibility['autonomie']!)
                  FutureBuilder(
                    future: getChartData('autonomie'),
                    builder: (context, snapshot) => buildChart(
                      snapshot,
                      'نشاط يومي',
                      'L\'autonomie',
                      values: autonomie,
                    ),
                  ),
                if (chartVisibility['sommeil']!)
                  FutureBuilder(
                    future: getChartData('sommeil'),
                    builder: (context, snapshot) => buildChart(
                      snapshot,
                      'جودة نومك',
                      'Sommeil',
                      values: sommeil,
                    ),
                  ),
                const SizedBox(height: 20),
                buildRemarquesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChart(AsyncSnapshot snapshot, String titleAr, String titleFr, {List<String>? values}) {
    if (!snapshot.hasData) {
      return const Center(
        child: Text("Pas de données disponibles !"),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromRGBO(232, 232, 232, 1),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          TitleOfSlider(
            titleAr: titleAr,
            titleFr: titleFr,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: SfCartesianChart(
              margin: const EdgeInsets.all(0),
              enableAxisAnimation: true,
              primaryXAxis: CategoryAxis(
                labelRotation: 45,
                labelStyle: const TextStyle(fontSize: 10),
                interval: 1,
                maximumLabels: 31,
              ),
              primaryYAxis: NumericAxis(
                interval: 1,
                minimum: 0,
                maximum: values != null ? (values.length - 1).toDouble() : 10,
                labelStyle: const TextStyle(fontSize: 10),
                axisLabelFormatter: (AxisLabelRenderDetails details) {
                  return values == null
                      ? ChartAxisLabel(
                          details.value.toInt().toString(),
                          const TextStyle(fontSize: 10),
                        )
                      : ChartAxisLabel(
                          values[details.value.toInt()],
                          const TextStyle(fontSize: 10),
                        );
                },
              ),
              series: <CartesianSeries>[
                LineSeries<_DataModel, String>(
                  color: pink,
                  dataSource: snapshot.data,
                  xValueMapper: (data, _) => data.day,
                  yValueMapper: (data, _) => data.value,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 6,
                    width: 6,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRemarquesSection() {
    return FutureBuilder(
      future: getRemarques(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("Pas de données disponibles !");
        }
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromRGBO(232, 232, 232, 1),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              const TitleOfSlider(
                titleAr: 'ملاحظات',
                titleFr: 'Remarques',
              ),
              const SizedBox(height: 12),
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
                  controller: TextEditingController(text: snapshot.data.toString()),
                  style: const TextStyle(fontSize: 14),
                  maxLines: 10,
                  enabled: true,
                  readOnly: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChartButton extends StatelessWidget {
  final String title;
  final String titleAr;
  final bool isSelected;
  final VoidCallback onTap;

  const ChartButton({
    required this.title,
    required this.titleAr,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? pink : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          "$title \n $titleAr",
          style: const TextStyle(fontSize: 12),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          titleFr,
          style: const TextStyle(
            color: Color(0xFF6f7478),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          titleAr,
          style: const TextStyle(
            color: Color(0xFF6f7478),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
