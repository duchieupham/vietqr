import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/register/views/page/confirm_otp_register.dart';
import 'package:vierqr/features/register/views/page/form_success_splash.dart';
import 'package:vierqr/features/verify_email/blocs/verify_email_bloc.dart';
import 'package:vierqr/features/verify_email/events/verify_email_event.dart';
import 'package:vierqr/features/verify_email/states/verify_email_state.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/layouts/register_app_bar.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/register_provider.dart';

class ConfirmEmailRegisterScreen extends StatefulWidget {
  final String phoneNum;
  const ConfirmEmailRegisterScreen({super.key, required this.phoneNum});

  @override
  State<ConfirmEmailRegisterScreen> createState() =>
      _ConfirmEmailRegisterScreenState();
}

class _ConfirmEmailRegisterScreenState
    extends State<ConfirmEmailRegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  final EmailBloc _bloc = getIt.get<EmailBloc>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return emailRegex.hasMatch(email);
  }

  void validateEmail(String email) {
    if (email.isEmpty || !isValidEmail(email)) {
      setState(() {
        _emailError =
            'Email không hợp lệ. Vui lòng kiểm tra lại thông tin của bạn.';
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }
  }

  String get userId => SharePrefUtils.getProfile().userId.trim();
  // bool _onHomeCalled = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailBloc, EmailState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is SendOTPSuccessfulState) {
          Fluttertoast.showToast(
            msg: 'Gửi mã OTP thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmOtpRegisterScreen(
                email: _emailController.text,
                isFocus: true,
              ),
            ),
          );
        }
        if (state is SendOTPFailedState) {
          Fluttertoast.showToast(
            msg: 'Gửi mã OTP thất bại',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.WHITE,
          appBar: RegisterAppBar(
            isLeading: false,
            title: '',
            onPressed: () {
              // Navigator.of(context).pop();
            },
          ),
          resizeToAvoidBottomInset:
              true, // Allow the screen to resize when the keyboard is visible
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Xác thực thông tin ',
                          style: TextStyle(
                            color: AppColor.BLACK,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Email',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(Rect.fromLTWH(0, 0, 200, 40)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'cho tài khoản ${widget.phoneNum}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  MTextFieldCustom(
                    controller: _emailController,
                    isObscureText: false,
                    maxLines: 1,
                    showBorder: false,
                    enable: true,
                    fillColor: AppColor.WHITE,
                    autoFocus: true,
                    textFieldType: TextfieldType.DEFAULT,
                    title: '',
                    hintText: '',
                    inputType: TextInputType.emailAddress,
                    keyboardAction: TextInputAction.next,
                    onSubmitted: (value) {
                      validateEmail(_emailController.text);
                      bool isValidEmail = _emailError == null &&
                          _emailController.text.isNotEmpty;
                      if (isValidEmail) {
                        Map<String, dynamic> param = {
                          'recipient': _emailController.text,
                          'userId': SharePrefUtils.getProfile().userId,
                        };
                        _bloc.add(SendOTPEvent(param: param));
                      }
                    },
                    onChange: (value) {
                      validateEmail(value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Nhập email tại đây',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: AppColor.GREY_TEXT,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.GREY_DADADA),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.GREY_DADADA),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.GREY_DADADA),
                      ),
                    ),
                  ),
                  if (_emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        _emailError!,
                        style: const TextStyle(color: Colors.red, fontSize: 11),
                      ),
                    ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Nhận ngay ưu đãi sử dụng dịch vụ VietQR ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: 'miễn phí 01 tháng',
                          style: TextStyle(
                            fontSize: 20,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(Rect.fromLTWH(0, 0, 200, 40)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      XImage(
                        imagePath: 'assets/images/ic-noti-bdsd-black.png',
                        width: 40,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Nhận thông báo biến động số dư',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      XImage(
                        imagePath: 'assets/images/ic-earth-black.png',
                        width: 40,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Chuyển khoản nhanh chóng, mọi lúc mọi nơi',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      XImage(
                        imagePath: 'assets/images/ic-store-black.png',
                        width: 40,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Quản lý doanh thu các cửa hàng',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VietQRButton.gradient(
                  onPressed: () {
                    Map<String, dynamic> param = {
                      'recipient': _emailController.text,
                      'userId': SharePrefUtils.getProfile().userId,
                    };
                    _bloc.add(SendOTPEvent(param: param));
                  },
                  isDisabled: !(_emailError == null &&
                      _emailController.text.isNotEmpty),
                  size: VietQRButtonSize.large,
                  child: Center(
                    child: Text(
                      'Xác thực Email',
                      style: TextStyle(
                        color: (_emailError == null &&
                                _emailController.text.isNotEmpty)
                            ? AppColor.WHITE
                            : AppColor.BLACK,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    NavigationService.push(Routes.REGISTER_SPLASH_SCREEN);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => FormRegisterSuccessSplash(
                    //         // onHome: () {
                    //         //   _onHomeCalled = true;
                    //         //   // Navigator.of(context).popUntil((route) => route.,);
                    //         //   // Navigator.of(context).pop();
                    //         //   // Navigator.of(context).pop();
                    //         //   // Navigator.of(context).pop();
                    //         //   // backToPreviousPage(context, true);

                    //         // },
                    //         ),
                    //   ),
                    // );
                  },
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: const Text(
                      'Bỏ qua',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void backToPreviousPage(BuildContext context, bool isRegisterSuccess) {
    Navigator.pop(context, {
      'phone': Provider.of<RegisterProvider>(context, listen: false)
          .phoneNoController
          .text
          .replaceAll(' ', ''),
      'password': Provider.of<RegisterProvider>(context, listen: false)
          .passwordController
          .text,
    });
  }
}
