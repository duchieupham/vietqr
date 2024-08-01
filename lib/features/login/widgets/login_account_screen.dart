import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/info_user_dto.dart';

class LoginAccountScreen extends StatefulWidget {
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
  State<LoginAccountScreen> createState() => _LoginAccountScreenState();
}

class _LoginAccountScreenState extends State<LoginAccountScreen> {
  final PageController _pageController = PageController();
  bool isVNSelected = true;
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
      appBar: AppBar(
        leadingWidth: 100,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: XImage(
            imagePath: 'assets/images/ic-viet-qr.png',
            height: 40,
            // width: 30,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
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
                              shaderCallback: (bounds) => const LinearGradient(
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
                              shaderCallback: (bounds) => const LinearGradient(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 0),
          SizedBox(
            width: width,
            height: height * 0.6,
            child: PageView(
              controller: _pageController,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                introdution1(),
                introdution2(),
                introdution3(),
                introdution4(),
                introdution5(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 5,
              effect: ExpandingDotsEffect(
                dotWidth: 8,
                dotHeight: 8,
                expansionFactor: 3,
                spacing: 5,
                dotColor: Colors.blue.withOpacity(0.5),
                activeDotColor: Colors.blue,
              ),
            ),
          ),
          const Spacer(),
          widget.list.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    widget.onQuickLogin!(widget.list.first);
                  },
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: XImage(
                          imagePath: 'assets/images/ic-suggest.png',
                          width: 30,
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => VietQRTheme
                            .gradientColor.aiTextColor
                            .createShader(bounds),
                        child: Text(
                          'Bạn có phải là ${widget.list.first.fullName} ?',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 8),
          VietQRButton.gradient(
              margin: EdgeInsets.symmetric(horizontal: 30),
              onPressed: widget.onRegister!,
              isDisabled: false,
              child: const Center(
                child: Text(
                  'Tôi là người dùng mới',
                  style: TextStyle(color: AppColor.WHITE, fontSize: 15),
                ),
              )),
          // Container(
          //   alignment: Alignment.center,
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: GestureDetector(
          //     onTap: widget.onRegister,
          //     child: const Text(
          //       'Đăng ký tài khoản mới',
          //       style: TextStyle(
          //           color: AppColor.BLUE_TEXT,
          //           decoration: TextDecoration.underline),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: widget.onBackLogin,
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF00C6FF),
                    Color(0xFF0072FF),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: const Text(
                  'Bạn đã có tài khoản VietQR ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Expanded(
          //   child: Column(
          //     children: [
          //       Text(widget.list.isNotEmpty ? widget.list.first.fullName : ''),

          //       // Column(
          //       //   children: List.generate(widget.list.length, (index) {
          //       //     return GestureDetector(
          //       //       onTap: () {
          //       //         widget.onQuickLogin!(widget.list[index]);
          //       //       },
          //       //       child: _buildItem(widget.list[index], index, height),
          //       //     );
          //       //   }).toList(),
          //       // ),
          //       SizedBox(height: height < 800 ? 4 : 16),
          //       GestureDetector(
          //         onTap: widget.onBackLogin,
          //         child: Container(
          //           width: MediaQuery.of(context).size.width,
          //           padding: const EdgeInsets.symmetric(vertical: 10),
          //           margin: const EdgeInsets.symmetric(horizontal: 20),
          //           alignment: Alignment.center,
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(16),
          //               color: Colors.transparent,
          //               border: Border.all(color: AppColor.BLUE_TEXT)),
          //           child: const Text(
          //             'Đăng nhập bằng tài khoản khác',
          //             style: TextStyle(fontSize: 15, color: AppColor.BLUE_TEXT),
          //           ),
          //         ),
          //       ),
          //       SizedBox(height: height < 800 ? 12 : 16),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 20),
          //         child: Row(
          //           children: [
          //             Expanded(
          //               child: Container(
          //                   height: 0.5,
          //                   color: AppColor.BLACK.withOpacity(0.6)),
          //             ),
          //             const Padding(
          //               padding: EdgeInsets.symmetric(horizontal: 8.0),
          //               child: Text(
          //                 'Hoặc',
          //                 style: TextStyle(fontWeight: FontWeight.w300),
          //               ),
          //             ),
          //             Expanded(
          //               child: Container(
          //                   height: 0.5,
          //                   color: AppColor.BLACK.withOpacity(0.6)),
          //             ),
          //           ],
          //         ),
          //       ),
          //       SizedBox(height: height < 800 ? 12 : 16),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //         child: Row(
          //           children: [
          //             // Expanded(
          //             //   child: MButtonWidget(
          //             //     title: '',
          //             //     isEnable: true,
          //             //     colorEnableBgr: AppColor.WHITE,
          //             //     margin: EdgeInsets.zero,
          //             //     child: Row(
          //             //       mainAxisAlignment: MainAxisAlignment.center,
          //             //       children: [
          //             //         Image.asset('assets/images/logo-google.png'),
          //             //         Text(
          //             //           'Đăng nhập với Google',
          //             //           style: height < 800
          //             //               ? TextStyle(fontSize: 10)
          //             //               : TextStyle(fontSize: 12),
          //             //         ),
          //             //       ],
          //             //     ),
          //             //     onTap: () {},
          //             //   ),
          //             // ),
          //             // const SizedBox(width: 16),
          //             Expanded(
          //               child: MButtonWidget(
          //                 height: 50,
          //                 title: '',
          //                 isEnable: true,
          //                 colorEnableBgr: AppColor.BLUE_E1EFFF,
          //                 margin: EdgeInsets.zero,
          //                 onTap: widget.onLoginCard,
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     const XImage(imagePath: ImageConstant.icCard),
          //                     const SizedBox(width: 8),
          //                     Text(
          //                       'VQR ID Card',
          //                       style: height < 800
          //                           ? const TextStyle(fontSize: 10)
          //                           : const TextStyle(fontSize: 12),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       const Spacer(),
          //       Column(
          //         children: [
          //           widget.child,
          //           const SizedBox(height: 16),
          //           Container(
          //             alignment: Alignment.center,
          //             padding: const EdgeInsets.symmetric(horizontal: 20),
          //             child: GestureDetector(
          //               onTap: widget.onRegister,
          //               child: const Text(
          //                 'Đăng ký tài khoản mới',
          //                 style: TextStyle(
          //                     color: AppColor.BLUE_TEXT,
          //                     decoration: TextDecoration.underline),
          //               ),
          //             ),
          //           ),
          //           const SizedBox(height: 24),
          //           if (widget.list.length == 1) ...[
          //             SizedBox(height: height < 800 ? 0 : 16),
          //             widget.buttonNext,
          //             SizedBox(height: height < 800 ? 0 : 16),
          //           ] else
          //             const SizedBox(height: 16),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
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
              // ? XImage(
              //     imagePath: dto.imgId!,
              //     width: 40,
              //     height: 40,
              //     fit: BoxFit.fill,
              //   )
              // : const XImage(
              //     imagePath: ImageConstant.icAvatar,
              //     width: 40,
              //     height: 40,
              //   ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.fullName.trim(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dto.phoneNo ?? '',
                    style: const TextStyle(
                        fontSize: 15, color: AppColor.GREY_TEXT),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.onRemoveAccount!(index);
              },
              child: const XImage(
                imagePath: ImageConstant.icNextUser,
                width: 30,
                height: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget introdution1() {
    return Center(
      child: Container(
        // color: Colors.greenAccent,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const XImage(
              imagePath: 'assets/images/ic-viet-qr.png',
              height: 50,
            ),
            // const SizedBox(height: 16),
            const XImage(
              imagePath: 'assets/images/login-intro1.png',
              width: 320,
              height: 320,
            ),
            // const SizedBox(height: 16),
            const Spacer(),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Color(0xFF9CD740),
                  Color(0xFF2BACE6),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                'Ứng dụng Tiện ích, Đơn giản cho cuộc sống hiện đại',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget introdution2() {
    return Center(
      child: Container(
        // color: Colors.greenAccent,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF4260ED),
                  Color(0xFFFC7218),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                'Thanh toán nhanh gọn,\nđối soát nhanh chóng',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const XImage(
              imagePath: 'assets/images/login-intro2.png',
              width: 320,
              height: 320,
            ),
            const Spacer(),
            const Text(
              'Quét mã VietQR thanh toán tức thì.\nHỗ trợ quét mã thanh toán cho tất cả\ncác ứng dụng ngân hàng và ví điện tử.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget introdution3() {
    return Center(
      child: Container(
        // color: Colors.greenAccent,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF4260ED),
                  Color(0xFFFC7218),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                'Quản lý cửa hàng hiệu quả',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const XImage(
              imagePath: 'assets/images/login-intro3.png',
              width: 320,
              height: 320,
            ),
            const Spacer(),
            const Text(
              'Dữ liệu thống kê trực quan, đáng tin cậy.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget introdution4() {
    return Center(
      child: Container(
        // color: Colors.greenAccent,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF4260ED),
                  Color(0xFFFC7218),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                'Chia sẻ thông tin số dư\nqua nền tảng mạng xã hội',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const XImage(
              imagePath: 'assets/images/login-intro4.png',
              width: 320,
              height: 320,
            ),
            const Spacer(),
            const Text(
              'Chia sẻ thông tin giao dịch\nvới nhóm nhân viên của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget introdution5() {
    return Center(
      child: Container(
        // color: Colors.greenAccent,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF4260ED),
                  Color(0xFFFC7218),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                'Tích hợp dịch vụ VietQR\nvào hệ thống của bạn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const XImage(
              imagePath: 'assets/images/login-intro5.png',
              width: 320,
              height: 320,
            ),
            const Spacer(),
            const Text(
              'Sử dụng bộ API Service của chúng tôi\nđể tích hợp và quản trị trực tiếp trên\nhệ thống của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
