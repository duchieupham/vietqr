import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/phone_widget.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/login/blocs/login_provider.dart';
import 'package:vierqr/features/login/events/login_event.dart';
import 'package:vierqr/features/login/states/login_state.dart';
import 'package:vierqr/features/register/views/register_screen.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/pin_code_input.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => LoginBloc(),
      child: ChangeNotifierProvider<LoginProvider>(
        create: (_) => LoginProvider(),
        child: _Login(),
      ),
    );
  }
}

class _Login extends StatefulWidget {
  @override
  State<_Login> createState() => _LoginState();
}

class _LoginState extends State<_Login> {
  final phoneNoController = TextEditingController();
  final passController = TextEditingController();

  String code = '';

  Uuid uuid = const Uuid();

  late LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    code = uuid.v1();
  }

  @override
  void dispose() {
    phoneNoController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLogoutEnterHome = false;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final arg = ModalRoute.of(context)!.settings.arguments as Map;
      isLogoutEnterHome = arg['isLogout'] ?? false;
    }

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state.status == BlocStatus.UNLOADING) {
          Navigator.of(context).pop();
        }

        if (state.request == LoginType.TOAST) {
          // _loginBloc.add(LoginEventGetUserInformation(userId: state.userId));
          //pop loading dialog
          //navigate to home screen
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context)
              .pushReplacementNamed(Routes.DASHBOARD, arguments: {
            'isFromLogin': true,
            'isLogoutEnterHome': isLogoutEnterHome,
          });
          if (state.isToast) {
            Fluttertoast.showToast(
              msg: 'Đăng ký thành công',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
          }
        }
        if (state.request == LoginType.CHECK_EXIST) {
          Provider.of<LoginProvider>(context, listen: false)
              .updateQuickLogin(true);
        }

        if (state.request == LoginType.ERROR) {
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.of(context).pop();
          //pop loading dialog
          //show msg dialog
          DialogWidget.instance.openMsgDialog(
            title: 'Đăng nhập không thành công',
            msg: state.msg ?? '',
            // 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập.',
          );
        }
        if (state.request == LoginType.REGISTER) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          if (keyboardHeight > 0.0) {
            FocusManager.instance.primaryFocus?.unfocus();
          }

          if (!mounted) return;
          final data = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Register(phoneNo: state.phone ?? ''),
              settings: const RouteSettings(
                name: Routes.REGISTER,
              ),
            ),
          );

          if (data is Map) {
            AccountLoginDTO dto = AccountLoginDTO(
              phoneNo: data['phone'],
              password: EncryptUtils.instance.encrypted(
                data['phone'],
                data['password'],
              ),
              device: '',
              fcmToken: '',
              platform: '',
              sharingCode: '',
            );
            if (!mounted) return;
            context
                .read<LoginBloc>()
                .add(LoginEventByPhone(dto: dto, isToast: true));
          }

          if (state.request != LoginType.NONE ||
              state.status != BlocStatus.NONE) {
            _bloc.add(UpdateEvent());
          }
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Consumer<LoginProvider>(
            builder: (context, provider, child) {
              if (provider.isQuickLogin) {
                return Scaffold(
                  body: Container(
                    color: AppColor.GREY_BG,
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          padding: const EdgeInsets.only(
                              top: 70, left: 20, right: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/bgr-header.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'Xin chào, ${state.infoUserDTO?.fullName}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          state.infoUserDTO?.phoneNo ?? '',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    height: 40,
                                    child: Image.asset(
                                      'assets/images/ic-viet-qr.png',
                                      height: 40,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Vui lòng nhập mật khẩu để đăng nhập',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 40,
                                padding: const EdgeInsets.only(right: 60),
                                child: PinCodeInput(
                                  obscureText: true,
                                  controller: passController,
                                  autoFocus: true,
                                  onChanged: provider.onChangePin,
                                  onCompleted: (value) {
                                    AccountLoginDTO dto = AccountLoginDTO(
                                      phoneNo: provider.phone,
                                      password: EncryptUtils.instance.encrypted(
                                        provider.phone,
                                        passController.text,
                                      ),
                                      device: '',
                                      fcmToken: '',
                                      platform: '',
                                      sharingCode: '',
                                    );
                                    context
                                        .read<LoginBloc>()
                                        .add(LoginEventByPhone(dto: dto));
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              // GestureDetector(
                              //   child: const Text(
                              //     'Quên mật khẩu?',
                              //     style: TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //         color: AppColor.BLUE_TEXT),
                              //   ),
                              // ),
                              // const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  provider.updateQuickLogin(false);
                                },
                                child: const Text(
                                  'Đổi số điện thoại',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.BLUE_TEXT),
                                ),
                              ),
                              const SizedBox(height: 8),

                              GestureDetector(
                                onTap: () {
                                  DialogWidget.instance.openMsgDialog(
                                    title: 'Tính năng đang bảo trì',
                                    msg: 'Vui lòng thử lại sau',
                                  );
                                },
                                child: const Text(
                                  'Quên mật khẩu',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.BLUE_TEXT),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomSheet: MButtonWidget(
                    title: 'Đăng nhập',
                    isEnable: provider.isButtonLogin,
                    colorEnableText: provider.isButtonLogin
                        ? AppColor.WHITE
                        : AppColor.GREY_TEXT,
                    onTap: () {
                      AccountLoginDTO dto = AccountLoginDTO(
                        phoneNo: provider.phone,
                        password: EncryptUtils.instance.encrypted(
                          provider.phone,
                          passController.text,
                        ),
                        device: '',
                        fcmToken: '',
                        platform: '',
                        sharingCode: '',
                      );
                      context
                          .read<LoginBloc>()
                          .add(LoginEventByPhone(dto: dto));
                    },
                  ),
                );
              }

              return Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/bgr-header.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: ClipRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                child: Opacity(
                                  opacity: 0.6,
                                  child: Container(
                                    height: 30,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width / 2,
                                margin: const EdgeInsets.only(top: 50),
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/logo_vietgr_payment.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          PhoneWidget(
                            phoneController: phoneNoController,
                            onChanged: provider.updatePhone,
                          ),
                          Visibility(
                            visible: provider.errorPhone != null,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, top: 5, right: 30),
                              child: Text(
                                provider.errorPhone ?? '',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: AppColor.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                bottomSheet: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MButtonWidget(
                      title: 'Tiếp tục',
                      isEnable: provider.isEnableButton,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      colorEnableText: provider.isEnableButton
                          ? AppColor.WHITE
                          : AppColor.GREY_TEXT,
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _bloc.add(CheckExitsPhoneEvent(phone: provider.phone));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Chưa có tài khoản? '),
                          GestureDetector(
                            onTap: () async {
                              final data = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Register(phoneNo: state.phone ?? ''),
                                  settings: const RouteSettings(
                                    name: Routes.REGISTER,
                                  ),
                                ),
                              );

                              if (data is Map) {
                                AccountLoginDTO dto = AccountLoginDTO(
                                  phoneNo: data['phone'],
                                  password: EncryptUtils.instance.encrypted(
                                    data['phone'],
                                    data['password'],
                                  ),
                                  device: '',
                                  fcmToken: '',
                                  platform: '',
                                  sharingCode: '',
                                );
                                if (!mounted) return;
                                context.read<LoginBloc>().add(
                                    LoginEventByPhone(dto: dto, isToast: true));
                              }
                            },
                            child: const Text(
                              'Đăng ký ngay',
                              style: TextStyle(color: AppColor.BLUE_TEXT),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    )
                  ],
                ),
                // body: LoginFrame(
                //   width: width,
                //   height: height,
                //   padding: EdgeInsets.zero,
                //   widget1: _buildWidget1(
                //     width: width,
                //     isResized: PlatformUtils.instance.resizeWhen(width, 750),
                //   ),
                //   widget2: _buildWidget2(context: context),
                // ),
              );
            },
          ),
        );
      },
    );
  }

  void openPinDialog(BuildContext context) {
    if (phoneNoController.text.isEmpty) {
      DialogWidget.instance.openMsgDialog(
          title: 'Đăng nhập không thành công',
          msg: 'Vui lòng nhập số điện thoại để đăng nhập.');
    } else {
      DialogWidget.instance.openPINDialog(
        title: 'Nhập Mật khẩu',
        onDone: (pin) {
          Navigator.of(context).pop();
          AccountLoginDTO dto = AccountLoginDTO(
            phoneNo: phoneNoController.text,
            password: EncryptUtils.instance.encrypted(
              phoneNoController.text,
              pin,
            ),
            device: '',
            fcmToken: '',
            platform: '',
            sharingCode: '',
          );
          context.read<LoginBloc>().add(LoginEventByPhone(dto: dto));
        },
      );
    }
  }
}
