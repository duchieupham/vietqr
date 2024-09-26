import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/utils/currency_utils.dart';
import '../../../models/annual_fee_dto.dart';

class PopupDetailAnnualFee extends StatelessWidget {
  final AnnualFeeDTO dto;
  final String bankName;
  final String bankAccount;
  // final String duration;
  const PopupDetailAnnualFee({
    super.key,
    required this.dto,
    required this.bankName,
    required this.bankAccount,
  });

  @override
  Widget build(BuildContext context) {
    int vat = dto.totalWithVat! - dto.totalAmount!;

    String formattedStartDate = DateFormat('dd/MM/yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(dto.timeFrom! * 1000));
    String formattedEndDate = DateFormat('dd/MM/yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(dto.timeTo! * 1000));
    String dateRange = '$formattedStartDate - $formattedEndDate';

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
              const DefaultTextStyle(
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
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          _buildItem(
            'Dịch vụ',
            'Dịch vụ phần mềm VietQR',
            FontWeight.normal,
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildItem(
            'TK Kích hoạt',
            "$bankName - $bankAccount",
            FontWeight.normal,
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildItem(
            'Thời gian',
            dateRange,
            FontWeight.normal,
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildItem(
            'Đơn giá',
            '${CurrencyUtils.instance.getCurrencyFormatted(dto.amount.toString())} VND',
            FontWeight.bold,
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildItem(
            'Số lượng',
            '${CurrencyUtils.instance.getCurrencyFormatted(dto.duration.toString())} tháng',
            FontWeight.bold,
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildItem(
            'VAT',
            '${CurrencyUtils.instance.getCurrencyFormatted(vat.toString())} VND',
            FontWeight.bold,
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildItem(
            'Thành tiền',
            '${CurrencyUtils.instance.getCurrencyFormatted(dto.totalWithVat.toString())} VND',
            FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    String leftText,
    String rightText,
    FontWeight fontWeightText, {
    double height = 50.0,
  }) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DefaultTextStyle(
              style: const TextStyle(
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
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
