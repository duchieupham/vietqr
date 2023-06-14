// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_card/states/bank_card_state.dart';
import 'package:vierqr/features/bank_card/views/bank_card_select_view.dart';
import 'package:vierqr/features/home/dashboard.dart';
import 'package:vierqr/features/home/widgets/disconnect_widget.dart';
import 'package:vierqr/features/home/widgets/maintain_widget.dart';
import 'package:vierqr/features/introduce/views/introduce_screen.dart';
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features/notification/events/notification_event.dart';
import 'package:vierqr/features/notification/states/notification_state.dart';
import 'package:vierqr/features/permission/blocs/permission_bloc.dart';
import 'package:vierqr/features/permission/events/permission_event.dart';
import 'package:vierqr/features/permission/states/permission_state.dart';
import 'package:vierqr/features/personal/views/user_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/features/scan_qr/views/qr_scan_view.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/features/token/blocs/token_bloc.dart';
import 'package:vierqr/features/token/events/token_event.dart';
import 'package:vierqr/features/token/states/token_state.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/services/providers/account_balance_home_provider.dart';
import 'package:vierqr/services/providers/bank_card_select_provider.dart';
import 'package:vierqr/services/providers/page_select_provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/shared_references/qr_scanner_helper.dart';
import 'dart:ui';

import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'widgets/custom_app_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  //page controller
  late PageController _pageController;

  //list page
  final List<Widget> _homeScreens = [];

  //focus node
  final FocusNode focusNode = FocusNode();

  //blocs
  late PermissionBloc _permissionBloc;
  late TokenBloc _tokenBloc;
  late NotificationBloc _notificationBloc;

  //notification count
  int _notificationCount = 0;

  //providers
  final AccountBalanceHomeProvider accountBalanceHomeProvider =
      AccountBalanceHomeProvider('');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _permissionBloc = BlocProvider.of(context);
    _tokenBloc = BlocProvider.of(context);
    _notificationBloc = BlocProvider.of(context);
    String userId = UserInformationHelper.instance.getUserId();
    initialServices(context, userId);
    _pageController = PageController(
      initialPage:
          Provider.of<PageSelectProvider>(context, listen: false).indexSelected,
      keepPage: true,
    );
    listenNewNotification(userId);
  }

  void initialServices(BuildContext context, String userId) {
    checkUserInformation();
    _tokenBloc.add(const TokenEventCheckValid());
    _permissionBloc.add(const PermissionEventRequest());
    _notificationBloc.add(NotificationGetCounterEvent(userId: userId));
    _homeScreens.addAll(
      [
        const BankCardSelectView(key: PageStorageKey('QR_GENERATOR_PAGE')),
        const IntroduceScreen(),
        const SizedBox(),
        const DashboardView(key: PageStorageKey('SMS_LIST_PAGE')),
        UserSetting(
          key: const PageStorageKey('USER_SETTING_PAGE'),
          voidCallback: () {
            _animatedToPage(0);
          },
        ),
      ],
    );
  }

  void listenNewNotification(String userId) {
    notificationController.listen((isNotificationPushed) {
      if (isNotificationPushed) {
        notificationController.sink.add(false);
        Future.delayed(const Duration(milliseconds: 1000), () {
          _notificationBloc.add(NotificationGetCounterEvent(userId: userId));
        });
      }
    });
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
    if (!isFromLogin) {
      _tokenBloc.add(const TokenFcmUpdateEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double height = MediaQuery.of(context).size.height;
    bool isFromLogin = false;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final arg = ModalRoute.of(context)!.settings.arguments as Map;
      isFromLogin = arg['isFromLogin'] ?? false;
    }

    return BlocListener<TokenBloc, TokenState>(
      listener: (context, state) {
        if (state is TokenValidState) {
          _updateFcmToken(isFromLogin);
        }
        if (state is SystemMaintainState) {
          DialogWidget.instance.showFullModalBottomContent(
            isDissmiss: false,
            widget: MaintainWidget(
              tokenBloc: _tokenBloc,
            ),
          );
        }
        if (state is SystemConnectionFailedState) {
          DialogWidget.instance.showFullModalBottomContent(
            isDissmiss: false,
            widget: DisconnectWidget(
              tokenBloc: _tokenBloc,
            ),
          );
        }
        if (state is TokenExpiredState) {
          DialogWidget.instance.openMsgDialog(
              title: 'Phiên đăng nhập hết hạn',
              msg: 'Vui lòng đăng nhập lại ứng dụng',
              function: () {
                Navigator.pop(context);
                _tokenBloc.add(TokenEventLogout());
              });
        }
        if (state is TokenExpiredLogoutState) {
          Navigator.of(context).pushReplacementNamed(Routes.LOGIN);
        }
        if (state is TokenLogoutFailedState) {
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể đăng xuất',
            msg: 'Vui lòng thử lại sau.',
          );
        }
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
        child: BlocBuilder<BankCardBloc, BankCardState>(
          builder: (context, state) {
            if (state is BankCardGetListSuccessState) {
              Future.delayed(const Duration(milliseconds: 0), () {
                Provider.of<BankCardSelectProvider>(context, listen: false)
                    .updateTotalBanks(state.list.length);
                Provider.of<BankCardSelectProvider>(context, listen: false)
                    .updateBanks(state.list);
                Provider.of<BankCardSelectProvider>(context, listen: false)
                    .updateColors(state.colors);
              });
            }
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: CustomAppBarWidget(
                child: _buildAppBar(),
              ),
              body: Stack(
                children: [
                  Listener(
                    onPointerMove: (moveEvent) {
                      if (moveEvent.delta.dx > 0) {
                        Provider.of<PageSelectProvider>(context, listen: false)
                            .updateMoveEvent(TypeMoveEvent.RIGHT);
                      } else {
                        Provider.of<PageSelectProvider>(context, listen: false)
                            .updateMoveEvent(TypeMoveEvent.LEFT);
                      }
                    },
                    child: Consumer<PageSelectProvider>(
                        builder: (context, page, child) {
                      return PageView(
                        key: const PageStorageKey('PAGE_VIEW'),
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (index) async {
                          if (index == 2) {
                            if (QRScannerHelper.instance.getQrIntro()) {
                              await Navigator.pushNamed(
                                context,
                                Routes.SCAN_QR_VIEW,
                              );
                            } else {
                              await DialogWidget.instance
                                  .showFullModalBottomContent(
                                widget: const QRScanWidget(),
                                color: DefaultTheme.BLACK,
                              );
                              await Navigator.pushNamed(
                                  context, Routes.SCAN_QR_VIEW);
                            }

                            if (page.moveEvent == TypeMoveEvent.RIGHT) {
                              _animatedToPage(index + 1);
                              Provider.of<PageSelectProvider>(context,
                                      listen: false)
                                  .updateIndex(index + 1);
                            } else {
                              _animatedToPage(index - 1);
                              Provider.of<PageSelectProvider>(context,
                                      listen: false)
                                  .updateIndex(index - 1);
                            }
                          } else {
                            Provider.of<PageSelectProvider>(context,
                                    listen: false)
                                .updateIndex(index);
                          }
                        },
                        children: _homeScreens,
                      );
                    }),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: (PlatformUtils.instance.isAndroidApp())
                          ? const EdgeInsets.only(bottom: 5)
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                              child: Container(
                                alignment: Alignment.center,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: DefaultTheme.GREY_VIEW
                                          .withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Consumer<PageSelectProvider>(
                                      builder: (context, provider, child) {
                                        return Row(
                                          children: List.generate(
                                              provider.listItem.length,
                                              (index) {
                                            var item = provider.listItem
                                                .elementAt(index);

                                            String url = (index ==
                                                    provider.indexSelected)
                                                ? item.assetsActive
                                                : item.assetsUnActive;

                                            return _buildShortcut(
                                                index, url, context);
                                          }).toList(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //build shorcuts in bottom bar
  Widget _buildShortcut(int index, String url, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (index != 2) {
          _animatedToPage(index);
        } else {
          if (QRScannerHelper.instance.getQrIntro()) {
            Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
          } else {
            DialogWidget.instance.showFullModalBottomContent(
              widget: const QRScanWidget(),
              color: DefaultTheme.BLACK,
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: (index == 2)
              ? DefaultTheme.PURPLE_NEON.withOpacity(0.8)
              : DefaultTheme.TRANSPARENT,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          url,
          width: 35,
          height: 35,
        ),
      ),
    );
  }

  //navigate to page
  void _animatedToPage(int index) {
    try {
      _pageController.jumpToPage(
        index,
        // duration: const Duration(milliseconds: 200),
        // curve: Curves.easeInOutQuart,
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

  //get title page
  Widget _getTitlePaqe(BuildContext context, int indexSelected) {
    Widget titleWidget = const SizedBox();
    if (indexSelected == 0) {
      titleWidget =
          Consumer<BankCardSelectProvider>(builder: (context, provider, child) {
        return RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).hintColor,
              letterSpacing: 0.2,
            ),
            children: [
              const TextSpan(
                text: 'TK ngân hàng',
                style: TextStyle(
                  fontFamily: 'NewYork',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              if (provider.totalBanks != 0) ...[
                WidgetSpan(
                  child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: DefaultTheme.PURPLE_NEON.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      provider.totalBanks.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ]

              // TextSpan(
              //   text: '\n${provider.totalBanks} TK ngân hàng được thêm',
              //   style: const TextStyle(
              //     fontSize: 12,
              //     fontWeight: FontWeight.normal,
              //     color: DefaultTheme.PURPLE_NEON,
              //   ),
              // ),
            ],
          ),
        );
      });
    }

    if (indexSelected == 1) {
      titleWidget = const Text(
        'Mở tài khoản MB',
        style: TextStyle(
          fontFamily: 'NewYork',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      );
    }
    if (indexSelected == 2) {
      titleWidget = RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor,
            letterSpacing: 0.2,
          ),
          children: const [
            TextSpan(
              text: 'VietQR',
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
      /* title =
          '${TimeUtils.instance.getCurrentDateInWeek()}\n${TimeUtils.instance.getCurentDate()}';*/
    }
    if (indexSelected == 3) {
      titleWidget = RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            fontSize: 18,
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
                fontSize: 12,
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
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      );
    }
    return titleWidget;
  }

  @override
  bool get wantKeepAlive => true;

//header
  Widget _buildAppBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 25,
            sigmaY: 25,
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 10, top: 0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Consumer<PageSelectProvider>(
                  builder: (context, page, child) {
                    return _getTitlePaqe(context, page.indexSelected);
                  },
                ),
                const Spacer(),
                ButtonIconWidget(
                  width: 35,
                  height: 35,
                  borderRadius: 40,
                  icon: Icons.search_rounded,
                  title: '',
                  function: () {
                    Navigator.pushNamed(context, Routes.SEARCH_BANK);
                  },
                  bgColor: Theme.of(context).cardColor.withOpacity(0.3),
                  textColor: Theme.of(context).hintColor,
                ),
                const Padding(padding: EdgeInsets.only(left: 5)),
                SizedBox(
                    width: 50,
                    height: 60,
                    child: BlocConsumer<NotificationBloc, NotificationState>(
                      listener: (context, state) {
                        //
                      },
                      builder: (context, state) {
                        if (state is NotificationCountSuccessState) {
                          _notificationCount = state.count;
                        }
                        if (state is NotificationUpdateStatusSuccessState) {
                          _notificationCount = 0;
                        }
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            ButtonIconWidget(
                              width: 35,
                              height: 35,
                              borderRadius: 40,
                              icon: Icons.notifications_outlined,
                              title: '',
                              function: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.NOTIFICATION_VIEW,
                                  arguments: {
                                    'notificationBloc': _notificationBloc,
                                  },
                                ).then((value) {
                                  _notificationBloc.add(
                                    NotificationUpdateStatusEvent(
                                      userId: UserInformationHelper.instance
                                          .getUserId(),
                                    ),
                                  );
                                });
                              },
                              bgColor:
                                  Theme.of(context).cardColor.withOpacity(0.3),
                              textColor: Theme.of(context).hintColor,
                            ),
                            if (_notificationCount != 0)
                              Positioned(
                                top: 5,
                                right: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: DefaultTheme.RED_CALENDAR,
                                  ),
                                  child: Text(
                                    _notificationCount.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: (_notificationCount
                                                  .toString()
                                                  .length >=
                                              3)
                                          ? 8
                                          : 10,
                                      color: DefaultTheme.WHITE,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    )),
                const Padding(padding: EdgeInsets.only(left: 5)),
                Container(
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                    //color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/images/ic-viet-qr.png',
                    width: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
