// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:lupus_app/custom_widgets/custom_bottom_bar.dart';
import 'package:lupus_app/screens/bilan/widgets/user_info.dart';

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
  var horaires = ["Matin", "Midi", "Soir"];
  int dropdownvalue = 1;
  Future<Profile> getProfile() async {
    Profile profileFile = await FileService.getProfile();

    setState(() {
      profile = profileFile;
    });

    return profileFile;
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  int priseCort = 0;
  int prisePlaqenil = 0;
  int priseAzath = 0;
  int priseMetho = 0;
  int priseFoldine = 0;
  int priseMMF = 0;

  int nbrCort = 0;
  int nbrPlaqenil = 0;
  int nbrAzath = 0;
  int nbrMetho = 0;
  int nbrFoldine = 0;
  int nbrMMF = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
        title: const Text("Prescription"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Medicaments", style: TextStyle(fontSize: 20)),
                      MedicamentSection(
                          prisesParJour: "Une seule prise par jour",
                          horairePrise: priseCort,
                          horaireChange: (value) {
                            setState(() {
                              priseCort = value ?? 0;
                            });
                          },
                          medicamentName: "Corticoïdes",
                          imgPath: "assets/corticoides.png",
                          nbrPrises: nbrCort,
                          prisesChange: (value) {
                            setState(() {
                              nbrCort = value ?? 0;
                            });
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      MedicamentSection(
                          prisesParJour: "Deux prises par jour",
                          horairePrise: prisePlaqenil,
                          horaireChange: (value) {
                            setState(() {
                              prisePlaqenil = value ?? 0;
                            });
                          },
                          medicamentName: "Plaquenil",
                          imgPath: "assets/plaquenil.png",
                          nbrPrises: nbrPlaqenil,
                          prisesChange: (value) {
                            setState(() {
                              nbrPlaqenil = value ?? 0;
                            });
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      MedicamentSection(
                          prisesParJour: "Trois prises par jour",
                          horairePrise: priseAzath,
                          horaireChange: (value) {
                            setState(() {
                              priseAzath = value ?? 0;
                            });
                          },
                          medicamentName: "Azathioprine",
                          imgPath: "assets/azathioprine.png",
                          nbrPrises: nbrAzath,
                          prisesChange: (value) {
                            setState(() {
                              nbrAzath = value ?? 0;
                            });
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      MedicamentSection(
                          prisesParJour: "Une prise par semaine",
                          horairePrise: priseMetho,
                          horaireChange: (value) {
                            setState(() {
                              priseMetho = value ?? 0;
                            });
                          },
                          medicamentName: "Methotrexate",
                          imgPath: "assets/methotrexate.png",
                          nbrPrises: nbrMetho,
                          prisesChange: (value) {
                            setState(() {
                              nbrMetho = value ?? 0;
                            });
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      MedicamentSection(
                          prisesParJour: "Une prise par semaine",
                          horairePrise: priseFoldine,
                          horaireChange: (value) {
                            setState(() {
                              priseFoldine = value ?? 0;
                            });
                          },
                          medicamentName: "Foldine",
                          imgPath: "assets/foldine.png",
                          nbrPrises: nbrFoldine,
                          prisesChange: (value) {
                            setState(() {
                              nbrFoldine = value ?? 0;
                            });
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      MedicamentSection(
                          prisesParJour: "Deux prises par jour",
                          horairePrise: priseMMF,
                          horaireChange: (value) {
                            setState(() {
                              priseMMF = value ?? 0;
                            });
                          },
                          medicamentName: "MMF",
                          imgPath: "assets/mmf.png",
                          nbrPrises: nbrMMF,
                          prisesChange: (value) {
                            setState(() {
                              nbrMMF = value ?? 0;
                            });
                          }),
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

class AddMedicament extends StatelessWidget {
  const AddMedicament({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(2),
        ),
        border: Border.all(
          color: const Color.fromRGBO(232, 232, 232, 1),
          width: 2,
        ),
      ),
      width: 303,
      padding: const EdgeInsets.all(15),
      child: Center(
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(245, 124, 204, 1),
          ),
          padding: const EdgeInsets.all(5),
          // color: Colors.pinkAccent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
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
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(126, 126, 126, 1),
                ),
              ),
              Text(
                prisesParJour,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
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

class NameRow extends StatelessWidget {
  const NameRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 308,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        padding: const EdgeInsets.all(15),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ioussam Gaff",
              style: TextStyle(
                color: Color.fromRGBO(116, 116, 116, 1),
              ),
            ),
            Text("Homme-20")
          ],
        ),
      ),
    );
  }
}

class MedicamentSection extends StatelessWidget {
  final String medicamentName, imgPath, prisesParJour;
  final int nbrPrises, horairePrise;
  final Function prisesChange, horaireChange;

  const MedicamentSection({
    Key? key,
    required this.prisesParJour,
    required this.horairePrise,
    required this.horaireChange,
    required this.medicamentName,
    required this.imgPath,
    required this.nbrPrises,
    required this.prisesChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var horaires = ["Matin", "Midi", "Soir"];
    var parSemaineJour = ["Par jour", "Par semaine"];

    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(255, 229, 245, 0.2),
            blurRadius: 4,
            spreadRadius: 0.1,
            offset: Offset(4, 8), // Shadow position
          ),
        ],
        color: const Color.fromRGBO(255, 229, 245, 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            width: 1, color: const Color.fromRGBO(255, 180, 252, 0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Column(
        children: [
          MedicamentCard(
              medicamentName: medicamentName,
              imgPath: imgPath,
              prisesParJour: prisesParJour),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Nombre de comprimés",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(126, 126, 126, 1),
                ),
              ),
              DropdownButton<int>(
                iconEnabledColor: Colors.pink[200],
                value: nbrPrises,
                hint: const Text("---"),
                items: <int>[0, 1, 2, 3, 4, 5].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      value.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(126, 126, 126, 1),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  prisesChange(value);
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Horaire de prise",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(126, 126, 126, 1),
                ),
              ),
              DropdownButton<int>(
                value: horairePrise,
                iconEnabledColor: Colors.pink[200],
                hint: const Text("---"),
                alignment: Alignment.center,
                items: <int>[0, 1, 2].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      horaires[value],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(126, 126, 126, 1),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  horaireChange(value);
                },
              )
            ],
          ),
          ElevatedButton(
              onPressed: () {
                var hour = 8;
                if (horairePrise == 0) {
                  hour = 8;
                } else if (horairePrise == 1) {
                  hour = 12;
                } else
                  hour = 17;
                _scheduleNotification(
                    medicamentName,
                    "Il est temps de prendre vos $medicamentName",
                    medicamentName.hashCode,
                    hour,
                    0,
                    null);
              },
              child: const Text("Enregistrer"))
        ],
      ),
    );
  }

  void _scheduleNotification(
    String title,
    String body,
    int id,
    int? hour,
    int? minute,
    DateTime? date,
  ) {
    NotificationSchedule schedule;

    if (date == null) {
      schedule = NotificationCalendar.fromDate(
          repeats: true,
          allowWhileIdle: true,
          date: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            hour!,
            minute!,
          ).add(const Duration(days: 1)));
    } else {
      schedule = NotificationCalendar.fromDate(
        date: date,
      );
    }

    AwesomeNotifications()
        .createNotification(
      content: NotificationContent(
        id: id,
        channelKey: "lupus_notif_channel_key",
        title: title,
        body: body,
      ),
      schedule: schedule,
    )
        .catchError((e) {
      print("Error creating notification: $e");
    });
  }
}

//  const Text("Corticoïdes Dates"),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Obx(
//                     () => Text(
//                       DateFormat("dd-MM-yyyy")
//                           .format(medicamentsController.corticioidesDate.value)
//                           .toString(),
//                       style: const TextStyle(fontSize: 15),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () =>
//                         medicamentsController.selectCorticoidesDate(context),
//                     child: const Text('Date pour les corticoïdes'),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text("Plaquenil Dates"),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Obx(
//                     () => Text(
//                       "${medicamentsController.plaquenilDate1.value.hour}:${medicamentsController.plaquenilDate1.value.minute}",
//                       style: const TextStyle(fontSize: 15),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () =>
//                         medicamentsController.selectPlaquenilDate1(context),
//                     child: const Text('Premiere date pour le plaquenil'),
//                   )
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Obx(
//                     () => Text(
//                       "${medicamentsController.plaquenilDate2.value.hour}:${medicamentsController.plaquenilDate2.value.minute}",
//                       style: const TextStyle(fontSize: 15),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () =>
//                         medicamentsController.selectPlaquenilDate2(context),
//                     child: const Text('Deuxieme date pour le plaquenil'),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text("Azathioprine Dates"),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Obx(
//                     () => Text(
//                       "${medicamentsController.azathioprineDate1.value.hour}:${medicamentsController.azathioprineDate1.value.minute}",
//                       style: const TextStyle(fontSize: 15),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () =>
//                         medicamentsController.selectAzathioprineDate1(context),
//                     child: const Text('Premiere date pour l\'azathioprine'),
//                   )
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Obx(
//                     () => Text(
//                       "${medicamentsController.azathioprineDate2.value.hour}:${medicamentsController.azathioprineDate2.value.minute}",
//                       style: const TextStyle(fontSize: 15),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () =>
//                         medicamentsController.selectAzathioprineDate2(context),
//                     child: const Text('Deuxieme date pour l\'azathioprine'),
//                   )
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Obx(
//                     () => Text(
//                       "${medicamentsController.azathioprineDate3.value.hour}:${medicamentsController.azathioprineDate3.value.minute}",
//                       style: const TextStyle(fontSize: 15),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () =>
//                         medicamentsController.selectAzathioprineDate3(context),
//                     child: const Text('Troisieme date pour l\'azathioprine'),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text("Methotrxate Dates"),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Obx(
//                     () => Text(
//                       DateFormat("dd-MM-yyyy")
//                           .format(medicamentsController.methotrexateDate.value)
//                           .toString(),
//                       style: const TextStyle(fontSize: 15),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () =>
//                         medicamentsController.selectMethotrexateDate(context),
//                     child: const Text('Date pour le methotrexate'),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text("Foldine Dates"),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Obx(
//                     () => Text(
//                       DateFormat("dd-MM-yyyy")
//                           .format(medicamentsController.foldineDate.value)
//                           .toString(),
//                       style: const TextStyle(fontSize: 15),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () =>
//                         medicamentsController.selectFoldineDate(context),
//                     child: const Text('Date pour le foldine'),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text("MMF Dates"),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Obx(
//                     () => Text(
//                       "${medicamentsController.mmfDate1.value.hour}:${medicamentsController.mmfDate1.value.minute}",
//                       style: const TextStyle(fontSize: 15),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () =>
//                         medicamentsController.selectMmfDate1(context),
//                     child: const Text('Premiere date de mmf'),
//                   )
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Obx(
//                     () => Text(
//                       "${medicamentsController.mmfDate2.value.hour}:${medicamentsController.mmfDate2.value.minute}",
//                       style: const TextStyle(fontSize: 15),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () =>
//                         medicamentsController.selectMmfDate2(context),
//                     child: const Text('Deuxieme date de mmf'),
//                   )
//                 ],
//               ),