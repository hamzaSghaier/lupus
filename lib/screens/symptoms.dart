import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_app/custom_widgets/custom_bottom_bar.dart';
import 'package:hospital_app/custom_widgets/custom_slider.dart';
import 'package:reviews_slider/reviews_slider.dart';
class SymptomsController extends GetxController {
  var fatigue = 0.0.obs;
  var arthralgies = 0.0.obs;
  var autonomie = 0.0.obs;
  var humeur = 0.0.obs;
  var activitePhysique = 0.0.obs;
}
class SymptomsScreen extends StatefulWidget {
  SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  final List<String> symptoms = [
    "Fatigue",
    "Arthralgies",
    "Autonomie(Vie Quotidienne)",
    "Humeur (Echelle Visages)",
    "Activité physique (nombre de pas)"
  ];

  final SymptomsController symptomsController = Get.put(SymptomsController());
  late int selectedValue1 = 1;
  late int selectedValue2 = 2;

  void onChange1(int value) {
    setState(() {
      selectedValue1 = value;
    });
  }

  void onChange2(int value) {
    setState(() {
      selectedValue2 = value;
    });
  }

  final List<bool> _selectedAutonomie = <bool>[true, false, false];
  final List<bool> _selectedSommeil = <bool>[true, false, false];

  List<Widget> autonomie = <Widget>[
    const Text('Peu d\'activité \n   نشاط قليل'),
    const Text('Intermédiaire \n  نشاط وسط'),
    const Text('Normale \n  نشاط عادي')
  ];

  List<Widget> sommeil = <Widget>[const Text('Mauvaise \n سيئة'), const Text('Moyenne \n  متوسطة'), const Text('Bonne \n  جيدة')];
  bool vertical = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const TitleOfSlider(
                  titleAr: 'درجة التعب',
                  titleFr: 'La fatigue',
                ),
                const SizedBox(height: 20),
                CustomSlider(
                  sliderName: symptoms[0],
                  sliderValue: symptomsController.fatigue.value,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const TitleOfSlider(
              titleAr: 'ألم مفصلي',
              titleFr: 'Les arthralgies',
            ),
            CustomSlider(
              sliderName: symptoms[1],
              sliderValue: symptomsController.arthralgies.value,
            ),
            const SizedBox(height: 20),
            const TitleOfSlider(
              titleAr: 'نشاط يومي',
              titleFr: 'L’autonomie',
            ),
            const SizedBox(height: 10),
            ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < _selectedAutonomie.length; i++) {
                    _selectedAutonomie[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 60.0,
                minWidth: 100.0,
              ),
              isSelected: _selectedAutonomie,
              children: autonomie,
            ),
            const SizedBox(height: 20),
            const TitleOfSlider(
              titleAr: 'المزاج',
              titleFr: 'Humeur',
            ),
            const SizedBox(height: 10),
            ReviewSlider(
                optionStyle: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
                circleDiameter: 60,
                onChange: onChange2,
                initialValue: 1,
                options: ['terrible', 'Malo', 'Bien', 'Vale', 'Genial']),
            const SizedBox(height: 20),
            const TitleOfSlider(
              titleAr: '  جودة نومك',
              titleFr: 'Sommeil',
            ),
            const SizedBox(height: 10),
            ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < _selectedSommeil.length; i++) {
                    _selectedSommeil[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 60.0,
                minWidth: 100.0,
              ),
              isSelected: _selectedSommeil,
              children: sommeil,
            ),
            Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.save_sharp,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Enregistrer  قم بتسجيل ",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                                const SizedBox(height: 40),

          ],
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
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            titleFr,
            style: TextStyle(color: Color(0xFF6f7478), fontSize: 18),
          ),
          Text(
            titleAr,
            style: TextStyle(color: Color(0xFF6f7478), fontSize: 18),
          ),
        ],
      ),
    );
  }
}
