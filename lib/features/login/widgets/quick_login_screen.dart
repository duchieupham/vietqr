import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
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
  ///TODO: check lại xem có thực sự cần biến này
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
      Provider.of<PinProvider>(context, listen: false).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                      const BackgroundAppBarLogin(child: SizedBox()),
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
                                      child: const XImage(
                                        imagePath:
                                            ImageConstant.logoVietQRPayment,
                                        width: 160,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: _buildItem(height),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
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
                      margin: const EdgeInsets.symmetric(horizontal: 40),
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
                  const Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                  ),
                ],
              ),
            ),
            MButtonWidget(
              title: 'Đăng nhập',
              width: 350,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
                  ? XImage(
                      imagePath: widget.imgId,
                      width: 45,
                      height: 45,
                      fit: BoxFit.fill,
                    )
                  : const XImage(
                      imagePath: ImageConstant.icAvatar,
                      width: 45,
                      height: 45,
                    ),
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
