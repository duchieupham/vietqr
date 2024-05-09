import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../commons/constants/configurations/theme.dart';

class PopupDeleteWebhookWidget extends StatelessWidget {
  final Function() onDelete;
  const PopupDeleteWebhookWidget({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(45, 0, 45, 0),
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
      // width: MediaQuery.of(context).size.width * 0.35,
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
          color: AppColor.WHITE, borderRadius: BorderRadius.circular(20)),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/ic-info-blue.png',
            height: 80,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(height: 40),
          Text(
            'Huỷ kết nối Google Chat',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Ngưng nhận Biến động số dư qua \nnền tảng Google Chat.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          InkWell(
            onTap: onDelete,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: AppColor.BLUE_TEXT,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  'Xác nhận',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: AppColor.WHITE),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: AppColor.GREY_DADADA,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  'Đóng cửa sổ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
