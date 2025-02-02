import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulup/custom_widgets/custom_app_bar.dart';
import 'package:tulup/custom_widgets/custom_bottom_bar.dart';
import 'package:tulup/entity/symptome.dart';
import 'package:tulup/screens/bilan/widgets/expanded_widget/humeur_icons_slider.dart';
import 'package:tulup/shared/file_service.dart';

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
    "النشاط اليومي",
    "المزاج",
    "جودة النوم"
  ];

  int _selectedValueHumeur = 0;
  int _selectedAutonomieValue = 0;
  int _selectedSomeilValue = 1;
  double _selectedFatigueValue = 0;
  double _selectedArthralgieValue = 0;

  bool isEditing = false;
  bool canEdit = false;
  bool saved = false;

  List<bool> _selectedAutonomie = <bool>[true, false, false];
  List<bool> _selectedSommeil = <bool>[true, false, false];

  TextEditingController noteController = TextEditingController();

  /// Colors for the mood (Red → Orange → Yellow → LightGreen → Green)
  final List<Color> _moodColors = [
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.lightGreen,
    Colors.green
  ];

  bool areDatesOnSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      appBar: const CustomAppBar(
        title: "Symptômes\nالأعراض",
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Absorb user input if not editing and data is for today
                  AbsorbPointer(
                    absorbing: (!isEditing &&
                        areDatesOnSameDay(
                            latestSymptomes.data?.createdAt, DateTime.now())),
                    child: Column(
                      children: [
                        //===== FATIGUE =====
                        const TitleOfSlider(
                          titleAr: 'درجة التعب',
                          titleFr: 'La fatigue',
                        ),
                        Text(
                          _selectedFatigueValue.round().toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
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
                          label: _selectedFatigueValue.round().toString(),
                        ),

                        const SizedBox(height: 10),

                        //===== ARTHRALGIES =====
                        const TitleOfSlider(
                          titleFr: 'Les arthralgies',
                          titleAr: 'ألم مفصلي',
                        ),
                        Text(
                          _selectedArthralgieValue.round().toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
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
                          label: _selectedArthralgieValue.round().toString(),
                        ),

                        const SizedBox(height: 10),

                        //===== HUMEUR =====
                        const TitleOfSlider(
                          titleFr: "L'Humeur",
                          titleAr: 'المزاج',
                        ),
                        const SizedBox(height: 10),
                        ReviewSlider(
                          optionStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          circleDiameter: 60,
                          onChange: (index) {
                            setState(() {
                              _selectedValueHumeur = index;
                            });
                          },
                          initialValue: _selectedValueHumeur,
                          options: const [
                            'Terrible',
                            'Mauvais',
                            'Moyen',
                            'Bon',
                            'Génial'
                          ],
                          // activeColor: _moodColors[_selectedValueHumeur.clamp(0, 4)],
                        ),

                        const SizedBox(height: 20),

                        //===== AUTONOMIE =====
                        const TitleOfSlider(
                          titleFr: 'L’autonomie',
                          titleAr: 'النشاط اليومي',
                        ),
                        const SizedBox(height: 10),
                        ToggleButtons(
                          onPressed: (int index) {
                            setState(() {
                              _selectedAutonomieValue = index;
                              for (int i = 0;
                                  i < _selectedAutonomie.length;
                                  i++) {
                                _selectedAutonomie[i] = i == index;
                              }
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor:
                              getStatusColor(_selectedAutonomieValue),
                          selectedColor: Colors.white,
                          fillColor: getStatusColor(_selectedAutonomieValue),
                          color: Colors.black,
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          constraints: const BoxConstraints(
                            minHeight: 60.0,
                            minWidth: 90.0,
                          ),
                          isSelected: _selectedAutonomie,
                          children: const [
                            Text(
                              'Peu d\'activité\nنشاط قليل',
                              textAlign: TextAlign.center,
                            ),
                            Text('Intermédiaire\nنشاط وسط',
                                textAlign: TextAlign.center),
                            Text('Normale\nنشاط عادي',
                                textAlign: TextAlign.center),
                          ],
                        ),

                        const SizedBox(height: 20),

                        //===== SOMMEIL =====
                        const TitleOfSlider(
                          titleFr: 'La qualité du sommeil',
                          titleAr: 'جودة النوم',
                        ),
                        const SizedBox(height: 10),
                        ToggleButtons(
                          onPressed: (int index) {
                            setState(() {
                              _selectedSomeilValue = index;
                              for (int i = 0;
                                  i < _selectedSommeil.length;
                                  i++) {
                                _selectedSommeil[i] = i == index;
                              }
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor:
                              getStatusColor(_selectedSomeilValue),
                          selectedColor: Colors.white,
                          fillColor: getStatusColor(_selectedSomeilValue),
                          color: Colors.black,
                          constraints: const BoxConstraints(
                            minHeight: 60.0,
                            minWidth: 80.0,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          isSelected: _selectedSommeil,
                          children: const [
                            Text('Mauvaise\nسيئة', textAlign: TextAlign.center),
                            Text('Moyenne\nمتوسطة',
                                textAlign: TextAlign.center),
                            Text('Bonne\nجيدة', textAlign: TextAlign.center),
                          ],
                        ),

                        const SizedBox(height: 20),

                        //===== REMARQUES =====
                        const TitleOfSlider(
                          titleFr: 'Remarques',
                          titleAr: 'ملاحظات',
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: noteController,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 3,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  //===== BUTTONS =====
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // If not same day or we are editing => Show ENREGISTRER (green)
                      (!areDatesOnSameDay(latestSymptomes.data?.createdAt,
                                  DateTime.now()) ||
                              isEditing)
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () async {
                                DateTime now = DateTime.now();

                                var fatigue = SymptomeData(
                                  value: _selectedFatigueValue.round(),
                                  date: now,
                                );
                                var arthralgies = SymptomeData(
                                  value: _selectedArthralgieValue.round(),
                                  date: now,
                                );
                                var autonomie = SymptomeData(
                                  value: _selectedAutonomieValue,
                                  date: now,
                                );
                                var humeur = SymptomeData(
                                  value: _selectedValueHumeur,
                                  date: now,
                                );
                                var sommeil = SymptomeData(
                                  value: _selectedSomeilValue,
                                  date: now,
                                );
                                var remarksValue = noteController.text.trim();
                                var remarque = Remarque(
                                  value:
                                      remarksValue.isEmpty ? '' : remarksValue,
                                  date: now,
                                );

                                var symptome = Symptome(
                                  fatigue: fatigue,
                                  arthralgies: arthralgies,
                                  autonomie: autonomie,
                                  humeur: humeur,
                                  sommeil: sommeil,
                                  remarque: remarque,
                                  createdAt: now,
                                  updatedAt: now,
                                );

                                if (isEditing) {
                                  await FileService.updateFile("fatigue.txt",
                                      jsonEncode(fatigue.toJson()));
                                  await FileService.updateFile(
                                      "arthralgies.txt",
                                      jsonEncode(arthralgies.toJson()));
                                  await FileService.updateFile("autonomie.txt",
                                      jsonEncode(autonomie.toJson()));
                                  await FileService.updateFile("humeur.txt",
                                      jsonEncode(humeur.toJson()));
                                  await FileService.updateFile("sommeil.txt",
                                      jsonEncode(sommeil.toJson()));
                                  await FileService.updateFile("remarques.txt",
                                      jsonEncode(remarque.toJson()));
                                  await FileService.updatelatestSymptomes(
                                      symptome);
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
                                  await FileService.updatelatestSymptomes(
                                      symptome);
                                  setState(() {
                                    saved = true;
                                    isEditing = false;
                                  });
                                  // ignore: use_build_context_synchronously
                                  // AwesomeDialog(
                                  //   context: context,
                                  //   animType: AnimType.leftSlide,
                                  //   headerAnimationLoop: false,
                                  //   dialogType: DialogType.success,
                                  //   showCloseIcon: true,
                                  //   title: ' ',
                                  //   desc: 'Les données ont été modifiées avec succès \n تم تعديل المعطيات بنجاح',
                                  //   btnOkOnPress: () {
                                  //     debugPrint('OnClcik');
                                  //   },
                                  //   btnOkIcon: Icons.check_circle,
                                  //   onDismissCallback: (type) {
                                  //     debugPrint('Dialog Dissmiss from callback $type');
                                  //   },
                                  // ).show();
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
                                      value: _selectedAutonomieValue,
                                      date: now);
                                  await FileService.writeFile("autonomie.txt",
                                      jsonEncode(autonomie.toJson()));
                                  var humeur = SymptomeData(
                                      value: _selectedValueHumeur, date: now);
                                  await FileService.writeFile("humeur.txt",
                                      jsonEncode(humeur.toJson()));
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
                                  Icon(Icons.save_sharp, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text("Enregistrer  تسجيل",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            )
                          : Container(),

                      // If it's the same day and not editing => show Modifier (blue)
                      areDatesOnSameDay(latestSymptomes.data?.createdAt,
                                  DateTime.now()) &&
                              !isEditing
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditing = true;
                                });
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text("Modifier  تعديل",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            )
                          : Container(),

                      // If editing => show Annuler (red)
                      isEditing
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditing = false;
                                });
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cancel, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text("Annuler  إلغاء",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            )
                          : Container(),
                    ],
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

  Color getStatusColor(int index) {
    if (index == 0) {
      return Colors.red;
    } else if (index == 1) {
      return Colors.orange;
    } else
      return Colors.green;
  }
}

class TitleOfSlider extends StatelessWidget {
  const TitleOfSlider(
      {super.key, required this.titleFr, required this.titleAr});

  final String titleFr;
  final String titleAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            titleFr,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            titleAr,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
