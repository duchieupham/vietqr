import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/extensions/string_extension.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/account/account_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class BankCardDetailAppBar extends SliverPersistentHeaderDelegate {
  const BankCardDetailAppBar();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;
    return Material(
      color: AppColor.TRANSPARENT,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 270,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: AppColor.WHITE.withOpacity(0.6),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            // bottom: 0,
            child: Opacity(
              opacity: disappear(shrinkOffset),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    height: 400,
                    decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(5, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ],
              ),
            ),
          )
          // !isExpanded
          //     ? Positioned(
          //         top: 0,
          //         left: 0,
          //         right: 0,
          //         child: buildBackground(shrinkOffset),
          //       )
          //     : const SizedBox.shrink(),
          // buildFloating(shrinkOffset),
        ],
      ),
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / 430;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / 430;

  Widget buildBackground(double shrinkOffset) => AnimatedOpacity(
        curve: Curves.easeInOut,
        opacity: disappear(shrinkOffset),
        duration: const Duration(milliseconds: 150),
        child: Container(
          // alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAvatar(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Image.asset(
                      AppImages.icLogoVietQr,
                      width: 95,
                      fit: BoxFit.fitWidth,
                    ),
                  )
                ],
              ),
              // widget
            ],
          ),
        ),
      );

  Widget _buildAvatar() {
    String imgId = SharePrefUtils.getProfile().imgId;
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
            onTap: () => NavigatorUtils.navigatePage(
                context, const AccountScreen(),
                routeName: AccountScreen.routeName),
            child: SizedBox(
              width: 40,
              height: 40,
              child: XImage(
                borderRadius: BorderRadius.circular(100),
                imagePath: provider.avatarUser.path.isEmpty
                    ? imgId.isNotEmpty
                        ? imgId.getPathIMageNetwork
                        : ImageConstant.icAvatar
                    : provider.avatarUser.path,
                errorWidget: XImage(
                  borderRadius: BorderRadius.circular(100),
                  imagePath: ImageConstant.icAvatar,
                  width: 40,
                  height: 40,
                ),
              ),
            ));
      },
    );
  }

  // Widget buildFloating(double shrinkOffset) => AnimatedOpacity(
  //       curve: Curves.easeInOut,
  //       duration: const Duration(milliseconds: 150),
  //       opacity: appear(shrinkOffset),
  //       child: Container(
  //         padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
  //         height: 142,
  //         child: widget,
  //       ),
  //     );
  @override
  double get maxExtent => 420;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
