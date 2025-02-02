import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunlup/constants/colors.dart';

class MedicamentsController extends GetxController {
  var corticioidesDate = DateTime.now().obs;
  var plaquenilDate1 = const TimeOfDay(hour: 00, minute: 00).obs;
  var plaquenilDate2 = const TimeOfDay(hour: 00, minute: 00).obs;
  var azathioprineDate1 = const TimeOfDay(hour: 00, minute: 00).obs;
  var azathioprineDate2 = const TimeOfDay(hour: 00, minute: 00).obs;
  var azathioprineDate3 = const TimeOfDay(hour: 00, minute: 00).obs;
  var methotrexateDate = DateTime.now().obs;
  var foldineDate = DateTime.now().obs;
  var mmfDate1 = const TimeOfDay(hour: 00, minute: 00).obs;
  var mmfDate2 = const TimeOfDay(hour: 00, minute: 00).obs;

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
          date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        hour!,
        minute!,
      ));
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

  Future<void> selectCorticoidesDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: corticioidesDate.value,
      firstDate: DateTime.now(),
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

    if (picked != null && picked != corticioidesDate.value) {
      corticioidesDate.value = DateTime(picked.year, picked.month, picked.day);

      _scheduleNotification(
        "Corticoides",
        "Il est temps de prendre vos corticoides",
        10,
        null,
        null,
        corticioidesDate.value,
      );
    }
  }

  Future<void> selectPlaquenilDate1(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: plaquenilDate1.value,
    );

    if (picked != null && picked != plaquenilDate1.value) {
      plaquenilDate1.value =
          TimeOfDay(hour: picked.hour, minute: picked.minute);

      _scheduleNotification(
        "Plaquenil",
        "Il est temps de prendre vos plaquenil",
        11,
        plaquenilDate1.value.hour,
        plaquenilDate1.value.minute,
        null,
      );
    }
  }

  Future<void> selectPlaquenilDate2(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: plaquenilDate2.value,
    );

    if (picked != null && picked != plaquenilDate2.value) {
      plaquenilDate2.value =
          TimeOfDay(hour: picked.hour, minute: picked.minute);

      _scheduleNotification(
        "Plaquenil",
        "Il est temps de prendre vos plaquenil",
        12,
        plaquenilDate2.value.hour,
        plaquenilDate2.value.minute,
        null,
      );
    }
  }

  Future<void> selectAzathioprineDate1(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: azathioprineDate1.value,
    );

    if (picked != null && picked != azathioprineDate1.value) {
      azathioprineDate1.value =
          TimeOfDay(hour: picked.hour, minute: picked.minute);

      _scheduleNotification(
        "Azathioprine",
        "Il est temps de prendre vos azathioprine",
        13,
        azathioprineDate1.value.hour,
        azathioprineDate1.value.minute,
        null,
      );
    }
  }

  Future<void> selectAzathioprineDate2(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: azathioprineDate2.value,
    );

    if (picked != null && picked != azathioprineDate2.value) {
      azathioprineDate2.value =
          TimeOfDay(hour: picked.hour, minute: picked.minute);

      _scheduleNotification(
        "Azathioprine",
        "Il est temps de prendre vos azathioprine",
        14,
        azathioprineDate2.value.hour,
        azathioprineDate2.value.minute,
        null,
      );
    }
  }

  Future<void> selectAzathioprineDate3(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: azathioprineDate3.value,
    );

    if (picked != null && picked != azathioprineDate3.value) {
      azathioprineDate3.value =
          TimeOfDay(hour: picked.hour, minute: picked.minute);

      _scheduleNotification(
        "Azathioprine",
        "Il est temps de prendre vos azathioprine",
        15,
        azathioprineDate3.value.hour,
        azathioprineDate3.value.minute,
        null,
      );
    }
  }

  Future<void> selectMethotrexateDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: methotrexateDate.value,
      firstDate: DateTime.now(),
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

    if (picked != null && picked != methotrexateDate.value) {
      methotrexateDate.value = DateTime(picked.year, picked.month, picked.day);

      _scheduleNotification(
        "Methotrexate",
        "Il est temps de prendre vos methotrexate",
        16,
        null,
        null,
        methotrexateDate.value,
      );
    }
  }

  Future<void> selectFoldineDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: foldineDate.value,
      firstDate: DateTime.now(),
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

    if (picked != null && picked != foldineDate.value) {
      foldineDate.value = DateTime(picked.year, picked.month, picked.day);

      _scheduleNotification(
        "Foldine",
        "Il est temps de prendre vos foldine",
        17,
        null,
        null,
        foldineDate.value,
      );
    }
  }

  Future<void> selectMmfDate1(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: mmfDate1.value,
    );

    if (picked != null && picked != mmfDate1.value) {
      mmfDate1.value = TimeOfDay(hour: picked.hour, minute: picked.minute);

      _scheduleNotification(
        "MMF",
        "Il est temps de prendre vos MMF",
        18,
        mmfDate1.value.hour,
        mmfDate1.value.minute,
        null,
      );
    }
  }

  Future<void> selectMmfDate2(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: mmfDate2.value,
    );

    if (picked != null && picked != mmfDate2.value) {
      mmfDate2.value = TimeOfDay(hour: picked.hour, minute: picked.minute);

      _scheduleNotification(
        "MMF",
        "Il est temps de prendre vos MMF",
        19,
        mmfDate2.value.hour,
        mmfDate2.value.minute,
        null,
      );
    }
  }
}
