import 'package:clipboard/clipboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/share_utils.dart';

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
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Email chưa được xác thực',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.clear,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Liên hệ mail ',
                  style: TextStyle(
                    color: AppColor.BLACK,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextSpan(
                  text: emailSupport,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      String? encodeQueryParameters(
                          Map<String, String> params) {
                        return params.entries
                            .map((MapEntry<String, String> e) =>
                                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                            .join('&');
                      }

// ···
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: emailSupport,
                        query: encodeQueryParameters(<String, String>{
                          'subject': 'Quên mật khẩu VietQR',
                        }),
                      );
                    
                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      }
                    },
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(
                        const Rect.fromLTWH(
                            0, 0, 200, 40), // Adjust size as needed
                      ),
                  ),
                ),
                const TextSpan(
                  text: ' để được hỗ trợ đổi mật khẩu.',
                  style: TextStyle(
                    color: AppColor.BLACK,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.center,
            child: Text(
              '---------Hoặc---------',
              style: TextStyle(color: AppColor.GREY_TEXT),
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Gọi vào ',
                  style: TextStyle(
                    color: AppColor.BLACK,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextSpan(
                  text: '1900.6234',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final Uri url = Uri(
                        scheme: 'tel',
                        path: '19006234',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(
                        const Rect.fromLTWH(
                            0, 0, 200, 40), // Adjust size as needed
                      ),
                  ),
                ),
                const TextSpan(
                  text: ' - ',
                  style: TextStyle(
                    color: AppColor.BLACK,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextSpan(
                  text: '09.2233.3636',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final Uri url = Uri(
                        scheme: 'tel',
                        path: '0922333636',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(
                        const Rect.fromLTWH(
                            0, 0, 200, 40), // Adjust size as needed
                      ),
                  ),
                ),
                const TextSpan(
                  text: ' để được hỗ trợ.',
                  style: TextStyle(
                    color: AppColor.BLACK,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
