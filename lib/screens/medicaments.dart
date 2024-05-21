import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lupus_app/custom_widgets/custom_bottom_bar.dart';
import 'package:lupus_app/screens/bilan/widgets/user_info.dart';
import 'package:intl/intl.dart';

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Medicaments", style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    const MedicamentCard(
                        medicamentName: "Corticoïdes",
                        imgPath: "assets/corticoides.png",
                        prisesParJour: "Une seule prise par jour"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            DateFormat("dd-MM-yyyy")
                                .format(medicamentsController
                                    .corticioidesDate.value)
                                .toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => medicamentsController
                              .selectCorticoidesDate(context),
                          child: const Text('1'),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const MedicamentCard(
                        medicamentName: "Plaquenil",
                        imgPath: "assets/plaquenil.png",
                        prisesParJour: "Deux prises par jour"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            "${medicamentsController.plaquenilDate1.value.hour}:${medicamentsController.plaquenilDate1.value.minute}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => medicamentsController
                              .selectPlaquenilDate1(context),
                          child: const Text('1'),
                        ),
                        Obx(
                          () => Text(
                            "${medicamentsController.plaquenilDate2.value.hour}:${medicamentsController.plaquenilDate2.value.minute}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => medicamentsController
                              .selectPlaquenilDate2(context),
                          child: const Text('2'),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const MedicamentCard(
                        medicamentName: "Azathioprine",
                        imgPath: "assets/azathioprine.png",
                        prisesParJour: "Trois prises par jour"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            "${medicamentsController.azathioprineDate1.value.hour}:${medicamentsController.azathioprineDate1.value.minute}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => medicamentsController
                              .selectAzathioprineDate1(context),
                          child: const Text('1'),
                        ),
                        Obx(
                          () => Text(
                            "${medicamentsController.azathioprineDate2.value.hour}:${medicamentsController.azathioprineDate2.value.minute}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => medicamentsController
                              .selectAzathioprineDate2(context),
                          child: const Text('2'),
                        ),
                        Obx(
                          () => Text(
                            "${medicamentsController.azathioprineDate3.value.hour}:${medicamentsController.azathioprineDate3.value.minute}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => medicamentsController
                              .selectAzathioprineDate3(context),
                          child: const Text('3'),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const MedicamentCard(
                        medicamentName: "Methotrexate",
                        imgPath: "assets/methotrexate.png",
                        prisesParJour: "Une prise par semaine"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            DateFormat("dd-MM-yyyy")
                                .format(medicamentsController
                                    .methotrexateDate.value)
                                .toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => medicamentsController
                              .selectMethotrexateDate(context),
                          child: const Text('1'),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const MedicamentCard(
                        medicamentName: "Foldine",
                        imgPath: "assets/foldine.png",
                        prisesParJour: "Une prise par semaine"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            DateFormat("dd-MM-yyyy")
                                .format(medicamentsController.foldineDate.value)
                                .toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              medicamentsController.selectFoldineDate(context),
                          child: const Text('1'),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const MedicamentCard(
                        medicamentName: "MMF",
                        imgPath: "assets/mmf.png",
                        prisesParJour: "Deux prises par jour"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            "${medicamentsController.mmfDate1.value.hour}:${medicamentsController.mmfDate1.value.minute}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              medicamentsController.selectMmfDate1(context),
                          child: const Text('1'),
                        ),
                        Obx(
                          () => Text(
                            "${medicamentsController.mmfDate2.value.hour}:${medicamentsController.mmfDate2.value.minute}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              medicamentsController.selectMmfDate2(context),
                          child: const Text('2'),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const AddMedicament()
                  ],
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
    return Container(
      width: 303,
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 64,
            height: 35,
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
              Text(prisesParJour),
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