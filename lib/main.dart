import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_app/screens/dashboard.dart';
import 'package:hospital_app/screens/signup.dart';
import 'package:hospital_app/shared/file_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'entity/profile.dart';

void main() {
  Permission.notification.request();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: "lupus_notif_channel_key",
            channelName: "Notification Lupus channel",
            channelDescription: "Notification Lupus",
            defaultColor: Colors.purpleAccent,
            ledColor: Colors.white),
      ],
      debug: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lupus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 230, 0, 153)),
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
    super.initState();
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
                snapshot.data == null) {
              // If there is an error or no profile data, show SignUpScreen
              return const SignUpScreen();
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
