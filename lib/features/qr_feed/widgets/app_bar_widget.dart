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

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Widget widget;
  final bool isExpanded;
  const CustomSliverAppBarDelegate({
    required this.expandedHeight,
    required this.widget,
    required this.isExpanded,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;
    return Material(
      color: AppColor.WHITE,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: widget,
            ),
          ),
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

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

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
              widget
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

  Widget buildFloating(double shrinkOffset) => AnimatedOpacity(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 150),
        opacity: appear(shrinkOffset),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
          height: 142,
          child: widget,
        ),
      );
  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 112;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
