import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_detail_bank.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_remove_dto.dart';

class OptionWidget extends StatefulWidget {
  AccountBankDetailDTO dto;
  final BankCardBloc bloc;
  final String bankId;
  OptionWidget(
      {super.key, required this.dto, required this.bankId, required this.bloc});

  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  bool isLinked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF6FF),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tuỳ chọn',
                  style: TextStyle(fontSize: 20),
                ),
                if (!widget.dto.authenticated)
                  const Text(
                    'Chưa liên kết',
                    style: TextStyle(fontSize: 12, color: AppColor.ORANGE),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (!widget.dto.authenticated)
              buildOptionRow('Liên kết tài khoản ngân hàng',
                  'assets/images/ic-linked-black.png', () {
                print('Liên kết tài khoản ngân hàng');
              }),
            if (!widget.dto.authenticated)
              const MySeparator(
                color: AppColor.GREY_DADADA,
              ),
            buildOptionRow(
                'Thông tin tài khoản ngân hàng', 'assets/images/ic-i-black.png',
                () {
              DialogWidget.instance.showModelBottomSheet(
                borderRadius: BorderRadius.circular(16),
                widget: BottomSheetDetail(
                  dto: widget.dto,
                ),
              );
              print('Thông tin tài khoản ngân hàng');
            }),
            const MySeparator(
              color: AppColor.GREY_DADADA,
            ),
            buildOptionRow(
                'Tuỳ chỉnh giao diện mã VietQR', 'assets/images/ic-effect.png',
                () {
              print('Tuỳ chỉnh giao diện mã VietQR');
            }),
            const MySeparator(
              color: AppColor.GREY_DADADA,
            ),
            buildOptionRow(
                'Xoá tài khoản ngân hàng', 'assets/images/ic-remove-black.png',
                () {
              if (widget.dto.authenticated) {
                DialogWidget.instance.openMsgDialog(
                  title: 'Không thể xoá TK',
                  msg:
                      'Vui lòng huỷ liên kết tài khoản ngân hàng trước khi xoá.',
                );
              } else {
                BankAccountRemoveDTO bankAccountRemoveDTO =
                    BankAccountRemoveDTO(
                  bankId: widget.bankId,
                  type: widget.dto.type,
                  isAuthenticated: widget.dto.authenticated,
                );
                widget.bloc.add(BankCardEventRemove(dto: bankAccountRemoveDTO));
              }
              print('Xoá tài khoản ngân hàng');
            }),
          ],
        ),
      ),
    );
  }

  Widget buildOptionRow(String title, String path, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        width: double.infinity, // Mở rộng chiều rộng của Container
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 12)),
            XImage(
              imagePath: path,
              width: 30,
            ),
          ],
        ),
      ),
    );
  }
}
