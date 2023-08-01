import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';

class ContactUSScreen extends StatefulWidget {
  const ContactUSScreen({super.key});

  @override
  State<ContactUSScreen> createState() => _ContactUSScreenState();
}

class _ContactUSScreenState extends State<ContactUSScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/bgr-header.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                        child: Opacity(
                          opacity: 0.6,
                          child: Container(
                            height: 30,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2,
                        margin: const EdgeInsets.only(top: 50),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/logo_vietgr_payment.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
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
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Thông tin liên hệ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      height: 1.4,
                      fontSize: 20,
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildItem(
                          value: formatPhoneNumberVN(phoneGroup),
                          icon: const Icon(Icons.phone,
                              size: 12, color: AppColor.WHITE),
                          onTap: () {
                            makePhoneCall(phoneGroup);
                          }),
                      const SizedBox(height: 10),
                      _buildItem(
                          value: formatPhoneNumberVN(phoneIndividual),
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
                          fontSize: 16,
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
                          fontSize: 16,
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
                          fontSize: 16,
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

  String formatPhoneNumberVN(String phoneNumber) {
    String numericString = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (numericString.length >= 10) {
      return phoneNumber.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'),
          (Match m) => "${m[1]} ${m[2]} ${m[3]}");
      return '${numericString.substring(0, 3)} ${numericString.substring(3, 6)} ${numericString.substring(6)}';
    } else {
      return numericString;
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
                fontSize: 16,
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
