import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lupus_app/custom_widgets/custom_app_bar.dart';
import 'package:lupus_app/custom_widgets/custom_bottom_bar.dart';
import 'package:lupus_app/entity/symptome.dart';
import 'package:lupus_app/shared/file_service.dart';
import 'package:reviews_slider/reviews_slider.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  int _selectedValueHumeur = 0;
  int _selectedAutonomieValue = 0;
  int _selectedSomeilValue = 1;
  double _selectedFatigueValue = 0;
  double _selectedArthralgieValue = 0;
  bool isEditing = false;
  bool canEdit = false;
  bool saved = false;

  // Store initial values for cancel functionality
  double _initialFatigueValue = 0;
  double _initialArthralgieValue = 0;
  int _initialHumeurValue = 0;
  int _initialAutonomieValue = 0;
  int _initialSommeilValue = 1;
  String _initialNote = '';

  void onChange2(int value) {
    setState(() {
      _selectedValueHumeur = value;
    });
  }

  List<bool> _selectedAutonomie = <bool>[true, false, false];
  List<bool> _selectedSommeil = <bool>[true, false, false];
  TextEditingController noteController = TextEditingController();

  // Updated translations
  final List<Widget> autonomie = const <Widget>[
    Text('Peu d\'activité\nنشاط قليل', textAlign: TextAlign.center),
    Text('Intermédiaire\nنشاط وسط', textAlign: TextAlign.center),
    Text('Normale\nنشاط عادي', textAlign: TextAlign.center)
  ];

  final List<Widget> sommeil = const <Widget>[
    Text('Mauvaise\nسيئة', textAlign: TextAlign.center),
    Text('Moyenne\nمتوسطة', textAlign: TextAlign.center),
    Text('Bonne\nجيدة', textAlign: TextAlign.center)
  ];

  void storeInitialValues() {
    _initialFatigueValue = _selectedFatigueValue;
    _initialArthralgieValue = _selectedArthralgieValue;
    _initialHumeurValue = _selectedValueHumeur;
    _initialAutonomieValue = _selectedAutonomieValue;
    _initialSommeilValue = _selectedSomeilValue;
    _initialNote = noteController.text;
  }

  void restoreInitialValues() {
    setState(() {
      _selectedFatigueValue = _initialFatigueValue;
      _selectedArthralgieValue = _initialArthralgieValue;
      _selectedValueHumeur = _initialHumeurValue;
      _selectedAutonomieValue = _initialAutonomieValue;
      _selectedSomeilValue = _initialSommeilValue;
      noteController.text = _initialNote;

      _selectedAutonomie = [false, false, false];
      _selectedAutonomie[_initialAutonomieValue] = true;

      _selectedSommeil = [false, false, false];
      _selectedSommeil[_initialSommeilValue] = true;

      isEditing = false;
    });
  }

  bool areDatesOnSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  Widget _buildSlider({
    required String title,
    required String titleAr,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        TitleOfSlider(titleFr: title, titleAr: titleAr),
        const SizedBox(height: 10),
        Stack(
          alignment: Alignment.center,
          children: [
            Slider(
              value: value,
              onChanged: onChanged,
              min: 0,
              max: 10,
              divisions: 10,
              label: value.round().toString(),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  value.round().toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool canEdit) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final buttonHeight = isSmallScreen ? 50.0 : 60.0;
    final fontSize = isSmallScreen ? 16.0 : 18.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          if (!isEditing && canEdit)
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isEditing = true;
                    storeInitialValues();
                  });
                },
                label: Text(
                  "Modifier | تعديل",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          if (isEditing || !canEdit)
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: buttonHeight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => _handleSave(context),
                    label: Text(
                      "Enregistrer | تسجيل",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                ),
                if (isEditing) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: restoreInitialValues,
                      label: Text(
                        "Annuler | إلغاء",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    try {
      DateTime now = DateTime.now();

      // Create all symptom data objects
      var fatigue = SymptomeData(value: _selectedFatigueValue.round(), date: now);
      var arthralgies = SymptomeData(value: _selectedArthralgieValue.round(), date: now);
      var autonomie = SymptomeData(value: _selectedAutonomieValue, date: now);
      var humeur = SymptomeData(value: _selectedValueHumeur, date: now);
      var sommeil = SymptomeData(value: _selectedSomeilValue, date: now);
      var remarque = Remarque(value: noteController.text.trim(), date: now);

      // Create complete symptom object
      var symptome = Symptome(
          fatigue: fatigue,
          arthralgies: arthralgies,
          autonomie: autonomie,
          humeur: humeur,
          sommeil: sommeil,
          remarque: remarque,
          createdAt: now,
          updatedAt: now);

      // Save all data
      if (isEditing) {
        await Future.wait([
          FileService.updateFile("fatigue.txt", jsonEncode(fatigue.toJson())),
          FileService.updateFile("arthralgies.txt", jsonEncode(arthralgies.toJson())),
          FileService.updateFile("autonomie.txt", jsonEncode(autonomie.toJson())),
          FileService.updateFile("humeur.txt", jsonEncode(humeur.toJson())),
          FileService.updateFile("sommeil.txt", jsonEncode(sommeil.toJson())),
          FileService.updateFile("remarques.txt", jsonEncode(remarque.toJson())),
          FileService.updatelatestSymptomes(symptome),
        ]);
      } else {
        await Future.wait([
          FileService.writeFile("fatigue.txt", jsonEncode(fatigue.toJson())),
          FileService.writeFile("arthralgies.txt", jsonEncode(arthralgies.toJson())),
          FileService.writeFile("autonomie.txt", jsonEncode(autonomie.toJson())),
          FileService.writeFile("humeur.txt", jsonEncode(humeur.toJson())),
          FileService.writeFile("sommeil.txt", jsonEncode(sommeil.toJson())),
          FileService.writeFile("remarques.txt", jsonEncode(remarque.toJson())),
          FileService.writeFile("symptomes_log.txt", jsonEncode(symptome.toJson())),
        ]);
      }

      setState(() {
        saved = true;
        canEdit = true;
        isEditing = false;
      });

      if (!context.mounted) return;

      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        showCloseIcon: true,
        title: ' ',
        desc: isEditing
            ? 'Les données ont été modifiées avec succès \n تم تعديل المعطيات بنجاح'
            : 'Les données ont été enregistrées avec succès \n تم تسجيل المعطيات بنجاح',
        btnOkOnPress: () {},
        btnOkIcon: Icons.check_circle,
      ).show();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final humeurColors = [
      Colors.red, // Terrible
      Colors.orange, // Mauvais
      Colors.yellow, // Moyen
      Colors.lightGreen, // Bon
      Colors.green, // Génial
    ];

    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      appBar: const CustomAppBar(
        title: "Symptômes\nالأعراض",
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: FutureBuilder(
              future: FileService.getlatestSymptomes(),
              builder: (context, latestSymptomes) {
                if (latestSymptomes.hasData && !isEditing && areDatesOnSameDay(latestSymptomes.data?.createdAt, DateTime.now())) {
                  // Update values from saved data
                  _selectedValueHumeur = latestSymptomes.data?.humeur.value ?? 0;
                  _selectedAutonomieValue = latestSymptomes.data?.autonomie.value ?? 0;
                  _selectedSomeilValue = latestSymptomes.data?.sommeil.value ?? 1;
                  _selectedFatigueValue = latestSymptomes.data?.fatigue.value.toDouble() ?? 0;
                  _selectedArthralgieValue = latestSymptomes.data?.arthralgies.value.toDouble() ?? 0;

                  _selectedAutonomie = [false, false, false];
                  _selectedAutonomie[_selectedAutonomieValue] = true;

                  _selectedSommeil = [false, false, false];
                  _selectedSommeil[_selectedSomeilValue] = true;

                  noteController.text = latestSymptomes.data?.remarque.value ?? "";
                }

                return AbsorbPointer(
                  absorbing: !isEditing && areDatesOnSameDay(latestSymptomes.data?.createdAt, DateTime.now()),
                  child: Column(
                    children: [
                      _buildSlider(
                        title: "La fatigue",
                        titleAr: "درجة التعب",
                        value: _selectedFatigueValue,
                        onChanged: (value) {
                          setState(() => _selectedFatigueValue = value);
                        },
                      ),
                      _buildSlider(
                        title: "Les arthralgies",
                        titleAr: "ألم مفصلي",
                        value: _selectedArthralgieValue,
                        onChanged: (value) {
                          setState(() => _selectedArthralgieValue = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      const TitleOfSlider(
                        titleFr: "L'humeur",
                        titleAr: "المزاج",
                      ),
                      const SizedBox(height: 10),
                      Theme(
                        data: Theme.of(context).copyWith(
                          sliderTheme: SliderThemeData(
                            activeTrackColor: Colors.green,
                            inactiveTrackColor: Colors.grey[300],
                            thumbColor: [
                              Colors.red,
                              Colors.orange,
                              Colors.yellow,
                              Colors.lightGreen,
                              Colors.green,
                            ][_selectedValueHumeur],
                          ),
                        ),
                        child: ReviewSlider(
                          optionStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 10 : 12,
                          ),
                          circleDiameter: isSmallScreen ? 40 : 50,
                          onChange: onChange2,
                          initialValue: _selectedValueHumeur,
                          options: const ['Terrible', 'Mauvais', 'Moyen', 'Bon', 'Génial'],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const TitleOfSlider(
                        titleFr: "L'autonomie",
                        titleAr: "النشاط اليومي",
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ToggleButtons(
                          direction: Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              _selectedAutonomieValue = index;
                              for (int i = 0; i < _selectedAutonomie.length; i++) {
                                _selectedAutonomie[i] = i == index;
                              }
                            });
                          },
                          textStyle: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          selectedBorderColor: Colors.red[700],
                          selectedColor: Colors.white,
                          fillColor: Colors.red[200],
                          color: Colors.red[400],
                          constraints: BoxConstraints(
                            minHeight: 50.0,
                            minWidth: isSmallScreen ? 90.0 : 100.0,
                          ),
                          isSelected: _selectedAutonomie,
                          children: autonomie,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const TitleOfSlider(
                        titleFr: "La qualité du sommeil",
                        titleAr: "جودة النوم",
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ToggleButtons(
                          direction: Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              _selectedSomeilValue = index;
                              for (int i = 0; i < _selectedSommeil.length; i++) {
                                _selectedSommeil[i] = i == index;
                              }
                            });
                          },
                          textStyle: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          selectedBorderColor: Colors.red[700],
                          selectedColor: Colors.white,
                          fillColor: Colors.red[200],
                          color: Colors.red[400],
                          constraints: BoxConstraints(
                            minHeight: 50.0,
                            minWidth: isSmallScreen ? 90.0 : 100.0,
                          ),
                          isSelected: _selectedSommeil,
                          children: sommeil,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // if (noteController.text.isNotEmpty ) ...[
                      const TitleOfSlider(
                        titleFr: "Remarques",
                        titleAr: "ملاحظات",
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: noteController,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(
                            isSmallScreen ? 12.0 : 16.0,
                          ),
                        ),
                      ),
                      // ],
                      const SizedBox(height: 20),
                      _buildActionButtons(
                        context,
                        areDatesOnSameDay(
                          latestSymptomes.data?.createdAt,
                          DateTime.now(),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                );
              },
            ),
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
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16.0 : 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            titleFr,
            style: TextStyle(
              color: Colors.black,
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            titleAr,
            style: TextStyle(
              color: Colors.black,
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
