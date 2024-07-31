import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/utils/user_information_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/login/events/login_event.dart';
import 'package:vierqr/features/login/repositories/login_repository.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/register/events/register_event.dart';
import 'package:vierqr/features/register/states/register_state.dart';
import 'package:vierqr/features/register/views/page/confirm_email.register.dart';
import 'package:vierqr/features/register/views/page/form_confirm_password.dart';
import 'package:vierqr/features/register/views/page/form_password.dart';
import 'package:vierqr/features/register/views/page/form_phone.dart';
import 'package:vierqr/features/register/views/page/form_success_splash.dart';
import 'package:vierqr/features/register/views/page/referral_code.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/n_app_bar.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/services/providers/register_provider.dart';

import '../../layouts/register_app_bar.dart';
import '../../services/providers/pin_provider.dart';
import 'views/verify_otp_screen.dart';

class Register extends StatelessWidget {
  final PageController pageController;
  final String phoneNo;
  final bool isFocus;

  const Register({
    super.key,
    this.phoneNo = '',
    required this.isFocus,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (BuildContext context) => RegisterBloc(),
      child: RegisterScreen(
        phoneNo: phoneNo,
        isFocus: isFocus,
        pageController: pageController,
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  final PageController pageController;
  final String phoneNo;
  final bool isFocus;

  const RegisterScreen(
      {super.key,
      required this.phoneNo,
      required this.isFocus,
      required this.pageController});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterBloc _bloc;
  final _phoneNoController = TextEditingController();
  final focusNode = FocusNode();
  // final PageController pageController = PageController();
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
              AccountLoginDTO dto = AccountLoginDTO(
                phoneNo: Provider.of<RegisterProvider>(context, listen: false)
                    .phoneNoController
                    .text,
                password: EncryptUtils.instance.encrypted(
                  Provider.of<RegisterProvider>(context, listen: false)
                      .phoneNoController
                      .text,
                  Provider.of<RegisterProvider>(context, listen: false)
                      .passwordController
                      .text,
                ),
              );
              getIt
                  .get<LoginBloc>(
                      param1: context, param2: getIt.get<LoginRepository>())
                  .add(LoginEventByPhone(
                    dto: dto,
                    isToast: true,
                  ));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfirmEmailRegisterScreen(
                    phoneNum:
                        Provider.of<RegisterProvider>(context, listen: false)
                            .phoneNoController
                            .text,
                  ),
                ),
              );
            }
            // if (state is RegisterSuccessState) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const FormRegisterSuccessSplash()),
            //   );
            //   Future.delayed(const Duration(seconds: 3), () {
            //     Navigator.of(context).pop();
            //     Navigator.of(context).pop();
            //     backToPreviousPage(context, true);
            //   });
            // }
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                appBar: RegisterAppBar(
                  title: '',
                  onPressed: () {
                    // Provider.of<PinProvider>(context, listen: false).reset();
                    // FocusManager.instance.primaryFocus?.unfocus();
                    // Navigator.of(context).pop();
                    if (provider.page == 0) {
                      Provider.of<PinProvider>(context, listen: false).reset();
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.of(context).pop();
                    }
                    if (provider.page == 1) {
                      Provider.of<PinProvider>(context, listen: false).reset();
                      FocusManager.instance.primaryFocus?.unfocus();
                      provider.updatePage(0);
                    }
                    if (provider.page == 2) {
                      Provider.of<PinProvider>(context, listen: false).reset();
                      FocusManager.instance.primaryFocus?.unfocus();
                      provider.updatePage(0);
                    }
                    if (provider.page == 3) {
                      Provider.of<PinProvider>(context, listen: false).reset();
                      FocusManager.instance.primaryFocus?.unfocus();
                      provider.updatePage(2);
                    }
                  },
                ),
                backgroundColor: AppColor.WHITE,
                resizeToAvoidBottomInset: true,
                bottomNavigationBar:
                    _bottom(width, height, viewInsets, provider),
                body: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      provider.page == 0
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: FormPhone(
                                pageController: widget.pageController,
                                phoneController: provider.phoneNoController,
                                isFocus: widget.isFocus,
                                onEnterIntro: (value) {
                                  provider.updatePage(value);
                                  widget.pageController.animateToPage(value,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease);
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                      provider.page == 1
                          ? const ReferralCode()
                          : const SizedBox.shrink(),
                      provider.page == 2
                          ? FormPassword(
                              isFocus: true,
                            )
                          : const SizedBox.shrink(),
                      provider.page == 3
                          ? FormConfirmPassword(
                              isFocus: true,
                              onEnterIntro: (value) {
                                provider.updatePage(value);
                                widget.pageController.animateToPage(value,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease);
                              },
                            )
                          : const SizedBox.shrink(),
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

  Widget _bottom(double width, double height, EdgeInsets viewInsets,
      RegisterProvider provider) {
    return (PlatformUtils.instance.checkResize(width))
        ? const SizedBox()
        : Consumer<RegisterProvider>(
            builder: (context, provider, child) {
              // if (provider.page == 0) {
              //   return _buildButtonSubmitFormPhone(height, () {
              //     provider.updatePage(2);
              //     widget.pageController.animateToPage(2,
              //         duration: const Duration(milliseconds: 300),
              //         curve: Curves.ease);
              //   });
              // }
              // if (provider.page == 2) {
              //   return _buildButtonSubmitFormPassword(heights, () {
              //     Provider.of<PinProvider>(context, listen: false).reset();
              //     provider.updatePage(3);
              //     widget.pageController.animateToPage(3,
              //         duration: const Duration(milliseconds: 300),
              //         curve: Curves.ease);
              //   });
              // }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (provider.page == 0) ...[
                      _buildButtonSubmitFormPhone(
                        height,
                        () {
                          provider.updatePage(2);
                          widget.pageController.animateToPage(2,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                      ),
                    ],
                    if (provider.page == 2) ...[
                      _buildButtonSubmitFormPassword(
                        heights,
                        () {
                          Provider.of<PinProvider>(context, listen: false)
                              .reset();
                          provider.updatePage(3);
                          widget.pageController.animateToPage(3,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                      ),
                    ],
                    if (provider.page == 1) ...[
                      _buildButtonSubmit(context, heights),
                    ],
                    if (provider.page == 3) ...[
                      _buildButtonSubmitFormConfirmPassword(height),
                    ],
                    // if (_provider.page == 2) ...[
                    //   _buildButtonSubmitFormPassword(
                    //       heights,
                    //       () => {
                    //             Provider.of<PinProvider>(context, listen: false)
                    //                 .reset(),
                    //             provider.updatePage(3),
                    //             pageController.animateToPage(3,
                    //                 duration: const Duration(milliseconds: 300),
                    //                 curve: Curves.ease),
                    //           }),
                    // ],
                    if (!provider.isShowButton)
                      SizedBox(height: viewInsets.bottom),
                    const SizedBox(height: 10),
                  ],
                ),
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

  Widget _buildButtonSubmitFormConfirmPassword(double height) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        // return MButtonWidget(
        //   title: 'Đăng ký',
        //   isEnable: provider.isEnableButton(),
        //   margin: const EdgeInsets.only(bottom: 10),
        //   colorDisableBgr: AppColor.GREY_BUTTON,
        //   width: 350,
        //   height: 50,
        //   onTap: () async {
        //     // await provider.phoneAuthentication(_phoneNoController.text,
        //     //     onSentOtp: (type) {
        //     //   _bloc.add(RegisterEventSentOTP(typeOTP: type));
        //     // });
        // onRegister(provider, height);
        // Provider.of<PinProvider>(context, listen: false).reset();
        //   },
        // );
        return VietQRButton.gradient(
          onPressed: () async {
            onRegister(provider, height);
            Provider.of<PinProvider>(context, listen: false).reset();
          },
          child: Center(
            child: Text(
              'Đăng ký',
              style: TextStyle(
                color:
                    provider.isEnableButton() ? AppColor.WHITE : AppColor.BLACK,
              ),
            ),
          ),
          isDisabled: !(provider.isEnableButton()),
        );
      },
    );
  }

  Widget _buildButtonSubmitFormPhone(double height, VoidCallback callback) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        // return MButtonWidget(
        //     title: 'Tiếp tục',
        //     isEnable: provider.isEnableButtonPhone(),
        //     margin: const EdgeInsets.only(bottom: 10),
        //     colorDisableBgr: AppColor.GREY_BUTTON,
        //     width: 350,
        //     height: 50,
        //     onTap: callback);
        return VietQRButton.gradient(
          onPressed: callback,
          isDisabled: !(provider.isEnableButtonPhone()),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.abc,
                  size: 18,
                  color: AppColor.TRANSPARENT,
                ),
                Text(
                  'Tiếp tục',
                  style: TextStyle(
                    color: provider.isEnableButtonPhone()
                        ? AppColor.WHITE
                        : AppColor.BLACK,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_outlined,
                  size: 18,
                  color: provider.isEnableButtonPhone()
                      ? AppColor.WHITE
                      : AppColor.BLACK,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonSubmitFormPassword(double height, VoidCallback callback) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        // return MButtonWidget(
        //   title: 'Tiếp tục',
        //   isEnable: provider.isEnableButtonPassword() &&
        //       provider.passwordController.text.isNotEmpty,
        //   margin: const EdgeInsets.only(bottom: 10),
        //   colorDisableBgr: AppColor.GREY_BUTTON,
        //   width: 350,
        //   height: 50,
        //   onTap: callback,
        // );
        return VietQRButton.gradient(
          onPressed: callback,
          isDisabled: !(provider.isEnableButtonPassword() &&
              provider.passwordController.text.isNotEmpty),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.abc,
                  size: 18,
                  color: AppColor.TRANSPARENT,
                ),
                Text(
                  'Tiếp tục',
                  style: TextStyle(
                    color: (provider.isEnableButtonPassword() &&
                            provider.passwordController.text.isNotEmpty)
                        ? AppColor.WHITE
                        : AppColor.BLACK,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_outlined,
                  size: 18,
                  color: (provider.isEnableButtonPassword() &&
                          provider.passwordController.text.isNotEmpty)
                      ? AppColor.WHITE
                      : AppColor.BLACK,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonSubmit(BuildContext context, double height) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Container(
              child: MButtonWidget(
                title: 'Bỏ qua',
                isEnable: true,
                height: 50,
                margin: const EdgeInsets.only(bottom: 15, left: 40, right: 40),
                colorEnableBgr: AppColor.WHITE,
                colorEnableText: AppColor.BLUE_TEXT,
                border: Border.all(width: 1, color: AppColor.BLUE_TEXT),
                onTap: () async {
                  onRegister(provider, height);
                  Provider.of<PinProvider>(context, listen: false).reset();
                },
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Container(
              child: MButtonWidget(
                title: 'Đăng ký',
                isEnable: provider.isEnableButton(),
                margin: const EdgeInsets.only(bottom: 2, left: 40, right: 40),
                height: 50,
                onTap: () async {
                  onRegister(provider, height);
                  Provider.of<PinProvider>(context, listen: false).reset();
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
