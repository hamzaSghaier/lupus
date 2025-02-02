// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tunlup/custom_widgets/custom_app_bar.dart';
import 'package:tunlup/custom_widgets/custom_bottom_bar.dart';

class InfoLupusScreen extends StatelessWidget {
  const InfoLupusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewPlusExampleMainPage();
  }
}

class WebViewPlusExampleMainPage extends StatefulWidget {
  const WebViewPlusExampleMainPage({super.key});

  @override
  _WebViewPlusExampleMainPageState createState() =>
      _WebViewPlusExampleMainPageState();
}

class _WebViewPlusExampleMainPageState
    extends State<WebViewPlusExampleMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Informations\nمعلومات',
      ),
      bottomNavigationBar: CustomBottomBar(),
      body: Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: SfPdfViewer.asset('assets/about_lupus.pdf')
          /*
        WebViewPlus(
          zoomEnabled: true,
          onWebViewCreated: (controller) {
            controller.loadUrl('assets/lupus.html');
          },
          javascriptMode: JavascriptMode.unrestricted,
        ),
        */
          ),
    );
  }
}
