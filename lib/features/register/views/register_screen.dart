import 'package:vierqr/commons/constants/configurations/numeral.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/utils/user_information_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/register/events/register_event.dart';
import 'package:vierqr/features/register/frame/register_frame.dart';
import 'package:vierqr/features/register/states/register_state.dart';
import 'package:vierqr/features/register/views/pin_register_widget.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/services/providers/pin_provider.dart';
import 'package:vierqr/services/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'pin_code_input.dart';

class Register extends StatelessWidget {
  final String phoneNo;

  const Register({super.key, required this.phoneNo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (BuildContext context) => RegisterBloc(),
      child: RegisterScreen(phoneNo: phoneNo),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  final String phoneNo;

  const RegisterScreen({super.key, required this.phoneNo});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _phoneNoController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPassController = TextEditingController();

  bool _isChangePhone = false;

  bool _isChangePass = false;

  final FocusNode focusNode = FocusNode();

  // final auth = FirebaseAuth.instance;

  void initialServices(BuildContext context) {
    if (!_isChangePass) {
      _passwordController.clear();
      _confirmPassController.clear();
    }
    if (!_isChangePhone) {
      if (StringUtils.instance.isNumeric(widget.phoneNo)) {
        _phoneNoController.value =
            _phoneNoController.value.copyWith(text: widget.phoneNo);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initialServices(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) async {
        if (state is RegisterLoadingState) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state is RegisterFailedState) {
          //pop loading dialog
          Navigator.pop(context);
          //
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể đăng ký',
            msg: state.msg,
          );
        }
        if (state is RegisterSuccessState) {
          //pop loading dialog
          Navigator.of(context).pop();
          //pop to login page
          backToPreviousPage(context, true);
        }
        // if (state is RegisterSentOTPFailedState) {
        //   DialogWidget.instance.openLoadingDialog();
        //
        //   Future.delayed(const Duration(milliseconds: 500), () {
        //     Navigator.of(context).pop();
        //     DialogWidget.instance.openMsgDialog(
        //       title: 'Không thể đăng ký',
        //       msg: state.msg,
        //     );
        //   });
        // }

        // if (state is RegisterSentOTPSuccessState) {
        //   String userIP = await UserInformationUtils.instance.getIPAddress();
        //   AccountLoginDTO dto = AccountLoginDTO(
        //     phoneNo: _phoneNoController.text,
        //     password: EncryptUtils.instance.encrypted(
        //       _phoneNoController.text,
        //       _passwordController.text,
        //     ),
        //     device: userIP,
        //     fcmToken: '',
        //     platform: 'MOBILE',
        //   );
        //   DialogWidget.instance
        //       .showModalBottomContent(
        //         widget: VerifyOTPView(
        //           phone: _phoneNoController.text,
        //           dto: dto,
        //         ),
        //         height: height * 0.5,
        //       )
        //       .then((value) => isOpenOTP = false);
        // }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppBar(toolbarHeight: 0),
            body: Column(
              children: [
                SubHeader(
                    title: 'Đăng ký',
                    function: () {
                      backToPreviousPage(context, false);
                      Provider.of<PinProvider>(context, listen: false).reset();
                    }),
                (PlatformUtils.instance.isWeb())
                    ? const Padding(padding: EdgeInsets.only(top: 10))
                    : const SizedBox(),
                Expanded(child: Consumer<RegisterProvider>(
                  builder: (context, value, child) {
                    return RegisterFrame(
                      mobileChildren: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          BoxLayout(
                            width: width,
                            child: Column(
                              children: [
                                TextFieldWidget(
                                  width: width,
                                  isObscureText: false,
                                  textfieldType: TextfieldType.LABEL,
                                  title: 'Số điện thoại',
                                  titleWidth: 100,
                                  hintText: '090 123 4567',
                                  controller: _phoneNoController,
                                  inputType: TextInputType.number,
                                  keyboardAction: TextInputAction.next,
                                  onChange: (value) {
                                    _isChangePhone = true;
                                  },
                                ),
                                const Divider(
                                  height: 0.5,
                                  color: DefaultTheme.GREY_LIGHT,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Mật khẩu',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: PinRegisterWidget(
                                        pinSize: 20,
                                        pinLength: Numeral.DEFAULT_PIN_LENGTH,
                                        onDone: (value) {
                                          setState(() {
                                            _passwordController.value =
                                                _passwordController.value
                                                    .copyWith(text: value);
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),

                                // TextFieldWidget(
                                //   width: width,
                                //   isObscureText: true,
                                //   textfieldType: TextfieldType.LABEL,
                                //   title: 'Mật khẩu',
                                //   titleWidth: 100,
                                //   hintText: 'Bao gồm 6 số',
                                //   controller: _passwordController,
                                //   inputType: TextInputType.number,
                                //   keyboardAction: TextInputAction.next,
                                //   onChange: (value) {
                                //     _isChangePass = true;
                                //   },
                                // ),
                                const Divider(
                                  height: 0.5,
                                  color: DefaultTheme.GREY_LIGHT,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Xác nhận lại',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: PinRegisterWidget(
                                        pinSize: 20,
                                        pinLength: Numeral.DEFAULT_PIN_LENGTH,
                                        onDone: (value) {
                                          setState(() {
                                            _confirmPassController.value =
                                                _confirmPassController.value
                                                    .copyWith(text: value);
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                                // TextFieldWidget(
                                //   width: width,
                                //   isObscureText: true,
                                //   textfieldType: TextfieldType.LABEL,
                                //   title: 'Xác nhận lại',
                                //   titleWidth: 100,
                                //   hintText: 'Xác nhận lại Mật khẩu',
                                //   controller: _confirmPassController,
                                //   inputType: TextInputType.number,
                                //   keyboardAction: TextInputAction.next,
                                //   onChange: (value) {
                                //     _isChangePass = true;
                                //   },
                                // ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: value.phoneErr,
                            child: const Padding(
                              padding:
                                  EdgeInsets.only(left: 10, top: 5, right: 30),
                              child: Text(
                                'Số điện thoại không đúng định dạng.',
                                style: TextStyle(
                                    color: DefaultTheme.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: value.passwordErr,
                            child: const Padding(
                              padding:
                                  EdgeInsets.only(left: 10, top: 5, right: 30),
                              child: Text(
                                'Mật khẩu bao gồm 6 số.',
                                style: TextStyle(
                                    color: DefaultTheme.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: value.confirmPassErr,
                            child: const Padding(
                              padding:
                                  EdgeInsets.only(left: 10, top: 5, right: 30),
                              child: Text(
                                'Xác nhận Mật khẩu không trùng khớp.',
                                style: TextStyle(
                                    color: DefaultTheme.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                      webChildren: [
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: Image.asset(
                              'assets/images/ic-viet-qr.png',
                            ),
                          ),
                        ),
                        BorderLayout(
                          width: width,
                          isError: value.phoneErr,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFieldWidget(
                            width: width,
                            isObscureText: false,
                            maxLines: 1,
                            textfieldType: TextfieldType.LABEL,
                            title: 'Số điện thoại',
                            titleWidth: 100,
                            hintText: '090 123 4567',
                            controller: _phoneNoController,
                            inputType: TextInputType.number,
                            keyboardAction: TextInputAction.next,
                            onChange: (value) {
                              _isChangePhone = true;
                            },
                          ),
                        ),
                        Visibility(
                          visible: value.phoneErr,
                          child: const Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 5, right: 30),
                            child: Text(
                              'Số điện thoại không đúng định dạng.',
                              style: TextStyle(
                                  color: DefaultTheme.RED_TEXT, fontSize: 13),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        BorderLayout(
                          width: width,
                          isError: value.passwordErr,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFieldWidget(
                            width: width,
                            isObscureText: true,
                            maxLines: 1,
                            textfieldType: TextfieldType.LABEL,
                            title: 'Mật khẩu',
                            titleWidth: 100,
                            hintText: 'Bao gồm 6 số',
                            controller: _passwordController,
                            inputType: TextInputType.number,
                            keyboardAction: TextInputAction.next,
                            onChange: (value) {
                              _isChangePass = true;
                            },
                          ),
                        ),
                        Visibility(
                          visible: value.passwordErr,
                          child: const Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 5, right: 30),
                            child: Text(
                              'Mật khẩu bao gồm 6 số.',
                              style: TextStyle(
                                  color: DefaultTheme.RED_TEXT, fontSize: 13),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        BorderLayout(
                          width: width,
                          isError: value.confirmPassErr,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFieldWidget(
                            width: width,
                            isObscureText: true,
                            maxLines: 1,
                            textfieldType: TextfieldType.LABEL,
                            title: 'Xác nhận lại',
                            titleWidth: 100,
                            hintText: 'Xác nhận lại Mật khẩu',
                            controller: _confirmPassController,
                            inputType: TextInputType.number,
                            keyboardAction: TextInputAction.next,
                            onChange: (value) {
                              _isChangePass = true;
                            },
                          ),
                        ),
                        Visibility(
                          visible: value.confirmPassErr,
                          child: const Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 5, right: 30),
                            child: Text(
                              'Xác nhận Mật khẩu không trùng khớp.',
                              style: TextStyle(
                                  color: DefaultTheme.RED_TEXT, fontSize: 13),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 50)),
                        _buildButtonSubmit(context, width),
                      ],
                    );
                  },
                )),
                (PlatformUtils.instance.checkResize(width))
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                        child: _buildButtonSubmit(context, width),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  void backToPreviousPage(BuildContext context, bool isRegisterSuccess) {
    _isChangePhone = false;
    _isChangePass = false;
    Provider.of<RegisterProvider>(context, listen: false).reset();
    Navigator.pop(
        context,
        isRegisterSuccess
            ? {
                'phone': _phoneNoController.text,
                'password': _passwordController.text,
              }
            : null);
  }

  Widget _buildButtonSubmit(BuildContext context, double width) {
    return ButtonWidget(
      width: width - 40,
      text: 'Đăng ký tài khoản',
      textColor: DefaultTheme.WHITE,
      bgColor: DefaultTheme.GREEN,
      function: () async {
        Provider.of<RegisterProvider>(context, listen: false).updateErrs(
          phoneErr:
              (StringUtils.instance.isValidatePhone(_phoneNoController.text)!),
          passErr: (!StringUtils.instance.isNumeric(_passwordController.text) ||
              (_passwordController.text.length != 6)),
          confirmPassErr: !StringUtils.instance.isValidConfirmText(
              _passwordController.text, _confirmPassController.text),
        );
        if (Provider.of<RegisterProvider>(context, listen: false)
            .isValidValidation()) {
          String userIP = await UserInformationUtils.instance.getIPAddress();
          AccountLoginDTO dto = AccountLoginDTO(
            phoneNo: _phoneNoController.text,
            password: EncryptUtils.instance.encrypted(
              _phoneNoController.text,
              _passwordController.text,
            ),
            device: userIP,
            fcmToken: '',
            platform: 'MOBILE',
          );
          if (!mounted) return;
          context.read<RegisterBloc>().add(RegisterEventSubmit(dto: dto));
          // await Provider.of<RegisterProvider>(context, listen: false)
          //     .phoneAuthentication(
          //   _phoneNoController.text,
          //   onSentOtp: (type) {
          //     context
          //         .read<RegisterBloc>()
          //         .add(RegisterEventSentOTP(typeOTP: type));
          //   },
          // );
        }
      },
    );
  }

  bool isOpenOTP = false;
}
