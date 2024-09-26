import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String url;
  final String title;
  final String? userId;
  final double height;

  const CustomWebView({
    super.key,
    required this.url,
    required this.title,
    this.userId,
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
    String jsCode = 'receiveDataFromFlutter("${widget.userId}");';
    controller.runJavaScript(jsCode);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: width,
                child: WebViewWidget(
                  controller: controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
