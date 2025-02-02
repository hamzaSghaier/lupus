// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tunlup/constants/colors.dart';
import 'package:tunlup/custom_widgets/custom_bottom_bar.dart';
import 'package:tunlup/screens/statistics/rdv_model.dart';
import 'package:tunlup/shared/file_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<RdvModel> _selectedEvents = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late Future<List<RdvModel>> _rdvsFuture;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _rdvsFuture = FileService.getRDVs();
    _rdvsFuture.then((value) {
      Map<DateTime, List<RdvModel>> kEventSource = {};

      for (var rdv in value) {
        DateTime date = rdv.date;

        if (kEventSource[date] == null) {
          kEventSource[date] = [];
        }
        kEventSource[date]!.add(rdv);
      }

      kEvents.addAll(kEventSource);
      _selectedEvents = _getEventsForDay(_selectedDay!);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<RdvModel> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<RdvModel> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.disabled;
      });

      _selectedEvents = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents = _getEventsForDay(end);
    }
  }

  final kEvents = LinkedHashMap<DateTime, List<RdvModel>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  final String _inputText = '';

  Future<void> _showInputDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController rdvTypeController = TextEditingController();
    TextEditingController rdvDateController = TextEditingController();

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(lastDateYear),
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
          title: const Text('Ajouter un RDV'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  textInputAction: TextInputAction.next,
                  controller: titleController,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "Votre RDV",
                  ),
                ),
                TextField(
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 14),
                  controller: rdvTypeController,
                  decoration: const InputDecoration(hintText: "Type RDV"),
                ),
                TextFormField(
                  style: const TextStyle(fontSize: 14),
                  controller: rdvDateController,
                  decoration:
                      const InputDecoration(hintText: "Prochaine consultation"),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    await selectDate(context);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ajouter'),
              onPressed: () async {
                var rdv = RdvModel(
                    title: titleController.text,
                    dateProchaineConsultation: rdvDateController.text,
                    type: rdvTypeController.text,
                    date: _selectedDay ?? _focusedDay);
                await FileService.writeFile(
                    "rdv.txt", jsonEncode(rdv.toJson()));

                setState(() {
                  _rdvsFuture = FileService.getRDVs();
                  _rdvsFuture.then((value) {
                    Map<DateTime, List<RdvModel>> kEventSource = {};

                    for (var rdv in value) {
                      DateTime date = rdv.date;

                      if (kEventSource[date] == null) {
                        kEventSource[date] = [];
                      }
                      kEventSource[date]!.add(rdv);
                    }

                    kEvents.addAll(kEventSource);
                    _selectedEvents = _getEventsForDay(_selectedDay!);
                  });
                });

                //one day before rdv at 10 AM
                var nDate = (_selectedDay ?? _focusedDay)
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
                      Navigator.of(context).pop();
                    },
                    btnOkIcon: Icons.check_circle,
                    onDismissCallback: (type) {
                      debugPrint('Dialog Dissmiss from callback $type');
                    },
                  ).show();
                });
              },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomBottomBar(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: FloatingActionButton(
              child: const Icon(
                Icons.add,
              ),
              onPressed: () async {
                _showInputDialog(context);
              }),
        ),
        body: FutureBuilder(
          future: _rdvsFuture,
          builder: (context, snapshot) {
            Map<DateTime, List<RdvModel>> kEventSource = {};
            if (snapshot.hasData) {
              for (var rdv in snapshot.data!) {
                DateTime date = rdv.date;

                if (kEventSource[date] == null) {
                  kEventSource[date] = [];
                }
                kEventSource[date]!.add(rdv);
              }

              kEvents.addAll(kEventSource);
            }
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TableCalendar<RdvModel>(
                  locale: "fr_FR",
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  daysOfWeekHeight: 50,
                  calendarStyle: const CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    todayDecoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(
                        color: Colors.pink, shape: BoxShape.circle),

                    outsideDaysVisible: true,
                  ),
                  onDaySelected: _onDaySelected,
                  onRangeSelected: _onRangeSelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
                const SizedBox(height: 8.0),
                Expanded(
                    child: ListView.builder(
                  itemCount: _selectedEvents.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        border: Border.all(
                          color: const Color.fromRGBO(232, 232, 232, 1),
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                        onTap: () => print('${_selectedEvents[index]}'),
                        title: Text(_selectedEvents[index].title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bilan : ${_selectedEvents[index].type}"),
                            Text(
                                "Date Consultation : ${_selectedEvents[index].dateProchaineConsultation}")
                          ],
                        ),
                      ),
                    );
                  },
                )),
              ],
            );
          },
        ));
  }
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
Map<DateTime, List<RdvModel>> _kEventSource = {};

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
