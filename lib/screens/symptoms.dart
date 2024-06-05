import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lupus_app/custom_widgets/custom_app_bar.dart';
import 'package:lupus_app/custom_widgets/custom_bottom_bar.dart';
import 'package:lupus_app/entity/symptome.dart';
import 'package:lupus_app/shared/file_service.dart';
import 'package:reviews_slider/reviews_slider.dart';

class SymptomsController extends GetxController {
  var fatigue = 0.0.obs;
  var arthralgies = 0.0.obs;
  var autonomie = 0.0.obs;
  var humeur = 0.0.obs;
  var activitePhysique = 0.0.obs;
}

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

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

  // late int selectedValue1 = 1;
  int _selectedValueHumeur = 0;
  int _selectedAutonomieValue = 0;
  int _selectedSomeilValue = 1;
  double _selectedFatigueValue = 0;
  double _selectedArthralgieValue = 0;
  bool isEditing = false;
  bool canEdit = false;
  bool saved = false;
  // void onChange1(int value) {
  //   setState(() {
  //     selectedValue1 = value;
  //   });
  // }

  void onChange2(int value) {
    setState(() {
      _selectedValueHumeur = value;
    });
  }

  List<bool> _selectedAutonomie = <bool>[true, false, false];
  List<bool> _selectedSommeil = <bool>[true, false, false];
  TextEditingController noteController = TextEditingController();
  List<Widget> autonomie = <Widget>[
    const Text('Peu d\'activité \n   نشاط قليل', textAlign: TextAlign.center),
    const Text('Intermédiaire \n  نشاط وسط', textAlign: TextAlign.center),
    const Text('Normale \n  نشاط عادي', textAlign: TextAlign.center)
  ];

  List<Widget> sommeil = <Widget>[
    const Text(
      'Mauvaise \n سيئة',
      textAlign: TextAlign.center,
    ),
    const Text('Moyenne \n  متوسطة', textAlign: TextAlign.center),
    const Text('Bonne \n  جيدة', textAlign: TextAlign.center)
  ];

  late ThemeData theme;
  bool vertical = false;

  bool areDatesOnSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      appBar: const CustomAppBar(
        title: "Symptômes",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FutureBuilder(
            future: FileService.getlatestSymptomes(),
            builder: (context, latestSymptomes) {
              if (latestSymptomes.hasData &&
                  !isEditing &&
                  areDatesOnSameDay(
                      latestSymptomes.data?.createdAt, DateTime.now())) {
                _selectedValueHumeur = latestSymptomes.data?.humeur.value ?? 0;
                _selectedAutonomieValue =
                    latestSymptomes.data?.autonomie.value ?? 0;
                _selectedSomeilValue = latestSymptomes.data?.sommeil.value ?? 1;
                _selectedFatigueValue =
                    latestSymptomes.data?.fatigue.value.toDouble() ?? 0;
                _selectedArthralgieValue =
                    latestSymptomes.data?.arthralgies.value.toDouble() ?? 0;

                _selectedAutonomie = [false, false, false];
                _selectedAutonomie[_selectedAutonomieValue] = true;

                _selectedSommeil = [false, false, false];
                _selectedSommeil[_selectedSomeilValue] = true;

                noteController.text =
                    latestSymptomes.data?.remarque.value ?? "";
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AbsorbPointer(
                    absorbing: !isEditing &&
                        areDatesOnSameDay(
                            latestSymptomes.data?.createdAt, DateTime.now()),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const TitleOfSlider(
                              titleAr: 'درجة التعب',
                              titleFr: 'La fatigue',
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                Slider(
                                  value: _selectedFatigueValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedFatigueValue = value;
                                    });
                                  },
                                  min: 0,
                                  max: 10,
                                  divisions: 10,
                                  label:
                                      _selectedFatigueValue.round().toString(),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                            // CustomSlider(
                            //   sliderName: symptoms[0],
                            //   sliderValue: _selectedFatigueValue,
                            // ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        const TitleOfSlider(
                          titleAr: 'ألم مفصلي',
                          titleFr: 'Les arthralgies',
                        ),
                        Column(
                          children: [
                            Slider(
                              value: _selectedArthralgieValue,
                              onChanged: (value) {
                                setState(() {
                                  _selectedArthralgieValue = value;
                                });
                              },
                              min: 0,
                              max: 10,
                              divisions: 10,
                              label:
                                  _selectedArthralgieValue.round().toString(),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        // CustomSlider(
                        //   sliderName: symptoms[1],
                        //   sliderValue: _selectedArthralgieValue,
                        // ),
                        const SizedBox(height: 10),
                        const TitleOfSlider(
                          titleAr: 'المزاج',
                          titleFr: 'Humeur',
                        ),
                        const SizedBox(height: 10),
                        ReviewSlider(
                            optionStyle: const TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            circleDiameter: 60,
                            onChange: onChange2,
                            initialValue: _selectedValueHumeur,
                            options: const [
                              'Terrible',
                              'Mauvais',
                              'Moyen',
                              'Bon',
                              'Génial'
                            ]),
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
                              _selectedAutonomieValue = index;
                              for (int i = 0;
                                  i < _selectedAutonomie.length;
                                  i++) {
                                _selectedAutonomie[i] = i == index;
                              }
                            });
                          },
                          textStyle: theme.textTheme.headlineSmall,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
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
                          titleAr: '  جودة نومك',
                          titleFr: 'Sommeil',
                        ),
                        const SizedBox(height: 10),
                        ToggleButtons(
                          direction: vertical ? Axis.vertical : Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              // The button that is tapped is set to true, and the others to false.
                              _selectedSomeilValue = index;
                              for (int i = 0;
                                  i < _selectedSommeil.length;
                                  i++) {
                                _selectedSommeil[i] = i == index;
                              }
                            });
                          },
                          textStyle: theme.textTheme.headlineSmall,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
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

                        const SizedBox(height: 20),
                        const TitleOfSlider(
                          titleAr: 'ملاحظات',
                          titleFr: 'Remarques',
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: noteController,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 3,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        )
                      ],
                    ),
                  ),
                  (!areDatesOnSameDay(latestSymptomes.data?.createdAt,
                              DateTime.now()) ||
                          isEditing)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            onPressed: () async {
                              if (isEditing) {
                                DateTime now = DateTime.now();

                                var fatigue = SymptomeData(
                                    value: _selectedFatigueValue.round(),
                                    date: now);
                                await FileService.updateFile("fatigue.txt",
                                    jsonEncode(fatigue.toJson()));
                                var arthralgies = SymptomeData(
                                    value: _selectedArthralgieValue.round(),
                                    date: now);
                                await FileService.updateFile("arthralgies.txt",
                                    jsonEncode(arthralgies.toJson()));
                                var autonomie = SymptomeData(
                                    value: _selectedAutonomieValue, date: now);
                                await FileService.updateFile("autonomie.txt",
                                    jsonEncode(autonomie.toJson()));
                                var humeur = SymptomeData(
                                    value: _selectedValueHumeur, date: now);
                                await FileService.updateFile(
                                    "humeur.txt", jsonEncode(humeur.toJson()));
                                var sommeil = SymptomeData(
                                    value: _selectedSomeilValue, date: now);
                                await FileService.updateFile("sommeil.txt",
                                    jsonEncode(sommeil.toJson()));

                                var remarque = Remarque(
                                    value: noteController.text, date: now);
                                await FileService.updateFile("remarques.txt",
                                    jsonEncode(remarque.toJson()));

                                var symptome = Symptome(
                                    fatigue: fatigue,
                                    arthralgies: arthralgies,
                                    autonomie: autonomie,
                                    humeur: humeur,
                                    sommeil: sommeil,
                                    remarque: remarque,
                                    createdAt: now,
                                    updatedAt: now);

                                await FileService.updatelatestSymptomes(
                                    symptome);
                                setState(() {
                                  saved = true;
                                  isEditing = false;
                                });
                                // ignore: use_build_context_synchronously
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.leftSlide,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.success,
                                  showCloseIcon: true,
                                  title: ' ',
                                  desc:
                                      'Les données ont été modifiées avec succès \n تم تعديل المعطيات بنجاح',
                                  btnOkOnPress: () {
                                    debugPrint('OnClcik');
                                  },
                                  btnOkIcon: Icons.check_circle,
                                  onDismissCallback: (type) {
                                    debugPrint(
                                        'Dialog Dissmiss from callback $type');
                                  },
                                ).show();
                              } else {
                                DateTime now = DateTime.now();

                                var fatigue = SymptomeData(
                                    value: _selectedFatigueValue.round(),
                                    date: now);
                                await FileService.writeFile("fatigue.txt",
                                    jsonEncode(fatigue.toJson()));
                                var arthralgies = SymptomeData(
                                    value: _selectedArthralgieValue.round(),
                                    date: now);
                                await FileService.writeFile("arthralgies.txt",
                                    jsonEncode(arthralgies.toJson()));
                                var autonomie = SymptomeData(
                                    value: _selectedAutonomieValue, date: now);
                                await FileService.writeFile("autonomie.txt",
                                    jsonEncode(autonomie.toJson()));
                                var humeur = SymptomeData(
                                    value: _selectedValueHumeur, date: now);
                                await FileService.writeFile(
                                    "humeur.txt", jsonEncode(humeur.toJson()));
                                var sommeil = SymptomeData(
                                    value: _selectedSomeilValue, date: now);
                                await FileService.writeFile("sommeil.txt",
                                    jsonEncode(sommeil.toJson()));
                                var remarque = Remarque(
                                    value: noteController.text, date: now);
                                await FileService.writeFile("remarques.txt",
                                    jsonEncode(remarque.toJson()));

                                var symptome = Symptome(
                                    fatigue: fatigue,
                                    arthralgies: arthralgies,
                                    autonomie: autonomie,
                                    humeur: humeur,
                                    sommeil: sommeil,
                                    remarque: remarque,
                                    createdAt: now,
                                    updatedAt: now);
                                FileService.writeFile("symptomes_log.txt",
                                    jsonEncode(symptome.toJson()));
                                setState(() {
                                  saved = true;
                                  canEdit = true;
                                });
                                // ignore: use_build_context_synchronously
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.leftSlide,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.success,
                                  showCloseIcon: true,
                                  title: ' ',
                                  desc:
                                      'Les données ont été enregistrées avec succès \n تم تسجيل المعطيات بنجاح',
                                  btnOkOnPress: () {},
                                  btnOkIcon: Icons.check_circle,
                                  onDismissCallback: (type) {
                                    debugPrint(
                                        'Dialog Dissmiss from callback $type');
                                  },
                                ).show();
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            onPressed: () async {
                              setState(() {
                                isEditing = true;
                              });
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Modifier  قم بالتعديل ",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                  const SizedBox(height: 50),
                ],
              );
            },
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            titleFr,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          Text(
            titleAr,
            style: const TextStyle(color: Colors.black, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
