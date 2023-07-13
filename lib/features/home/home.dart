import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/widgets/ambient_avatar_widget.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_card/bank_screen.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/home/states/home_state.dart';
import 'package:vierqr/features/home/widgets/disconnect_widget.dart';
import 'package:vierqr/features/home/widgets/maintain_widget.dart';
import 'package:vierqr/features/introduce/views/introduce_screen.dart';
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features/notification/events/notification_event.dart';
import 'package:vierqr/features/notification/states/notification_state.dart';
import 'package:vierqr/features/personal/views/user_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/features/token/blocs/token_bloc.dart';
import 'package:vierqr/features/token/events/token_event.dart';
import 'package:vierqr/features/token/states/token_state.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/services/providers/account_balance_home_provider.dart';
import 'package:vierqr/services/providers/avatar_provider.dart';
import 'package:vierqr/services/providers/bank_card_select_provider.dart';
import 'package:vierqr/services/providers/page_select_provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/shared_references/qr_scanner_helper.dart';
import 'dart:ui';

import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'blocs/home_bloc.dart';
import 'events/home_event.dart';

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
  late HomeBloc _homeBloc;
  late TokenBloc _tokenBloc;
  late NotificationBloc _notificationBloc;

  //notification count
  int _notificationCount = 0;

  NationalScannerDTO? identityDTO;

  //providers
  final AccountBalanceHomeProvider accountBalanceHomeProvider =
      AccountBalanceHomeProvider('');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _homeBloc = BlocProvider.of(context);
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

  Future<void> startBarcodeScanStream() async {
    String data = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR);
    if (data.isNotEmpty) {
      if (data == TypeQR.NEGATIVE_ONE.value) {
      } else if (data == TypeQR.NEGATIVE_TWO.value) {
        DialogWidget.instance.openMsgDialog(
          title: 'Không thể xác nhận mã QR',
          msg: 'Ảnh QR không đúng định dạng, vui lòng chọn ảnh khác.',
          function: () {
            Navigator.pop(context);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      } else {
        if (data.contains('|')) {
          final list = data.split("|");
          if (list.isNotEmpty) {
            identityDTO = NationalScannerDTO.fromJson(list);
            if (!mounted) return;
            Navigator.pushNamed(
              context,
              Routes.NATIONAL_INFORMATION,
              arguments: {'dto': identityDTO},
            );
          }
        } else {
          _homeBloc.add(ScanQrEventGetBankType(code: data));
        }
      }
    }
  }

  void initialServices(BuildContext context, String userId) {
    checkUserInformation();
    _tokenBloc.add(const TokenEventCheckValid());
    _homeBloc.add(const PermissionEventRequest());
    _notificationBloc.add(NotificationGetCounterEvent(userId: userId));
    _homeScreens.addAll(
      [
        // const BankCardSelectView(key: PageStorageKey('QR_GENERATOR_PAGE')),
        const BankScreen(key: PageStorageKey('QR_GENERATOR_PAGE')),
        const DashboardScreen(key: PageStorageKey('SMS_LIST_PAGE')),
        if (PlatformUtils.instance.isAndroidApp()) const IntroduceScreen(),
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
        _homeBloc.add(const PermissionEventGetStatus());
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
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.type == TypePermission.Request) {
            _homeBloc.add(const PermissionEventGetStatus());
          }
          if (state.type == TypePermission.CameraDenied) {
            Future.delayed(const Duration(milliseconds: 0), () {
              Provider.of<SuggestionWidgetProvider>(context, listen: false)
                  .updateCameraSuggestion(true);
            });
          }
          if (state.type == TypePermission.CameraAllow) {
            Future.delayed(const Duration(milliseconds: 0), () {
              Provider.of<SuggestionWidgetProvider>(context, listen: false)
                  .updateCameraSuggestion(false);
            });
          }
          if (state.type == TypePermission.Allow) {
            Future.delayed(const Duration(milliseconds: 0), () {
              Provider.of<SuggestionWidgetProvider>(context, listen: false)
                  .updateCameraSuggestion(false);
            });
          }

          if (state.type == TypePermission.ScanNotFound) {
            DialogWidget.instance.openMsgDialog(
              title: 'Không thể xác nhận mã QR',
              msg:
                  'Không tìm thấy thông tin trong đoạn mã QR. Vui lòng kiểm tra lại thông tin.',
              function: () {
                Navigator.pop(context);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            );
          }
          if (state.type == TypePermission.ScanError) {
            DialogWidget.instance.openMsgDialog(
              title: 'Không tìm thấy thông tin',
              msg:
                  'Không tìm thấy thông tin ngân hàng tương ứng. Vui lòng thử lại sau.',
              function: () {
                Navigator.pop(context);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            );
          }
          if (state.type == TypePermission.ScanSuccess) {
            Navigator.pushNamed(
              context,
              Routes.ADD_BANK_CARD,
              arguments: {
                'step': 0,
                'bankDTO': state.bankTypeDTO,
                'bankAccount': state.bankAccount,
                'name': ''
              },
            );
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              _buildAppBar(),
              Consumer<PageSelectProvider>(builder: (context, page, child) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 120),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 120,
                        child: Listener(
                          onPointerMove: (moveEvent) {
                            if (moveEvent.delta.dx > 0) {
                              Provider.of<PageSelectProvider>(context,
                                      listen: false)
                                  .updateMoveEvent(TypeMoveEvent.RIGHT);
                            } else {
                              Provider.of<PageSelectProvider>(context,
                                      listen: false)
                                  .updateMoveEvent(TypeMoveEvent.LEFT);
                            }
                          },
                          child: PageView(
                            key: const PageStorageKey('PAGE_VIEW'),
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _pageController,
                            onPageChanged: (index) async {
                              Provider.of<PageSelectProvider>(context,
                                      listen: false)
                                  .updateIndex(index);
                            },
                            children: _homeScreens,
                          ),
                        ),
                      ),
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
                                filter:
                                    ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            AppColor.GREY_VIEW.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: List.generate(
                                            page.listItem.length, (index) {
                                          var item =
                                              page.listItem.elementAt(index);

                                          String url =
                                              (item.index == page.indexSelected)
                                                  ? item.assetsActive
                                                  : item.assetsUnActive;

                                          return _buildShortcut(
                                              item.index, url, context);
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  //build shorcuts in bottom bar
  Widget _buildShortcut(int index, String url, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (index != -1) {
          _animatedToPage(index);
        } else {
          if (QRScannerHelper.instance.getQrIntro()) {
            startBarcodeScanStream();
            // Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
          } else {
            await DialogWidget.instance.showFullModalBottomContent(
              widget: const QRScanWidget(),
              color: AppColor.BLACK,
            );
            startBarcodeScanStream();
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: (index == -1)
              ? AppColor.PURPLE_NEON.withOpacity(0.8)
              : AppColor.TRANSPARENT,
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
        return ButtonIconWidget(
          width: double.infinity,
          height: 40,
          borderRadius: 40,
          icon: Icons.search_rounded,
          iconSize: 18,
          contentPadding: const EdgeInsets.only(left: 16),
          alignment: Alignment.centerLeft,
          title: 'Tài khoản ngân hàng',
          textSize: 11,
          function: () {
            Navigator.pushNamed(context, Routes.SEARCH_BANK);
          },
          bgColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).hintColor,
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
                color: AppColor.GREY_TEXT,
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
    double paddingTop = MediaQuery.of(context).viewPadding.top;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 230,
      padding: EdgeInsets.only(top: paddingTop + 12),
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bgr-header.png'),
              fit: BoxFit.fitWidth)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
            Expanded(
              child: Consumer<PageSelectProvider>(
                builder: (context, page, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _getTitlePaqe(context, page.indexSelected),
                  );
                },
              ),
            ),
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
                          width: 45,
                          height: 45,
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
                          bgColor: Theme.of(context).cardColor,
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
                                color: AppColor.RED_CALENDAR,
                              ),
                              child: Text(
                                _notificationCount.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:
                                      (_notificationCount.toString().length >=
                                              3)
                                          ? 8
                                          : 10,
                                  color: AppColor.WHITE,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                )),
            const Padding(padding: EdgeInsets.only(left: 5)),
            GestureDetector(
                onTap: () {
                  Provider.of<PageSelectProvider>(context, listen: false)
                      .updateIndex(4);

                  _animatedToPage(4);
                },
                child: _buildAvatarWidget(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWidget(BuildContext context) {
    double size = 45;
    String imgId = UserInformationHelper.instance.getAccountInformation().imgId;
    return Consumer<AvatarProvider>(
      builder: (context, provider, child) => (imgId.isEmpty)
          ? ClipOval(
              child: SizedBox(
                width: size,
                height: size,
                child: Image.asset('assets/images/ic-avatar.png'),
              ),
            )
          : AmbientAvatarWidget(
              imgId: imgId,
              size: size,
              onlyImage: true,
            ),
    );
  }
}
