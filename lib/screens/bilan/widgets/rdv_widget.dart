import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tulup/constants/colors.dart';
import 'package:tulup/constants/icons.dart';
import 'package:tulup/screens/statistics/rdv_model.dart';
import 'package:tulup/shared/file_service.dart';

class RdvWidget extends StatefulWidget {
  const RdvWidget({
    super.key,
    required this.mediaQuery,
    required this.rdvs,
    required this.hasRdv,
    required this.update,
  });

  final MediaQueryData mediaQuery;
  final List<RdvModel> rdvs;
  final bool hasRdv;
  final Function update;

  @override
  State<RdvWidget> createState() => _RdvWidgetState();
}

class _RdvWidgetState extends State<RdvWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 1),
              child: Text(
                'RDV de consultation\nموعد العيادة',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
                textAlign: TextAlign.center,
              ),
            ),
            // Main Consultation Appointments
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              //
              decoration: BoxDecoration(
                color: grey,
                border: Border.all(color: greyContour),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  // List of consultation appointments
                  ...widget.rdvs
                      .where((rdv) => rdv.type == "Consultation")
                      .map((rdv) => _buildRdvItem(rdv)),
                  // Add button if no consultation appointments
                  if (!widget.hasRdv)
                    InkWell(
                      onTap: () => _showInputDialog(context, "Consultation"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                            ),
                          ],
                          border: Border.all(color: greyContour),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Ajouter un RDV",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "أضف موعدًا",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Image(
                                image: AssetImage(rdvPlusIcon),
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Other Appointments Button

            // Other Appointments List
            if (widget.rdvs.any((rdv) => rdv.type != "Consultation"))
              Container(
                padding: const EdgeInsets.all(1),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.rdvs
                      .where((rdv) => rdv.type != "Consultation")
                      .map((rdv) => _buildRdvItem(rdv))
                      .toList(),
                ),
              ),
            if (widget.hasRdv)
              ElevatedButton.icon(
                onPressed: () => _showInputDialog(context, "Autre"),
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 24,
                  color: Colors.white,
                ),
                label: const Text("Autres RDVs\nمواعيد أخرى",
                    textAlign: TextAlign.center),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, RdvModel rdv) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer le RDV?\nحذف الموعد؟',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
          content: const Text(
              'Cette action ne peut pas être annulée.\nلا يمكن التراجع عن هذا الإجراء.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
          actions: [
            TextButton(
              child: const Text(
                'Annuler | إلغاء',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Supprimer | حذف',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                try {
                  await FileService.deleteRdv(rdv);
                  widget.update(); // Refresh the list
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'RDV supprimé avec succès\nتم حذف الموعد بنجاح',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 12),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  debugPrint('Error during deletion: $e');
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Erreur lors de la suppression\nخطأ أثناء الحذف',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        backgroundColor: Colors.red,
                        action: SnackBarAction(
                          label: 'OK',
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRdvItem(RdvModel rdv) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          ListTile(
            leading: const Image(
              image: AssetImage(rdvIcon),
              height: 40,
            ),
            title: Text(rdv.title,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 12)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rdv.type,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 12)),
                Text(DateFormat('dd-MM-yyyy').format(rdv.date),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (rdv.id != null)
                const Icon(
                  Icons.notifications_active,
                  color: Colors.green,
                  size: 20,
                ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: rdv.date,
                    firstDate: DateTime(firstDateYear),
                    lastDate: DateTime(lastDateYear),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData(
                          textTheme: const TextTheme(
                            headlineMedium:
                                TextStyle(fontSize: 12.0), // Selected date text
                            titleMedium: TextStyle(
                                fontSize: 13.0), // Calendar header text
                            bodyMedium:
                                TextStyle(fontSize: 12.0), // Calendar days
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    RdvModel updatedRdv = RdvModel(
                      id: rdv.id,
                      date: picked,
                      title: rdv.title,
                      type: rdv.type,
                      dateProchaineConsultation:
                          DateFormat('dd-MM-yyyy').format(picked),
                    );
                    await _updateRdv(updatedRdv);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditDialog(context, rdv),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
                onPressed: () => _showDeleteConfirmation(context, rdv),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _updateRdv(RdvModel rdv) async {
    await FileService.updateFile("rdv.txt", jsonEncode(rdv.toJson()));
    await _scheduleNotification(rdv);
    widget.update();
  }

  Future<void> _showInputDialog(BuildContext context, String type) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController rdvTypeController = TextEditingController();
    TextEditingController rdvDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          type == "Consultation"
              ? 'Ajouter un RDV\nأضف موعدًا'
              : 'Ajouter un autre RDV\nأضف موعدًا آخر',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 12),
                decoration: const InputDecoration(
                  labelText: "Titre | العنوان",
                ),
              ),
              if (type != "Consultation")
                TextField(
                  controller: rdvTypeController,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 12),
                  decoration: const InputDecoration(
                    labelText: "Type de RDV | نوع الموعد",
                  ),
                ),
              TextFormField(
                controller: rdvDateController,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 12),
                decoration: const InputDecoration(
                  labelText: "Date | التاريخ",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context, rdvDateController),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text('Annuler | إلغاء',
                style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () async {
              if (titleController.text.isEmpty ||
                  rdvDateController.text.isEmpty) {
                return;
              }

              final rdv = RdvModel(
                id: DateTime.now().millisecondsSinceEpoch % 100000,
                date: DateTime.parse(rdvDateController.text),
                title: titleController.text,
                type: rdvTypeController.text,
                dateProchaineConsultation: rdvDateController.text,
              );

              await FileService.writeFile("rdv.txt", jsonEncode(rdv.toJson()));

              widget.update();
              Navigator.pop(context);

              _showSuccessDialog();
              await _scheduleNotification(rdv);
            },
            child: const Text('Ajouter | إضافة',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(firstDateYear),
      lastDate: DateTime(lastDateYear),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            textTheme: const TextTheme(
              headlineMedium: TextStyle(fontSize: 12.0), // Selected date text
              titleMedium: TextStyle(fontSize: 13.0), // Calendar header text
              bodyMedium: TextStyle(fontSize: 12.0), // Calendar days
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _scheduleNotification(RdvModel rdv) async {
    var notificationDate = rdv.date.subtract(const Duration(days: 1));
    notificationDate = DateTime(
      notificationDate.year,
      notificationDate.month,
      notificationDate.day,
      10, // 10 AM
    );

    // Generate a smaller, unique ID
    final notificationId = rdv.id?.abs() ??
        (DateTime.now().millisecondsSinceEpoch % 100000); // Keep last 5 digits

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: "tulup_notif_channel_key",
        title: rdv.title,
        body:
            "Rappel: Vous avez un rendez-vous ${rdv.type} demain à ${rdv.dateProchaineConsultation}",
        category: NotificationCategory.Reminder,
        displayOnBackground: true,
        displayOnForeground: true,
        wakeUpScreen: true,
      ),
      schedule: NotificationCalendar.fromDate(
        date: notificationDate,
        preciseAlarm: true,
        allowWhileIdle: true,
        repeats: false,
      ),
    );
  }

  void _showSuccessDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Succès',
      desc: 'RDV ajouté avec succès!\nتمت إضافة الموعد بنجاح!',
      btnOkOnPress: () {},
    ).show();
  }

  Future<void> _showEditDialog(BuildContext context, RdvModel rdv) async {
    TextEditingController titleController =
        TextEditingController(text: rdv.title);
    TextEditingController typeController =
        TextEditingController(text: rdv.type);
    TextEditingController dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(rdv.date),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Modifier le RDV\nتعديل الموعد',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 12),
                decoration: const InputDecoration(labelText: "Titre | العنوان"),
              ),
              if (rdv.type != "Consultation")
                TextField(
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 12),
                  controller: typeController,
                  decoration: const InputDecoration(labelText: "Type | النوع"),
                ),
              TextFormField(
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 12),
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Date | التاريخ",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context, dateController),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () async {
              if (titleController.text.isEmpty || dateController.text.isEmpty) {
                return;
              }

              final updatedRdv = RdvModel(
                id: rdv.id,
                date: DateTime.parse(dateController.text),
                title: titleController.text,
                type: typeController.text,
                dateProchaineConsultation: dateController.text,
              );

              await _updateRdv(updatedRdv);
              Navigator.pop(context);
              _showSuccessDialog();
            },
            child: const Text('Modifier | تعديل',
                style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler | إلغاء',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
