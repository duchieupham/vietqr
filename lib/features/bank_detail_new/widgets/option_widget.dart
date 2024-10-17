import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_detail_bank.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_remove_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class OptionWidget extends StatefulWidget {
  final AccountBankDetailDTO dto;
  final BankCardBloc bloc;
  final bool isOwner;
  final String bankId;
  const OptionWidget(
      {super.key,
      required this.dto,
      required this.bankId,
      required this.bloc,
      required this.isOwner});

  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  bool isLinked = false;

  void _unLink() {
    // Navigator.of(context).pop();
    if (widget.dto.unLinkBIDV) {
      Map<String, dynamic> body = {
        'ewalletToken': widget.dto.ewalletToken,
        'bankAccount': widget.dto.bankAccount,
        'bankCode': widget.dto.bankCode,
      };
      widget.bloc.add(BankCardEventUnLink(body: body));
    } else {
      widget.bloc.add(
          BankCardEventUnRequestOTP(accountNumber: widget.dto.bankAccount));
    }
  }

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
                if (widget.dto.authenticated && widget.isOwner)
                  Text(
                    !widget.dto.authenticated ? 'Chưa liên kết' : 'Đã liên kết',
                    style: TextStyle(
                        fontSize: 12,
                        color: !widget.dto.authenticated
                            ? AppColor.ORANGE
                            : AppColor.GREEN),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (!widget.dto.authenticated)
              buildOptionRow('Liên kết tài khoản ngân hàng',
                  'assets/images/ic-linked-black.png', () async {
                BankTypeDTO bankTypeDTO = BankTypeDTO(
                  id: widget.dto.bankTypeId,
                  bankCode: widget.dto.bankCode,
                  bankName: widget.dto.bankName,
                  imageId: widget.dto.imgId,
                  bankShortName: widget.dto.bankCode,
                  status: widget.dto.bankTypeStatus,
                  caiValue: widget.dto.caiValue,
                  bankId: widget.dto.id,
                  bankAccount: widget.dto.bankAccount,
                  userBankName: widget.dto.userBankName,
                );
                await NavigatorUtils.navigatePage(
                        context, AddBankScreen(bankTypeDTO: bankTypeDTO, isSaved: true,),
                        routeName: AddBankScreen.routeName)
                    .then((value) {
                  if (value is bool) {
                    widget.bloc.add(const BankCardGetDetailEvent());
                  }
                });
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
            }),
            const MySeparator(
              color: AppColor.GREY_DADADA,
            ),
            buildOptionRow('Tuỳ chỉnh giao diện mã VietQR',
                'assets/images/ic-effect.png', () {}),
            const MySeparator(
              color: AppColor.GREY_DADADA,
            ),
            buildOptionRow(
                widget.dto.authenticated && widget.isOwner
                    ? 'Huỷ liên kết tài khoản'
                    : 'Xoá tài khoản ngân hàng',
                'assets/images/ic-remove-black.png', () {
              if (widget.dto.authenticated && widget.isOwner) {
                _unLink();
              } else {
                BankAccountRemoveDTO bankAccountRemoveDTO =
                    BankAccountRemoveDTO(
                  bankId: widget.bankId,
                  type: widget.dto.type,
                  isAuthenticated: widget.dto.authenticated,
                );
                widget.bloc.add(BankCardEventRemove(dto: bankAccountRemoveDTO));
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget buildOptionRow(String title, String path, Function() onTap) {
    return InkWell(
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
