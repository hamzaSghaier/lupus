import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_app/custom_widgets/custom_bottom_bar.dart';
import 'package:intl/intl.dart';

import '../controllers/medicaments_controller.dart';

class MedicamentsScreen extends StatelessWidget {
  MedicamentsScreen({super.key});

  final MedicamentsController medicamentsController =
      Get.put(MedicamentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Corticoïdes Dates"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => Text(
                    DateFormat("dd-MM-yyyy")
                        .format(medicamentsController.corticioidesDate.value)
                        .toString(),
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      medicamentsController.selectCorticoidesDate(context),
                  child: const Text('Date pour les corticoïdes'),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text("Plaquenil Dates"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => Text(
                    "${medicamentsController.plaquenilDate1.value.hour}:${medicamentsController.plaquenilDate1.value.minute}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      medicamentsController.selectPlaquenilDate1(context),
                  child: const Text('Premiere date pour le plaquenil'),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => Text(
                    "${medicamentsController.plaquenilDate2.value.hour}:${medicamentsController.plaquenilDate2.value.minute}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      medicamentsController.selectPlaquenilDate2(context),
                  child: const Text('Deuxieme date pour le plaquenil'),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text("Azathioprine Dates"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => Text(
                    "${medicamentsController.azathioprineDate1.value.hour}:${medicamentsController.azathioprineDate1.value.minute}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      medicamentsController.selectAzathioprineDate1(context),
                  child: const Text('Premiere date pour l\'azathioprine'),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => Text(
                    "${medicamentsController.azathioprineDate2.value.hour}:${medicamentsController.azathioprineDate2.value.minute}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      medicamentsController.selectAzathioprineDate2(context),
                  child: const Text('Deuxieme date pour l\'azathioprine'),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => Text(
                    "${medicamentsController.azathioprineDate3.value.hour}:${medicamentsController.azathioprineDate3.value.minute}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      medicamentsController.selectAzathioprineDate3(context),
                  child: const Text('Troisieme date pour l\'azathioprine'),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text("Methotrxate Dates"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => Text(
                    DateFormat("dd-MM-yyyy")
                        .format(medicamentsController.methotrexateDate.value)
                        .toString(),
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      medicamentsController.selectMethotrexateDate(context),
                  child: const Text('Date pour le methotrexate'),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text("Foldine Dates"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  child: const Text('Date pour le foldine'),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text("MMF Dates"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  child: const Text('Premiere date de mmf'),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => Text(
                    "${medicamentsController.mmfDate2.value.hour}:${medicamentsController.mmfDate2.value.minute}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      medicamentsController.selectMmfDate2(context),
                  child: const Text('Deuxieme date de mmf'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
