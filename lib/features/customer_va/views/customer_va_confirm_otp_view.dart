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
import 'package:vierqr/models/response_message_dto.dart';
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
                        ButtonWidget(
                            text: 'Gửi lại OTP',
                            width: 120,
                            height: 40,
                            borderRadius: 5,
                            textColor: AppColor.BLUE_TEXT,
                            bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                            function: () {
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
                            }),
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
                  child: CachedNetworkImage(
                    imageUrl: Provider.of<CustomerVaInsertProvider>(context,
                            listen: false)
                        .bidvLogoUrl,
                    height: 50,
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
                bool isValidButton = (!provider.bankAccountErr &&
                    provider.bankAccount.toString().trim().isNotEmpty &&
                    !provider.userBankNameErr &&
                    provider.userBankName.toString().trim().isNotEmpty);
                return ButtonWidget(
                  text: 'Xác thực',
                  textColor: (!isValidButton) ? AppColor.BLACK : AppColor.WHITE,
                  bgColor: (!isValidButton)
                      ? AppColor.GREY_VIEW
                      : AppColor.BLUE_TEXT,
                  borderRadius: 5,
                  function: () async {
                    if (isValidButton) {}
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
  Future<void> _confirmOTP() async {
    //
  }
}
