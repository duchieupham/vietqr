import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/button/m_button_icon_widget.dart';
import 'package:vierqr/layouts/dashedline/horizontal_dashed_line.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/notify_trans_dto.dart';

class TransSuccessView extends StatelessWidget {
  final NotifyTransDTO dto;
  final int type;

  static String routeName = '/TransSuccessView';

  const TransSuccessView(
      {super.key,
      required this.dto,
      required this.type}); // = 0: yêu cầu xác nhận, =1 là update luôn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title: 'Trở về', centerTitle: false, showBG: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
                type == 0
                    ? AppImages.icPendingTrans
                    : AppImages.icSuccessInBlue,
                width: 120),
            Text(
              type == 0
                  ? 'Thông tin đã yêu cầu được cập nhật'
                  : 'Thông tin đã được cập nhật',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.BLACK, fontSize: 16),
            ),
            const SizedBox(height: 24),
            CustomPaint(
              painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
              size: const Size(double.infinity, 1),
            ),
            const SizedBox(height: 24),
            Text(
              dto.terminalName.isNotEmpty ? dto.terminalName : dto.terminalCode,
              style: const TextStyle(
                  fontSize: 20,
                  color: AppColor.BLACK,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildInfo(),
            const Spacer(),
            MButtonIconWidget(
              icon: Icons.check,
              iconSize: 14,
              iconColor: AppColor.WHITE,
              title: 'Hoàn thành',
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              border: Border.all(color: AppColor.BLUE_TEXT),
              bgColor: AppColor.BLUE_TEXT,
              textColor: AppColor.WHITE,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...[
          _buildItem(
            title: 'Tài khoản nhận:',
            content: '${dto.bankCode} - ${dto.bankAccount}',
          ),
          CustomPaint(
            painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
            size: const Size(double.infinity, 1),
          ),
        ],
        ...[
          _buildItem(
            title: 'Số tiền',
            content: dto.getAmount,
            textColor: AppColor.BLUE_TEXT,
          ),
          CustomPaint(
            painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
            size: const Size(double.infinity, 1),
          ),
        ],
        ...[
          _buildItem(
            title: 'Mã GD:',
            content: dto.referenceNumber,
          ),
          CustomPaint(
            painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
            size: const Size(double.infinity, 1),
          ),
        ],
        _buildItem(
          title: 'Thời gian TT:',
          content: dto.timePayment,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildItem(
      {String title = '',
      String content = '',
      int maxLines = 1,
      Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: AppColor.GREY_TEXT.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            child: Text(
              content.isEmpty ? '-' : content,
              textAlign: TextAlign.right,
              maxLines: maxLines,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
                color: textColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
