import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/utils/user_information_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/phone_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/register/frame/register_frame.dart';
import 'package:vierqr/features/register/states/register_state.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/account_login_dto.dart';
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
      child: ChangeNotifierProvider<RegisterProvider>(
        create: (_) => RegisterProvider(),
        child: RegisterScreen(phoneNo: phoneNo),
      ),
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
  final _phoneNoController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPassController = TextEditingController();

  bool _isChangePhone = false;

  bool _isChangePass = false;

  final FocusNode focusNode = FocusNode();

  // final auth = FirebaseAuth.instance;

  void initialServices(BuildContext context) {
    if (StringUtils.instance.isNumeric(widget.phoneNo)) {
      Provider.of<RegisterProvider>(context, listen: false)
          .updatePhone(widget.phoneNo);
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
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: const MAppBar(title: 'Đăng ký'),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (PlatformUtils.instance.isWeb())
                    const SizedBox(height: 10),
                  Expanded(child: Consumer<RegisterProvider>(
                    builder: (context, provider, child) {
                      return RegisterFrame(
                        mobileChildren: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                PhoneWidget(
                                  onChanged: (value) {
                                    provider.updatePhone(value);
                                  },
                                ),
                                Visibility(
                                  visible: provider.phoneErr,
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, top: 5, right: 30),
                                    child: Text(
                                      'Số điện thoại không đúng định dạng.',
                                      style: TextStyle(
                                          color: AppColor.RED_TEXT,
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Mật khẩu ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.BLACK,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '*',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.RED_EC1010,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' (Bao gồm 6 số)',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.BLACK,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 40,
                                  child: PinCodeInput(
                                    obscureText: true,
                                    onChanged: (value) {
                                      provider.updatePassword(value);
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: provider.passwordErr,
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, top: 5, right: 30),
                                    child: Text(
                                      'Mật khẩu bao gồm 6 số.',
                                      style: TextStyle(
                                          color: AppColor.RED_TEXT,
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                TextFieldCustom(
                                  isObscureText: false,
                                  maxLines: 1,
                                  textFieldType: TextfieldType.LABEL,
                                  title: 'Mã giới thiệu',
                                  hintText: 'Nhập mã giới thiệu của bạn bè',
                                  controller: provider.introduceController,
                                  inputType: TextInputType.text,
                                  keyboardAction: TextInputAction.next,
                                  onChange: (value) {
                                    provider.updateRePass(value);
                                  },
                                ),
                              ],
                            ),
                            Visibility(
                              visible: provider.confirmPassErr,
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    left: 10, top: 5, right: 30),
                                child: Text(
                                  'Xác nhận Mật khẩu không trùng khớp.',
                                  style: TextStyle(
                                      color: AppColor.RED_TEXT, fontSize: 13),
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
                            isError: provider.phoneErr,
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
                            visible: provider.phoneErr,
                            child: const Padding(
                              padding:
                                  EdgeInsets.only(left: 10, top: 5, right: 30),
                              child: Text(
                                'Số điện thoại không đúng định dạng.',
                                style: TextStyle(
                                    color: AppColor.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          BorderLayout(
                            width: width,
                            isError: provider.passwordErr,
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
                            visible: provider.passwordErr,
                            child: const Padding(
                              padding:
                                  EdgeInsets.only(left: 10, top: 5, right: 30),
                              child: Text(
                                'Mật khẩu bao gồm 6 số.',
                                style: TextStyle(
                                    color: AppColor.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          BorderLayout(
                            width: width,
                            isError: provider.confirmPassErr,
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
                            visible: provider.confirmPassErr,
                            child: const Padding(
                              padding:
                                  EdgeInsets.only(left: 10, top: 5, right: 30),
                              child: Text(
                                'Xác nhận Mật khẩu không trùng khớp.',
                                style: TextStyle(
                                    color: AppColor.RED_TEXT, fontSize: 13),
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
          ),
        );
      },
    );
  }

  void backToPreviousPage(BuildContext context, bool isRegisterSuccess) {
    Navigator.pop(
        context,
        isRegisterSuccess
            ? {
                'phone': Provider.of<RegisterProvider>(context, listen: false)
                    .phoneNoController
                    .text,
                'password':
                    Provider.of<RegisterProvider>(context, listen: false)
                        .passwordController
                        .text,
              }
            : null);
  }

  Widget _buildButtonSubmit(BuildContext context, double width) {
    return ButtonWidget(
      width: width - 40,
      text: 'Đăng ký',
      textColor: AppColor.WHITE,
      bgColor: AppColor.BLUE_TEXT,
      borderRadius: 5,
      function: () async {
        String phone = Provider.of<RegisterProvider>(context, listen: false)
            .phoneNoController
            .text;

        String password = Provider.of<RegisterProvider>(context, listen: false)
            .passwordController
            .text;
        String confirmPassword =
            Provider.of<RegisterProvider>(context, listen: false)
                .confirmPassController
                .text;

        Provider.of<RegisterProvider>(context, listen: false).updateErrs(
          phoneErr: (StringUtils.instance.isValidatePhone(phone)!),
          passErr: (!StringUtils.instance.isNumeric(password) ||
              (password.length != 6)),
          confirmPassErr: !StringUtils.instance
              .isValidConfirmText(password, confirmPassword),
        );
        if (Provider.of<RegisterProvider>(context, listen: false)
            .isValidValidation()) {
          String userIP = await UserInformationUtils.instance.getIPAddress();
          AccountLoginDTO dto = AccountLoginDTO(
            phoneNo: phone,
            password: EncryptUtils.instance.encrypted(phone, password),
            device: userIP,
            fcmToken: '',
            platform:
                PlatformUtils.instance.isIOsApp() ? 'MOBILE' : 'MOBILE_ADR',
          );
          if (!mounted) return;
          // context.read<RegisterBloc>().add(RegisterEventSubmit(dto: dto));
        }
      },
    );
  }

  bool isOpenOTP = false;
}
