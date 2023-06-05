import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/login/events/login_event.dart';
import 'package:vierqr/features/login/frames/login_frame.dart';
import 'package:vierqr/features/login/states/login_state.dart';
import 'package:vierqr/features/register/views/register_view.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/services/providers/login_provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {
  static final TextEditingController phoneNoController =
      TextEditingController();

  static late LoginBloc _loginBloc;
  static String code = '';
  static const Uuid uuid = Uuid();

  @override
  void initState() {
    super.initState();
    code = uuid.v1();
    _loginBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    // LoginRepository.codeLoginController.close();
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

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: BlocListener<LoginBloc, LoginState>(
        listener: ((context, state) {
          if (state is LoginLoadingState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is LoginSuccessfulState) {
            // _loginBloc.add(LoginEventGetUserInformation(userId: state.userId));
            //pop loading dialog
            Navigator.of(context).pop();
            //navigate to home screen
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacementNamed(Routes.HOME, arguments: {
              'isFromLogin': true,
              'isLogoutEnterHome': isLogoutEnterHome
            });
          }
          if (state is LoginFailedState) {
            FocusManager.instance.primaryFocus?.unfocus();
            //pop loading dialog
            Navigator.of(context).pop();

            //show msg dialog
            DialogWidget.instance.openMsgDialog(
              title: 'Đăng nhập không thành công',
              msg:
                  'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập.',
            );
          }
        }),
        child: LoginFrame(
          width: width,
          height: height,
          padding: EdgeInsets.zero,
          widget1: _buildWidget1(
            width: width,
            isResized: PlatformUtils.instance.resizeWhen(width, 750),
          ),
          widget2: _buildWidget2(context: context),
        ),
      ),
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
            );
            _loginBloc.add(
              LoginEventByPhone(dto: dto),
            );
          });
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
                    width: width,
                    widthLayout: width,
                    isObscureText: false,
                    autoFocus: true,
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
                textColor: DefaultTheme.WHITE,
                bgColor: DefaultTheme.GREEN,
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
                          color: DefaultTheme.GREY_TEXT,
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
                textColor: DefaultTheme.WHITE,
                bgColor: DefaultTheme.BLUE_TEXT,
                function: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RegisterView(
                        phoneNo: phoneNoController.text,
                      ),
                    ),
                  );
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
            bgColor: DefaultTheme.WHITE,
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
