import 'package:flutter/material.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/utils/currency_utils.dart';

class PopupDetailAnnualFee extends StatelessWidget {
  // final String amount;
  // final String duration;
  const PopupDetailAnnualFee(
      {super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
      height: MediaQuery.of(context).size.height * 0.6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DefaultTextStyle(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                child: Text(
                  'Chi tiết hoá đơn',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          _buildItem('Dịch vụ', 'Dịch vụ phần mềm VietQR', FontWeight.normal),
          MySeparator(
            color: AppColor.GREY_TEXT,
          ),
          _buildItem('TK Kích hoạt', 'MBBank - 1231312312', FontWeight.normal),
          MySeparator(
            color: AppColor.GREY_TEXT,
          ),
          _buildItem('Thời gian', '26/04/2024 - 26/10/2024', FontWeight.normal),
          MySeparator(
            color: AppColor.GREY_TEXT,
          ),
          _buildItem(
              'Đơn giá',
              ' 66,000 VND',
              FontWeight.bold),
          MySeparator(
            color: AppColor.GREY_TEXT,
          ),
          _buildItem(
              'Số lượng',
              '6 tháng',
              FontWeight.bold),
          MySeparator(
            color: AppColor.GREY_TEXT,
          ),
          _buildItem('VAT', '31,680 VND', FontWeight.bold),
          MySeparator(
            color: AppColor.GREY_TEXT,
          ),
          _buildItem('Thành tiền', '427,680 VND', FontWeight.bold),
        ],
      ),
    );
  }

  Widget _buildItem(
    String leftText,
    String rightText,
    FontWeight fontWeightText,
  ) {
    return Container(
      width: double.infinity,
      height: 50,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
              child: Text(
                leftText,
              ),
            ),
            DefaultTextStyle(
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: fontWeightText,
              ),
              child: Text(
                rightText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
