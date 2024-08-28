import 'package:clipboard/clipboard.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/layouts/image/x_image.dart';

import 'button_gradient_border_widget.dart';

class PopUpForgotPasswordWidget extends StatelessWidget {
  const PopUpForgotPasswordWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const String emailSupport = 'itsupport@vietqr.vn';
    return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hỗ trợ đổi mật khẩu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(top: 30),
                        child: const XImage(
                          imagePath: 'assets/images/logo-home.png',
                          height: 80,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            ClipPath(
                              clipper: LowerNipMessageClipper(
                                  MessageType.receive,
                                  bubbleRadius: 10),
                              child: Container(
                                width: 150,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 16, 8),
                                height: 40,
                                decoration: BoxDecoration(
                                    gradient:
                                        VietQRTheme.gradientColor.lilyLinear),
                                child: const Center(
                                  child: Text(
                                    'Chào anh / chị',
                                    style: TextStyle(fontSize: 13),
                                    // textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                                child: GradientBorderButton(
                              gradient: VietQRTheme.gradientColor.aiTextColor,
                              widget: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Vui lòng liên lạc để được hỗ trợ qua:',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    // const SizedBox(height: 16),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              const XImage(
                                                imagePath:
                                                    'assets/images/ic-mail.png',
                                                width: 16,
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(width: 8),
                                              GestureDetector(
                                                onTap: () async {
                                                  String? encodeQueryParameters(
                                                      Map<String, String>
                                                          params) {
                                                    return params.entries
                                                        .map((MapEntry<String,
                                                                    String>
                                                                e) =>
                                                            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                                        .join('&');
                                                  }

// ···
                                                  final Uri emailLaunchUri =
                                                      Uri(
                                                    scheme: 'mailto',
                                                    path: emailSupport,
                                                    query:
                                                        encodeQueryParameters(<String,
                                                            String>{
                                                      'subject':
                                                          'Quên mật khẩu đăng nhập VietQR',
                                                    }),
                                                  );

                                                  if (await canLaunchUrl(
                                                      emailLaunchUri)) {
                                                    await launchUrl(
                                                        emailLaunchUri);
                                                  }
                                                },
                                                child: const Text(
                                                  emailSupport,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColor.BLACK),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const XImage(
                                                imagePath:
                                                    'assets/images/ic-call.png',
                                                width: 16,
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(width: 8),
                                              RichText(
                                                text: TextSpan(
                                                    text: '1900.6234',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColor.BLACK),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () async {
                                                            final Uri url = Uri(
                                                              scheme: 'tel',
                                                              path: '19006234',
                                                            );
                                                            if (await canLaunchUrl(
                                                                url)) {
                                                              await launchUrl(
                                                                  url);
                                                            }
                                                          },
                                                    children: [
                                                      const TextSpan(
                                                        text: ' - ',
                                                        style: TextStyle(
                                                          color: AppColor.BLACK,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '092.233.3636',
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                AppColor.BLACK),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap =
                                                                  () async {
                                                                final Uri url =
                                                                    Uri(
                                                                  scheme: 'tel',
                                                                  path:
                                                                      '0922333636',
                                                                );
                                                                if (await canLaunchUrl(
                                                                    url)) {
                                                                  await launchUrl(
                                                                      url);
                                                                }
                                                              },
                                                      ),
                                                    ]),
                                              )
                                              // GestureDetector(
                                              //   onTap: () {},
                                              //   child: const Text(
                                              //     '1900.6234 - 092.233.3636',
                                              //     style: TextStyle(
                                              //         fontSize: 15,
                                              //         fontWeight: FontWeight.bold,
                                              //         color: AppColor.BLACK),
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              borderRadius: BorderRadius.circular(10),
                              borderWidth: 1,
                            )),
                            const SizedBox(height: 30),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.clear,
                  size: 25,
                ),
              ),
            ),
          ],
        ));
  }
}
