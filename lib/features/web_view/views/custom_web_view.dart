import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatelessWidget {
  final String url;
  final String title;
  final double height;
  static late WebViewController controller;

  const CustomWebView({
    super.key,
    required this.url,
    required this.title,
    required this.height,
  });

  void initialServices(BuildContext context) {
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
          onWebResourceError: (WebResourceError error) {},
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     return NavigationDecision.prevent;
          //   }
          //   return NavigationDecision.navigate;
          // },
        ),
      )
      ..loadRequest(Uri.parse(url));
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
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
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
        SizedBox(
          width: width,
          height: height - 70,
          child: WebViewWidget(
            controller: controller,
          ),
        ),
      ],
    );
  }
}
