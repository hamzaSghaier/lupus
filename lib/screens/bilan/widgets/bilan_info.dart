import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lupus_app/constants/colors.dart';
import 'package:lupus_app/constants/icons.dart';
import 'package:lupus_app/screens/bilan/models/bilan_model.dart';
import 'package:lupus_app/shared/file_service.dart';

class BilanInfo extends StatefulWidget {
  const BilanInfo({
    super.key,
    required this.mediaQuery,
    required this.index,
    required this.bilan,
  });

  final MediaQueryData mediaQuery;
  final int index;
  final BilanModel bilan;

  @override
  State<BilanInfo> createState() => _BilanInfoState();
}

class _BilanInfoState extends State<BilanInfo> {
  late List<CameraDescription> _cameras;

  CameraController? controller;

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    controller = CameraController(
      // Get a specific camera from the list of available cameras.
      _cameras.first,
      // Define the resolution to use.
      ResolutionPreset.max,
    );
  }

  @override
  void initState() {
    initCamera();
    super.initState();
  }

  BuildContext? outerContext;

  @override
  Widget build(BuildContext context) {
    final GlobalKey alertKey = GlobalKey();
    outerContext = context;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.grey.withAlpha(30),
                style: BorderStyle.solid,
                width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                "Bilan ${widget.index}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            */
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              height: widget.mediaQuery.size.height * 0.07,
              decoration: const BoxDecoration(
                  color: lightPink,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.bilan.type ?? ""),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: pink,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                key: alertKey,
                                title: Center(
                                  child: Text(
                                    widget.bilan.type ?? "",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                content: FutureBuilder<void>(
                                  future: controller?.initialize(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      // If the Future is complete, display the preview.
                                      return SizedBox(
                                        height:
                                            widget.mediaQuery.size.height * 0.5,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            CameraPreview(controller!),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    // Take the Picture in a try / catch block. If anything goes wrong,
                                                    // catch the error.
                                                    try {
                                                      // Ensure that the camera is initialized.

                                                      // Attempt to take a picture and then get the location
                                                      // where the image file is saved.
                                                      final image =
                                                          await controller
                                                              ?.takePicture();

                                                      Uint8List? bytes =
                                                          await image!
                                                              .readAsBytes();

                                                      String img64 =
                                                          base64Encode(bytes);
                                                      BilanModel newBilan =
                                                          widget.bilan;
                                                      newBilan.done = true;
                                                      newBilan.image =
                                                          image.path;
                                                      await FileService
                                                          .updateBilan(
                                                              newBilan);

                                                      Navigator.pop(context);

                                                      AwesomeDialog(
                                                          context:
                                                              outerContext!,
                                                          dialogType: DialogType
                                                              .success,
                                                          body: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20.0),
                                                            child: Text(
                                                              "Photo Sauvegardée !\nتم حفظ الصورة!",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          )).show();
                                                    } catch (e) {
                                                      // If an error occurs, log the error to the console.
                                                      print(e);
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape: const CircleBorder(),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    backgroundColor: Colors
                                                        .pinkAccent, // <-- Button color
                                                    foregroundColor: Colors
                                                        .red, // <-- Splash color
                                                  ),
                                                  child: const Icon(
                                                      Icons.camera_alt_rounded,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    } else {
                                      // Otherwise, display a loading indicator.
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              );
                            },
                          ).then((onValue) {
                            controller?.dispose();
                            initCamera();
                          });
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.document_scanner,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Photo | صورة",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                decoration: const BoxDecoration(
                  color: grey,
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(calendarIcon),
                    SizedBox(
                      width: widget.mediaQuery.size.width * 0.02,
                    ),
                    Text(widget.bilan.date ?? "")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
