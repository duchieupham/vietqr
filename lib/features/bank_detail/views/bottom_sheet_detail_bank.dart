import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';

class BottomSheetDetail extends StatefulWidget {
  final AccountBankDetailDTO dto;
  const BottomSheetDetail({Key? key, required this.dto}) : super(key: key);

  @override
  State<BottomSheetDetail> createState() => _BottomSheetAddUserBDSDState();
}

class _BottomSheetAddUserBDSDState extends State<BottomSheetDetail> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            children: [
              const SizedBox(
                width: 32,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Thông tin tài khoản',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.clear,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        _buildSectionInfo('Ngân hàng:', widget.dto.bankName, showCoppy: false),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: DividerWidget(width: width),
        ),
        _buildSectionInfo('Số tài khoản:', widget.dto.bankAccount),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: DividerWidget(width: width),
        ),
        _buildSectionInfo('Tên chủ tài khoản:', widget.dto.userBankName),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: DividerWidget(width: width),
        ),
        _buildSectionInfo(
            'Số điện thoại xác thực:', widget.dto.phoneAuthenticated),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: DividerWidget(width: width),
        ),
        _buildSectionInfo(
            'Căn cước công dân/Mã số thuê:', widget.dto.nationalId),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionInfo(String title, String value,
      {bool showCoppy = true}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                value,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        if (showCoppy)
          GestureDetector(
              onTap: () {
                FlutterClipboard.copy(value).then(
                  (value) => Fluttertoast.showToast(
                    msg: 'Đã sao chép',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).hintColor,
                    fontSize: 15,
                    webBgColor: 'rgba(255, 255, 255, 0.5)',
                    webPosition: 'center',
                  ),
                );
              },
              child: Image.asset(
                'assets/images/ic_copy.png',
                width: 28,
              ))
      ],
    );
  }
}
