import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/helper/app_data_helper.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/features/bank_detail/provider/input_money_provider.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/qr_bank_detail.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class BottomSheetInputMoney extends StatefulWidget {
  final QRGeneratedDTO dto;

  const BottomSheetInputMoney({Key? key, required this.dto}) : super(key: key);

  @override
  State<BottomSheetInputMoney> createState() => _BottomSheetAddUserBDSDState();
}

class _BottomSheetAddUserBDSDState extends State<BottomSheetInputMoney> {
  final _focusMoney = FocusNode();
  final _focusContent = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InputMoneyProvider>(
        create: (context) => InputMoneyProvider()..init(widget.dto.bankAccount),
        child: Consumer<InputMoneyProvider>(
          builder: ((context, provider, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              'Tùy chỉnh số tiền',
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
                  const SizedBox(height: 32),
                  MTextFieldCustom(
                    isObscureText: false,
                    maxLines: 1,
                    showBorder: true,
                    value: provider.money,
                    fillColor: AppColor.WHITE,
                    textFieldType: TextfieldType.LABEL,
                    title: 'Số tiền',
                    autoFocus: true,
                    focusNode: _focusMoney,
                    hintText: 'Nhập số tiền thanh toán',
                    inputType: TextInputType.number,
                    keyboardAction: TextInputAction.next,
                    onChange: provider.updateMoney,
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'VND',
                          style: TextStyle(
                              fontSize: 14, color: AppColor.textBlack),
                        ),
                        const SizedBox(width: 8),
                        const SizedBox(width: 8),
                      ],
                    ),
                    inputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  if (provider.errorAmount.isNotEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5, top: 5, right: 30),
                      child: Text(
                        provider.errorAmount ?? '',
                        style: const TextStyle(
                            color: AppColor.RED_TEXT, fontSize: 13),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  MTextFieldCustom(
                    isObscureText: false,
                    maxLines: 1,
                    showBorder: true,
                    value: provider.content,
                    fillColor: AppColor.WHITE,
                    textFieldType: TextfieldType.LABEL,
                    title: 'Nội dung (${provider.content.length}/50 ký tự)',
                    focusNode: _focusContent,
                    hintText: 'Nhập nội dung',
                    inputType: TextInputType.text,
                    keyboardAction: TextInputAction.next,
                    onChange: provider.updateContent,
                    inputFormatter: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonWidget(
                          height: 40,
                          text: 'Xóa tất cả',
                          textColor: AppColor.BLUE_TEXT,
                          bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                          function: () {
                            QRDetailBank qrDetailBank = QRDetailBank(
                                money: '', content: '', bankAccount: '');
                            AppDataHelper.instance
                                .removeAtBankAccount(widget.dto.bankAccount);
                            Navigator.pop(context, qrDetailBank);
                          },
                          borderRadius: 5,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ButtonWidget(
                          height: 40,
                          text: 'Lưu',
                          textColor: AppColor.WHITE,
                          bgColor: AppColor.BLUE_TEXT,
                          function: () {
                            if (provider.money.isEmpty ||
                                provider.money == '0') {
                              QRDetailBank qrDetailBank = QRDetailBank(
                                  money: '', content: '', bankAccount: '');
                              AppDataHelper.instance
                                  .removeAtBankAccount(widget.dto.bankAccount);
                              Navigator.pop(context, qrDetailBank);
                            } else {
                              QRDetailBank qrDetailBank = QRDetailBank(
                                  money: provider.money,
                                  content: provider.content,
                                  bankAccount: widget.dto.bankAccount);
                              Navigator.pop(context, qrDetailBank);
                            }
                          },
                          borderRadius: 5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }),
        ));
  }
}
