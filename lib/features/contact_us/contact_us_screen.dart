// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/features/login/widgets/bgr_app_bar_login.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';

class ContactUSScreen extends StatefulWidget {
  const ContactUSScreen({super.key, required this.appInfoDTO});

  final AppInfoDTO appInfoDTO;

  static String routeName = '/contact_us_screen';

  @override
  State<ContactUSScreen> createState() => _ContactUSScreenState();
}

class _ContactUSScreenState extends State<ContactUSScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).initThemeDTO();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  BackgroundAppBarLogin(),
                  Positioned(
                    top: 40,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        padding: const EdgeInsets.only(left: 20),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    textContent,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      height: 1.4,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Thông tin liên hệ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      height: 1.4,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Số điện thoại',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          height: 1.4,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildItem(
                          value: StringUtils.instance
                              .formatPhoneNumberVN(phoneGroup),
                          icon: const Icon(Icons.phone,
                              size: 12, color: AppColor.WHITE),
                          onTap: () {
                            makePhoneCall(phoneGroup);
                          }),
                      const SizedBox(height: 10),
                      _buildItem(
                          value: StringUtils.instance
                              .formatPhoneNumberVN(phoneIndividual),
                          icon: const Icon(Icons.phone,
                              size: 12, color: AppColor.WHITE),
                          onTap: () {
                            makePhoneCall(phoneIndividual);
                          }),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Email',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          height: 1.4,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildItem(
                          value: email,
                          textButton: 'Gửi mail',
                          icon: const Icon(Icons.email_outlined,
                              size: 12, color: AppColor.WHITE),
                          onTap: () {
                            makePhoneCall(email, isMail: true);
                          }),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Trang web của chúng tôi',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          height: 1.4,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(listWebs.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              makeWeb(listWebs.elementAt(index).link);
                            },
                            child: _buildItemWeb(
                              listWebs.elementAt(index),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Theo dõi chúng tôi qua',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          height: 1.4,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(listFollow.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              makeWeb(listFollow.elementAt(index).link);
                            },
                            child: Image.asset(
                              listFollow.elementAt(index).title,
                              width: 50,
                              height: 50,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void makePhoneCall(String phoneNumber, {bool isMail = false}) async {
    String url = '';
    if (isMail) {
      url = 'mailto:$phoneNumber';
    } else {
      url = 'tel:$phoneNumber';
    }
    await launch(url);
  }

  void makeWeb(String link) async {
    if (link.isNotEmpty) {
      await launch(link);
    }
  }

  Widget _buildItem(
      {required String value,
      String textButton = 'Gọi ngay',
      required Icon icon,
      GestureTapCallback? onTap}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.WHITE,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.start,
              style: const TextStyle(
                height: 1.4,
                fontSize: 15,
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColor.BLUE_TEXT,
              ),
              child: Row(
                children: [
                  icon,
                  const SizedBox(width: 4),
                  Text(
                    textButton,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      height: 1.4,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColor.WHITE,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemWeb(DataModel data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppColor.BLUE_TEXT.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        data.title,
        style: const TextStyle(
          fontSize: 16,
          color: AppColor.BLUE_TEXT,
        ),
      ),
    );
  }

  static String textContent =
      'VietQR là chuẩn thanh toán QR của EMV Co. · Giao dịch nhanh chóng/ Đơn giản hóa trải nghiệm và tăng tốc độ thanh toán thông qua việc quét mã QR được phát triển nhằm tạo sự thanh toán và thuận tiện cho mọi người.';
  static String phoneGroup = '19006234';
  static String phoneIndividual = '0922333636';
  static String email = 'sales@vietqr.vn';

  final List<DataModel> listWebs = [
    DataModel(title: 'vietqr.vn', link: 'https://vietqr.vn/'),
    DataModel(title: 'vietqr.com', link: 'https://vietqr.com/'),
    DataModel(title: 'vietqr.org', link: 'https://vietqr.org/'),
  ];

  final List<DataModel> listFollow = [
    DataModel(
        title: 'assets/images/logo-facebook.png',
        link: 'https://www.facebook.com/vietqr.vn/'),
    DataModel(
        title: 'assets/images/logo-youtube.png',
        link: 'https://www.youtube.com/@VietQR'),
    DataModel(title: 'assets/images/logo-zalo.png', link: ''),
  ];
}

class DataModel {
  final String title;
  final String link;

  DataModel({required this.title, required this.link});
}
