import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/utils/user_information_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/login/events/login_event.dart';
import 'package:vierqr/features/login/repositories/login_repository.dart';
import 'package:vierqr/features/login/states/login_state.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/register/events/register_event.dart';
import 'package:vierqr/features/register/states/register_state.dart';
import 'package:vierqr/features/register/utils/register_utils.dart';
import 'package:vierqr/features/register/views/page/form_confirm_password.dart';
import 'package:vierqr/features/register/views/page/form_password.dart';
import 'package:vierqr/features/register/views/page/form_phone.dart';
import 'package:vierqr/features/register/views/page/referral_code.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';

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
    return RegisterScreen(
      phoneNo: phoneNo,
      isFocus: isFocus,
      pageController: pageController,
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
  late final LoginBloc _loginBloc = getIt.get<LoginBloc>(
      param1: context, param2: getIt.get<LoginRepository>());

  final RegisterBloc _registerBloc = getIt.get<RegisterBloc>();

  final _phoneNoController = TextEditingController();
  final focusNode = FocusNode();

  final controller = ScrollController();

  // late RegisterProvider _registerProvider;

  // final auth = FirebaseAuth.instance;

  void initialServices(BuildContext context) {
    if (StringUtils.instance.isNumeric(widget.phoneNo)) {
      // _registerProvider.updatePhone(widget.phoneNo);

      _registerBloc.add(RegisterEventUpdatePhone(phone: widget.phoneNo));

      _phoneNoController.value =
          _phoneNoController.value.copyWith(text: widget.phoneNo);
    }
    // _registerProvider.updateErrs(
    //     phoneErr: !_registerProvider.isEnableButtonPhone(),
    //     passErr: false,
    //     confirmPassErr: false);
  }

  @override
  void initState() {
    super.initState();
    // _registerBloc = BlocProvider.of(context);
    // _pinCubit = PinCubit();
    // _registerProvider = Provider.of<RegisterProvider>(context, listen: false);
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

    return BlocConsumer<RegisterBloc, RegisterState>(
      bloc: _registerBloc,
      listener: (context, state) async {
        // if (state is RegisterLoadingState ||
        //     state is RegisterSentOTPLoadingState) {
        //   DialogWidget.instance.openLoadingDialog();
        // }
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }
        // if (state is RegisterSentOTPSuccessState) {
        //   Navigator.pop(context);
        //   DialogWidget.instance
        //       .showModalBottomContent(
        //         widget: VerifyOTPView(
        //           phone: _phoneNoController.text,
        //           onChangePage: (index) async {
        //             onRegister(provider, height);
        //           },
        //           onVerifyOTP: provider.verifyOTP,
        //           onResendOTP: provider.phoneAuthentication(
        //               _phoneNoController.text, onSentOtp: (type) {
        //             _registerBloc.add(RegisterEventSentOTP(typeOTP: type));
        //           }),
        //         ),
        //         height: height * 0.5,
        //       )
        //       .then((value) => isOpenOTP = false);
        // }
        if (state.status == BlocStatus.SUCCESS &&
            state.request == RegisterType.SENT_OPT) {
          Navigator.pop(context);
          DialogWidget.instance
              .showModalBottomContent(
                widget: VerifyOTPView(
                  phone: _phoneNoController.text,
                  onChangePage: (index) async {
                    onRegister(height, _registerBloc, state);
                  },
                  registerBloc: _registerBloc,
                  // onVerifyOTP: provider.verifyOTP,
                  // onResendOTP: provider.phoneAuthentication(
                  //     _phoneNoController.text, onSentOtp: (type) {
                  //   _registerBloc.add(RegisterEventSentOTP(typeOTP: type));
                  // }),
                ),
                height: height * 0.5,
              )
              .then((value) => isOpenOTP = false);
        }

        // if (state is RegisterSentOTPFailedState) {
        //   Navigator.pop(context);
        //   onRegister(provider, height);
        // }

        if (state.status == BlocStatus.ERROR &&
            state.request == RegisterType.SENT_OPT) {
          Navigator.pop(context);
          onRegister(height, _registerBloc, state);
        }

        // if (state is RegisterFailedState) {
        //   Navigator.pop(context);
        //   provider.updatePage(0);
        //   DialogWidget.instance.openMsgDialog(
        //     title: 'Không thể đăng ký',
        //     msg: state.msg,
        //   );
        // }
        if (state.status == BlocStatus.ERROR &&
            state.request == RegisterType.REGISTER) {
          final msg = state.msg;
          if (msg != null) {
            Navigator.pop(context);
            // provider.updatePage(0);
            _registerBloc.add(const RegisterEventUpdatePage(page: 0));
            DialogWidget.instance.openMsgDialog(
              title: 'Không thể đăng ký',
              msg: msg,
            );
          }
        }

        // if (state is RegisterSuccessState) {
        //   AccountLoginDTO dto = AccountLoginDTO(
        //     phoneNo: Provider.of<RegisterProvider>(context, listen: false)
        //         .phoneNoController
        //         .text,
        //     password: EncryptUtils.instance.encrypted(
        //       Provider.of<RegisterProvider>(context, listen: false)
        //           .phoneNoController
        //           .text,
        //       Provider.of<RegisterProvider>(context, listen: false)
        //           .passwordController
        //           .text,
        //     ),
        //   );
        //   _loginBloc.add(LoginEventByPhone(
        //     dto: dto,
        //     isToast: true,
        //   ));
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ConfirmEmailRegisterScreen(
        //         phoneNum:
        //             Provider.of<RegisterProvider>(context, listen: false)
        //                 .phoneNoController
        //                 .text
        //                 .replaceAll(' ', ''),
        //       ),
        //     ),
        //   );
        // }

        if (state.status == BlocStatus.SUCCESS &&
            state.request == RegisterType.REGISTER) {
          AccountLoginDTO dto = AccountLoginDTO(
            phoneNo: state.phoneNumber.replaceAll(' ', ''),
            password: EncryptUtils.instance.encrypted(
              state.phoneNumber.replaceAll(' ', ''),
              state.password,
            ),
          );
          _loginBloc.add(LoginEventByPhone(
            dto: dto,
            isToast: true,
          ));
          await NavigationService.pushAndRemoveUntil(Routes.CONFIRM_EMAIL_SCREEN,
              arguments: {
                'phoneNum': state.phoneNumber.replaceAll(' ', ''),
                'registerBloc': _registerBloc
              });
          // Navigator.of(context).pushReplacementNamed(
          //     Routes.CONFIRM_EMAIL_SCREEN,
          //     arguments: {'phoneNum': state.phoneNumber.replaceAll(' ', '')});
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: RegisterAppBar(
              // isLeading: provider.page == 0 ? false : true,
              isLeading: state.page == 0 ? false : true,
              title: '',
              onPressed: () {
                // Provider.of<PinProvider>(context, listen: false).reset();
                // FocusManager.instance.primaryFocus?.unfocus();
                // Navigator.of(context).pop();
                // if (provider.page == 0) {
                //   Provider.of<PinProvider>(context, listen: false).reset();
                //   FocusManager.instance.primaryFocus?.unfocus();
                //   Navigator.of(context).pop();
                // }
                // if (provider.page == 1) {
                //   Provider.of<PinProvider>(context, listen: false).reset();
                //   FocusManager.instance.primaryFocus?.unfocus();
                //   provider.updatePage(0);
                // }
                // if (provider.page == 2) {
                //   Provider.of<PinProvider>(context, listen: false).reset();
                //   FocusManager.instance.primaryFocus?.unfocus();
                //   provider.updatePage(0);
                // }
                // if (provider.page == 3) {
                //   Provider.of<PinProvider>(context, listen: false).reset();
                //   FocusManager.instance.primaryFocus?.unfocus();
                //   provider.updatePage(2);
                // }
                if (state.page == 0) {
                  _registerBloc.add(const RegisterEventReset());
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.of(context).pop();
                }
                if (state.page == 1) {
                  _registerBloc.add(const RegisterEventReset());
                  FocusManager.instance.primaryFocus?.unfocus();
                  _registerBloc.add(const RegisterEventUpdatePage(page: 0));
                }
                if (state.page == 2) {
                  _registerBloc.add(const RegisterEventReset());
                  FocusManager.instance.primaryFocus?.unfocus();
                  _registerBloc.add(const RegisterEventUpdatePage(page: 0));
                }
                if (state.page == 3) {
                  _registerBloc.add(const RegisterEventReset());
                  FocusManager.instance.primaryFocus?.unfocus();
                  _registerBloc.add(const RegisterEventUpdatePage(page: 2));
                }
              },
            ),
            backgroundColor: AppColor.WHITE,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar:
                _bottom(width, height, viewInsets, state, _phoneNoController),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  state.page == 0
                      ? BlocConsumer<LoginBloc, LoginState>(
                          bloc: _loginBloc,
                          builder: (context, state) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: FormPhone(
                                pageController: widget.pageController,
                                phoneController: _phoneNoController,
                                isFocus: widget.isFocus,
                                registerBloc: _registerBloc,
                                onExistPhone: (value) {
                                  _loginBloc
                                      .add(CheckExitsPhoneEvent(phone: value));
                                },
                              ),
                            );
                          },
                          listener: (context, state) {
                            if (state.request == LoginType.NONE &&
                                state.status == BlocStatus.LOADING) {
                              DialogWidget.instance.openLoadingDialog();
                            }
                            if (state.status == BlocStatus.UNLOADING) {
                              Navigator.of(context).pop();
                            }
                            if (state.request == LoginType.CHECK_EXIST) {
                              if (state.infoUserDTO != null) {
                                Navigator.of(context).pop(state.infoUserDTO);
                              }
                            }
                            if (state.request == LoginType.REGISTER) {
                              // provider.updatePage(2);
                              _registerBloc
                                  .add(const RegisterEventUpdatePage(page: 2));
                              widget.pageController.animateToPage(2,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            }
                          },
                        )
                      : const SizedBox.shrink(),
                  // provider.page == 1
                  state.page == 1
                      ? ReferralCode(
                          bloc: _registerBloc,
                        )
                      : const SizedBox.shrink(),
                  // provider.page == 2
                  state.page == 2
                      ? FormPassword(
                          isFocus: true,
                          registerBloc: _registerBloc,
                        )
                      : const SizedBox.shrink(),
                  // provider.page == 3
                  state.page == 3
                      ? FormConfirmPassword(
                          isFocus: true,
                          registerBloc: _registerBloc,
                          onEnterIntro: (value) {
                            // provider.updatePage(value);
                            _registerBloc
                                .add(RegisterEventUpdatePage(page: value));
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
  }

  Widget _bottom(
      double width,
      double height,
      EdgeInsets viewInsets,
      // RegisterProvider provider,
      RegisterState state,
      TextEditingController phoneNoController) {
    return (PlatformUtils.instance.checkResize(width))
        ? const SizedBox()
        // : Consumer<RegisterProvider>(
        //     builder: (context, provider, child) {

        //     },
        //   );
        : Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.page == 0) ...[
                  _buildButtonSubmitFormPhone(height, () {
                    _loginBloc.add(
                      CheckExitsPhoneEvent(
                          // phone: provider.phoneNoController.text
                          //     .replaceAll(' ', ''),
                          phone: phoneNoController.text.replaceAll(' ', '')),
                    );
                    // provider.updatePage(2);
                    // widget.pageController.animateToPage(2,
                    //     duration: const Duration(milliseconds: 300),
                    //     curve: Curves.ease);
                  }, state),
                ],
                if (state.page == 2) ...[
                  _buildButtonSubmitFormPassword(heights, () {
                    Provider.of<PinProvider>(context, listen: false).reset();
                    // provider.updatePage(3);
                    _registerBloc.add(const RegisterEventUpdatePage(page: 3));
                    widget.pageController.animateToPage(3,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                  }, state),
                ],
                if (state.page == 1) ...[
                  _buildButtonSubmit(context, heights, state),
                ],
                if (state.page == 3) ...[
                  _buildButtonSubmitFormConfirmPassword(height, state),
                ],

                // if (!provider.isShowButton)
                SizedBox(height: viewInsets.bottom),
                const SizedBox(height: 10),
                // if (!state.isShowButton)
                //   SizedBox(height: viewInsets.bottom),
                // const SizedBox(height: 10),
              ],
            ),
          );
  }

  // void backToPreviousPage(
  //     BuildContext context, bool isRegisterSuccess, RegisterState state) {
  //   Navigator.pop(context, {
  //     // 'phone': Provider.of<RegisterProvider>(context, listen: false)
  //     //     .phoneNoController
  //     //     .text,
  //     // 'password': Provider.of<RegisterProvider>(context, listen: false)
  //     //     .passwordController
  //     //     .text,
  //     'phone': state.phoneNumber,
  //     'password': state.password
  //   });
  // }

  Widget _buildButtonSubmitFormConfirmPassword(
      double height, RegisterState state) {
    return VietQRButton.gradient(
      onPressed: () async {
        onRegister(height, _registerBloc, state);
        Provider.of<PinProvider>(context, listen: false).reset();
      },
      isDisabled: !RegisterUtils.instance.isEnableButton(
          state.phoneNumber,
          state.password,
          state.confirmPassword,
          state.isPhoneErr,
          state.isPasswordErr,
          state.isConfirmPassErr),
      child: Center(
        child: Text(
          'Đăng ký',
          style: TextStyle(
            color: RegisterUtils.instance.isEnableButton(
                    state.phoneNumber,
                    state.password,
                    state.confirmPassword,
                    state.isPhoneErr,
                    state.isPasswordErr,
                    state.isConfirmPassErr)
                ? AppColor.WHITE
                : AppColor.BLACK,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonSubmitFormPhone(
      double height, Function() callback, RegisterState state) {
    // return Consumer<RegisterProvider>(
    //   builder: (context, provider, child) {

    //   },
    // );
    bool isEnable =
        RegisterUtils.instance.isEnableButtonPhone(state.phoneNumber);

    return VietQRButton.gradient(
      onPressed: () {
        if (isEnable) {
          callback();
        }
      },
      isDisabled: !isEnable,
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
                color: isEnable ? AppColor.WHITE : AppColor.BLACK,
              ),
            ),
            Icon(
              Icons.arrow_forward_outlined,
              size: 18,
              color:
                  RegisterUtils.instance.isEnableButtonPhone(state.phoneNumber)
                      ? AppColor.WHITE
                      : AppColor.BLACK,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSubmitFormPassword(
      double height, Function() callback, RegisterState state) {
    // return Consumer<RegisterProvider>(
    //   builder: (context, provider, child) {

    //   },
    // );
    return VietQRButton.gradient(
      onPressed: () {
        callback;
      },
      isDisabled: !RegisterUtils.instance.isEnableButtonPassword(
          state.phoneNumber,
          state.password,
          state.isPhoneErr,
          state.isPasswordErr),
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
                color: (RegisterUtils.instance.isEnableButtonPassword(
                            state.phoneNumber,
                            state.password,
                            state.isPhoneErr,
                            state.isPasswordErr) &&
                        state.password.isNotEmpty)
                    ? AppColor.WHITE
                    : AppColor.BLACK,
              ),
            ),
            Icon(
              Icons.arrow_forward_outlined,
              size: 18,
              color: (RegisterUtils.instance.isEnableButtonPassword(
                          state.phoneNumber,
                          state.password,
                          state.isPhoneErr,
                          state.isPasswordErr) &&
                      state.password.isNotEmpty)
                  ? AppColor.WHITE
                  : AppColor.BLACK,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSubmit(
      BuildContext context, double height, RegisterState state) {
    // return Consumer<RegisterProvider>(
    //   builder: (context, provider, child) {

    //   },
    // );
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
              onRegister(height, _registerBloc, state);
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
            // isEnable: provider.isEnableButton(),
            isEnable: RegisterUtils.instance.isEnableButton(
                state.phoneNumber,
                state.password,
                state.confirmPassword,
                state.isPhoneErr,
                state.isPasswordErr,
                state.isConfirmPassErr),
            margin: const EdgeInsets.only(bottom: 2, left: 40, right: 40),
            height: 50,
            onTap: () async {
              onRegister(height, _registerBloc, state);
              Provider.of<PinProvider>(context, listen: false).reset();
            },
          ),
        ),
      ],
    );
  }

  onRegister(height, RegisterBloc bloc, RegisterState state) async {
    // provider.updateHeight(height, true);
    bloc.add(RegisterEventUpdateHeight(height: height, showBT: true));

    // String phone = provider.phoneNoController.text.replaceAll(' ', '');
    String phone = state.phoneNumber.replaceAll(' ', '');

    // String password = provider.passwordController.text;
    // String confirmPassword = provider.confirmPassController.text;
    String password = state.password;
    String confirmPassword = state.confirmPassword;

    // String sharingCode = provider.introduceController.text;
    String sharingCode = state.introduce;

    // provider.updateErrs(
    //   phoneErr: !(StringUtils.instance.isValidatePhone(phone)),
    //   passErr:
    //       (!StringUtils.instance.isNumeric(password) || (password.length != 6)),
    //   confirmPassErr:
    //       !StringUtils.instance.isValidConfirmText(password, confirmPassword),
    // );

    bloc.add(RegisterEventUpdateErrs(
        phoneErr: !(StringUtils.instance.isValidatePhone(phone)),
        passErr: (!StringUtils.instance.isNumeric(password) ||
            (password.length != 6)),
        confirmPassErr: !StringUtils.instance
            .isValidConfirmText(password, confirmPassword)));

    if (RegisterUtils.instance.isValidValidation(
        state.isPhoneErr, state.isPasswordErr, state.isConfirmPassErr)) {
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
      // context.read<RegisterBloc>().add(RegisterEventSubmit(dto: dto));
      _registerBloc.add(RegisterEventSubmit(dto: dto));
    }
  }

  bool isOpenOTP = false;
}
