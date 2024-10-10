import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';

import '../commons/constants/configurations/theme.dart';

class RegisterAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final List<Widget>? actions;
  final bool isLeading;
  final VoidCallback? onPressed;
  final VoidCallback? callBackHome;
  final bool showBG;
  final bool centerTitle;

  const RegisterAppBar({
    super.key,
    required this.title,
    this.actions,
    this.isLeading = true,
    this.onPressed,
    this.callBackHome,
    this.showBG = true,
    this.centerTitle = true,
  }) : preferredSize = const Size.fromHeight(60);

  @override
  State<RegisterAppBar> createState() => _RegisterAppBarState();
}

class _RegisterAppBarState extends State<RegisterAppBar> {
  bool isVNSelected = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenProvider>(builder: (context, page, child) {
      // ignore: unused_local_variable
      String url = page.settingDTO.themeImgUrl;
      return Container(
        // decoration: showBG
        //     ? BoxDecoration(
        //         image: page.bannerApp.path.isEmpty
        //             ? DecorationImage(
        //                 image: NetworkImage(url), fit: BoxFit.cover)
        //             : DecorationImage(
        //                 image: FileImage(page.bannerApp), fit: BoxFit.cover))
        //     : BoxDecoration(),
        decoration: const BoxDecoration(color: AppColor.WHITE),
        child: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.4,
            ),
          ),
          leading: widget.isLeading
              ? _buildBackButton(context)
              : _buildBackButtonLeading(context),
          leadingWidth: 120,
          // leading: isLeading
          //     ? IconButton(
          //         onPressed: (onPressed == null)
          //             ? () => _handleBack(context)
          //             : () {
          //                 onPressed!();
          //               },
          //         padding: const EdgeInsets.only(left: 20),
          //         icon: const Icon(
          //           Icons.arrow_back_ios,
          //           color: Colors.black,
          //           size: 18,
          //         ),
          //       )
          //     : null,
          centerTitle: widget.centerTitle,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: widget.actions ??
              [
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
                                  color:
                                      isVNSelected ? null : Colors.transparent,
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
                                  color:
                                      !isVNSelected ? null : Colors.transparent,
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
                // GestureDetector(
                //   onTap: (callBackHome == null)
                //       ? () {
                //           Navigator.of(context)
                //               .popUntil((route) => route.isFirst);
                //         }
                //       : callBackHome,
                //   child: Container(
                //     width: 96,
                //     height: 56,
                //     margin: const EdgeInsets.only(right: 20),
                //     child: CachedNetworkImage(
                //       imageUrl: page.settingDTO.logoUrl,
                //       height: 56,
                //       width: 96,
                //       fit: BoxFit.contain,
                //     ),
                //   ),
                // ),
              ],
          backgroundColor: Colors.transparent,
        ),
      );
    });
  }

  _handleBack(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: (widget.onPressed == null)
          ? () => _handleBack(context)
          : widget.onPressed,
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        width: 100,
        alignment: Alignment.centerLeft,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 18,
            ),
            SizedBox(width: 4),
            XImage(
              imagePath: 'assets/images/ic-viet-qr.png',
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButtonLeading(BuildContext context) {
    return GestureDetector(
      onTap: (widget.onPressed == null)
          ? () => _handleBack(context)
          : widget.onPressed,
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        width: 100,
        alignment: Alignment.centerLeft,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon(
            //   Icons.arrow_back_ios,
            //   color: Colors.black,
            //   size: 18,
            // ),
            // SizedBox(width: 4),
            XImage(
              imagePath: 'assets/images/ic-viet-qr.png',
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
