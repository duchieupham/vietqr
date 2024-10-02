import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/models/setting_account_sto.dart';

class PopupBidvWidget extends StatefulWidget {
  const PopupBidvWidget({super.key});

  @override
  State<PopupBidvWidget> createState() => _PopupBidvWidgetState();
}

class _PopupBidvWidgetState extends State<PopupBidvWidget> {
  final String url =
      "https://omni.bidv.com.vn/static/bidv/share/gioi-thieu-ban-thuong-vo-han.html?data=aH0RHc6MyLk9Cbi5Wa2R2ch1nciRWYr5Wan5nLuZ2LiVlTBRGTS1VbuVVeYZEZo4";
  bool _doNotShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.TRANSPARENT,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication);
                }
              },
              child: Container(
                width: double.infinity,
                height: 500,
                // margin: const EdgeInsets.only(right: 8, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/bidv-banner.jpg',
                        ),
                        fit: BoxFit.cover)),
                child: Stack(
                  children: [
                    Positioned(
                        top: 15,
                        right: 15,
                        child: InkWell(
                          onTap: () {
                            if (_doNotShowAgain) {
                              getIt
                                  .get<DashBoardBloc>()
                                  .add(UpdateCloseNotiEvent(
                                      userConfig: UserConfig(
                                    bidvNotification: false,
                                  )));
                            }
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.close,
                            color: AppColor.WHITE,
                            size: 25,
                          ),
                        )),
                    Positioned(
                      left: 20,
                      top: 20,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mở tài khoản BIDV',
                            style: TextStyle(
                                fontSize: 15,
                                color: AppColor.WHITE,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Nhận ngay ưu đãi miễn phí 2 tháng sử dụng\nMiễn phí mở tài khoản số đẹp.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColor.WHITE,
                            ),
                          ),
                          const Spacer(),
                          RichText(
                            text: TextSpan(
                              text: 'Liên hệ: ',
                              style: const TextStyle(fontSize: 13),
                              children: [
                                TextSpan(
                                  text: '094.888.5828',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final Uri url = Uri(
                                        scheme: 'tel',
                                        path: '0948885828',
                                      );
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      }
                                    },
                                ),
                                TextSpan(
                                  text: ' - Ms Giang',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final Uri url = Uri(
                                        scheme: 'tel',
                                        path: '0948885828',
                                      );
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      }
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                // color: AppColor.BLACK.withOpacity(0.3),
                gradient: VietQRTheme.gradientColor.lilyLinear,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _doNotShowAgain,

                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _doNotShowAgain = value;
                        });
                      }
                    },
                    side: const BorderSide(
                      color: Colors.black, // White border
                      width: 2.0, // Border thickness
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50), // Makes the checkbox circular
                    ),
                    checkColor: Colors.white, // Color of the checkmark
                    activeColor: Colors.blue,
                  ),
                  const Text(
                    'Không hiển thị lại lần sau',
                    style: TextStyle(fontSize: 18, color: AppColor.BLACK),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
