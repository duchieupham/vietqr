import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/phone_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/login/blocs/login_provider.dart';
import 'package:vierqr/features/login/events/login_event.dart';
import 'package:vierqr/features/login/states/login_state.dart';
import 'package:vierqr/features/register/views/register_screen.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/layouts/pin_code_input.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/services/providers/login_provider.dart';

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
          Navigator.of(context).pushReplacementNamed(Routes.HOME, arguments: {
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomSheet: MButtonWidget(
                    title: 'Đăng nhập',
                    isEnable: provider.isButtonLogin,
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
                appBar: const MAppBar(
                  title: 'Đăng nhập',
                  isLeading: false,
                ),
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PhoneWidget(
                        phoneController: phoneNoController,
                        onChanged: provider.updatePhone,
                      ),
                      Visibility(
                        visible: provider.errorPhone != null,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 5, top: 5, right: 30),
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
                bottomSheet: MButtonWidget(
                  title: 'Tiếp tục',
                  isEnable: provider.isEnableButton,
                  onTap: () {
                    _bloc.add(CheckExitsPhoneEvent(phone: provider.phone));
                  },
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

  Widget _buildWidget1({required bool isResized, required double width}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/ic-viet-qr.png',
                  width: 100,
                  height: 100,
                ),
              ),
              Consumer<ValidProvider>(
                builder: (context, provider, child) {
                  return TextFieldCustom(
                    isObscureText: false,
                    autoFocus: false,
                    key: provider.phoneKey,
                    hintText: 'Số điện thoại',
                    controller: phoneNoController,
                    inputType: TextInputType.phone,
                    keyboardAction: TextInputAction.next,
                    onChange: provider.onChangePhone,
                  );
                },
              ),

              // const Padding(padding: EdgeInsets.only(top: 15)),
              // const Text(
              //   'Quên mật khẩu?',
              //   style: TextStyle(
              //     color: DefaultTheme.GREEN,
              //     fontSize: 15,
              //   ),
              // ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              ButtonWidget(
                width: width,
                height: 40,
                text: 'Đăng nhập',
                borderRadius: 5,
                textColor: AppColor.WHITE,
                bgColor: AppColor.GREEN,
                function: () {
                  openPinDialog(context);
                },
              ),
              (!isResized && PlatformUtils.instance.isWeb())
                  ? const Padding(
                      padding: EdgeInsets.only(top: 10),
                    )
                  : const SizedBox(),
              (!isResized && PlatformUtils.instance.isWeb())
                  ? ButtonWidget(
                      width: width,
                      height: 40,
                      text: 'Đăng nhập bằng QR Code',
                      borderRadius: 5,
                      textColor: Theme.of(context).hintColor,
                      bgColor: Theme.of(context).canvasColor,
                      function: () {
                        DialogWidget.instance.openContentDialog(
                            null, _buildWidget2(context: context));
                      },
                    )
                  : const SizedBox(),
              const Padding(padding: EdgeInsets.only(top: 20)),
              SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DividerWidget(width: width),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'hoặc',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColor.GREY_TEXT,
                        ),
                      ),
                    ),
                    Expanded(
                      child: DividerWidget(width: width),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              ButtonWidget(
                width: width,
                height: 40,
                text: 'Đăng ký',
                borderRadius: 5,
                textColor: AppColor.WHITE,
                bgColor: AppColor.BLUE_TEXT,
                function: () async {
                  final keyboardHeight =
                      MediaQuery.of(context).viewInsets.bottom;
                  if (keyboardHeight > 0.0) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }

                  final data = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          Register(phoneNo: phoneNoController.text),
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
                },
              ),
            ],
          ),
        ),
        ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset('assets/images/banner_app.png'))
      ],
    );
  }

  Widget _buildWidget2({required BuildContext context}) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BoxLayout(
            width: 200,
            height: 200,
            borderRadius: 5,
            enableShadow: true,
            alignment: Alignment.center,
            bgColor: AppColor.WHITE,
            padding: const EdgeInsets.all(0),
            child: QrImage(
              data: code,
              size: 200,
              embeddedImage:
                  const AssetImage('assets/images/ic-viet-qr-login.png'),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(30, 30),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 30)),
          const Text(
            'Đăng nhập bằng QR Code',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          const SizedBox(
            width: 250,
            child: Text(
              'Sử dụng ứng dụng VietQR trên điện thoại để quét mã đăng nhập.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
