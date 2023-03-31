// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/features/bank_card/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
import 'package:vierqr/features/bank_card/views/bank_card_select_view.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/generate_qr/views/qr_information_view.dart';
import 'package:vierqr/features/home/dashboard.dart';
import 'package:vierqr/features/permission/blocs/permission_bloc.dart';
import 'package:vierqr/features/permission/events/permission_event.dart';
import 'package:vierqr/features/permission/states/permission_state.dart';
import 'package:vierqr/features/personal/views/user_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/features/token/blocs/token_bloc.dart';
import 'package:vierqr/features/token/events/token_event.dart';
import 'package:vierqr/features/token/states/token_state.dart';
import 'package:vierqr/services/providers/account_balance_home_provider.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/services/providers/page_select_provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/services/providers/register_provider.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';
import 'package:vierqr/services/shared_references/event_bloc_helper.dart';
import 'dart:ui';

import 'package:vierqr/services/shared_references/user_information_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> with WidgetsBindingObserver {
  //page controller
  static late PageController _pageController;

  //list page
  final List<Widget> _homeScreens = [];

  //focus node
  final FocusNode focusNode = FocusNode();

  //blocs

  late PermissionBloc _permissionBloc;
  late TokenBloc _tokenBloc;
  late BusinessInformationBloc _businessInformationBloc;
  late BankCardBloc _bankCardBloc;

  //providers
  final AccountBalanceHomeProvider accountBalanceHomeProvider =
      AccountBalanceHomeProvider('');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _permissionBloc = BlocProvider.of(context);
    _tokenBloc = BlocProvider.of(context);
    _businessInformationBloc = BlocProvider.of(context);
    _bankCardBloc = BlocProvider.of(context);
    String userId = UserInformationHelper.instance.getUserId();
    initialServices(context, userId);
    _pageController = PageController(
      initialPage:
          Provider.of<PageSelectProvider>(context, listen: false).indexSelected,
      keepPage: true,
    );
  }

  void initialServices(BuildContext context, String userId) {
    checkUserInformation();
    _permissionBloc.add(const PermissionEventRequest());
    _bankCardBloc.add(BankCardEventGetList(userId: userId));
    _homeScreens.addAll([
      BankCardSelectView(
        key: const PageStorageKey('QR_GENERATOR_PAGE'),
        bankCardBloc: _bankCardBloc,
      ),
      QRInformationView(
        key: const PageStorageKey('QR_GENERATOR_PAGE'),
        businessInformationBloc: _businessInformationBloc,
        bankCardBloc: _bankCardBloc,
      ),
      const SizedBox(),
      DashboardView(
        key: const PageStorageKey('SMS_LIST_PAGE'),
        businessInformationBloc: _businessInformationBloc,
      ),
      const UserSetting(
        key: PageStorageKey('USER_SETTING_PAGE'),
      ),
    ]);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!PlatformUtils.instance.isWeb()) {
        _permissionBloc.add(const PermissionEventGetStatus());
      }
    }
  }

  @override
  void dispose() {
    // _notificationBloc.close();
    // _bankManageBloc.close();
    // _transactionBloc.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //check user information is updated before or not
  void checkUserInformation() {
    String firstName =
        UserInformationHelper.instance.getAccountInformation().firstName;
    if (firstName != 'Undefined') {
      Future.delayed(const Duration(milliseconds: 0), () {
        Provider.of<SuggestionWidgetProvider>(context, listen: false)
            .updateUserUpdating(false);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 0), () {
        Provider.of<SuggestionWidgetProvider>(context, listen: false)
            .updateUserUpdating(true);
      });
    }
  }

  void _updateFcmToken(bool isFromLogin) {
    // LOG.info('FROM LOGIN: $isFromLogin');
    if (!isFromLogin) {
      _tokenBloc.add(const TokenFcmUpdateEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFromLogin = false;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final arg = ModalRoute.of(context)!.settings.arguments as Map;
      isFromLogin = arg['isFromLogin'] ?? false;
    }
    _updateFcmToken(isFromLogin);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: BlocListener<TokenBloc, TokenState>(
        listener: (context, state) {
          if (state is TokenFcmUpdateSuccessState) {
            LOG.info('Update FCM Token success');
          }
          // if (state is TokenInvalidState) {
          //   DialogWidget.instance.openMsgDialog(
          //     title: 'Phiên đã hết hạn',
          //     msg: 'Phiên đăng nhập hết hạn\nVui lòng đăng nhập lại.',
          //     function: () async {
          //       Navigator.pop(context);
          //       await _resetAll(context).then(
          //         (value) =>
          //             Navigator.of(context).pushReplacementNamed(Routes.LOGIN),
          //       );
          //     },
          //   );
          // }
        },
        child: BlocListener<PermissionBloc, PermissionState>(
          listener: (context, state) {
            if (state is PermissionDeniedRequestState) {
              _permissionBloc.add(const PermissionEventGetStatus());
            }
            if (state is PermissionCameraDeniedState) {
              Future.delayed(const Duration(milliseconds: 0), () {
                Provider.of<SuggestionWidgetProvider>(context, listen: false)
                    .updateCameraSuggestion(true);
              });
            }
            if (state is PermissionCameraAllowsedState) {
              Future.delayed(const Duration(milliseconds: 0), () {
                Provider.of<SuggestionWidgetProvider>(context, listen: false)
                    .updateCameraSuggestion(false);
              });
            }
            if (state is PermissionAllowedState) {
              Future.delayed(const Duration(milliseconds: 0), () {
                // Provider.of<SuggestionWidgetProvider>(context, listen: false)
                //     .updateSMSStatus(2);
                Provider.of<SuggestionWidgetProvider>(context, listen: false)
                    .updateCameraSuggestion(false);
              });
            }
          },
          child: Stack(
            children: [
              //body
              PageView(
                key: const PageStorageKey('PAGE_VIEW'),
                allowImplicitScrolling: true,
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  Provider.of<PageSelectProvider>(context, listen: false)
                      .updateIndex(index);
                },
                children: _homeScreens,
              ),
              //header
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 65,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 25,
                      sigmaY: 25,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // const Padding(padding: EdgeInsets.only(left: 10)),
                          Consumer<PageSelectProvider>(
                              builder: (context, page, child) {
                            return _getTitlePaqe(context, page.indexSelected);
                          }),
                          const Spacer(),
                          Container(
                            width: 80,
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'assets/images/ic-viet-qr.png',
                              width: 50,
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {},
                          //   child: SizedBox(
                          //     height: 60,
                          //     width: 40,
                          //     child: Stack(
                          //       children: [
                          //         Center(
                          //             child: Container(
                          //           width: 40,
                          //           height: 40,
                          //           alignment: Alignment.center,
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(20),
                          //             color: Theme.of(context).cardColor,
                          //           ),
                          //           child: const Icon(
                          //             Icons.notifications_rounded,
                          //             color: DefaultTheme.GREY_TEXT,
                          //             size: 20,
                          //           ),
                          //         )),
                          //         // (_notificationCount != 0)
                          //         //     ? Positioned(
                          //         //         bottom: 5,
                          //         //         right: 0,
                          //         //         child: Container(
                          //         //           width: 20,
                          //         //           height: 20,
                          //         //           alignment: Alignment.center,
                          //         //           decoration: BoxDecoration(
                          //         //             color: DefaultTheme.RED_CALENDAR,
                          //         //             borderRadius:
                          //         //                 BorderRadius.circular(20),
                          //         //           ),
                          //         //           child: Text(
                          //         //             _notificationCount.toString(),
                          //         //             textAlign: TextAlign.center,
                          //         //             style: const TextStyle(
                          //         //               color: DefaultTheme.WHITE,
                          //         //               fontSize: 8,
                          //         //             ),
                          //         //           ),
                          //         //         ),
                          //         //       )
                          //         //     : const SizedBox(),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: (PlatformUtils.instance.isAndroidApp(context))
            ? const EdgeInsets.only(bottom: 5)
            : null,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.5),
                boxShadow: [
                  BoxShadow(
                    color: DefaultTheme.GREY_VIEW.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(2, 2),
                  ),
                ],
                // borderRadius: BorderRadius.circular(0),
              ),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Stack(
                children: [
                  Consumer<PageSelectProvider>(
                    builder: (context, page, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _buildShortcut(
                            0,
                            page.indexSelected,
                            context,
                          ),
                          _buildShortcut(
                            1,
                            page.indexSelected,
                            context,
                          ),
                          _buildShortcut(
                            2,
                            page.indexSelected,
                            context,
                          ),
                          _buildShortcut(
                            3,
                            page.indexSelected,
                            context,
                          ),
                          _buildShortcut(
                            4,
                            page.indexSelected,
                            context,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //build shorcuts in bottom bar
  _buildShortcut(int index, int indexSelected, BuildContext context) {
    bool isSelected = (index == indexSelected);
    return InkWell(
      onTap: () {
        _animatedToPage(index);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: (isSelected)
              ? Theme.of(context).toggleableActiveColor
              : DefaultTheme.TRANSPARENT,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Image.asset(
          _getAssetIcon(index, isSelected),
          width: 35,
          height: 35,
        ),
      ),
    );
  }

  //navigate to page
  void _animatedToPage(int index) {
    try {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutQuart,
      );
    } catch (e) {
      _pageController = PageController(
        initialPage: Provider.of<PageSelectProvider>(context, listen: false)
            .indexSelected,
        keepPage: true,
      );
      _animatedToPage(index);
    }
  }

  //get image assets
  String _getAssetIcon(int index, bool isSelected) {
    const String prefix = 'assets/images/';
    String assetImage = (index == 0 && isSelected)
        ? 'ic-card-selected.png'
        : (index == 0 && !isSelected)
            ? 'ic-card-unselect.png'
            : (index == 1 && isSelected)
                ? 'ic-qr.png'
                : (index == 1 && !isSelected)
                    ? 'ic-qr-unselect.png'
                    : (index == 2 && isSelected)
                        ? 'ic-qr-payment-selected.png'
                        : (index == 2 && !isSelected)
                            ? 'ic-qr-payment-unselect.png'
                            : (index == 3 && isSelected)
                                ? 'ic-dashboard.png'
                                : (index == 3 && !isSelected)
                                    ? 'ic-dashboard-unselect.png'
                                    : (index == 4 && isSelected)
                                        ? 'ic-user.png'
                                        : 'ic-user-unselect.png';
    return '$prefix$assetImage';
  }

  //get title page
  Widget _getTitlePaqe(BuildContext context, int indexSelected) {
    Widget titleWidget = const SizedBox();
    if (indexSelected == 0) {
      titleWidget = const Text(
        'TK ngân hàng',
        style: TextStyle(
          fontFamily: 'NewYork',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      );
    }
    if (indexSelected == 1) {
      titleWidget = RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor,
            letterSpacing: 0.2,
          ),
          children: const [
            TextSpan(
              text: 'QR theo tài khoản\n',
            ),
            TextSpan(
              text: 'QR không chứa số tiền và nội dung.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }
    if (indexSelected == 2) {
      titleWidget = RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor,
            letterSpacing: 0.2,
          ),
          children: const [
            TextSpan(
              text: 'Thanh toán VietQR',
            ),
            // TextSpan(
            //   text: 'QR không chứa số tiền và nội dung.',
            //   style: TextStyle(
            //     fontSize: 15,
            //     fontWeight: FontWeight.normal,
            //   ),
            // ),
          ],
        ),
      );
    }
    if (indexSelected == 3) {
      /* title =
          '${TimeUtils.instance.getCurrentDateInWeek()}\n${TimeUtils.instance.getCurentDate()}';*/
      titleWidget = RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor,
            letterSpacing: 0.2,
          ),
          children: [
            const TextSpan(
              text: 'Trang chủ\n',
            ),
            TextSpan(
              text:
                  '${TimeUtils.instance.getCurrentDateInWeek(DateTime.now())}, ${TimeUtils.instance.getCurentDate(DateTime.now())}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: DefaultTheme.GREY_TEXT,
              ),
            ),
          ],
        ),
      );
    }
    if (indexSelected == 4) {
      titleWidget = const Text(
        'Cá nhân',
        style: TextStyle(
          fontFamily: 'NewYork',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      );
    }
    return titleWidget;
  }
}

Future<void> _resetAll(BuildContext context) async {
  Provider.of<CreateQRProvider>(context, listen: false).reset();
  Provider.of<CreateQRPageSelectProvider>(context, listen: false).reset();
  Provider.of<BankAccountProvider>(context, listen: false).reset();
  Provider.of<UserEditProvider>(context, listen: false).reset();
  Provider.of<RegisterProvider>(context, listen: false).reset();
  Provider.of<SuggestionWidgetProvider>(context, listen: false).reset();
  await EventBlocHelper.instance.updateLogoutBefore(true);
  await UserInformationHelper.instance.initialUserInformationHelper();
  await AccountHelper.instance.setBankToken('');
  await AccountHelper.instance.setToken('');
}
