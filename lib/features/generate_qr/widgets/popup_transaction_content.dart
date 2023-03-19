import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class PopupTransactionContent extends StatelessWidget {
  final QRGeneratedDTO qrGeneratedDTO;
  final BankAccountDTO bankAccountDTO;
  final int status;

  const PopupTransactionContent(
      {super.key,
      required this.qrGeneratedDTO,
      required this.bankAccountDTO,
      required this.status});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 20)),
        Text(
          (status == 0) ? 'Giao dịch mới được tạo' : 'Giao dịch thành công',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),

        // const Spacer(),
        _buildContent(
          context: context,
          title: 'Đến',
          description: qrGeneratedDTO.bankAccount,
          titleWidth: 100,
        ),
        _buildContent(
          context: context,
          title: '',
          description: qrGeneratedDTO.bankName,
          titleWidth: 100,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: DividerWidget(width: width),
        ),
        _buildContent(
          context: context,
          title: 'Thời gian',
          description:
              TimeUtils.instance.formatHour2(DateTime.now().toString()),
          titleWidth: 100,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: DividerWidget(width: width),
        ),
        _buildContent(
          context: context,
          title: 'Số tiền',
          description:
              '${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND',
          titleWidth: 100,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: DividerWidget(width: width),
        ),
        // _buildContent(
        //   context: context,
        //   title: 'Trạng thái',
        //   description: (status == 0) ? 'Chưa thanh toán' : 'Đã thanh toán',
        //   titleWidth: 100,
        // ),
        SizedBox(
          width: width,
          child: Row(
            children: [
              const SizedBox(
                width: 100,
                child: Text('Trạng thái'),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:
                      (status == 0) ? DefaultTheme.ORANGE : DefaultTheme.GREEN,
                ),
                child: Text(
                  (status == 0) ? 'Chưa thanh toán' : 'Đã thanh toán',
                  style: const TextStyle(
                    color: DefaultTheme.WHITE,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: DividerWidget(width: width),
        ),
        _buildContent(
          context: context,
          title: 'Nội dung',
          description: qrGeneratedDTO.content,
          titleWidth: 100,
        ),
        const Spacer(),
        ButtonWidget(
          width: width,
          text: 'OK',
          textColor: DefaultTheme.WHITE,
          bgColor: DefaultTheme.GREEN,
          function: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required String title,
    required String description,
    required double titleWidth,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: titleWidth,
            child: Text(title),
          ),
          Expanded(
            child: Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
