// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulup/constants/colors.dart';
import 'package:tulup/custom_widgets/custom_app_bar.dart';
import 'package:tulup/custom_widgets/custom_bottom_bar.dart';
import 'package:tulup/screens/bilan/widgets/user_info.dart';

import '../controllers/medicaments_controller.dart';
import '../entity/profile.dart';
import '../shared/file_service.dart';

class MedicamentsScreen extends StatefulWidget {
  const MedicamentsScreen({super.key});

  @override
  State<MedicamentsScreen> createState() => _MedicamentsScreenState();
}

class _MedicamentsScreenState extends State<MedicamentsScreen> {
  final MedicamentsController medicamentsController =
      Get.put(MedicamentsController());

  Profile? profile;
  List<dynamic>? meds;
  var horaires = ["Matin | الصباح", "Midi | الزوال", "Soir | المساء"];
  var jrs = [
    'Quotidien | يوميا',
    'Lundi | الإثنين',
    'Mardi | الثلاثاء',
    'Mercredi | الأربعاء',
    'Jeudi | الخميس',
    'Vendredi | الجمعة',
    'Samedi | السبت',
    'Dimanche | الأحد'
  ];

  int dropdownvalue = 1;
  Future<Profile> getProfile() async {
    Profile profileFile = await FileService.getProfile();

    setState(() {
      profile = profileFile;
    });

    return profileFile;
  }

  Future<List<dynamic>> getMed() async {
    List<dynamic> medFile = await FileService.getMed();
    print("medFile: $medFile");

    setState(() {
      meds = medFile;
    });
    mapMedToReminder();

    return medFile;
  }

  void mapMedToReminder() {
    // Implement the logic to map medications to reminders
    // This function should iterate over the meds list and set up reminders for each medication
    if (meds != null) {
      for (var med in meds!) {
        // Extract necessary information from the medication object
        String savedMedName = med['medicament'];
        int savedNbrPrises = med['nbrPrises'];
        List<dynamic> savedSelectedDays = med['selectedDays'];
        List<dynamic> savedSelectedTimes = med['selectedTimes'];

        switch (savedMedName) {
          case "Corticoïdes":
            setState(() {
              SavedTimesCort = savedSelectedTimes.join(",");
              SavedPrisesCort = savedNbrPrises;
              SavedjrsCort = savedSelectedDays.join(", ");
            });
            break;
          case "Plaquenil":
            setState(() {
              SavedTimesPlaqenil = savedSelectedTimes.join(",");
              SavedPrisesPlaqenil = savedNbrPrises;
              SavedjrsPlaqenil = savedSelectedDays.join(", ");
            });
            break;
          case "Azathioprine":
            setState(() {
              SavedTimesAzath = savedSelectedTimes.join(",");
              SavedPrisesAzath = savedNbrPrises;
              SavedjrsAzath = savedSelectedDays.join(", ");
            });
            break;

          case "Methotrexate":
            setState(() {
              SavedTimesMetho = savedSelectedTimes.join(",");
              SavedPrisesMetho = savedNbrPrises;
              SavedjrsMetho = savedSelectedDays.join(", ");
            });
            break;

          case "Foldine":
            setState(() {
              SavedTimesFoldine = savedSelectedTimes.join(",");
              SavedPrisesFoldine = savedNbrPrises;
              SavedjrsFoldine = savedSelectedDays.join(", ");
            });
            break;

          case "MMF":
            setState(() {
              SavedTimesMMF = savedSelectedTimes.join(",");
              SavedPrisesMMF = savedNbrPrises;
              SavedjrsMMF = savedSelectedDays.join(", ");
            });
            break;
        }
      }
    }
  }

  @override
  void initState() {
    getProfile();
    getMed();

    super.initState();
  }

  String? SavedTimesCort;
  String? SavedTimesPlaqenil;
  String? SavedTimesAzath;
  String? SavedTimesMetho;
  String? SavedTimesFoldine;
  String? SavedTimesMMF;

  int priseCort = 0;
  int? SavedPrisesCort;
  int prisePlaqenil = 0;
  int? SavedPrisesPlaqenil;
  int priseAzath = 0;
  int? SavedPrisesAzath;
  int priseMetho = 0;
  int? SavedPrisesMetho;
  int priseFoldine = 0;
  int? SavedPrisesFoldine;
  int priseMMF = 0;
  int? SavedPrisesMMF;

  int nbrCort = 0;
  int nbrPlaqenil = 0;
  int nbrAzath = 0;
  int? nbrMetho;
  int nbrFoldine = 0;
  int nbrMMF = 0;

  int jrsCort = 0;
  String? SavedjrsCort;
  int jrsPlaqenil = 0;
  String? SavedjrsPlaqenil;
  int jrsAzath = 0;
  String? SavedjrsAzath;
  int jrsMetho = 0;
  String? SavedjrsMetho;
  int jrsFoldine = 0;
  String? SavedjrsFoldine;
  int jrsMMF = 0;
  String? SavedjrsMMF;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      appBar: const CustomAppBar(
        title: 'Prescription\nالوصفة الطبية',
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(240, 240, 240, 1),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserInfo(
                  mediaQuery: MediaQuery.of(context),
                  name: "${profile?.nom} ${profile?.prenom}",
                  gender: "",
                  age: (DateTime.now().year -
                          int.parse(
                              profile?.dateNaissance.substring(0, 4) ?? '0'))
                      .toString(),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MedicamentSection(
                        prisesParJour:
                            "Une seule prise par jour\nجرعة واحدة فقط في اليوم",
                        horairePrise: priseCort,
                        maxPrises: 12,
                        horaireChange: (value) {
                          setState(() {
                            priseCort = value ?? 0;
                          });
                        },
                        medicamentName: "Corticoïdes",
                        imgPath: "assets/corticoides.png",
                        nbrPrises: SavedPrisesCort ?? nbrCort,
                        prisesChange: (value) {
                          setState(() {
                            nbrCort = value ?? 0;
                          });
                        },
                        jrsChange: (value) {
                          setState(() {
                            jrsCort = value ?? 0;
                          });
                        },
                        jrsPrises: jrsCort,
                        savedSelectedDays: SavedjrsCort,
                        savedSelectedTimes: SavedTimesCort,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MedicamentSection(
                        savedSelectedDays: SavedjrsPlaqenil,
                        savedSelectedTimes: SavedTimesPlaqenil,
                        prisesParJour: "Deux prises par jour\nجرعتين يوميا",
                        horairePrise: prisePlaqenil,
                        maxPrises: 2,
                        daysCount: 7,
                        horaireChange: (value) {
                          setState(() {
                            prisePlaqenil = value ?? 0;
                          });
                        },
                        medicamentName: "Plaquenil",
                        imgPath: "assets/plaquenil.png",
                        nbrPrises: SavedPrisesPlaqenil ?? nbrPlaqenil,
                        prisesChange: (value) {
                          setState(() {
                            nbrPlaqenil = value ?? 0;
                          });
                        },
                        jrsChange: (value) {
                          setState(() {
                            jrsPlaqenil = value ?? 0;
                          });
                        },
                        jrsPrises: jrsPlaqenil,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MedicamentSection(
                        savedSelectedDays: SavedjrsAzath,
                        savedSelectedTimes: SavedTimesAzath,
                        prisesParJour:
                            "Trois prises par jour\nثلاث جرعات يوميا",
                        horairePrise: priseAzath,
                        maxPrises: 4,
                        daysCount: 7,
                        horaireChange: (value) {
                          setState(() {
                            priseAzath = value ?? 0;
                          });
                        },
                        medicamentName: "Azathioprine",
                        imgPath: "assets/azathioprine.png",
                        nbrPrises: SavedPrisesAzath ?? nbrAzath,
                        prisesChange: (value) {
                          setState(() {
                            nbrAzath = value ?? 0;
                          });
                        },
                        jrsChange: (value) {
                          setState(() {
                            jrsAzath = value ?? 0;
                          });
                        },
                        jrsPrises: jrsAzath,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MedicamentSection(
                        savedSelectedDays: SavedjrsMetho,
                        savedSelectedTimes: SavedTimesMetho,
                        prisesParJour:
                            "Une prise par semaine\nجرعة واحدة في الأسبوع",
                        horairePrise: priseMetho,
                        minPrises: 4,
                        maxPrises: 8,
                        daysCount: 7,
                        isOneDay: true,
                        horaireChange: (value) {
                          setState(() {
                            priseMetho = value ?? 0;
                          });
                        },
                        medicamentName: "Methotrexate",
                        imgPath: "assets/methotrexate.png",
                        isOneTime: true,
                        nbrPrises: SavedPrisesMetho ?? nbrMetho,
                        prisesChange: (value) {
                          setState(() {
                            nbrMetho = value ?? 0;
                          });
                        },
                        jrsChange: (value) {
                          setState(() {
                            jrsMetho = value ?? 0;
                          });
                        },
                        jrsPrises: jrsMetho,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MedicamentSection(
                        savedSelectedDays: SavedjrsFoldine,
                        savedSelectedTimes: SavedTimesFoldine,
                        prisesParJour:
                            "Une prise par semaine\nجرعة واحدة في الأسبوع",
                        horairePrise: priseFoldine,
                        maxPrises: 1,
                        daysCount: 1,
                        isOneDay: true,
                        horaireChange: (value) {
                          setState(() {
                            priseFoldine = value ?? 0;
                          });
                        },
                        medicamentName: "Foldine",
                        imgPath: "assets/foldine.png",
                        nbrPrises: SavedPrisesFoldine ?? nbrFoldine,
                        prisesChange: (value) {
                          setState(() {
                            nbrFoldine = value ?? 0;
                          });
                        },
                        jrsChange: (value) {
                          setState(() {
                            jrsFoldine = value ?? 0;
                          });
                        },
                        jrsPrises: jrsFoldine,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MedicamentSection(
                        savedSelectedDays: SavedjrsMMF,
                        savedSelectedTimes: SavedTimesMMF,
                        prisesParJour: "Deux prises par jour\nجرعتين يوميا",
                        horairePrise: priseMMF,
                        maxPrises: 6,
                        daysCount: 7,
                        horaireChange: (value) {
                          setState(() {
                            priseMMF = value ?? 0;
                          });
                        },
                        medicamentName: "MMF",
                        imgPath: "assets/mmf.png",
                        nbrPrises: SavedPrisesMMF ?? nbrMMF,
                        prisesChange: (value) {
                          setState(() {
                            nbrMMF = value ?? 0;
                          });
                        },
                        jrsChange: (value) {
                          setState(() {
                            jrsMMF = value ?? 0;
                          });
                        },
                        jrsPrises: jrsMMF,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MedicamentCard extends StatelessWidget {
  const MedicamentCard({
    super.key,
    required this.imgPath,
    required this.medicamentName,
    required this.prisesParJour,
  });

  final String imgPath;
  final String medicamentName;
  final String prisesParJour;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.75,
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: width * 0.2,
            height: width * 0.1,
            child: Image.asset(imgPath),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medicamentName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(126, 126, 126, 1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MedicamentSection extends StatefulWidget {
  final String medicamentName, imgPath, prisesParJour;
  final int horairePrise, jrsPrises, maxPrises, minPrises, daysCount;
  final int? nbrPrises;
  final Function prisesChange, horaireChange, jrsChange;
  final bool isOneDay, isOneTime, canbeMultipleTimes;

  final String? savedSelectedDays, savedSelectedTimes;

  const MedicamentSection({
    super.key,
    required this.prisesParJour,
    required this.horairePrise,
    required this.horaireChange,
    required this.medicamentName,
    required this.imgPath,
    required this.nbrPrises,
    required this.prisesChange,
    required this.jrsChange,
    required this.maxPrises,
    this.minPrises = 0,
    this.isOneTime = false,
    this.canbeMultipleTimes = false,
    this.daysCount = 7,
    this.isOneDay = false,
    required this.jrsPrises,
    this.savedSelectedDays,
    this.savedSelectedTimes,
  });

  @override
  _MedicamentSectionState createState() => _MedicamentSectionState();
}

class _MedicamentSectionState extends State<MedicamentSection> {
  bool _isScheduled = false; // <--- ADDED
  List<String> selectedDays = [];
  List<String> selectedTimes = [];

  void _showPillReminderDialog() async {
    final result = await showDialog<List<List<String>>>(
      context: context,
      builder: (BuildContext context) {
        return PillReminderDialog(
          isDaily: false,
          pills: widget.nbrPrises ?? 0,
          isOneDay: widget.isOneDay,
          isMultipleTimes: widget.canbeMultipleTimes,
        );
      },
    );

    // Process the selected days and times from the dialog
    if (result != null) {
      setState(() {
        selectedDays = result[0]; // Assuming first element is days
        selectedTimes = result[1]; // Assuming second element is times
      });
    }
  }

  void _scheduleMedication() {
    Map<String, int> timeMapping = {
      'Matin - صباح': 9,
      'Midi - الظهر': 12,
      'Soir - مساء': 19
    };

    for (var day in selectedDays) {
      for (var time in selectedTimes) {
        int? hour = timeMapping[time];
        if (hour == null) continue; // Skip if no valid hour mapping
        DateTime now = DateTime.now();
        DateTime scheduleDate = _getNextScheduleDate(day, hour, now);
        _scheduleNotification(
          widget.medicamentName,
          "Il est temps de prendre vos ${widget.nbrPrises} comprimé(s) de ${widget.medicamentName}.\n"
          "حان الوقت لتناول ${widget.medicamentName} ${widget.nbrPrises} أقراص",
          widget.medicamentName.hashCode ^ scheduleDate.hashCode,
          scheduleDate,
        );
      }
    }

    // Show success message
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: ' ',
      desc: 'Rappel enregistré ! \n !تم تسجيل التذكير',
      btnOkOnPress: () {
        setState(() {
          _isScheduled = true; // <--- ADDED
        });
      },
      btnOkIcon: Icons.check_circle,
    ).show();

    FileService.writeFile(
        "rappel_med.txt",
        jsonEncode({
          "medicament": widget.medicamentName,
          "nbrPrises": widget.nbrPrises,
          "selectedDays": selectedDays,
          "selectedTimes": selectedTimes,
        }));
  }

  DateTime _getNextScheduleDate(String day, int hour, DateTime now) {
    int dayOffset = 0;

    Map<String, int> daysOfWeek = {
      "Lun": 1,
      "Mar": 2,
      "Mer": 3,
      "Jeu": 4,
      "Ven": 5,
      "Sam": 6,
      "Dim": 7,
      "Lundi": 1,
      "Mardi": 2,
      "Mercredi": 3,
      "Jeudi": 4,
      "Vendredi": 5,
      "Samedi": 6,
      "Dimanche": 7,
      "الاثنين": 1,
      "الثلاثاء": 2,
      "الأربعاء": 3,
      "الخميس": 4,
      "الجمعة": 5,
      "السبت": 6,
      "الأحد": 7,
    };

    String cleanedDay = day.split(' - ')[0].trim();
    int? selectedDayIndex = daysOfWeek[cleanedDay];
    if (selectedDayIndex == null) {
      throw Exception('Invalid day: $day');
    }

    dayOffset = (selectedDayIndex - now.weekday + 7) % 7;

    // If the selected day is today and the time is already past, schedule for next week
    if (dayOffset == 0 && now.hour >= hour) {
      dayOffset += 7;
    }

    return DateTime(now.year, now.month, now.day + dayOffset, hour);
  }

  @override
  Widget build(BuildContext context) {
    List<int> nbrC = List.generate(widget.maxPrises - widget.minPrises + 1,
        (index) => index + widget.minPrises);

    if (!nbrC.contains(0)) nbrC.insert(0, 0);

    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(255, 229, 245, 0.2),
            blurRadius: 4,
            spreadRadius: 0.1,
            offset: Offset(4, 8),
          ),
        ],
        color: seedColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(51, 250, 126, 246),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Column(
        children: [
          MedicamentCard(
            medicamentName: widget.medicamentName,
            imgPath: widget.imgPath,
            prisesParJour: widget.prisesParJour,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Nombre de comprimés\nعدد الأقراص",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  // color: Color.fromRGBO(126, 126, 126, 1),
                ),
              ),
              DropdownButton<int>(
                iconEnabledColor: seedColor,
                value:
                    //(widget.minPrises != 0 && widget.nbrPrises == null)
                    //? widget.minPrises
                    //:
                    widget.nbrPrises,
                hint: const Text("--"),
                items: nbrC.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      value == 0 ? "--" : value.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(126, 126, 126, 1),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  widget.prisesChange(value);
                  setState(() {
                    // Reset selected days and times when pill count changes
                    selectedDays.clear();
                    selectedTimes.clear();
                  });
                },
              )
            ],
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.nbrPrises != 0 ? _showPillReminderDialog : null,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                backgroundColor: seedColor.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 3,
              ),
              child: const Text(
                "Fréquence et horaire de prise\nموعد الجرعة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // New Stylish Details Container
          if (selectedDays.isNotEmpty ||
              selectedTimes.isNotEmpty ||
              widget.savedSelectedDays != null ||
              widget.savedSelectedTimes != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ExpansionTile(
                collapsedIconColor: seedColor,
                title: const Text(
                  "Voir les détails du rappel\nعرض تفاصيل التذكير",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: seedColor,
                  ),
                ),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Divider(),
                      const SizedBox(height: 5),
                      if (selectedDays.isNotEmpty)
                        Text(
                          "Jours - الأيام:\n${selectedDays.join(", ")}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      if (selectedDays.isEmpty &&
                          widget.savedSelectedDays != null)
                        Text(
                          "Jours - الأيام:\n${widget.savedSelectedDays}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      const Divider(
                        indent: 80,
                        endIndent: 80,
                      ),
                      if (selectedTimes.isNotEmpty)
                        Text(
                          "Heures - التوقيت:\n${selectedTimes.join(" ")}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      if (selectedTimes.isEmpty &&
                          widget.savedSelectedTimes != null)
                        Text(
                          "Heures - التوقيت:\n${widget.savedSelectedTimes}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ],
              ),
            ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedDays.isNotEmpty &&
                      selectedTimes.isNotEmpty &&
                      !_isScheduled
                  ? _scheduleMedication
                  : null,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                backgroundColor: confirmColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if ((!_isScheduled &&
                          selectedDays.isNotEmpty &&
                          selectedTimes.isNotEmpty) ||
                      (!_isScheduled &&
                          selectedDays.isEmpty &&
                          selectedTimes.isEmpty &&
                          widget.savedSelectedDays == null &&
                          widget.savedSelectedTimes == null))
                    const Text(
                      "Programmer le rappel\nجدولة التذكير",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  if (_isScheduled ||
                      (widget.savedSelectedDays != null &&
                          widget.savedSelectedTimes != null &&
                          selectedDays.isEmpty &&
                          selectedTimes.isEmpty))
                    const Text(
                      'Rappel enregistré !\nتم تسجيل التذكير',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  if (_isScheduled ||
                      (widget.savedSelectedDays != null &&
                          widget.savedSelectedTimes != null &&
                          selectedDays.isEmpty &&
                          selectedTimes.isEmpty))
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.lightGreenAccent,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DateTime nextDayOfWeek(int dayOfWeek, [DateTime? from]) {
  from ??= DateTime.now();
  int daysToAdd = (dayOfWeek - from.weekday) % 7;
  daysToAdd = daysToAdd <= 0 ? daysToAdd + 7 : daysToAdd;
  return from.add(Duration(days: daysToAdd));
}

void _scheduleNotification(
  String title,
  String body,
  int id,
  DateTime date,
) {
  // Validate the date
  if (date.isBefore(DateTime.now())) {
    print("Error: The notification date is in the past.");
    // Optionally notify the user through the UI
    return;
  }

  // Define the notification schedule
  NotificationSchedule schedule = NotificationCalendar.fromDate(
    repeats: true, // Set this based on user preference for daily or weekly
    preciseAlarm: true,
    allowWhileIdle: true,
    date: date,
  );

  AwesomeNotifications()
      .createNotification(
        content: NotificationContent(
          category: NotificationCategory.Reminder,
          displayOnBackground: true,
          displayOnForeground: true,
          wakeUpScreen: true,
          id: id,
          channelKey: "tulup_notif_channel_key",
          title: title,
          body: body,
        ),
        schedule: schedule,
      )
      .then((value) => print("Notification scheduled: $value"))
      .catchError((e) {
    print("Error creating notification: $e");
    // Optionally show an error message in the UI
  });
}

class PillReminderDialog extends StatefulWidget {
  final int pills;
  int daysCount;
  final bool isDaily;
  bool isOneDay, isMultipleTimes;

  PillReminderDialog(
      {super.key,
      required this.pills,
      required this.isDaily,
      this.daysCount = 7,
      this.isMultipleTimes = true,
      this.isOneDay = false});

  @override
  _PillReminderDialogState createState() => _PillReminderDialogState();
}

class _PillReminderDialogState extends State<PillReminderDialog> {
  // Bilingual days of the week in French and Arabic
  List<String> daysOfWeek = [
    "Lun - الإثنين", // Monday
    "Mar - الثلاثاء", // Tuesday
    "Mer - الأربعاء", // Wednesday
    "Jeu - الخميس", // Thursday
    "Ven - الجمعة", // Friday
    "Sam - السبت", // Saturday
    "Dim - الأحد" // Sunday
  ];

  List<bool> selectedDays = List.generate(7, (index) => false);
  bool morningChecked = false;
  bool noonChecked = false;
  bool eveningChecked = false;

  @override
  void initState() {
    super.initState();
    if (widget.isDaily) {
      // If daily, pre-select all days and disable modification
      selectedDays = List.generate(7, (index) => true);
    }
  }

  // Check if at least one day is selected
  bool get isDaySelected {
    return selectedDays.contains(true);
  }

  // Check if at least one time is selected
  bool get isTimeSelected {
    return morningChecked || noonChecked || eveningChecked;
  }

  // Check if the "Save" button should be enabled
  bool get isSaveEnabled {
    return isDaySelected && isTimeSelected;
  }

  // Check the number of selected days
  int get selectedDaysCount => selectedDays.where((day) => day).length;

  // Check the number of selected times
  int get selectedTimesCount {
    int count = 0;
    if (morningChecked) count++;
    if (noonChecked) count++;
    if (eveningChecked) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'Rappel du médicament\nتذكير الدواء',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Days of the week selector (if not daily)
            if (!widget.isDaily)
              Wrap(
                spacing: 5.0,
                children: List.generate(daysOfWeek.length, (index) {
                  return ChoiceChip(
                    label: Text(
                      daysOfWeek[index],
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                    selected: selectedDays[index],
                    onSelected: (bool selected) {
                      bool daysCondition = (widget.daysCount > widget.pills) &&
                          (selectedDaysCount < widget.daysCount) &&
                          !widget.isOneDay;

                      bool pillsCountAndNotOneDay =
                          ((selectedDaysCount < widget.pills) &&
                              !widget.isOneDay);

                      bool isOneDayAndNotSelected =
                          (widget.isOneDay && (selectedDaysCount < 1));

                      if (pillsCountAndNotOneDay ||
                          isOneDayAndNotSelected ||
                          daysCondition ||
                          selectedDays[index]) {
                        setState(() {
                          selectedDays[index] = selected;
                        });
                      } else {
                        // If the user exceeds the allowed number of days, show a message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            content: Text(
                                'Vous pouvez choisir seulement ${widget.pills} jours\nيمكنك اختيار ${widget.pills} أيام فقط'),
                          ),
                        );
                      }
                    },
                  );
                }),
              ),

            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),

            // Morning checkbox (limited by the number of pills)
            CheckboxListTile(
              title: const Text(
                " 09:00 Matin - صباح ",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
              value: morningChecked,
              onChanged: (bool? value) {
                bool pillsCountAndNotOneDay =
                    ((selectedTimesCount < widget.pills) &&
                        !widget.isMultipleTimes);
                bool isOneDayAndNotSelected =
                    (widget.isOneDay && (selectedTimesCount < 1));

                if (pillsCountAndNotOneDay ||
                    isOneDayAndNotSelected ||
                    morningChecked) {
                  setState(() {
                    morningChecked = value ?? false;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Text(
                          'Vous pouvez choisir seulement ${widget.pills} créneaux horaires\nيمكنك اختيار ${widget.pills} توقيتات فقط'),
                    ),
                  );
                }
              },
            ),

            // Noon checkbox (limited by the number of pills)
            CheckboxListTile(
              title: const Text(
                "12:00 Midi - الظهر",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
              value: noonChecked,
              onChanged: (bool? value) {
                bool pillsCountAndNotOneDay =
                    ((selectedTimesCount < widget.pills) &&
                        !widget.isMultipleTimes);
                bool isOneDayAndNotSelected =
                    (widget.isOneDay && (selectedTimesCount < 1));

                if (pillsCountAndNotOneDay ||
                    isOneDayAndNotSelected ||
                    noonChecked) {
                  setState(() {
                    noonChecked = value ?? false;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Text(
                          'Vous pouvez choisir seulement ${widget.pills} créneaux horaires\nيمكنك اختيار ${widget.pills} توقيتات فقط'),
                    ),
                  );
                }
              },
            ),

            // Evening checkbox (limited by the number of pills)
            CheckboxListTile(
              title: const Text(
                "19:00 Soir - مساء",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
              value: eveningChecked,
              onChanged: (bool? value) {
                bool pillsCountAndNotOneDay =
                    ((selectedTimesCount < widget.pills) &&
                        !widget.isMultipleTimes);
                bool isOneDayAndNotSelected =
                    (widget.isOneDay && (selectedTimesCount < 1));

                if (pillsCountAndNotOneDay ||
                    isOneDayAndNotSelected ||
                    eveningChecked) {
                  setState(() {
                    eveningChecked = value ?? false;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Text(
                          'Vous pouvez choisir seulement ${widget.pills} créneaux horaires\nيمكنك اختيار ${widget.pills} توقيتات فقط'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.only(bottom: 30),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        Container(
          padding: EdgeInsets.all(8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Annuler - إلغاء',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            onPressed: isSaveEnabled
                ? () {
                    // Prepare the selected days and times for the calling widget
                    List<String> selectedDaysText = [];
                    for (int i = 0; i < selectedDays.length; i++) {
                      if (selectedDays[i]) {
                        selectedDaysText.add(daysOfWeek[i]);
                      }
                    }
                    List<String> selectedTimesText = [];
                    if (morningChecked)
                      selectedTimesText.add(" 09:00 Matin - صباح \n ");
                    if (noonChecked)
                      selectedTimesText.add(" 12:00 Midi - الظهر \n ");
                    if (eveningChecked)
                      selectedTimesText.add(" 19:00 Soir - مساء \n ");

                    // Show a success message after saving
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //     content: Text('Rappel enregistré !\nتم تسجيل التذكير'),
                    //   ),
                    // );

                    // Return selected days and times to the calling widget
                    Navigator.of(context)
                        .pop([selectedDaysText, selectedTimesText]);
                  }
                : null,
            child: const Text(
              'Enregistrer - حفظ',
              style: TextStyle(color: Colors.white),
            ), // Disable button if conditions are not met
          ),
        ),
      ],
    );
  }
}
