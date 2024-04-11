import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/pin_code_input.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';

import '../../../commons/constants/configurations/numeral.dart';
import '../../../commons/utils/image_utils.dart';
import '../../../commons/widgets/pin_widget_register.dart';
import '../../../models/info_user_dto.dart';
import '../../../services/providers/pin_provider.dart';
import 'bgr_app_bar_login.dart';
import 'forgot_password_screen.dart';

class QuickLoginScreen extends StatefulWidget {
  final String userName;
  final String phone;
  bool isFocus;
  final Function(AccountLoginDTO) onLogin;
  final GestureTapCallback? onQuickLogin;
  final TextEditingController pinController;
  final FocusNode passFocus;
  final AppInfoDTO appInfoDTO;
  final String imgId;

  QuickLoginScreen({
    super.key,
    required this.userName,
    required this.phone,
    required this.onLogin,
    required this.onQuickLogin,
    required this.pinController,
    required this.passFocus,
    required this.appInfoDTO,
    required this.isFocus,
    required this.imgId,
  });

  @override
  State<QuickLoginScreen> createState() => _QuickLoginScreenState();
}

class _QuickLoginScreenState extends State<QuickLoginScreen> {
  bool isButtonLogin = false;

  onChangePin(value) {
    if (value.length >= 6) {
      isButtonLogin = true;
    } else {
      isButtonLogin = false;
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<AuthProvider>(context, listen: false).initThemeDTO();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    Provider.of<PinProvider>(context, listen: false).reset();
    return Scaffold(
      body: Container(
        color: AppColor.WHITE,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Stack(
                    children: [
                      BackgroundAppBarLogin(child: const SizedBox()),
                      Container(
                        padding:
                            const EdgeInsets.only(top: 50, left: 0, right: 0),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: widget.onQuickLogin,
                                      padding: const EdgeInsets.only(left: 20),
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ),
                                    Container(
                                      width: 96,
                                      height: 40,
                                      margin: const EdgeInsets.only(right: 20),
                                      child: Image.asset(
                                        "assets/images/logo_vietgr_payment.png",
                                        width: 160,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Expanded(
                                //       child: Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.stretch,
                                //         children: [
                                //           Text(
                                //             'Xin chào, ${widget.userName}',
                                //             style: const TextStyle(
                                //               fontSize: 14,
                                //               fontWeight: FontWeight.w500,
                                //             ),
                                //           ),
                                //           const SizedBox(height: 4),
                                //           Text(
                                //             StringUtils.instance
                                //                 .formatPhoneNumberVN(
                                //                     widget.phone),
                                //             style: const TextStyle(
                                //               fontSize: 18,
                                //               fontWeight: FontWeight.bold,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //     Consumer<AuthProvider>(
                                //       builder: (context, page, child) {
                                //         return SizedBox(
                                //           width: 80,
                                //           height: 40,
                                //           child: page.logoApp.path.isNotEmpty
                                //               ? Image.file(page.logoApp)
                                //               : Image.asset(
                                //                   'assets/images/ic-viet-qr.png',
                                //                   height: 40,
                                //                 ),
                                //         );
                                //       },
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: _buildItem(height),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: const Text(
                      'Vui lòng nhập mật khẩu để đăng nhập',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Focus(
                    onFocusChange: (value) {
                      setState(() {
                        widget.isFocus = value;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: widget.isFocus
                                  ? AppColor.BLUE_TEXT
                                  : AppColor.GREY_TEXT,
                              width: 0.5)),
                      child: PinWidgetRegister(
                        width: MediaQuery.of(context).size.width,
                        pinSize: 15,
                        pinLength: Numeral.DEFAULT_PIN_LENGTH,
                        editingController: widget.pinController,
                        focusNode: widget.passFocus,
                        autoFocus: widget.isFocus,
                        onDone: (value) {
                          onChangePin(value);
                          Provider.of<PinProvider>(context, listen: false)
                              .reset();
                          AccountLoginDTO dto = AccountLoginDTO(
                            phoneNo: widget.phone,
                            password: EncryptUtils.instance.encrypted(
                              widget.phone,
                              widget.pinController.text,
                            ),
                            device: '',
                            fcmToken: '',
                            platform: '',
                            sharingCode: '',
                          );
                          widget.onLogin(dto);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: widget.onQuickLogin,
                    //       child: const Text(
                    //         'Đổi số điện thoại',
                    //         style: TextStyle(
                    //             fontSize: 14,
                    //             fontWeight: FontWeight.w500,
                    //             color: AppColor.BLUE_TEXT),
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         FocusManager.instance.primaryFocus?.unfocus();
                    //         NavigatorUtils.navigatePage(
                    //           context,
                    //           ForgotPasswordScreen(
                    //             userName: widget.userName,
                    //             phone: widget.phone,
                    //             appInfoDTO: widget.appInfoDTO,
                    //           ),
                    //           routeName: ForgotPasswordScreen.routeName,
                    //         );
                    //       },
                    //       child: const Text(
                    //         'Quên mật khẩu?',
                    //         style: TextStyle(
                    //             fontSize: 14,
                    //             fontWeight: FontWeight.w500,
                    //             color: AppColor.BLUE_TEXT),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ],
              ),
            ),
            MButtonWidget(
              title: 'Đăng nhập',
              width: 350,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              colorDisableBgr: AppColor.GREY_BUTTON,
              isEnable: widget.pinController.text.length >= 6,
              colorEnableText: widget.pinController.text.length >= 6
                  ? AppColor.WHITE
                  : AppColor.GREY_TEXT,
              onTap: () {
                AccountLoginDTO dto = AccountLoginDTO(
                  phoneNo: widget.phone,
                  password: EncryptUtils.instance.encrypted(
                    widget.phone,
                    widget.pinController.text,
                  ),
                  device: '',
                  fcmToken: '',
                  platform: '',
                  sharingCode: '',
                );
                widget.onLogin(dto);
              },
            ),
            SizedBox(height: height < 800 ? 0 : 16),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(double height) {
    return Container(
      margin: height < 800
          ? const EdgeInsets.only(left: 20, right: 20, bottom: 6)
          : const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.GREY_DADADA, width: 2),
          borderRadius: BorderRadius.circular(5),
          color: AppColor.WHITE),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 20, vertical: height < 800 ? 6 : 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: widget.imgId.isNotEmpty
                  ? Image(
                      image: ImageUtils.instance.getImageNetWork(widget.imgId),
                      width: 30,
                      height: 30,
                      fit: BoxFit.fill,
                    )
                  : Image.asset(
                      'assets/images/ic-avatar.png',
                      width: 30,
                      height: 30,
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.phone,
                    style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
