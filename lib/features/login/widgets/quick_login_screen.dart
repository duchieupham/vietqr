import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/pin_code_input.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/account_login_dto.dart';

import '../../../commons/constants/configurations/numeral.dart';
import '../../../commons/widgets/pin_widget_register.dart';
import '../../../services/providers/pin_provider.dart';
import 'bgr_app_bar_login.dart';

class QuickLoginScreen extends StatefulWidget {
  final String userName;
  final String phone;
  bool isFocus;
  final Function(AccountLoginDTO) onLogin;
  final GestureTapCallback? onQuickLogin;
  final TextEditingController pinController;
  final FocusNode passFocus;
  final String imgId;

  QuickLoginScreen({
    super.key,
    required this.userName,
    required this.phone,
    required this.onLogin,
    required this.onQuickLogin,
    required this.pinController,
    required this.passFocus,
    required this.isFocus,
    required this.imgId,
  });

  @override
  State<QuickLoginScreen> createState() => _QuickLoginScreenState();
}

class _QuickLoginScreenState extends State<QuickLoginScreen> {
  bool isVNSelected = true;
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
      Provider.of<PinProvider>(context, listen: false).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // Provider.of<PinProvider>(context, listen: false).reset();
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      appBar: AppBar(
        leadingWidth: 120,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: widget.onQuickLogin,
          child: const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 18,
                ),
                XImage(
                  imagePath: 'assets/images/ic-viet-qr.png',
                  height: 30,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              VietQRButton.solid(
                borderRadius: 50,
                onPressed: () {},
                isDisabled: false,
                width: 40,
                size: VietQRButtonSize.medium,
                child: const XImage(
                  imagePath: 'assets/images/ic-headphone-black.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, left: 8),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE1EFFF),
                        Color(0xFFE5F9FF),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isVNSelected = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: isVNSelected
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF00C6FF),
                                      Color(0xFF0072FF),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : null,
                            color: isVNSelected ? null : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: isVNSelected
                              ? const Text(
                                  'VN',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : ShaderMask(
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
                                    'VN',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 0),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isVNSelected = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: !isVNSelected
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF00C6FF),
                                      Color(0xFF0072FF),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : null,
                            color: !isVNSelected ? null : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: !isVNSelected
                              ? const Text(
                                  'EN',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : ShaderMask(
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
                                    'EN',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 100,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  // top: 0,
                  // bottom: 0,
                  // left: 0,
                  // right: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: widget.imgId.isNotEmpty
                        ? Image(
                            image: ImageUtils.instance
                                .getImageNetWork(widget.imgId),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/ic-avatar.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.black.withOpacity(0), // Transparent color
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: widget.imgId.isNotEmpty
                        ? Image(
                            image: ImageUtils.instance
                                .getImageNetWork(widget.imgId),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/ic-avatar.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Xin chào, ${widget.userName}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.phone,
            style: const TextStyle(fontSize: 15),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Focus(
              onFocusChange: (value) {
                setState(() {
                  widget.isFocus = value;
                });
              },
              child: PinCodeInput(
                obscureText: true,
                controller: widget.pinController,
                autoFocus: widget.isFocus,
                focusNode: widget.passFocus,
                onChanged: (text) {
                  // if (widget.pinController.text.length == 6) {
                  //   setState(() {
                  //     _isEnableButton = true;
                  //   });
                  // } else {
                  //   setState(() {
                  //     _isEnableButton = false;
                  //   });
                  // }
                },
                onCompleted: (value) {
                  onChangePin(value);
                  Provider.of<PinProvider>(context, listen: false).reset();
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
          // Stack(
          //   children: [
          //     // const BackgroundAppBarLogin(child: SizedBox()),
          //     Container(
          //       padding: const EdgeInsets.only(top: 50, left: 0, right: 0),
          //       width: MediaQuery.of(context).size.width,
          //       height: 100,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.stretch,
          //         children: [
          //           Column(
          //             children: [
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   IconButton(
          //                     onPressed: widget.onQuickLogin,
          //                     padding: const EdgeInsets.only(left: 20),
          //                     icon: const Icon(
          //                       Icons.arrow_back_ios,
          //                       color: Colors.black,
          //                       size: 18,
          //                     ),
          //                   ),
          //                   Container(
          //                     width: 96,
          //                     height: 40,
          //                     margin: const EdgeInsets.only(right: 20),
          //                     child: const XImage(
          //                       imagePath: ImageConstant.logoVietQRPayment,
          //                       width: 160,
          //                       fit: BoxFit.fitWidth,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               // Row(
          //               //   children: [
          //               //     Expanded(
          //               //       child: Column(
          //               //         crossAxisAlignment:
          //               //             CrossAxisAlignment.stretch,
          //               //         children: [
          //               //           Text(
          //               //             'Xin chào, ${widget.userName}',
          //               //             style: const TextStyle(
          //               //               fontSize: 14,
          //               //               fontWeight: FontWeight.w500,
          //               //             ),
          //               //           ),
          //               //           const SizedBox(height: 4),
          //               //           Text(
          //               //             StringUtils.instance
          //               //                 .formatPhoneNumberVN(
          //               //                     widget.phone),
          //               //             style: const TextStyle(
          //               //               fontSize: 18,
          //               //               fontWeight: FontWeight.bold,
          //               //             ),
          //               //           ),
          //               //         ],
          //               //       ),
          //               //     ),
          //               //     Consumer<AuthProvider>(
          //               //       builder: (context, page, child) {
          //               //         return SizedBox(
          //               //           width: 80,
          //               //           height: 40,
          //               //           child: page.logoApp.path.isNotEmpty
          //               //               ? Image.file(page.logoApp)
          //               //               : Image.asset(
          //               //                   'assets/images/ic-viet-qr.png',
          //               //                   height: 40,
          //               //                 ),
          //               //         );
          //               //       },
          //               //     ),
          //               //   ],
          //               // ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20, right: 20),
          //   child: _buildItem(height),
          // ),
          // const SizedBox(height: 10),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 40),
          //   child: Text(
          //     'Vui lòng nhập mật khẩu để đăng nhập',
          //     textAlign: TextAlign.start,
          //     style: TextStyle(
          //       fontSize: 25,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 16),
          // Focus(
          // onFocusChange: (value) {
          //   setState(() {
          //     widget.isFocus = value;
          //   });
          // },
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     margin: const EdgeInsets.symmetric(horizontal: 40),
          //     height: 40,
          //     alignment: Alignment.center,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(50),
          //         border: Border.all(
          //             color: widget.isFocus
          //                 ? AppColor.BLUE_TEXT
          //                 : AppColor.GREY_TEXT,
          //             width: 0.5)),
          //     child: PinWidgetRegister(
          //       width: MediaQuery.of(context).size.width,
          //       pinSize: 15,
          //       pinLength: Numeral.DEFAULT_PIN_LENGTH,
          //       editingController: widget.pinController,
          //       focusNode: widget.passFocus,
          //       autoFocus: widget.isFocus,
          //       onDone: (value) {
          //         onChangePin(value);
          //         Provider.of<PinProvider>(context, listen: false).reset();
          //         AccountLoginDTO dto = AccountLoginDTO(
          //           phoneNo: widget.phone,
          //           password: EncryptUtils.instance.encrypted(
          //             widget.phone,
          //             widget.pinController.text,
          //           ),
          //           device: '',
          //           fcmToken: '',
          //           platform: '',
          //           sharingCode: '',
          //         );
          //         widget.onLogin(dto);
          //       },
          //     ),
          //   ),
          // ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 40, right: 40),
          ),
          const Spacer(),
          // MButtonWidget(
          //   title: 'Đăng nhập',
          //   width: 350,
          //   height: 50,
          //   margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          //   colorDisableBgr: AppColor.GREY_BUTTON,
          //   isEnable: widget.pinController.text.length >= 6,
          //   colorEnableText: widget.pinController.text.length >= 6
          //       ? AppColor.WHITE
          //       : AppColor.GREY_TEXT,
          //   onTap: () {
          //     AccountLoginDTO dto = AccountLoginDTO(
          //       phoneNo: widget.phone,
          //       password: EncryptUtils.instance.encrypted(
          //         widget.phone,
          //         widget.pinController.text,
          //       ),
          //       device: '',
          //       fcmToken: '',
          //       platform: '',
          //       sharingCode: '',
          //     );
          //     widget.onLogin(dto);
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: VietQRButton.gradient(
              onPressed: () {
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
              isDisabled: !(widget.pinController.text.length >= 6),
              child: Center(
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    color: widget.pinController.text.length >= 6
                        ? AppColor.WHITE
                        : AppColor.BLACK,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: height < 800 ? 0 : 16),
        ],
      ),
    );
  }

  Widget _buildItem(double height) {
    return Container(
      margin: height < 800
          ? const EdgeInsets.only(left: 0, right: 0, bottom: 6)
          : const EdgeInsets.only(left: 0, right: 0, bottom: 10),
      decoration: BoxDecoration(
          // border: Border.all(color: AppColor.GREY_DADADA, width: 2),
          borderRadius: BorderRadius.circular(5),
          color: AppColor.WHITE),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 15, vertical: height < 800 ? 4 : 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: widget.imgId.isNotEmpty
                  ? Image(
                      image: ImageUtils.instance.getImageNetWork(widget.imgId),
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                    )
                  : Image.asset(
                      'assets/images/ic-avatar.png',
                      width: 40,
                      height: 40,
                    ),
              // ? XImage(
              //     imagePath: widget.imgId,
              //     width: 45,
              //     height: 45,
              //     fit: BoxFit.fill,
              //   )
              // : const XImage(
              //     imagePath: ImageConstant.icAvatar,
              //     width: 45,
              //     height: 45,
              //   ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.phone,
                    style: const TextStyle(
                        fontSize: 20, color: AppColor.GREY_TEXT),
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
