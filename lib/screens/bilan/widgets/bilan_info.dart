import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:tulup/constants/colors.dart';
import 'package:tulup/screens/bilan/models/bilan_model.dart';
import 'package:tulup/shared/file_service.dart';

class BilanInfo extends StatefulWidget {
  const BilanInfo({
    super.key,
    required this.mediaQuery,
    required this.index,
    required this.bilan,
    required this.reload,
  });

  final MediaQueryData mediaQuery;
  final int index;
  final BilanModel bilan;
  final Function reload;

  @override
  State<BilanInfo> createState() => _BilanInfoState();
}

class _BilanInfoState extends State<BilanInfo> {
  List<CameraDescription>? _cameras;
  CameraController? controller;
  bool hasReminder = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        controller = CameraController(
          _cameras!.first,
          ResolutionPreset.max,
          enableAudio: false,
        );
        controller?.setFlashMode(FlashMode.off);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Aucune caméra trouvée sur cet appareil')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur d\'initialisation de la caméra: $e')),
        );
      }
    }
  }

  Future<void> initNotifications() async {
    // Initialize settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize settings for iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      //   // Handle iOS notification when app is in foreground
      // },
    );

    // Complete initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
      },
    );
  }

  Future<void> scheduleReminder() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'bilan_reminders',
      'Rappels de bilan',
      channelDescription: 'Notifications pour les rappels de bilan',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      widget.index,
      'Rappel de bilan',
      'N\'oubliez pas votre ${widget.bilan.type}',
      platformChannelSpecifics,
    );
  }

  @override
  void initState() {
    super.initState();
    initCamera();
    initNotifications();
    hasReminder = widget.bilan.hasReminder ?? false;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> takePicture(BuildContext context) async {
    final imagesList = widget.bilan.images ?? [];
    if (imagesList.length >= 4) {
      // Changed from 2 to 4
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Maximum 4 photos par bilan')), // Updated message
      );
      return;
    }
    XFile? image;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Je prends une photo de mon bilan\nتصوير الفحص الطبي',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Annuler | إلغاء",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          content: FutureBuilder<void>(
            future: controller?.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                controller?.setFlashMode(FlashMode.off);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: widget.mediaQuery.size.height * 0.5,
                      child: CameraPreview(
                        controller!,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: seedColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                    onPressed: () async {
                                      image = await controller?.takePicture();
                                      controller?.pausePreview();
                                    },
                                    icon: Icon(
                                      Icons.camera_alt,
                                      size: 36,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                            onPressed: () async {
                              await controller?.initialize();
                              await controller?.setFlashMode(FlashMode.off);
                              await controller?.resumePreview();
                            },
                            child: const Text(
                              "Réessayer | أعد",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: confirmColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                            onPressed: () async {
                              try {
                                //image = await controller?.takePicture();
                                if (image == null)
                                  return;
                                else {
                                  BilanModel newBilan = widget.bilan;
                                  newBilan.images ??= [];
                                  newBilan.images!.add(image!.path);
                                  await FileService.updateBilan(newBilan);

                                  Navigator.pop(context);

                                  setState(() {});
                                }

                                // Refresh the UI
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Erreur: $e')),
                                );
                              }
                            },
                            child: const Text(
                              "Confirmer | تأكيد",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagesList = widget.bilan.images ?? [];

    return Card(
      elevation: 2,
      surfaceTintColor: Colors.grey,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.bilan.type ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.bilan.date ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        direction: Axis.horizontal,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: confirmColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                            onPressed: hasReminder
                                ? null
                                : () async {
                                    setState(() {
                                      hasReminder = !hasReminder;
                                    });

                                    BilanModel newBilan = widget.bilan;
                                    newBilan.hasReminder = hasReminder;
                                    await FileService.updateBilan(newBilan);

                                    if (hasReminder) {
                                      await scheduleReminder();
                                    }
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  hasReminder
                                      ? Icons.notifications_active
                                      : Icons.notifications_none,
                                  color:
                                      hasReminder ? Colors.green : Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Rappel | تذكير",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          // IconButton(
                          //   icon: const Icon(Icons.camera_alt),
                          //   onPressed: () => takePicture(context),
                          // ),
                          // Text(
                          //     '${imagesList.length}/4 photos'), // Updated to show 4
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: seedColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                              onPressed: imagesList.isEmpty
                                  ? null
                                  : () async {
                                      BilanModel newBilan = widget.bilan;
                                      newBilan.done = true;
                                      await FileService.updateBilan(newBilan);
                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.leftSlide,
                                        headerAnimationLoop: false,
                                        dialogType: DialogType.success,
                                        showCloseIcon: true,
                                        title: ' ',
                                        desc:
                                            "Saisie de bilan terminée avec succès\nتم إدخال الفحص بنجاح",
                                        btnOkOnPress: () {
                                          widget.reload();
                                        },
                                        btnOkIcon: Icons.check_circle,
                                      ).show();
                                    },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.done, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    "Terminer | إنهاء",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              // Using Wrap instead of SingleChildScrollView for better layout
              spacing: 8,
              runSpacing: 8,
              children: [
                ...List.generate(imagesList.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BilanImagesGallery(
                            imagePaths: imagesList,
                            initialIndex: index,
                            title: widget.bilan.type ?? '',
                            date: widget.bilan.date ?? '',
                          ),
                        ),
                      );
                    },
                    child: _buildImageThumbnail(imagesList[index]),
                  );
                }),
                ...List.generate(4 - imagesList.length, (index) {
                  // Changed from 2 to 4
                  return GestureDetector(
                    onTap: index != 0 ? null : () => takePicture(context),
                    child: _buildImagePlaceholder(),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods (unchanged)
  Widget _buildImagePlaceholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade100,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined,
              size: 30, color: Colors.grey),
          SizedBox(height: 4),
          Text(
            'Ajouter photo',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImageThumbnail(String imagePath) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.zoom_in,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BilanImageView extends StatelessWidget {
  final String imagePath;

  const BilanImageView({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PhotoView(
        imageProvider: FileImage(File(imagePath)),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        initialScale: PhotoViewComputedScale.contained,
      ),
    );
  }
}

class BilanImagesGallery extends StatelessWidget {
  final List<String> imagePaths;
  final int initialIndex;
  final String title;
  final String date;

  const BilanImagesGallery({
    super.key,
    required this.imagePaths,
    required this.title,
    required this.date,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("$title - $date"),
        backgroundColor: Colors.white,
      ),
      body: imagePaths.isEmpty
          ? const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                ),
                Text(
                  'Aucune photo disponible',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ))
          : PhotoViewGallery.builder(
              itemCount: imagePaths.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: FileImage(File(imagePaths[index])),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  initialScale: PhotoViewComputedScale.contained,
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              pageController: PageController(initialPage: initialIndex),
            ),
    );
  }
}
