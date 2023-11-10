import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String url;
  final String title;
  final double height;

  const CustomWebView({
    super.key,
    required this.url,
    required this.title,
    required this.height,
  });

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    // Gọi hàm này sau khi trang web tải xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sendDataToWebView();
    });
  }

  void initialServices(BuildContext context) async {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            print(error);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel('flutterToWeb', onMessageReceived: (message) {
        print('Data received from WebView: ${message.message}');
      })
      ..loadRequest(Uri.parse(widget.url));
  }

  void sendDataToWebView() async {
    String sampleData = 'Hello from Flutter!';
    String jsCode = 'receiveDataFromFlutter("$sampleData");';
    controller.runJavaScript(jsCode);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Column(
      children: [
        SizedBox(
          width: width,
          height: 50,
          child: Row(
            children: [
              const SizedBox(
                width: 80,
                height: 50,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 80,
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'Xong',
                    style: TextStyle(
                      color: AppColor.BLUE_TEXT,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        DividerWidget(width: width),
        Expanded(
          child: SizedBox(
            width: width,
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }
}
