import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/account/account_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  const CustomSliverAppBarDelegate({
    required this.expandedHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        buildBackground(shrinkOffset),
        buildFloating(shrinkOffset, true),
        Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: buildFloating(shrinkOffset, false)),
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   child: buildFloating(shrinkOffset, true),
        // ),
      ],
    );
    // return Stack(
    //   // fit: StackFit.expand,
    //   children: [
    //     // buildBackground(shrinkOffset),
    //     // Positioned(bottom: 0, child: buildFloating(shrinkOffset))
    //     // buildAppBar(shrinkOffset),
    //     // Positioned(
    //     //   bottom: 0,
    //     //   left: 0,
    //     //   right: 0,
    //     //   child: buildFloating(shrinkOffset),
    //     // ),
    //   ],
    // );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildBackground(double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAvatar(),
              Image.asset(
                AppImages.icLogoVietQr,
                width: 95,
                fit: BoxFit.fitWidth,
              )
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
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: provider.avatarUser.path.isEmpty
                      ? imgId.isNotEmpty
                          ? ImageUtils.instance.getImageNetWork(imgId)
                          : Image.asset('assets/images/ic-avatar.png').image
                      : Image.file(provider.avatarUser).image,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildFloating(double shrinkOffset, bool isAppear) => Opacity(
        opacity: isAppear ? appear(shrinkOffset) : disappear(shrinkOffset),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColor.BLUE_TEXT)),
                ),
              ),
            ],
          ),
        ),
      );
  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
