import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class CustomInAppWebView extends StatefulWidget {
  final String url;
  final String userId;

  static String routeName = '/custom_inapp_webview';

  const CustomInAppWebView(
      {super.key, required this.url, required this.userId});

  @override
  State<CustomInAppWebView> createState() => _CustomInAppWebViewState();
}

class _CustomInAppWebViewState extends State<CustomInAppWebView> {
  InAppWebViewController? webViewController;
  final webViewKey = GlobalKey();

  InAppWebViewSettings settings = InAppWebViewSettings(
    clearCache: true,
    useOnLoadResource: true,
    // cacheEnabled: false,
  );

  @override
  void initState() {
    super.initState();
  }

  void sendDataToWebView(InAppWebViewController controller) async {
    String userId = jsonEncode(widget.userId);
    String jsCode = 'receiveDataFromFlutter($userId);';
    await controller.evaluateJavascript(
        source: jsCode, contentWorld: ContentWorld.PAGE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        // webViewController!.dispose();
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: AppColor.BLACK_BUTTON,
                      )),
                  const Spacer(),
                  Container(
                    width: 50,
                    height: 40,
                    margin: const EdgeInsets.only(right: 20),
                    child: Image.asset(
                      'assets/images/ic-viet-qr.png',
                      height: 40,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: InAppWebView(
                key: webViewKey,
                initialUrlRequest:
                    URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
                initialUserScripts: UnmodifiableListView<UserScript>([]),
                initialSettings: settings,
                // initialOptions: options,
                onWebViewCreated: (controller) async {
                  webViewController = controller;
                  controller.addJavaScriptHandler(
                      handlerName: 'sendDataToFlutter',
                      callback: (data) {
                        if (data.isNotEmpty) {
                          if (data.contains('CLOSE_WEB')) {
                            Navigator.pop(context);
                          }
                        }
                      });
                },
                onLoadStart: (controller, url) async {
                  // sendDataToWebView(controller);

                  setState(() {});
                },
                onPermissionRequest: (controller, permissionRequest) async {
                  return PermissionResponse(
                    action: PermissionResponseAction.GRANT,
                    resources: permissionRequest.resources,
                  );
                },
                // androidOnPermissionRequest:
                //     (controller, request, resources) async {
                //   return PermissionRequestResponse(
                //       resources: resources,
                //       action: PermissionRequestResponseAction.GRANT);
                // },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;

                  if (![
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about"
                  ].contains(uri.scheme)) {
                    if (await canLaunchUrl(uri)) {
                      // Launch the App
                      await launchUrl(
                        uri,
                      );
                      // and cancel the request
                      return NavigationActionPolicy.CANCEL;
                    }
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onLoadResource: (controller, resource) {
                  sendDataToWebView(controller);
                  setState(() {});
                },
                onLoadStop: (controller, url) async {
                  // sendDataToWebView(controller);
                  setState(() {});
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {}
                  setState(() {});
                },
                onUpdateVisitedHistory: (controller, url, isReload) {
                  setState(() {});
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    webViewController!.dispose();
    super.dispose();
  }
}
