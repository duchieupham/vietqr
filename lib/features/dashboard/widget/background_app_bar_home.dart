import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/account/account_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/features/dashboard/widget/maintain_widget.dart';
import 'package:vierqr/features/notification/notification_screen.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../maintain_charge/maintain_charge_screen.dart';

class BackgroundAppBarHome extends StatefulWidget {
  const BackgroundAppBarHome({super.key});

  @override
  State<BackgroundAppBarHome> createState() => _BackgroundAppBarHomeState();
}

class _BackgroundAppBarHomeState extends State<BackgroundAppBarHome> {
  bool isSearch = false;

  void _onNotification() async {
    context.read<DashBoardBloc>().add(NotifyUpdateStatusEvent());
    NavigatorUtils.navigatePage(context, NotificationScreen(),
        routeName: NotificationScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).viewPadding.top;
    double width = MediaQuery.of(context).size.width;
    return Consumer<AuthProvider>(
      builder: (context, page, child) {
        File file = page.bannerApp;
        return Container(
          height: 230,
          width: width,
          padding: EdgeInsets.only(top: paddingTop + 12),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              image: file.path.isNotEmpty
                  ? DecorationImage(
                      image: FileImage(file), fit: BoxFit.fitWidth)
                  : DecorationImage(
                      image: AssetImage('assets/images/bgr-header.png'),
                      fit: BoxFit.fitWidth)),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  width: width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor,
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.1),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        tileMode: TileMode.clamp),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildAvatar(page),
                    const SizedBox(width: 12),
                    _buildNotification(),
                    const SizedBox(width: 12),
                    _getSearchPage(context, page.pageSelected),
                    const Spacer(),
                    page.logoApp.path.isEmpty
                        ? Container(
                            width: 96,
                            height: 56,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: CachedNetworkImage(
                                imageUrl: page.settingDTO.logoUrl))
                        : Image.file(
                            page.logoApp,
                            width: 96,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //get title page
  Widget _getSearchPage(BuildContext context, int indexSelected) {
    Widget titleWidget = const SizedBox();
    if (indexSelected != PageType.SCAN_QR.pageIndex) {
      titleWidget = GestureDetector(
        onTap: () => Navigator.pushNamed(context, Routes.SEARCH_BANK),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: AppColor.WHITE,
          ),
          child: Icon(Icons.search, size: 20),
        ),
      );
    }

    return titleWidget;
  }

  Widget _buildNotification() {
    return BlocBuilder<DashBoardBloc, DashBoardState>(
        builder: (context, state) {
      int lengthNotify = state.countNotify.toString().length;
      return SizedBox(
        width: 40,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
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
                child: Icon(Icons.notifications_outlined, size: 20),
              ),
            ),
            if (state.countNotify != 0)
              Positioned(
                top: 0,
                right: 0,
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
        ),
      );
    });
  }

  _buildAvatar(AuthProvider provider) {
    String imgId = SharePrefUtils.getProfile().imgId;
    return GestureDetector(
      onTap: () => NavigatorUtils.navigatePage(context, AccountScreen(),
          routeName: AccountScreen.routeName),
      child: Container(
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
  }
}
