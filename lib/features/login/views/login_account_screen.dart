import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/models/info_user_dto.dart';

class LoginAccountScreen extends StatelessWidget {
  final Function(InfoUserDTO)? onQuickLogin;
  final Function(int)? onRemoveAccount;
  final GestureTapCallback? onBackLogin;
  final GestureTapCallback? onRegister;
  final List<InfoUserDTO> list;

  const LoginAccountScreen(
      {super.key,
      this.onQuickLogin,
      this.onRemoveAccount,
      this.onBackLogin,
      required this.list,
      this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
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
          Column(
            children: List.generate(list.length, (index) {
              return GestureDetector(
                onTap: () {
                  onQuickLogin!(list[index]);
                },
                child: _buildItem(list[index],index),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onBackLogin,
            child: const Text(
              'Đăng nhập bằng tài khoản khác',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: AppColor.BLUE_TEXT),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onRegister,
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
                'Đăng ký tài khoản mới',
                style: TextStyle(fontSize: 15, color: AppColor.BLUE_TEXT),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildItem(InfoUserDTO dto,int index) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: AppColor.WHITE),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/ic-avatar.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dto.fullName,
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
                )
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                onRemoveAccount!(index);
              },
              child: Image.asset(
                'assets/images/ic-remove-account.png',
                width: 30,
                height: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
