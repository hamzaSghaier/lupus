import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tulup/constants/colors.dart';
import 'package:tulup/screens/dashboard.dart';
import 'package:tulup/screens/login.dart';
import 'package:tulup/shared/file_service.dart';

import 'entity/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.request();
  await initializeNotifications();

  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

Future<void> initializeNotifications() async {
  List<String> medicaments = [
    "CORTICOÏDES",
    "PLAQUENIL",
    "AZATHIOPRINE",
    "METHOTREXATE",
    "FOLDINE",
    "MMF",
  ];
  List<NotificationChannel> channels = medicaments.map((medicament) {
    return NotificationChannel(
      channelKey: "${medicament.toLowerCase().replaceAll(" ", "_")}_channel",
      channelName: "$medicament Notifications",
      channelDescription: "Notifications for $medicament",
      playSound: true,
      defaultPrivacy: NotificationPrivacy.Public,
      defaultRingtoneType: DefaultRingtoneType.Alarm,
      enableLights: true,
      importance: NotificationImportance.Max,
      enableVibration: true,
      defaultColor: Colors.pink[200],
      ledColor: Colors.pink[200],
    );
  }).toList();

  //Default channel
  channels.add(
    NotificationChannel(
        channelKey: "tulup_notif_channel_key",
        playSound: true,
        defaultPrivacy: NotificationPrivacy.Public,
        defaultRingtoneType: DefaultRingtoneType.Alarm,
        //icon: "assets/lupus-icon.png",
        enableLights: true,
        importance: NotificationImportance.Max,
        enableVibration: true,
        channelName: "Notification Tulup channel",
        channelDescription: "Notification Tulup",
        defaultColor: Colors.pink[200],
        ledColor: Colors.pink[200]),
  );

  await AwesomeNotifications().initialize(null, channels, debug: false);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tulup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(fontSize: 16.0),
          errorStyle: TextStyle(fontSize: 12.0),
        ),
        textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 24.0),
            bodySmall: TextStyle(fontSize: 18.0),
            headlineSmall: TextStyle(fontSize: 16.0),
            labelLarge: TextStyle(fontSize: 14.0),
            bodyMedium: TextStyle(fontSize: 18.0)),
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Profile?>? profileFuture;

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    profileFuture = FileService.getProfile();
    disableBattaryOptimization();
    super.initState();
  }

  void disableBattaryOptimization() {
    DisableBatteryOptimization.showDisableAllOptimizationsSettings(
        "Enable Auto Start",
        "Follow the steps and enable the auto start of this app",
        "Your device has additional battery optimization",
        "Follow the steps and disable the optimizations to allow smooth functioning of this app");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: CustomBottomBar(),
      body: SafeArea(
        child: FutureBuilder<Profile?>(
          future: profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While loading profile, show a loading indicator
              return const CircularProgressIndicator();
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data?.isLoggedIn == false) {
              // If there is an error or no profile data, show SignUpScreen
              return const LoginScreen();
            } else {
              // If profile data exists, show DashboardScreen
              return const DashboardScreen();
            }
          },
        ),
      ),
    );
  }
}
