import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_recreate_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/trans_list_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class ConfrimQrWidget extends StatefulWidget {
  final BankAccountDTO bankAccount;
  final String orderId;
  final TransactionItemDTO dto;
  const ConfrimQrWidget(
      {super.key,
      required this.bankAccount,
      required this.orderId,
      required this.dto});

  @override
  State<ConfrimQrWidget> createState() => _ConfrimQrWidgetState();
}

class _ConfrimQrWidgetState extends State<ConfrimQrWidget> {
  String get userId => SharePrefUtils.getProfile().userId;

  TextEditingController textEditingController = TextEditingController();
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(true);
  bool isCheckOrderId = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        initData();
      },
    );
  }

  void initData() async {
    isLoadingNotifier.value = true;

    final ResponseMessageDTO result = await checkOrderId(
        bankId: widget.bankAccount.id, orderId: widget.orderId);
    setState(() {
      isCheckOrderId = result.status == 'CHECK';
      textEditingController.text = widget.dto.orderId;
    });

    isLoadingNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoadingNotifier,
      builder: (context, value, child) {
        if (value == true) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin tạo mã',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColor.GREY_TEXT),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => VietQRTheme
                          .gradientColor.brightBlueLinear
                          .createShader(bounds),
                      child: const Text(
                        'VietQR',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColor.WHITE),
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const XImage(
                    imagePath: 'assets/images/ic-close-black.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildItem(
                text: 'Tài khoản:',
                value:
                    '${widget.dto.bankShortName} - ${widget.dto.bankAccount}'),
            const MySeparator(color: AppColor.GREY_DADADA),
            _buildItem(text: 'Chủ TK:', value: widget.dto.userBankName),
            const MySeparator(color: AppColor.GREY_DADADA),
            // _buildItem(text: 'Mã đơn:', value: widget.dto.orderId),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mã đơn:',
                    style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                  ),
                  SizedBox(
                    width: 150,
                    child: MTextFieldCustom(
                        controller: textEditingController,
                        contentPadding: EdgeInsets.zero,
                        focusBorder: InputBorder.none,
                        enableBorder: InputBorder.none,
                        textAlign: TextAlign.right,
                        styles: const TextStyle(
                            fontSize: 15, color: AppColor.GREY_TEXT),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.edit_note_sharp,
                            color: AppColor.BLUE_TEXT,
                            size: 20,
                          ),
                        ),
                        enable: true,
                        hintText: '',
                        keyboardAction: TextInputAction.done,
                        onChange: (value) {},
                        inputType: TextInputType.text,
                        isObscureText: false),
                  )
                ],
              ),
            ),
            const MySeparator(color: AppColor.GREY_DADADA),
            _buildItem(
                text: 'Điểm bán:',
                value: widget.dto.terminalCode.isEmpty
                    ? '-'
                    : widget.dto.terminalCode),
            const MySeparator(color: AppColor.GREY_DADADA),
            _buildItem(text: 'Nội dung TT:', value: widget.dto.content),
            const Spacer(),
            if (isCheckOrderId) ...[
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'Lưu ý: mã đơn này đã được sử dụng',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
              ),
              const SizedBox(height: 10),
            ],
            VietQRButton.gradient(
                onPressed: () {
                  QRRecreateDTO qrRecreateDTO = QRRecreateDTO(
                      terminalCode: widget.dto.terminalCode,
                      bankId: widget.bankAccount.id,
                      amount: widget.dto.amount.replaceAll(',', ''),
                      content: widget.dto.content,
                      orderId: textEditingController.text,
                      userId: userId,
                      newTransaction: true);
                  Navigator.of(context).pop(qrRecreateDTO);
                },
                isDisabled: false,
                size: VietQRButtonSize.large,
                child: const Center(
                  child: Text(
                    'Xác nhận tạo mã QR',
                    style: TextStyle(fontSize: 15, color: AppColor.WHITE),
                  ),
                ))
          ],
        );
      },
    );
  }

  Widget _buildItem({
    required String text,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              textAlign: TextAlign.right,
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  Future<ResponseMessageDTO> checkOrderId(
      {required String bankId, required String orderId}) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}transaction-check/order?bankId=$bankId&orderId=$orderId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }
}
