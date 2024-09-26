import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class AccountLinkView extends StatelessWidget {
  final BankTypeDTO bankTypeDTO;
  final String bankAccount;
  final String bankUserName;
  final Function(dynamic)? onTap;
  final ValueChanged<String>? onChangePhone;
  final ValueChanged<String>? onChangeCMT;
  final TextEditingController phone;
  final TextEditingController cmt;
  final GestureTapCallback? onEdit;
  final GestureTapCallback? onScan;
  final String? errorPhone;
  final String? errorCMT;

  const AccountLinkView({
    super.key,
    required this.bankTypeDTO,
    required this.bankAccount,
    required this.bankUserName,
    this.onTap,
    this.onScan,
    this.onChangePhone,
    this.onChangeCMT,
    required this.phone,
    required this.cmt,
    required this.onEdit,
    required this.errorPhone,
    required this.errorCMT,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldCustom(
          isObscureText: false,
          maxLines: 1,
          controller: phone,
          textFieldType: TextfieldType.LABEL,
          title: 'Số điện thoại xác thực',
          unTitle:
              'Số điện thoại phải trùng khớp với thông tin đăng ký tài khoản ngân hàng',
          isRequired: true,
          hintText: 'Nhập số điện thoại xác thực',
          inputType: TextInputType.number,
          keyboardAction: TextInputAction.next,
           inputFormatter: [
            LengthLimitingTextInputFormatter(10),
          ],
          onChange: onChangePhone,
        ),
        if (SharePrefUtils.getPhone().isNotEmpty)
          GestureDetector(
            onTap: () {
              phone.text = SharePrefUtils.getPhone();
              onChangePhone!(SharePrefUtils.getPhone());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColor.BLUE_TEXT),
                color: AppColor.BLUE_TEXT.withOpacity(0.3),
              ),
              child: Text(
                StringUtils.instance
                    .formatPhoneNumberVN(SharePrefUtils.getPhone()),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
          ),
        Visibility(
          visible: errorPhone != null,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              errorPhone ?? '',
              maxLines: 2,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: Styles.errorStyle(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 30),
        TextFieldCustom(
          isObscureText: false,
          maxLines: 1,
          controller: cmt,
          textFieldType: TextfieldType.LABEL,
          title: 'CCCD/MST',
          unTitle:
              'CCCD (Căn cước công dân)/MST (Mã số thuế) phải trùng khớp với thông tin đăng ký tài khoản ngân hàng',
          isRequired: true,
          hintText: 'Nhập chứng minh thư hoặc mã số thuế',
          // controller: provider.introduceController,
          inputType: TextInputType.number,
          keyboardAction: TextInputAction.next,
          inputFormatter: [
            LengthLimitingTextInputFormatter(12),
          ],
          suffixIcon: GestureDetector(
            onTap: onScan,
            child: Image.asset(
              'assets/images/ic-scan-content.png',
              width: 24,
              height: 24,
            ),
          ),
          onChange: onChangeCMT,
        ),
        if (SharePrefUtils.getProfile().nationalId.isNotEmpty)
          GestureDetector(
            onTap: () {
              cmt.text = SharePrefUtils.getProfile().nationalId;
              onChangeCMT!(
                  SharePrefUtils.getProfile().nationalId);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColor.BLUE_TEXT),
                color: AppColor.BLUE_TEXT.withOpacity(0.3),
              ),
              child: Text(
                SharePrefUtils.getProfile().nationalId,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
          ),
        Visibility(
          visible: errorCMT != null,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              errorCMT ?? '',
              maxLines: 2,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: Styles.errorStyle(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tài khoản',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            GestureDetector(
              onTap: onEdit,
              child: const Text(
                'Chỉnh sửa',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: AppColor.BLUE_TEXT,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: AppColor.WHITE,
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 30,
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ImageUtils.instance
                          .getImageNetWork(bankTypeDTO.imageId)),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      bankTypeDTO.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.BLACK),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bankAccount,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.BLACK),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bankUserName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.BLACK),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
