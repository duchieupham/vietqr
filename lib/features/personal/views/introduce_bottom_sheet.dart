import 'package:flutter/cupertino.dart';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/features/business/repositories/business_information_repository.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class IntroduceBottomSheet extends StatefulWidget {
  final IntroduceDTO? introduceDTO;

  const IntroduceBottomSheet({super.key, this.introduceDTO});

  @override
  State<IntroduceBottomSheet> createState() => _IntroduceBottomSheetState();
}

class _IntroduceBottomSheetState extends State<IntroduceBottomSheet> {
  late BusinessInformationRepository repository;
  String userId = UserInformationHelper.instance.getUserId();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initData();
  }

  void initData() async {
    try {} catch (e) {
      LOG.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: DefaultTheme.BANK_CARD_COLOR_3.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: [
          SizedBox(
            width: width,
            height: 50,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.transparent,
                    size: 18,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Giới thiệu VietQR VN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.clear,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(width: width - 32),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildItemIntroduce('Mã giới thiệu',
                            widget.introduceDTO?.sharingCode ?? 'avasvsav'),
                        const SizedBox(height: 20),
                        _buildItemIntroduce('Link giới thiệu',
                            widget.introduceDTO?.walletId ?? 'vasasvasv'),
                      ],
                    ),
                  ),
                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      SizedBox(width: 4),
                      Text(
                        'hoặc',
                        style: TextStyle(
                            fontSize: 14, color: DefaultTheme.GREY_TEXT),
                      ),
                      SizedBox(width: 4),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                          color: DefaultTheme.BLUE_TEXT,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: const [
                          Icon(Icons.ios_share),
                          Expanded(
                            child: Text(
                              'Chia sẻ mã giới thiệu',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: DefaultTheme.WHITE,
                              ),
                            ),
                          ),
                          Icon(Icons.ios_share, color: Colors.transparent),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemIntroduce(String title, String data) {
    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: data));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: DefaultTheme.greyF0F0F0,
                border: Border.all(color: DefaultTheme.grey979797, width: 0.5),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    data,
                    style: const TextStyle(
                        fontSize: 14, color: DefaultTheme.GREY_TEXT),
                  ),
                ),
                Image.asset(
                  'assets/images/ic_copy.png',
                  width: 28,
                  height: 28,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
