import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/qr_certificate/view/choose_bank_connect_view.dart';
import 'package:vierqr/features/qr_certificate/view/create_info_connect_view.dart';
import 'package:vierqr/features/qr_certificate/widget/qr_cert_appbar.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/ecommerce_request_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

import 'view/connection_info_view.dart';

class QrCertificateScreen extends StatefulWidget {
  final String qrCode;

  const QrCertificateScreen({super.key, required this.qrCode});

  @override
  State<QrCertificateScreen> createState() => _QrCertificateScreenState();
}

class _QrCertificateScreenState extends State<QrCertificateScreen> {
  final PageController pageController = PageController();
  // ValueNotifier<int> pageNotifier = ValueNotifier<int>(0);
  int currentPage = 0;
  ValueNotifier<bool> enableButtonNotifier = ValueNotifier<bool>(false);

  BankAccountDTO? selectedBank;

  ValueNotifier<EcommerceRequest> ecomNotifier =
      ValueNotifier<EcommerceRequest>(
          EcommerceRequest(fullName: '', name: '', certificate: ''));

  Future<ResponseMessageDTO> ecomActive(EcommerceRequest ecom) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(message: '', status: '');

    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}ecommerce/active';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: ecom.toJson(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      resizeToAvoidBottomInset: true,
      appBar: VietQrAppBar(
        leadingWidth: 120,
        leading: InkWell(
          onTap: () {
            if (currentPage == 0) {
              Navigator.of(context).pop();
            } else {
              pageController.previousPage(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.black,
                  size: 25,
                ),
                const SizedBox(width: 2),
                if (currentPage == 0)
                  const XImage(
                    imagePath: 'assets/images/ic-viet-qr.png',
                    height: 28,
                    fit: BoxFit.fitHeight,
                  )
                else
                  const Text(
                    "Trở về",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  )
              ],
            ),
          ),
        ),
        actions: [
          if (currentPage != 0) ...[
            const XImage(
              imagePath: 'assets/images/ic-viet-qr.png',
              height: 28,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(width: 4)
          ],
          const XImage(imagePath: 'assets/images/ic-merchant-3D.png'),
          const SizedBox(width: 8)
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder<EcommerceRequest>(
        valueListenable: ecomNotifier,
        builder: (context, ecom, child) {
          return ValueListenableBuilder<bool>(
            valueListenable: enableButtonNotifier,
            builder: (context, enable, child) {
              bool isEnable = false;
              switch (currentPage) {
                case 0:
                  isEnable = !enable;
                  break;
                case 1:
                  FocusManager.instance.primaryFocus?.unfocus();
                  isEnable = selectedBank == null;
                  break;
                case 2:
                  isEnable = selectedBank == null;
                  break;
                default:
              }
              return VietQRButton.gradient(
                height: 50,
                margin: EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    MediaQuery.of(context).viewInsets.bottom != 0
                        ? 8 + MediaQuery.of(context).viewInsets.bottom
                        : 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: () async {
                  switch (currentPage) {
                    case 0:
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeInOut);
                      break;
                    case 1:
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeInOut);
                      break;
                    case 2:
                      await ecomActive(EcommerceRequest(
                        fullName: ecom.fullName,
                        name: ecom.name,
                        certificate: widget.qrCode,
                        bankCode: selectedBank!.bankCode,
                        bankAccount: selectedBank!.bankAccount,
                        address: ecom.address,
                        businessType: ecom.businessType,
                        career: ecom.career,
                        email: ecom.email,
                        nationalId: ecom.nationalId,
                        phoneNo: ecom.phoneNo,
                      )).then(
                        (res) {
                          if (res.status == 'SUCCESS') {
                            Fluttertoast.showToast(
                              msg: 'Kết nối thành công',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Theme.of(context).cardColor,
                              textColor: Theme.of(context).hintColor,
                              fontSize: 15,
                            );
                            Navigator.of(context).pop();
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Kết nối thất bại',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Theme.of(context).cardColor,
                              textColor: Theme.of(context).hintColor,
                              fontSize: 15,
                            );
                          }
                        },
                      );
                      break;
                    default:
                  }
                },
                isDisabled: isEnable,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const XImage(
                      imagePath: 'assets/images/ic-next-blue.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      color: AppColor.TRANSPARENT,
                    ),
                    Text(
                      currentPage == 2 ? 'Xác nhận' : 'Tiếp tục',
                      style: TextStyle(
                          fontSize: 15,
                          color: !isEnable ? AppColor.WHITE : AppColor.BLACK),
                    ),
                    XImage(
                      imagePath: 'assets/images/ic-next-blue.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      color: !isEnable ? AppColor.WHITE : AppColor.BLACK,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
        children: [
          ValueListenableBuilder<EcommerceRequest>(
            valueListenable: ecomNotifier,
            builder: (context, ecom, child) {
              return CreateInfoConnectView(
                ecom: ecom,
                qrCode: widget.qrCode,
                onChange: (ecom) {
                  ecomNotifier.value = ecom;
                },
                onInput: (isEnable) {
                  enableButtonNotifier.value = isEnable;
                },
              );
            },
          ),
          ChooseBankConnectView(
            onSelectBank: (bank) {
              setState(() {
                selectedBank = bank;
              });
            },
            bankSelect: selectedBank,
          ),
          ValueListenableBuilder<EcommerceRequest>(
            valueListenable: ecomNotifier,
            builder: (context, ecom, child) {
              return ConnectionInfoView(
                dto: EcommerceRequest(
                  fullName: ecom.fullName,
                  name: ecom.name,
                  certificate: widget.qrCode,
                  bankCode: selectedBank != null ? selectedBank!.bankCode : '',
                  bankAccount:
                      selectedBank != null ? selectedBank!.bankAccount : '',
                  address: ecom.address,
                  businessType: ecom.businessType,
                  career: ecom.career,
                  email: ecom.email,
                  nationalId: ecom.nationalId,
                  phoneNo: ecom.phoneNo,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
