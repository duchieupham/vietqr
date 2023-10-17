import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/info_user_dto.dart';

import '../../../commons/utils/image_utils.dart';

class LoginAccountScreen extends StatelessWidget {
  final Function(InfoUserDTO)? onQuickLogin;
  final Function(int)? onRemoveAccount;
  final GestureTapCallback? onBackLogin;
  final GestureTapCallback? onRegister;
  final GestureTapCallback? onLoginCard;
  final List<InfoUserDTO> list;
  final Widget child;
  final Widget buttonNext;

  const LoginAccountScreen({
    super.key,
    this.onQuickLogin,
    this.onRemoveAccount,
    this.onBackLogin,
    this.onLoginCard,
    this.onRegister,
    required this.list,
    required this.child,
    required this.buttonNext,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: height * 0.3,
            width: width,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: height * 0.3,
                    width: width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bgr-header.png'),
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
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
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
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                Column(
                  children: List.generate(list.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        onQuickLogin!(list[index]);
                      },
                      child: _buildItem(list[index], index, height),
                    );
                  }).toList(),
                ),
                SizedBox(height: height < 800 ? 4 : 16),
                GestureDetector(
                  onTap: onBackLogin,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.transparent,
                        border: Border.all(color: AppColor.BLUE_TEXT)),
                    child: Text(
                      'Đăng nhập bằng tài khoản khác',
                      style: TextStyle(fontSize: 15, color: AppColor.BLUE_TEXT),
                    ),
                  ),
                ),
                SizedBox(height: height < 800 ? 12 : 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            height: 0.5,
                            color: AppColor.BLACK.withOpacity(0.6)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Hoặc',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            height: 0.5,
                            color: AppColor.BLACK.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height < 800 ? 12 : 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: MButtonWidget(
                          title: '',
                          isEnable: true,
                          colorEnableBgr: AppColor.WHITE,
                          margin: EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/logo-google.png'),
                              Text(
                                'Đăng nhập với Google',
                                style: height < 800
                                    ? TextStyle(fontSize: 10)
                                    : TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MButtonWidget(
                          title: '',
                          isEnable: true,
                          margin: EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/ic-card.png'),
                              const SizedBox(width: 8),
                              Text(
                                'VQR ID Card',
                                style: height < 800
                                    ? TextStyle(
                                        fontSize: 10, color: AppColor.WHITE)
                                    : TextStyle(
                                        fontSize: 12, color: AppColor.WHITE),
                              ),
                            ],
                          ),
                          onTap: onLoginCard,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    child,
                    if (list.length == 1) ...[
                      SizedBox(height: height < 800 ? 0 : 16),
                      buttonNext,
                      SizedBox(height: height < 800 ? 0 : 16),
                    ] else
                      const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(InfoUserDTO dto, int index, double height) {
    return Container(
      margin: height < 800
          ? const EdgeInsets.only(left: 20, right: 20, bottom: 6)
          : const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: AppColor.WHITE),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 20, vertical: height < 800 ? 6 : 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: dto.imgId?.isNotEmpty ?? false
                  ? Image(
                      image: ImageUtils.instance.getImageNetWork(dto.imgId!),
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
                    dto.fullName.trim(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    dto.phoneNo ?? '',
                    style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                onRemoveAccount!(index);
              },
              child: Image.asset(
                'assets/images/ic-next-user.png',
                width: 30,
                height: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
