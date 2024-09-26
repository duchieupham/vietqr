import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/extensions/string_extension.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/account/account_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/features/notification/notification_screen.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class BackgroundAppBarHome extends StatefulWidget {
  const BackgroundAppBarHome({super.key});

  @override
  State<BackgroundAppBarHome> createState() => _BackgroundAppBarHomeState();
}

class _BackgroundAppBarHomeState extends State<BackgroundAppBarHome> {
  final DashBoardBloc _dashBoardBloc = getIt.get<DashBoardBloc>();

  void _onNotification() async {
    _dashBoardBloc.add(NotifyUpdateStatusEvent());
    NavigatorUtils.navigatePage(context, const NotificationScreen(),
        routeName: NotificationScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).viewPadding.top;
    double width = MediaQuery.of(context).size.width;
    return Consumer<AuthenProvider>(
      builder: (context, page, child) {
        File file = page.bannerApp;
        return Container(
          // height: 240,
          width: width,
          // padding: EdgeInsets.only(top: paddingTop + 4),
          // alignment: Alignment.topCenter,
          // decoration: BoxDecoration(
          //   image: file.path.isNotEmpty
          //       ? DecorationImage(
          //           image: FileImage(file),
          //           fit: BoxFit.fitWidth,
          //         )
          //       : const DecorationImage(
          //           image: AssetImage(ImageConstant.bgrHeader),
          //           fit: BoxFit.fitWidth,
          //         ),
          // ),
          // child: Stack(
          //   children: [
          //     ///blur chân của tấm hình
          //     Align(
          //       alignment: Alignment.bottomCenter,
          //       child: Container(
          //         height: 40,
          //         width: width,
          //         decoration: BoxDecoration(
          //           gradient: LinearGradient(
          //               colors: [
          //                 Theme.of(context).scaffoldBackgroundColor,
          //                 Theme.of(context)
          //                     .scaffoldBackgroundColor
          //                     .withOpacity(0.1),
          //               ],
          //               begin: Alignment.bottomCenter,
          //               end: Alignment.topCenter,
          //               tileMode: TileMode.clamp),
          //         ),
          //       ),
          //     ),

          //     ///các tính năng trên thanh appbar
          //     Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 25),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           _buildAvatar(page),
          //           const SizedBox(width: 12),
          //           _buildNotification(),
          //           const SizedBox(width: 12),
          //           _getSearchPage(context, page.pageSelected),
          //           const Spacer(),
          //           SizedBox(
          //             width: 96,
          //             height: 56,
          //             child: XImage(
          //               imagePath: page.logoApp.path.isEmpty
          //                   ? page.settingDTO.logoUrl
          //                   : page.logoApp.path,
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildAvatar(page),
                const SizedBox(width: 12),
                _buildNotification(),
                const SizedBox(width: 12),
                _getSearchPage(context, page.pageSelected),
                const Spacer(),
                const XImage(
                  imagePath: 'assets/images/ic-viet-qr.png',
                  height: 35,
                  // borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //get title page
  Widget _getSearchPage(BuildContext context, int indexSelected) {
    if (indexSelected != PageType.SCAN_QR.pageIndex) {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(context, Routes.SEARCH_BANK),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: AppColor.WHITE,
          ),
          child: const Icon(Icons.search, size: 20),
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildNotification() {
    return BlocBuilder<DashBoardBloc, DashBoardState>(
        bloc: _dashBoardBloc,
        builder: (context, state) {
          int lengthNotify = state.countNotify.toString().length;
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: _onNotification,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColor.WHITE,
                  ),
                  child: const Icon(Icons.notifications_outlined, size: 20),
                ),
              ),
              if (state.countNotify != 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColor.RED_CALENDAR,
                    ),
                    child: Text(
                      state.countNotify.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (lengthNotify >= 3) ? 8 : 10,
                        color: AppColor.WHITE,
                      ),
                    ),
                  ),
                ),
            ],
          );
        });
  }

  Widget _buildAvatar(AuthenProvider provider) {
    String imgId = SharePrefUtils.getProfile().imgId;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => NavigatorUtils.navigatePage(
        context,
        const AccountScreen(),
        routeName: AccountScreen.routeName,
      ),
      child: XImage(
        width: 40,
        height: 40,
        borderRadius: BorderRadius.circular(20),
        imagePath: provider.avatarUser.path.isEmpty
            ? imgId.isNotEmpty
                ? imgId.getPathIMageNetwork
                : ImageConstant.icAvatar
            : provider.avatarUser.path,
        errorWidget: const XImage(
          imagePath: ImageConstant.icAvatar,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
