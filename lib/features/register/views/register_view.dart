import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/commons/widgets/web_widgets/header_web_widget_old.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/register/events/register_event.dart';
import 'package:vierqr/features/register/frame/register_frame.dart';
import 'package:vierqr/features/register/states/register_state.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/services/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  final String phoneNo;

  static final TextEditingController _phoneNoController =
      TextEditingController();

  static final TextEditingController _passwordController =
      TextEditingController();

  static final TextEditingController _confirmPassController =
      TextEditingController();

  static late RegisterBloc _registerBloc;

  static bool _isChangePhone = false;
  static bool _isChangePass = false;

  const RegisterView({super.key, required this.phoneNo});

  void initialServices(BuildContext context) {
    _registerBloc = BlocProvider.of(context);
    if (!_isChangePass) {
      _passwordController.clear();
      _confirmPassController.clear();
    }
    if (!_isChangePhone) {
      if (StringUtils.instance.isNumeric(phoneNo)) {
        _phoneNoController.value =
            _phoneNoController.value.copyWith(text: phoneNo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          (PlatformUtils.instance.isWeb())
              ? HeaderWebWidgetOld(
                  title: 'Đăng ký',
                  isAuthenticate: false,
                  functionBack: () {
                    backToPreviousPage(context);
                  },
                )
              : SubHeader(
                  title: 'Đăng ký',
                  function: () {
                    backToPreviousPage(context);
                  }),
          (PlatformUtils.instance.isWeb())
              ? const Padding(padding: EdgeInsets.only(top: 10))
              : const SizedBox(),
          Expanded(
            child: BlocListener<RegisterBloc, RegisterState>(
              listener: ((context, state) {
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
                  backToPreviousPage(context);
                }
              }),
              child: Consumer<RegisterProvider>(
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
                                onChange: (vavlue) {
                                  _isChangePhone = true;
                                },
                              ),
                              const Divider(
                                height: 0.5,
                                color: DefaultTheme.GREY_LIGHT,
                              ),
                              TextFieldWidget(
                                width: width,
                                isObscureText: true,
                                textfieldType: TextfieldType.LABEL,
                                title: 'Mật khẩu',
                                titleWidth: 100,
                                hintText: 'Bao gồm 6 số',
                                controller: _passwordController,
                                inputType: TextInputType.number,
                                keyboardAction: TextInputAction.next,
                                onChange: (vavlue) {
                                  _isChangePass = true;
                                },
                              ),
                              const Divider(
                                height: 0.5,
                                color: DefaultTheme.GREY_LIGHT,
                              ),
                              TextFieldWidget(
                                width: width,
                                isObscureText: true,
                                textfieldType: TextfieldType.LABEL,
                                title: 'Xác nhận lại',
                                titleWidth: 100,
                                hintText: 'Xác nhận lại Mật khẩu',
                                controller: _confirmPassController,
                                inputType: TextInputType.number,
                                keyboardAction: TextInputAction.next,
                                onChange: (vavlue) {
                                  _isChangePass = true;
                                },
                              ),
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
                          onChange: (vavlue) {
                            _isChangePhone = true;
                          },
                        ),
                      ),
                      Visibility(
                        visible: value.phoneErr,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10, top: 5, right: 30),
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
                          onChange: (vavlue) {
                            _isChangePass = true;
                          },
                        ),
                      ),
                      Visibility(
                        visible: value.passwordErr,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10, top: 5, right: 30),
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
                          onChange: (vavlue) {
                            _isChangePass = true;
                          },
                        ),
                      ),
                      Visibility(
                        visible: value.confirmPassErr,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10, top: 5, right: 30),
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
              ),
            ),
          ),
          (PlatformUtils.instance.checkResize(width))
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: _buildButtonSubmit(context, width),
                ),
        ],
      ),
    );
  }

  void backToPreviousPage(BuildContext context) {
    _isChangePhone = false;
    _isChangePass = false;
    Provider.of<RegisterProvider>(context, listen: false).reset();
    Navigator.pop(context);
  }

  Widget _buildButtonSubmit(BuildContext context, double width) {
    return ButtonWidget(
        width: width - 40,
        text: 'Đăng ký tài khoản',
        textColor: DefaultTheme.WHITE,
        bgColor: DefaultTheme.GREEN,
        function: () {
          Provider.of<RegisterProvider>(context, listen: false).updateErrs(
            phoneErr: !StringUtils.instance.isNumeric(_phoneNoController.text),
            passErr:
                (!StringUtils.instance.isNumeric(_passwordController.text) ||
                    (_passwordController.text.length != 6)),
            confirmPassErr: !StringUtils.instance.isValidConfirmText(
                _passwordController.text, _confirmPassController.text),
          );
          if (Provider.of<RegisterProvider>(context, listen: false)
              .isValidValidation()) {
            AccountLoginDTO dto = AccountLoginDTO(
              phoneNo: _phoneNoController.text,
              password: EncryptUtils.instance
                  .encrypted(_phoneNoController.text, _passwordController.text),
            );
            _registerBloc.add(RegisterEventSubmit(dto: dto));
          }
        });
  }
}
