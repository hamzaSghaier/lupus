import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:lupus_app/constants/colors.dart';
import 'package:lupus_app/constants/icons.dart';
import 'package:lupus_app/screens/statistics/rdv_model.dart';
import 'package:lupus_app/shared/file_service.dart';

class RdvWidget extends StatefulWidget {
  const RdvWidget(
      {super.key,
      required this.mediaQuery,
      required this.rdv,
      required this.hasRdv,
      required this.update});

  final MediaQueryData mediaQuery;

  final RdvModel? rdv;

  final bool hasRdv;

  final Function update;

  @override
  State<RdvWidget> createState() => _RdvWidgetState();
}

class _RdvWidgetState extends State<RdvWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.all(10),
        height: widget.mediaQuery.size.height * 0.1,
        decoration: BoxDecoration(
            color: grey,
            border: Border.all(color: greyContour),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: widget.hasRdv
            ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Image(
                    image: AssetImage(rdvIcon),
                    height: 50,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.rdv?.title ?? "--"),
                    Text(widget.rdv?.dateProchaineConsultation ?? "--/--/----")
                  ],
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      _showEditDialog(context);
                    },
                    icon: const Icon(Icons.edit_calendar_outlined))
              ])
            : InkWell(
                enableFeedback: true,
                onTap: () {},
                child: InkWell(
                  onTap: () {
                    _showInputDialog(context);
                  },
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Image(
                            image: AssetImage(rdvPlusIcon),
                            height: 60,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Ajouter un RDV"),
                            Text("أضف موعدًا")
                          ],
                        )
                      ]),
                ),
              ));
  }

  Future<void> _showInputDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController rdvTypeController = TextEditingController();
    TextEditingController rdvDateController = TextEditingController();

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              textTheme: const TextTheme(
                headlineMedium: TextStyle(fontSize: 15.0), // Selected date text
                titleMedium: TextStyle(fontSize: 16.0), // Calendar header text
                bodyMedium: TextStyle(fontSize: 14.0), // Calendar days
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        setState(() {
          rdvDateController.text = "${picked.toLocal()}".split(' ')[0];
        });
      }
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Ajouter un RDV\nأضف موعدًا',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  textInputAction: TextInputAction.next,
                  controller: titleController,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "Votre RDV | موعدك",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 14),
                  controller: rdvTypeController,
                  decoration:
                      const InputDecoration(hintText: "Type RDV | نوع الموعد"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: const TextStyle(fontSize: 14),
                  controller: rdvDateController,
                  decoration: const InputDecoration(hintText: "Date | التاريخ"),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    await selectDate(context);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Annuler | إلغاء",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: pink,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              onPressed: () async {
                var rdv = RdvModel(
                    title: titleController.text,
                    dateProchaineConsultation: rdvDateController.text,
                    type: rdvTypeController.text,
                    date: DateTime.parse(rdvDateController.text));
                await FileService.writeFile(
                    "rdv.txt", jsonEncode(rdv.toJson()));

                //one day before rdv at 10 AM
                var nDate = (DateTime.parse(rdvDateController.text))
                    .subtract(const Duration(days: 1));
                var finalDate = DateTime(
                  nDate.year,
                  nDate.month,
                  nDate.day,
                  10,
                );
                _scheduleNotification(
                    rdv.title,
                    "Votre RDV ${rdv.title} est planifié le ${rdv.date}\nBilan : ${rdv.type}\nDate Prochaine Consult. : ${rdv.dateProchaineConsultation}",
                    rdv.hashCode,
                    finalDate);
                Future.delayed(Duration.zero, () {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.leftSlide,
                    headerAnimationLoop: false,
                    dialogType: DialogType.success,
                    showCloseIcon: true,
                    title: ' ',
                    desc: 'Rappel enregistré ! \n !تم تسجيل التذكير',
                    btnOkOnPress: () {
                      debugPrint('OnClcik');
                      widget.update();
                      Navigator.of(context).pop();
                    },
                    btnOkIcon: Icons.check_circle,
                    onDismissCallback: (type) {
                      debugPrint('Dialog Dissmiss from callback $type');
                    },
                  ).show();
                });
              },
              child: const Text(
                "Ajouter | إضافة",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController rdvTypeController = TextEditingController();
    TextEditingController rdvDateController = TextEditingController();

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.rdv?.date,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              textTheme: const TextTheme(
                headlineMedium: TextStyle(fontSize: 15.0), // Selected date text
                titleMedium: TextStyle(fontSize: 16.0), // Calendar header text
                bodyMedium: TextStyle(fontSize: 14.0), // Calendar days
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        setState(() {
          rdvDateController.text = "${picked.toLocal()}".split(' ')[0];
        });
      }
    }

    titleController.text = widget.rdv?.title ?? "";
    rdvDateController.text = widget.rdv?.dateProchaineConsultation ?? "";
    rdvTypeController.text = widget.rdv?.type ?? "";

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Modifier le RDV\nتعديل الموعد',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  textInputAction: TextInputAction.next,
                  controller: titleController,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "Votre RDV | موعدك",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 14),
                  controller: rdvTypeController,
                  decoration:
                      const InputDecoration(hintText: "Type RDV | نوع الموعد"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: const TextStyle(fontSize: 14),
                  controller: rdvDateController,
                  decoration: const InputDecoration(hintText: "Date | التاريخ"),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    await selectDate(context);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Annuler | إلغاء",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: pink,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              onPressed: () async {
                var rdv = RdvModel(
                    id: hashCode,
                    title: titleController.text,
                    dateProchaineConsultation: rdvDateController.text,
                    type: rdvTypeController.text,
                    date: DateTime.parse(rdvDateController.text));
                await FileService.updateFile(
                    "rdv.txt", jsonEncode(rdv.toJson()));

                //one day before rdv at 10 AM
                var nDate = (DateTime.parse(rdvDateController.text))
                    .subtract(const Duration(days: 1));
                var finalDate = DateTime(
                  nDate.year,
                  nDate.month,
                  nDate.day,
                  10,
                );

                await AwesomeNotifications().cancel(rdv.id ?? hashCode);

                _scheduleNotification(
                    rdv.title,
                    "Votre RDV ${rdv.title} est planifié le ${rdv.date}\nBilan : ${rdv.type}\nDate Prochaine Consult. : ${rdv.dateProchaineConsultation}",
                    rdv.id ?? hashCode,
                    finalDate);
                Future.delayed(Duration.zero, () {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.leftSlide,
                    headerAnimationLoop: false,
                    dialogType: DialogType.success,
                    showCloseIcon: true,
                    title: ' ',
                    desc: 'Rappel enregistré ! \n !تم تسجيل التذكير',
                    btnOkOnPress: () {
                      debugPrint('OnClcik');
                      widget.update();
                      Navigator.of(context).pop();
                    },
                    btnOkIcon: Icons.check_circle,
                    onDismissCallback: (type) {
                      debugPrint('Dialog Dissmiss from callback $type');
                    },
                  ).show();
                });
              },
              child: const Text(
                "Valider | تأكيد",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _scheduleNotification(
    String title,
    String body,
    int id,
    DateTime date,
  ) {
    NotificationSchedule schedule;

    schedule = NotificationCalendar.fromDate(
      repeats: true,
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
            channelKey: "lupus_notif_channel_key",
            title: title,
            body: body,
          ),
          schedule: schedule,
        )
        .then((value) => print("notif value : $value"))
        .catchError((e) {
      print("Error creating notification: $e");
    });
  }
}
