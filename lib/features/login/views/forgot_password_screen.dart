import 'dart:ui';

import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/login/repositories/login_repository.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/pin_code_input.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/providers/auth_provider.dart';
import 'package:vierqr/services/providers/verify_otp_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String userName;
  final String phone;
  final AppInfoDTO appInfoDTO;

  static String routeName = '/forgot_password';

  const ForgotPasswordScreen(
      {super.key,
      required this.userName,
      required this.phone,
      required this.appInfoDTO});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with WidgetsBindingObserver {
  final pinController = TextEditingController();
  late CountDownOTPNotifier countdownProvider;
  final repassFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    countdownProvider = CountDownOTPNotifier(120);
    Provider.of<AuthProvider>(context, listen: false).initFileTheme();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    countdownProvider.onHideApp(state);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VerifyOtpProvider>(
      create: (_) => VerifyOtpProvider()
        ..phoneAuthentication(
          widget.phone,
          onSentOtp: (type) {
            if (type == TypeOTP.SUCCESS) {
              countdownProvider.countDown();
            }
          },
        ),
      child: Consumer<VerifyOtpProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            body: Column(
              children: [
                Container(
                  height: 200,
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        padding:
                            const EdgeInsets.only(top: 70, left: 40, right: 40),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: widget.appInfoDTO.isEventTheme
                              ? DecorationImage(
                                  image: NetworkImage(
                                      widget.appInfoDTO.themeImgUrl),
                                  fit: BoxFit.cover)
                              : Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .file
                                      .path
                                      .isNotEmpty
                                  ? DecorationImage(
                                      image: FileImage(
                                          Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false)
                                              .file),
                                      fit: BoxFit.cover)
                                  : DecorationImage(
                                      image: AssetImage(
                                          'assets/images/bgr-header.png'),
                                      fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 30),
                            child: Container(
                              color: Colors.white.withOpacity(0.0),
                              height: 40,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.only(
                            top: kToolbarHeight, left: 20, right: 40),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Xin chào, ${widget.userName}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        StringUtils.instance
                                            .formatPhoneNumberVN(widget.phone),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Image.asset(
                                    'assets/images/ic-viet-qr.png',
                                    height: 40,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 30, right: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    const Spacer(),
                                    _buildStep(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Quên mật khẩu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                if (step == 1) ...[
                  Text(
                    'Đặt mật khẩu*',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.BLACK,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Mật khẩu có độ dài 6 ký tự số, không bao gồm chữ và ký tự đặc biệt',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColor.BLACK,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: 280,
                    child: PinCodeInput(
                      autoFocus: true,
                      obscureText: true,
                      onChanged: (value) {
                        provider.updatePassword(value);
                        if (value.length == 6) {
                          repassFocus.requestFocus();
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: provider.passwordErr,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        'Mật khẩu bao gồm 6 số.',
                        style:
                            TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Xác nhận lại mật khẩu*',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.BLACK,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Nhập lại mật khẩu ở trên để xác nhận',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColor.BLACK,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: 280,
                    child: PinCodeInput(
                      autoFocus: true,
                      obscureText: true,
                      focusNode: repassFocus,
                      onChanged: provider.updateConfirmPassword,
                    ),
                  ),
                  Visibility(
                    visible: provider.confirmPassErr,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        'Mật khẩu không trùng khớp',
                        style:
                            TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                      ),
                    ),
                  ),
                ] else ...[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Nhập mã OTP từ MB gửi về số điện thoại ',
                          style: TextStyle(fontSize: 15, color: AppColor.BLACK),
                        ),
                        TextSpan(
                          text: '${widget.phone}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColor.BLACK),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    alignment: Alignment.center,
                    child: PinCodeInput(
                      controller: pinController,
                      autoFocus: true,
                      onChanged: provider.onChangePinCode,
                      onCompleted: (value) {},
                      clBorderErr:
                          provider.otpError != null ? AppColor.error700 : null,
                      error: provider.otpError != null ? true : false,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.otpError ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 20 / 12,
                      color: AppColor.error700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder(
                    valueListenable: countdownProvider,
                    builder: (_, value, child) {
                      if (value != 0) {
                        return RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 15,
                            ),
                            children: [
                              const TextSpan(
                                  text: 'Mã OTP có hiệu lực trong vòng '),
                              TextSpan(
                                text: value.toString(),
                                style:
                                    const TextStyle(color: AppColor.BLUE_TEXT),
                              ),
                              const TextSpan(text: 's.'),
                            ],
                          ),
                        );
                      } else {
                        return RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 15,
                            ),
                            children: [
                              const TextSpan(text: 'Không nhận được mã OTP? '),
                              if (countdownProvider.resendOtp <= 0)
                                const TextSpan()
                              else
                                TextSpan(
                                  text:
                                      'Gửi lại (${countdownProvider.resendOtp})',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: AppColor.BLUE_TEXT,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      countdownProvider.resendCountDown();
                                      pinController.clear();
                                      provider
                                          .phoneAuthentication(widget.phone);
                                    },
                                ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
                const Spacer(),
                if (step == 1)
                  MButtonWidget(
                    title: 'Đặt lại mật khẩu',
                    isEnable: provider.isEnable(),
                    onTap: () async {
                      final body = {
                        'phoneNo': widget.phone,
                        'password': EncryptUtils.instance.encrypted(
                            widget.phone, provider.passwordController.text),
                      };
                      ResponseMessageDTO result =
                          await loginRepository.forgotPass(body);

                      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
                        Fluttertoast.showToast(
                          msg: 'Thành công',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Theme.of(context).cardColor,
                          textColor: Theme.of(context).hintColor,
                          fontSize: 15,
                        );

                        Navigator.pop(context);
                      } else {
                        await DialogWidget.instance.openMsgDialog(
                            title: 'Thông báo',
                            msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau.');
                      }
                    },
                  )
                else
                  MButtonWidget(
                    title: 'Xác thực',
                    isEnable: pinController.text.length >= 6,
                    colorEnableText: pinController.text.length >= 6
                        ? AppColor.WHITE
                        : AppColor.GREY_TEXT,
                    onTap: () async {
                      final data = await provider.verifyOTP(pinController.text);
                      if (data != null) {
                        step = 1;
                        setState(() {});
                      }
                    },
                  ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  final loginRepository = LoginRepository();

  int step = 0;

  Widget _buildStep() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: const SizedBox()),
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: AppColor.BLUE_TEXT,
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      '1',
                      style: TextStyle(color: AppColor.WHITE),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          height: 2,
                          color: step == 1
                              ? AppColor.BLUE_TEXT
                              : AppColor.grey979797)),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Xác thực OTP',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                          height: 2,
                          color: step == 1
                              ? AppColor.BLUE_TEXT
                              : AppColor.grey979797)),
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: step == 1
                            ? AppColor.BLUE_TEXT
                            : AppColor.grey979797.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      '2',
                      style: TextStyle(
                          color: step == 1
                              ? AppColor.WHITE
                              : AppColor.textBlack.withOpacity(0.6)),
                    ),
                  ),
                  Expanded(child: const SizedBox()),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Nhập mật khẩu mới',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
