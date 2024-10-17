import 'dart:async';
import 'dart:ui';

import 'package:dudv_base/themes/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/numeral.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/extensions/string_extension.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/pin_confirm_password_widget.dart';
import 'package:vierqr/commons/widgets/pin_new_password_widget.dart';
import 'package:vierqr/features/login/blocs/forgot_password_bloc.dart';
import 'package:vierqr/features/login/events/forgot_password_event.dart';
import 'package:vierqr/features/login/states/forgot_password_state.dart';
import 'package:vierqr/features/login/widgets/text_field_code.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/pin_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String userName;
  final String phone;
  final String imageId;
  final String email;
  final AppInfoDTO appInfoDTO;

  // static String routeName = '/forgot_password';

  const ForgotPasswordScreen(
      {super.key,
      required this.userName,
      required this.phone,
      required this.appInfoDTO,
      required this.email,
      required this.imageId});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with WidgetsBindingObserver {
  late Timer _timer;

  final ValueNotifier<int> _timerNotifier = ValueNotifier<int>(600);
  final ValueNotifier<bool> _expriedNotifer = ValueNotifier<bool>(false);

  late final _authenProvider =
      Provider.of<AuthenProvider>(context, listen: false);
  late final ForgotPasswordBloc _bloc;

  final FocusNode otpNode = FocusNode();
  final FocusNode passNode = FocusNode();
  final FocusNode confirmPassNode = FocusNode();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  bool isPassFocus = false;
  bool isConfirmPassFocus = false;
  bool isSamePass = false;
  bool isCircle = false;
  bool isSuccess = false;
  bool readOnly = true;
  bool readOnlyConfirm = true;

  @override
  void initState() {
    Provider.of<AuthenProvider>(context, listen: false).initThemeDTO();
    // Provider.of<PinProvider>(context, listen: false).resetPinNewPass();
    _bloc = getIt.get<ForgotPasswordBloc>();
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    Map<String, dynamic> param = {
      'phoneNo': widget.phone,
      'email': widget.email,
    };
    _bloc.add(ForgotPasswordEventSendOTP(param: param));

    _startTimer();
    otpNode.requestFocus();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secondsRemaining = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secondsRemaining.toString().padLeft(2, '0')}';
  }

  void _resetTimer() {
    _timerNotifier.value = 600;
    _expriedNotifer.value = false;
    // _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerNotifier.value > 0) {
        _timerNotifier.value--;
      } else {
        Map<String, dynamic> param = {
          'phoneNo': widget.phone,
          'email': widget.email,
        };
        _bloc.add(ForgotPasswordEventResendOTP(param: param));
        _expriedNotifer.value = true;
        _resetTimer();

        readOnly = true;
        readOnlyConfirm = true;
        isPassFocus = false;
        isConfirmPassFocus = false;

        _passwordController.clear();
        _confirmPasswordController.clear();

        FocusManager.instance.primaryFocus?.unfocus();
        Provider.of<PinProvider>(context, listen: false).resetPinNewPass();
        Provider.of<PinProvider>(context, listen: false)
            .resetPinConfirmNewPass();
        otpNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    otpNode.dispose();
    passNode.dispose();
    confirmPassNode.dispose();
    _timer.cancel();
    // re.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state.status == BlocStatus.SUCCESS &&
              state.request == ForgotPasswordType.SEND_OTP) {}

          if (state.status == BlocStatus.ERROR &&
              (state.request == ForgotPasswordType.SEND_OTP ||
                  state.request == ForgotPasswordType.RESEND_OTP)) {
            Fluttertoast.showToast(
              msg: state.msg,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
            _expriedNotifer.value = true;
            _timer.cancel();
          }

          if (state.status == BlocStatus.SUCCESS &&
              state.request == ForgotPasswordType.RESEND_OTP) {
            _resetTimer();
          }

          if (state.status == BlocStatus.SUCCESS &&
              state.request == ForgotPasswordType.VERIFY_OTP) {
            readOnly = false;
            otpNode.unfocus();
            if (!otpNode.hasFocus) {
              isPassFocus = true;
              passNode.requestFocus();
            }
          }

          if (state.status == BlocStatus.SUCCESS &&
              state.request == ForgotPasswordType.NEW_PASS) {
            FocusManager.instance.primaryFocus?.unfocus();
            isConfirmPassFocus = true;
            readOnlyConfirm = false;
            confirmPassNode.requestFocus();
          }

          if (state.status == BlocStatus.ERROR &&
              state.request == ForgotPasswordType.CONFIRM_PASS) {
            isSamePass = state.isSamePass;
          }

          if (state.status == BlocStatus.SUCCESS &&
              state.request == ForgotPasswordType.CONFIRM_PASS) {
            isSamePass = false;
          }

          if (state.status == BlocStatus.LOADING &&
              state.request == ForgotPasswordType.CHANGE_PASS) {
            // DialogWidget.instance.openLoadingDialog();
            isCircle = true;
            readOnly = true;
            FocusManager.instance.primaryFocus?.unfocus();
          }

          if (state.status == BlocStatus.SUCCESS &&
              state.request == ForgotPasswordType.CHANGE_PASS) {
            isCircle = false;
            isSuccess = true;
            Future.delayed(const Duration(seconds: 2)).then(
              (value) {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: 'Thay đổi mật khẩu thành công!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Theme.of(context).hintColor,
                  fontSize: 15,
                );
              },
            );

            Provider.of<PinProvider>(context, listen: false).resetPinNewPass();
            Provider.of<PinProvider>(context, listen: false)
                .resetPinConfirmNewPass();
          }
          if (state.status == BlocStatus.ERROR &&
              state.request == ForgotPasswordType.CHANGE_PASS) {
            isSuccess = false;
            isCircle = false;

            readOnly = false;
            readOnlyConfirm = true;

            isPassFocus = true;
            isConfirmPassFocus = false;

            passNode.requestFocus();

            DialogWidget.instance.openMsgDialog(
                title: 'Không thể cập nhật Mật khẩu',
                msg: state.msg,
                // 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập.',
                function: () {
                  Navigator.pop(context);
                  Provider.of<PinProvider>(context, listen: false)
                      .resetPinNewPass();
                  Provider.of<PinProvider>(context, listen: false)
                      .resetPinConfirmNewPass();
                  _passwordController.clear();
                  _confirmPasswordController.clear();
                });
            // Provider.of<PinProvider>(context, listen: false).resetPinNewPass();
            // Provider.of<PinProvider>(context, listen: false)
            //     .resetPinConfirmNewPass();
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            bottomNavigationBar: _buildButtonSubmit(height, width, () {
              _bloc.add(
                ForgotPasswordEventChangePassword(
                  _passwordController.text,
                  _confirmPasswordController.text,
                  widget.phone,
                ),
              );
            }, isSuccess, isCircle, state.isVerified, state.isSamePass),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 150,
                    child: Stack(
                      children: [
                        Container(
                          height: 150,
                          padding: const EdgeInsets.only(
                              top: 50, left: 40, right: 40),
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
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
                          height: 150,
                          padding: const EdgeInsets.only(
                              top: kToolbarHeight, left: 20, right: 20),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Provider.of<PinProvider>(context,
                                              listen: false)
                                          .resetPinNewPass();
                                      Provider.of<PinProvider>(context,
                                              listen: false)
                                          .resetPinConfirmNewPass();
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  XImage(
                                    width: 40,
                                    height: 40,
                                    borderRadius: BorderRadius.circular(20),
                                    imagePath: _authenProvider
                                            .avatarUser.path.isEmpty
                                        ? widget.imageId.isNotEmpty
                                            ? widget.imageId.getPathIMageNetwork
                                            : ImageConstant.icAvatar
                                        : _authenProvider.avatarUser.path,
                                    errorWidget: const XImage(
                                      imagePath: ImageConstant.icAvatar,
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.userName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.email,
                                          style: const TextStyle(
                                            color: AppColor.GREY_TEXT,
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/ic-viet-qr.png',
                                    height: 30,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Mã xác nhận ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ValueListenableBuilder<int>(
                              valueListenable: _timerNotifier,
                              builder: (context, time, child) {
                                if (time == 0) {
                                  return const SizedBox.shrink();
                                }
                                return ShaderMask(
                                  shaderCallback: (bounds) => VietQRTheme
                                      .gradientColor.brightBlueLinear
                                      .createShader(bounds),
                                  child: Text(
                                    // ignore: unnecessary_string_interpolations
                                    "${_formatTime(time)}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.WHITE),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: _expriedNotifer,
                          builder: (context, isExpired, child) {
                            return InkWell(
                              onTap: state.isVerified
                                  ? () {}
                                  : () => _timerNotifier.value = 0,
                              // onTap: () {
                              //   _timerNotifier.value = 0;
                              //   // Map<String, dynamic> param = {
                              //   //   'phoneNo': widget.phone,
                              //   //   'email': widget.email,
                              //   // };
                              //   // // _resetTimer();
                              //   // _bloc.add(
                              //   //     ForgotPasswordEventResendOTP(param: param));
                              // },
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF00C6FF),
                                    Color(0xFF0072FF),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds),
                                child: const Text(
                                  'Gửi lại mã',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.WHITE,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormFieldCode(
                      readOnly: state.isVerified,
                      hintText: 'Nhập mã xác nhận',
                      onTap: state.isVerified
                          ? () {}
                          : () => _otpController.clear(),
                      controller: _otpController,
                      keyboardAction: TextInputAction.send,
                      onChange: (value) {
                        if (_otpController.text.length == 6) {
                          Map<String, dynamic> param = {
                            'phoneNo': widget.phone,
                            'otp': _otpController.text,
                          };
                          _bloc.add(ForgotPasswordEventVerifyOTP(param: param));
                        }
                      },
                      inputType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                      ],
                      isObscureText: false,
                      autoFocus: true,
                      onSubmitted: (value) {
                        Map<String, dynamic> param = {
                          'otp': _otpController.text,
                          'userId': SharePrefUtils.getProfile().userId,
                          'email': widget.email,
                        };
                        _bloc.add(ForgotPasswordEventVerifyOTP(param: param));
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    height: 1,
                    color: AppColor.GREY_LIGHT,
                    width: double.infinity,
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 15),
                      child: Row(
                        mainAxisAlignment: !state.isErrVerify
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: !state.isErrVerify
                                ? !state.isVerified
                                : state.isVerified,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const XImage(
                                  imagePath: 'assets/images/ic-suggest.png',
                                  width: 30,
                                ),
                                ShaderMask(
                                  shaderCallback: (bounds) => VietQRTheme
                                      .gradientColor.aiTextColor
                                      .createShader(bounds),
                                  child: Text(
                                    'Gửi mã về ${widget.email}',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColor.WHITE,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: state.isErrVerify,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                state.msg,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.errorStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    child: const Text(
                      'Mật khẩu mới',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: isPassFocus
                                ? AppColor.BLUE_TEXT
                                : AppColor.GREY_DADADA,
                            width: 1.5)),
                    child: PinNewPasswordWidget(
                      width: MediaQuery.of(context).size.width,
                      pinSize: 15,
                      readOnly: readOnly,
                      pinLength: Numeral.DEFAULT_PIN_LENGTH,
                      editingController: _passwordController,
                      focusNode: passNode,
                      onChanged: (value) {
                        Provider.of<PinProvider>(context, listen: false)
                            .updatePinNewPassLength(value.length);

                        if (value.length == Numeral.DEFAULT_PIN_LENGTH) {
                          _bloc.add(const ForgotPasswordEventNewPass());
                        }
                      },
                      // autoFocus: true,
                      onDone: (value) {
                        if (_passwordController.text.length ==
                            Numeral.DEFAULT_PIN_LENGTH) {
                          _bloc.add(const ForgotPasswordEventNewPass());
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    child: Text(
                      'Xác nhận lại',
                      style: TextStyle(
                        color: isSamePass ? Colors.red : Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: isConfirmPassFocus
                                ? isSamePass
                                    ? Colors.red
                                    : AppColor.BLUE_TEXT
                                : AppColor.GREY_DADADA,
                            width: 1.5)),
                    child: PinConfirmPasswordWidget(
                      readOnly: readOnlyConfirm,
                      width: MediaQuery.of(context).size.width,
                      pinSize: 15,
                      pinLength: Numeral.DEFAULT_PIN_LENGTH,
                      editingController: _confirmPasswordController,
                      focusNode: confirmPassNode,
                      // autoFocus: true,
                      onChanged: (value) {
                        Provider.of<PinProvider>(context, listen: false)
                            .updatePinConfirmPassLength(value.length);

                        if (value.length == Numeral.DEFAULT_PIN_LENGTH) {
                          // _bloc.add(const ForgotPasswordEventNewPass());
                          FocusManager.instance.primaryFocus?.unfocus();
                          _bloc.add(
                            ForgotPasswordEventConfirmPassword(
                              password: _passwordController.text,
                              confirmPassword: _confirmPasswordController.text,
                            ),
                          );
                        }

                        if (value.isEmpty) {
                          setState(() {
                            isSamePass = false;
                          });
                          _bloc.add(
                            ForgotPasswordEventConfirmPassword(
                              password: _passwordController.text,
                              confirmPassword: _confirmPasswordController.text,
                            ),
                          );
                        }
                      },
                      // autoFocus: true,
                      onDone: (value) {
                        if (_confirmPasswordController.text.length ==
                            Numeral.DEFAULT_PIN_LENGTH) {
                          // _bloc.add(const ForgotPasswordEventNewPass());
                          FocusManager.instance.primaryFocus?.unfocus();
                          _bloc.add(
                            ForgotPasswordEventConfirmPassword(
                              password: _passwordController.text,
                              confirmPassword: _confirmPasswordController.text,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: isSamePass,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              state.msg,
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.errorStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget? _buildButtonSubmit(double height, double width, Function() callback,
      bool isSuccess, bool isCircle, bool isVerify, bool isSamePass) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 50,
          color: Colors.transparent,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              right: 20,
              left: 20),
          child: GestureDetector(
            onTap: () {
              if (isVerify == true && isSamePass == false) {
                callback();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isCircle
                  ? 50
                  : !isSuccess
                      ? width
                      : 220,
              height: 50,
              decoration: BoxDecoration(
                gradient: (isVerify == true && isSamePass == false)
                    ? VietQRTheme.gradientColor.brightBlueLinear
                    : VietQRTheme.gradientColor.disableLinear,
                borderRadius: BorderRadius.circular(isCircle ? 30 : 50),
              ),
              alignment: Alignment.center,
              child: !isCircle
                  ? !isSuccess
                      ? Text(
                          'Xác nhận',
                          style: TextStyle(
                            color: (isVerify == true && isSamePass == false)
                                ? AppColor.WHITE
                                : AppColor.BLACK,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white),
                              child: const Icon(
                                Icons.check,
                                color: Colors.blue,
                                weight: 10,
                                size: 24,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Flexible(
                              child: Text(
                                "Đổi thành công",
                                softWrap: false,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            )
                          ],
                        )
                  : const CircularProgressIndicator(
                      color: Colors.white,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
