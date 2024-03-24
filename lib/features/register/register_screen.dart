import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/utils/user_information_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/register/events/register_event.dart';
import 'package:vierqr/features/register/states/register_state.dart';
import 'package:vierqr/features/register/views/page/form_account.dart';
import 'package:vierqr/features/register/views/page/referral_code.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/services/providers/register_provider.dart';

import 'views/verify_otp_screen.dart';

class Register extends StatelessWidget {
  final String phoneNo;
  final bool isFocus;

  const Register({super.key, this.phoneNo = '', required this.isFocus});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (BuildContext context) => RegisterBloc(),
      child: ChangeNotifierProvider<RegisterProvider>(
        create: (_) => RegisterProvider(),
        child: RegisterScreen(phoneNo: phoneNo, isFocus: isFocus),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  final String phoneNo;
  final bool isFocus;

  const RegisterScreen(
      {super.key, required this.phoneNo, required this.isFocus});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterBloc _bloc;
  final _phoneNoController = TextEditingController();
  final focusNode = FocusNode();
  final PageController pageController = PageController();
  final controller = ScrollController();

  // final auth = FirebaseAuth.instance;

  void initialServices(BuildContext context) {
    if (StringUtils.instance.isNumeric(widget.phoneNo)) {
      Provider.of<RegisterProvider>(context, listen: false)
          .updatePhone(widget.phoneNo);
      _phoneNoController.value =
          _phoneNoController.value.copyWith(text: widget.phoneNo);
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialServices(context);
    });
  }

  double heights = 0.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final viewInsets = EdgeInsets.fromWindowPadding(
        WidgetsBinding.instance.window.viewInsets,
        WidgetsBinding.instance.window.devicePixelRatio);

    if (heights < viewInsets.bottom) {
      heights = viewInsets.bottom;
    }

    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) async {
            if (state is RegisterLoadingState ||
                state is RegisterSentOTPLoadingState) {
              DialogWidget.instance.openLoadingDialog();
            }

            if (state is RegisterSentOTPSuccessState) {
              Navigator.pop(context);
              DialogWidget.instance
                  .showModalBottomContent(
                    widget: VerifyOTPView(
                      phone: _phoneNoController.text,
                      onChangePage: (index) async {
                        onRegister(provider, height);
                      },
                      onVerifyOTP: provider.verifyOTP,
                      onResendOTP: provider.phoneAuthentication(
                          _phoneNoController.text, onSentOtp: (type) {
                        _bloc.add(RegisterEventSentOTP(typeOTP: type));
                      }),
                    ),
                    height: height * 0.5,
                  )
                  .then((value) => isOpenOTP = false);
            }

            if (state is RegisterSentOTPFailedState) {
              Navigator.pop(context);
              onRegister(provider, height);
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
                resizeToAvoidBottomInset: false,
                body: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: pageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: FormAccount(
                                phoneController: _phoneNoController,
                                isFocus: widget.isFocus,
                                onEnterIntro: (value) {
                                  provider.updatePage(value);
                                  pageController.animateToPage(value,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease);
                                },
                              ),
                            ),
                            ReferralCode()
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      (PlatformUtils.instance.checkResize(width))
                          ? const SizedBox()
                          : Consumer<RegisterProvider>(
                              builder: (context, _provider, child) {
                                if (_provider.page == 0) {
                                  return _buildButtonSubmitFormAccount(height);
                                }

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildButtonSubmit(context, heights),
                                    if (!_provider.isShowButton)
                                      SizedBox(height: viewInsets.bottom),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void backToPreviousPage(BuildContext context, bool isRegisterSuccess) {
    Navigator.pop(context, {
      'phone': Provider.of<RegisterProvider>(context, listen: false)
          .phoneNoController
          .text,
      'password': Provider.of<RegisterProvider>(context, listen: false)
          .passwordController
          .text,
    });
  }

  Widget _buildButtonSubmitFormAccount(double height) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return MButtonWidget(
          title: 'Đăng ký',
          isEnable: provider.isEnableButton(),
          margin: EdgeInsets.zero,
          onTap: () async {
            // await provider.phoneAuthentication(_phoneNoController.text,
            //     onSentOtp: (type) {
            //   _bloc.add(RegisterEventSentOTP(typeOTP: type));
            // });
            onRegister(provider, height);
          },
        );
      },
    );
  }

  Widget _buildButtonSubmit(BuildContext context, double height) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child: MButtonWidget(
                title: 'Bỏ qua',
                isEnable: true,
                margin: EdgeInsets.zero,
                colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.3),
                colorEnableText: AppColor.BLUE_TEXT,
                onTap: () async {
                  await provider.phoneAuthentication(_phoneNoController.text,
                      onSentOtp: (type) {
                    _bloc.add(RegisterEventSentOTP(typeOTP: type));
                  });
                },
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: MButtonWidget(
                title: 'Đăng ký',
                isEnable: provider.isEnableButton(),
                margin: EdgeInsets.zero,
                onTap: () async {
                  onRegister(provider, height);
                  // await provider.phoneAuthentication(_phoneNoController.text,
                  //     onSentOtp: (type) {
                  //   _bloc.add(RegisterEventSentOTP(typeOTP: type));
                  // });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  onRegister(provider, height) async {
    provider.updateHeight(height, true);

    String phone = provider.phoneNoController.text;

    String password = provider.passwordController.text;
    String confirmPassword = provider.confirmPassController.text;

    String sharingCode = provider.introduceController.text;

    provider.updateErrs(
      phoneErr: (StringUtils.instance.isValidatePhone(phone)!),
      passErr:
          (!StringUtils.instance.isNumeric(password) || (password.length != 6)),
      confirmPassErr:
          !StringUtils.instance.isValidConfirmText(password, confirmPassword),
    );

    if (provider.isValidValidation()) {
      String userIP = await UserInformationUtils.instance.getIPAddress();

      AccountLoginDTO dto = AccountLoginDTO(
        phoneNo: phone,
        password: EncryptUtils.instance.encrypted(phone, password),
        device: userIP,
        fcmToken: '',
        sharingCode: sharingCode,
        platform: PlatformUtils.instance.isIOsApp() ? 'MOBILE' : 'MOBILE_ADR',
      );
      if (!mounted) return;
      context.read<RegisterBloc>().add(RegisterEventSubmit(dto: dto));
    }
  }

  bool isOpenOTP = false;
}
