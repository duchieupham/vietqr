import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/count_down_minus_second.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/customer_va/repositories/customer_va_repository.dart';
import 'package:vierqr/features/customer_va/widgets/customer_va_header_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/customer_va_confirm_dto.dart';
import 'package:vierqr/models/customer_va_insert_dto.dart';
import 'package:vierqr/models/customer_va_request_dto.dart';
import 'package:vierqr/models/customer_va_response_otp_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/customer_va/customer_va_insert_provider.dart';

class CustomerVaConfirmOtpView extends StatefulWidget {
  const CustomerVaConfirmOtpView({super.key});

  @override
  State<StatefulWidget> createState() => _CustomerVaConfirmOtpView();
}

class _CustomerVaConfirmOtpView extends State<CustomerVaConfirmOtpView>
    with TickerProviderStateMixin {
  final CustomerVaRepository customerVaRepository =
      const CustomerVaRepository();
  String _otp = '';
  String _phoneNo = '';
  late AnimationController _controller;
  int timer = 120;
  bool _isTimeout = false;

  @override
  void initState() {
    super.initState();
    _phoneNo = Provider.of<CustomerVaInsertProvider>(context, listen: false)
        .phoneAuthenticated;
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                timer) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller.forward();
    _controller.addListener(() {
      if (_controller.isCompleted) {
        _isTimeout = true;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      appBar: CustomerVaHeaderWidget(),
      body: Column(
        children: [
          Divider(
            color: AppColor.GREY_VIEW,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SizedBox(
              child: (_isTimeout)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mã OTP hết hiệu lực',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Consumer<CustomerVaInsertProvider>(
                          builder: (context, provider, child) {
                            bool isValidButton = (!provider.nationalIdErr &&
                                provider.nationalId
                                    .toString()
                                    .trim()
                                    .isNotEmpty &&
                                !provider.phoneAuthenticatedErr &&
                                provider.phoneAuthenticated
                                    .toString()
                                    .trim()
                                    .isNotEmpty);
                            return ButtonWidget(
                              text: 'Gửi lại OTP',
                              width: 120,
                              height: 40,
                              borderRadius: 5,
                              textColor: AppColor.BLUE_TEXT,
                              bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                              function: () async {
                                timer = 120;
                                _isTimeout = false;
                                setState(() {});
                                _controller = AnimationController(
                                    vsync: this,
                                    duration: Duration(
                                        seconds:
                                            timer) // gameData.levelClock is a user entered number elsewhere in the applciation
                                    );

                                _controller.forward();
                                CustomerVaRequestDTO dto = CustomerVaRequestDTO(
                                  merchantName:
                                      provider.merchantName.toString().trim(),
                                  bankAccount:
                                      provider.bankAccount.toString().trim(),
                                  bankCode: 'BIDV',
                                  userBankName:
                                      provider.userBankName.toString().trim(),
                                  nationalId:
                                      provider.nationalId.toString().trim(),
                                  phoneAuthenticated: provider
                                      .phoneAuthenticated
                                      .toString()
                                      .trim(),
                                );
                                await _requestCustomerVaOTP(dto);
                              },
                            );
                          },
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mã OTP có hiệu lực trong vòng',
                          style: const TextStyle(fontSize: 15),
                        ),
                        CountDown(
                          animation: StepTween(
                            begin: timer, // THIS IS A USER ENTERED NUMBER
                            end: 0,
                          ).animate(_controller),
                        ),
                      ],
                    ),
            ),
          ),
          Divider(
            color: AppColor.GREY_VIEW,
            height: 1,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0XFFDADADA), width: 1),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: Provider.of<CustomerVaInsertProvider>(context,
                              listen: false)
                          .bidvLogoUrl,
                      height: 50,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Vui lòng nhập mã OTP\nđược gửi về SĐT ${StringUtils.instance.formatPhoneNumberVN(_phoneNo)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                MTextFieldCustom(
                  isObscureText: true,
                  maxLines: 1,
                  showBorder: false,
                  fillColor: AppColor.TRANSPARENT,
                  value: _otp,
                  autoFocus: true,
                  textFieldType: TextfieldType.DEFAULT,
                  title: '',
                  hintText: '',
                  inputType: TextInputType.text,
                  keyboardAction: TextInputAction.done,
                  maxLength: 6,
                  onChange: (value) {
                    _otp = value;
                    setState(() {});
                    Provider.of<CustomerVaInsertProvider>(context,
                            listen: false)
                        .updateOtp(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Nhập mã OTP ở đây*',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppColor.GREY_TEXT,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                    ),
                  ),
                  inputFormatter: [
                    LengthLimitingTextInputFormatter(50),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            child: Consumer<CustomerVaInsertProvider>(
              builder: (context, provider, child) {
                bool isValidButton =
                    (provider.otp.toString().trim().isNotEmpty &&
                        provider.otp.toString().trim().length == 6);
                return ButtonWidget(
                  text: 'Xác thực',
                  textColor: (!isValidButton) ? AppColor.BLACK : AppColor.WHITE,
                  bgColor: (!isValidButton)
                      ? AppColor.GREY_VIEW
                      : AppColor.BLUE_TEXT,
                  borderRadius: 5,
                  function: () async {
                    if (isValidButton) {
                      CustomerVaConfirmDTO dto = CustomerVaConfirmDTO(
                        merchantId: provider.merchantId.toString().trim(),
                        merchantName: provider.merchantName.toString().trim(),
                        confirmId: provider.confirmId.toString().trim(),
                        otpNumber: provider.otp.toString().trim(),
                      );
                      _confirmOTP(
                        dto,
                        provider.bankAccount.toString().trim(),
                        provider.userBankName.toString().trim(),
                        provider.nationalId.toString().trim(),
                        provider.phoneAuthenticated.toString().trim(),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //
  Future<void> _requestCustomerVaOTP(CustomerVaRequestDTO dto) async {
    DialogWidget.instance.openLoadingDialog();
    dynamic result = await customerVaRepository.requestCustomerVaOTP(dto);
    String msg = ErrorUtils.instance.getErrorMessage('E05');
    if (result is ResponseObjectDTO) {
      //save data response
      Provider.of<CustomerVaInsertProvider>(context, listen: false)
          .updateMerchantIdAndConfirmId(
        result.data.merchantId,
        result.data.confirmId,
      );
      //
      Navigator.pop(context);
    } else if (result is ResponseMessageDTO) {
      msg = ErrorUtils.instance.getErrorMessage(result.message);
      Navigator.pop(context);
      DialogWidget.instance
          .openMsgDialog(title: 'Không thể đăng ký dịch vụ', msg: msg);
    } else {
      Navigator.pop(context);
      DialogWidget.instance
          .openMsgDialog(title: 'Không thể đăng ký dịch vụ', msg: msg);
    }
  }

  //
  Future<void> _confirmOTP(CustomerVaConfirmDTO dto, String bankAccount,
      String userBankName, String nationalId, String phoneAuthenticated) async {
    //

    DialogWidget.instance.openLoadingDialog();
    ResponseMessageDTO result =
        await customerVaRepository.confirmCustomerVaOTP(dto);
    String status = result.status;
    String msg = '';
    if (status == 'SUCCESS') {
      CustomerVaInsertDTO insertDTO = CustomerVaInsertDTO(
        merchantId: dto.merchantId,
        merchantName: dto.merchantName,
        bankId: '',
        userId: SharePrefUtils.getProfile().userId,
        bankAccount: bankAccount,
        userBankName: userBankName,
        nationalId: nationalId,
        phoneAuthenticated: phoneAuthenticated,
        vaNumber: result.message,
      );
      //insert
      ResponseMessageDTO resultInsert =
          await customerVaRepository.insertCustomerVa(insertDTO);
      String statusInsert = resultInsert.status;
      String msgInsert = '';
      if (statusInsert == 'SUCCESS') {
        Navigator.pop(context);
        //navigator success insert customer va screen
        Navigator.pushReplacementNamed(context, Routes.CUSTOMER_VA_SUCCESS);
      } else {
        msgInsert = ErrorUtils.instance.getErrorMessage(resultInsert.message);
        Navigator.pop(context);
        DialogWidget.instance
            .openMsgDialog(title: 'Không thể xác thực', msg: msgInsert);
      }
    } else {
      msg = ErrorUtils.instance.getErrorMessage(result.message);
      Navigator.pop(context);
      DialogWidget.instance
          .openMsgDialog(title: 'Không thể xác thực', msg: msg);
    }
  }
}
