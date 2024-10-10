import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/register/events/register_event.dart';
import 'package:vierqr/features/register/states/register_state.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/info_user_dto.dart';
import 'package:vierqr/models/user_profile.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
// import 'package:vierqr/features/dashboard/dashboard_screen.dart';
// import 'package:vierqr/features/home/home.dart';
// import 'package:vierqr/layouts/button/button.dart';
// import 'package:vierqr/layouts/m_button_widget.dart';
// import 'package:vierqr/services/providers/register_provider.dart';
// import 'package:vierqr/splash_screen.dart';

import '../../../../commons/constants/configurations/app_images.dart';
import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/widgets/dialog_widget.dart';

class FormRegisterSuccessSplash extends StatefulWidget {
  final RegisterBloc registerBloc;
  const FormRegisterSuccessSplash({super.key, required this.registerBloc});

  @override
  State<FormRegisterSuccessSplash> createState() =>
      _FormRegisterSuccessSplashState();
}

class _FormRegisterSuccessSplashState extends State<FormRegisterSuccessSplash> {
  // final RegisterBloc _registerBloc = getIt.get<RegisterBloc>();
  // late final LoginBloc _loginBloc = getIt.get<LoginBloc>(
  //     param1: context, param2: getIt.get<LoginRepository>());
  Timer? _timer;
  int _start = 15;
  bool _onHomeCalled = false;
  // late final LoginBloc _bloc = getIt.get<LoginBloc>(param1: context);

  late AuthenProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthenProvider>(context, listen: false);
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          if (!_onHomeCalled) {
            // Navigator.popUntil(context, ((route) {
            //   if (route.settings.name != null &&
            //       route.settings.name == Routes.REGISTER) {
            //     return true;
            //   } else {
            //     return false;
            //   }
            // }));
            // backToPreviousPage(context, true, state);
            widget.registerBloc.add(const RegisterEventLoginAfterRegister());
          }
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  // void backToPreviousPage(
  //     BuildContext context, bool isRegisterSuccess, RegisterState state) {
  //   Navigator.pop(context, {
  //     'phone': state.phoneNumber.replaceAll(' ', ''),
  //     'password': state.password
  //   });
  // }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      bloc: widget.registerBloc,
      listener: (context, state) {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state.request == RegisterType.NONE &&
            state.status == BlocStatus.UNLOADING) {
          widget.registerBloc.add(const RegisterEventUpdateErrs(
              phoneErr: false, passErr: false, confirmPassErr: false));
          _authProvider.updateRenderUI(isLogout: true);
          UserProfile userProfile = SharePrefUtils.getProfile();

          final infoUser = state.infoUserDTO;
          if (infoUser != null) {
            infoUser.imgId = userProfile.imgId;
            infoUser.firstName = userProfile.firstName;
            infoUser.middleName = userProfile.middleName;
            infoUser.lastName = userProfile.lastName;
            infoUser.middleName = userProfile.middleName;

            _saveAccount(state);
          }

          Provider.of<AuthenProvider>(context, listen: false)
              .checkStateLogin(false);
          NavigationService.pushAndRemoveUntil(Routes.SPLASH,
              arguments: {'isFromLogin': true});

          if (true) {
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

        if (state.request == RegisterType.NONE &&
            state.status == BlocStatus.ERROR) {
          Provider.of<AuthenProvider>(context, listen: false)
              .checkStateLogin(true);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColor.WHITE,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 90),
                          child: Image.asset(
                            AppImages.icLogoVietQr,
                            width: 160,
                            height: 66,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Image.asset(
                            AppImages.icRegisterSuccessful,
                            width: 236,
                            height: 200,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        DefaultTextStyle(
                          style: const TextStyle(
                            color: AppColor.BLACK,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF9CD740),
                                Color(0xFF2BACE6),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds),
                            child: const Text(
                              'Đăng ký thành công!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DefaultTextStyle(
                          style: const TextStyle(
                              fontSize: 15, color: AppColor.BLACK),
                          child: RichText(
                            text: TextSpan(
                              text: 'Hệ thống tự động điều hướng sau ',
                              style: const TextStyle(
                                  fontSize: 15, color: AppColor.BLACK),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '$_start',
                                  style: const TextStyle(
                                      fontSize: 15, color: AppColor.BLUE_TEXT),
                                ),
                                const TextSpan(
                                  text: 's.',
                                  style: TextStyle(
                                      fontSize: 15, color: AppColor.BLACK),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            // setState(() {
                            //   _onHomeCalled = true;
                            // });
                            // Navigator.popUntil(context, ((route) {
                            //   if (route.settings.name != null &&
                            //       route.settings.name == Routes.REGISTER) {
                            //     return true;
                            //   } else {
                            //     return false;
                            //   }
                            // }));
                            // backToPreviousPage(context, true, state);
                            widget.registerBloc
                                .add(const RegisterEventLoginAfterRegister());
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE1EFFF),
                                      Color(0xFFE5F9FF),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight)),
                            child: Center(
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  color: AppColor.BLACK,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                    'Trang chủ VietQR.VN',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Container(
                        //   child: DefaultTextStyle(
                        //     style: TextStyle(fontSize: 15),
                        //     child: MButtonWidget(
                        //       title: 'Truy cập trang chủ VietQR VN',
                        //       isEnable: true,
                        //       margin: EdgeInsets.only(left: 40, right: 40),
                        //       height: 50,
                        //       onTap: widget.onHome,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                // renderSuggestion(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget renderSuggestion() {
    final height = MediaQuery.of(context).size.height;
    print(height);
    return Positioned(
      bottom: height < 800 ? 60 : 85,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const XImage(
                  imagePath: 'assets/images/ic-suggest.png',
                  width: 30,
                ),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF458BF8),
                      Color(0xFFFF8021),
                      Color(0xFFFF3751),
                      Color(0xFFC958DB),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: Text(
                    'Gợi ý cho bạn',
                    style: TextStyle(
                      fontSize: 15,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [
                            Color(0xFF458BF8),
                            Color(0xFFFF8021),
                            Color(0xFFFF3751),
                            Color(0xFFC958DB),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(const Rect.fromLTWH(0, 0, 200, 30)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            //  const SizedBox(height: 12),
            InkWell(
              onTap: () {
                // onLoginCard();
              },
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: 270,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFD8ECF8),
                      Color(0xFFFFEAD9),
                      Color(0xFFF5C9D1),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    XImage(
                      imagePath: 'assets/images/ic-password-black.png',
                      width: 30,
                    ),
                    Text(
                      'Bạn có muốn cập nhật thông tin cá nhân?',
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {},
              child: Container(
                width: 240,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFD8ECF8),
                      Color(0xFFFFEAD9),
                      Color(0xFFF5C9D1),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      XImage(
                        imagePath: 'assets/images/ic-person@-black.png',
                        width: 30,
                      ),
                      Text(
                        'Thêm tài khoản ngân hàng của bạn',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: height < 800 ? 16 : 5),
          ],
        ),
      ),
    );
  }

  void _saveAccount(RegisterState state) async {
    List<InfoUserDTO> listCheck =
        await SharePrefUtils.getLoginAccountList() ?? [];
    final infoUserDTO = state.infoUserDTO;
    if (infoUserDTO != null) {
      if (listCheck.isNotEmpty) {
        if (listCheck.length >= 3) {
          listCheck.removeWhere(
              (element) => element.phoneNo!.trim() == infoUserDTO.phoneNo);

          if (listCheck.length < 3) {
            listCheck.add(infoUserDTO);
          } else {
            listCheck.sort(
                (a, b) => a.expiryAsDateTime.compareTo(b.expiryAsDateTime));
            listCheck.removeLast();
            listCheck.add(infoUserDTO);
          }
        } else {
          listCheck.removeWhere(
              (element) => element.phoneNo!.trim() == infoUserDTO.phoneNo);

          listCheck.add(infoUserDTO);
        }
      } else {
        listCheck.add(infoUserDTO);
      }

      if (listCheck.length >= 2) {
        listCheck
            .sort((a, b) => a.expiryAsDateTime.compareTo(b.expiryAsDateTime));
      }
    }

    await SharePrefUtils.saveLoginAccountList(listCheck);
  }
}
