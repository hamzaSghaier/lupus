import 'package:flutter/material.dart';
import 'package:hospital_app/custom_widgets/custom_app_bar.dart';
import 'package:hospital_app/custom_widgets/custom_bottom_bar.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class InfoLupusScreen extends StatelessWidget {
  const InfoLupusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WebViewPlusExampleMainPage();
  }
}

class WebViewPlusExampleMainPage extends StatefulWidget {
  const WebViewPlusExampleMainPage({Key? key}) : super(key: key);

  @override
  _WebViewPlusExampleMainPageState createState() =>
      _WebViewPlusExampleMainPageState();
}

class _WebViewPlusExampleMainPageState
    extends State<WebViewPlusExampleMainPage> {
  WebViewPlusController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'A propos',
      ),
      bottomNavigationBar: CustomBottomBar(),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WebViewPlus(
              zoomEnabled: true,
              onWebViewCreated: (controller) {
                controller.loadUrl('assets/lupus.html');
              },
              javascriptMode: JavascriptMode.unrestricted,
            ),
          )
        ],
      ),
    );
  }
}
