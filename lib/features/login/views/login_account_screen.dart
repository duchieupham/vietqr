import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/info_user_dto.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';

import '../../../commons/utils/image_utils.dart';
import 'bgr_app_bar_login.dart';

class LoginAccountScreen extends StatefulWidget {
  final Function(InfoUserDTO)? onQuickLogin;
  final Function(int)? onRemoveAccount;
  final GestureTapCallback? onBackLogin;
  final GestureTapCallback? onRegister;
  final GestureTapCallback? onLoginCard;
  final List<InfoUserDTO> list;
  final Widget child;
  final Widget buttonNext;
  final AppInfoDTO appInfoDTO;

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
    required this.appInfoDTO,
  });

  @override
  State<LoginAccountScreen> createState() => _LoginAccountScreenState();
}

class _LoginAccountScreenState extends State<LoginAccountScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).initThemeDTO();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: height * 0.3,
            width: width,
            child: Stack(
              children: [
                BackgroundAppBarLogin(),
                Positioned(
                  bottom: 10,
                  left: 20,
                  right: 20,
                  child: Text(
                    'Chọn tài khoản\nđể tiếp tục đăng nhập',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                  children: List.generate(widget.list.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        widget.onQuickLogin!(widget.list[index]);
                      },
                      child: _buildItem(widget.list[index], index, height),
                    );
                  }).toList(),
                ),
                SizedBox(height: height < 800 ? 4 : 16),
                GestureDetector(
                  onTap: widget.onBackLogin,
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
                      // Expanded(
                      //   child: MButtonWidget(
                      //     title: '',
                      //     isEnable: true,
                      //     colorEnableBgr: AppColor.WHITE,
                      //     margin: EdgeInsets.zero,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Image.asset('assets/images/logo-google.png'),
                      //         Text(
                      //           'Đăng nhập với Google',
                      //           style: height < 800
                      //               ? TextStyle(fontSize: 10)
                      //               : TextStyle(fontSize: 12),
                      //         ),
                      //       ],
                      //     ),
                      //     onTap: () {},
                      //   ),
                      // ),
                      // const SizedBox(width: 16),
                      Expanded(
                        child: MButtonWidget(
                          title: '',
                          isEnable: true,
                          colorEnableBgr: AppColor.BLUE_E1EFFF,
                          margin: EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/ic-card.png'),
                              const SizedBox(width: 8),
                              Text(
                                'VQR ID Card',
                                style: height < 800
                                    ? TextStyle(fontSize: 10)
                                    : TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          onTap: widget.onLoginCard,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    widget.child,
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: widget.onRegister,
                        child: const Text(
                          'Đăng ký tài khoản mới',
                          style: TextStyle(
                              color: AppColor.BLUE_TEXT,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (widget.list.length == 1) ...[
                      SizedBox(height: height < 800 ? 0 : 16),
                      widget.buttonNext,
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
              child: dto.imgId?.isNotEmpty ?? false
                  ? Image(
                      image: ImageUtils.instance.getImageNetWork(dto.imgId!),
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                    )
                  : Image.asset(
                      'assets/images/ic-avatar.png',
                      width: 40,
                      height: 40,
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
                  const SizedBox(height: 2),
                  Text(
                    dto.phoneNo ?? '',
                    style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.onRemoveAccount!(index);
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
