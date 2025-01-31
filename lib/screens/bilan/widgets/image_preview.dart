import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lupus_app/custom_widgets/custom_app_bar.dart';
import 'package:widget_zoom/widget_zoom.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({super.key, required this.path, required this.type, required this.date});
  final String path;
  final String type;
  final String date;
  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.white));
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: '${widget.type}\n${widget.date}',
      ),
      body: widget.path == ''
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, size: 50, color: Colors.grey),
                  SizedBox(height: 4),
                  Text(
                    'Pas de photo',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Center(
              child: WidgetZoom(
                heroAnimationTag: 'tag',
                zoomWidget: Image.file(File(widget.path)),
              ),
            ),
    ));
  }
}
