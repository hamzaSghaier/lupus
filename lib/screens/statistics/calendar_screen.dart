// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lupus_app/custom_widgets/custom_app_bar.dart';
import 'package:lupus_app/custom_widgets/custom_bottom_bar.dart';
import 'package:lupus_app/screens/statistics/rdv_model.dart';
import 'package:lupus_app/shared/file_service.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late List<RdvModel> _selectedEvents;
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
                  controller: titleController,
                  decoration: const InputDecoration(hintText: "Votre RDV"),
                ),
                TextField(
                  controller: rdvTypeController,
                  decoration: const InputDecoration(hintText: "Type RDV"),
                ),
                TextField(
                  controller: rdvDateController,
                  decoration:
                      const InputDecoration(hintText: "Prochaine consultation"),
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

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
