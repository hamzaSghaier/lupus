import 'package:flutter/material.dart';
import 'package:hospital_app/custom_widgets/custom_app_bar.dart';
import 'package:hospital_app/custom_widgets/custom_bottom_bar.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class InfoLupusScreen extends StatelessWidget {
  const InfoLupusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebViewPlusExampleMainPage();
  }
}

class WebViewPlusExampleMainPage extends StatefulWidget {
  const WebViewPlusExampleMainPage({Key? key}) : super(key: key);

  @override
  _WebViewPlusExampleMainPageState createState() => _WebViewPlusExampleMainPageState();
}

class _WebViewPlusExampleMainPageState extends State<WebViewPlusExampleMainPage> {
  WebViewPlusController? _controller;
  double _height = 1;

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
            height: _height,
            child: WebViewPlus(
              serverPort: 5353,
              javascriptChannels: null,
              initialUrl: 'assets/lupus.html',
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onPageFinished: (url) {
                _controller?.getHeight().then((double height) {
                  debugPrint("Height: " + height.toString());
                  setState(() {
                    _height = height;
                  });
                });
              },
              javascriptMode: JavascriptMode.unrestricted,
            ),
          )
        ],
      ),
    );
  }
}
