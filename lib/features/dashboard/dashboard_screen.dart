import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/widgets/ambient_avatar_widget.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/account/account_screen.dart';
import 'package:vierqr/features/bank_card/bank_screen.dart';
import 'package:vierqr/features/business/views/business_screen.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/features/dashboard/widget/background_app_bar_home.dart';
import 'package:vierqr/features/dashboard/widget/disconnect_widget.dart';
import 'package:vierqr/features/dashboard/widget/maintain_widget.dart';
import 'package:vierqr/features/home/home.dart';
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features/notification/events/notification_event.dart';
import 'package:vierqr/features/notification/states/notification_state.dart';
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

import 'events/dashboard_event.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreen();
}

class _DashBoardScreen extends State<DashBoardScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  //page controller
  late PageController _pageController;

  //list page
  final List<Widget> _listScreens = [];

  //focus node
  final FocusNode focusNode = FocusNode();

  //blocs
  late DashBoardBloc _dashBoardBloc;
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
    _dashBoardBloc = BlocProvider.of(context);
    _tokenBloc = BlocProvider.of(context);
    _notificationBloc = BlocProvider.of(context);
    _pageController = PageController(
      initialPage:
          Provider.of<PageSelectProvider>(context, listen: false).indexSelected,
      keepPage: true,
    );
    _listScreens.addAll(
      [
        // const BankCardSelectView(key: PageStorageKey('QR_GENERATOR_PAGE')),
        const BankScreen(key: PageStorageKey('QR_GENERATOR_PAGE')),
        const HomeScreen(key: PageStorageKey('HOME_PAGE')),
        const BusinessScreen(key: PageStorageKey('SMS_LIST_PAGE')),
        // if (PlatformUtils.instance.isAndroidApp()) const IntroduceScreen(),
        AccountScreen(
          key: const PageStorageKey('USER_SETTING_PAGE'),
          voidCallback: () {
            _animatedToPage(0);
          },
        ),
      ],
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialServices(context);
      listenNewNotification();
    });
  }

  Future<void> startBarcodeScanStream() async {
    String data = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
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
          _dashBoardBloc.add(ScanQrEventGetBankType(code: data));
        }
      }
    }
  }

  void initialServices(BuildContext context) {
    checkUserInformation();
    _tokenBloc.add(const TokenEventCheckValid());
    _dashBoardBloc.add(const PermissionEventRequest());
    _notificationBloc.add(NotificationGetCounterEvent());
  }

  void listenNewNotification() {
    notificationController.listen((isNotificationPushed) {
      if (isNotificationPushed) {
        notificationController.sink.add(false);
        Future.delayed(const Duration(milliseconds: 1000), () {
          _notificationBloc.add(NotificationGetCounterEvent());
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!PlatformUtils.instance.isWeb()) {
        _dashBoardBloc.add(const PermissionEventGetStatus());
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
      child: BlocListener<DashBoardBloc, DashBoardState>(
        listener: (context, state) {
          if (state.typePermission == DashBoardTypePermission.Request) {
            _dashBoardBloc.add(const PermissionEventGetStatus());
          }
          if (state.typePermission == DashBoardTypePermission.CameraDenied) {
            Future.delayed(const Duration(milliseconds: 0), () {
              Provider.of<SuggestionWidgetProvider>(context, listen: false)
                  .updateCameraSuggestion(true);
            });
          }
          if (state.typePermission == DashBoardTypePermission.CameraAllow) {
            Future.delayed(const Duration(milliseconds: 0), () {
              Provider.of<SuggestionWidgetProvider>(context, listen: false)
                  .updateCameraSuggestion(false);
            });
          }
          if (state.typePermission == DashBoardTypePermission.Allow) {
            Future.delayed(const Duration(milliseconds: 0), () {
              Provider.of<SuggestionWidgetProvider>(context, listen: false)
                  .updateCameraSuggestion(false);
            });
          }

          if (state.request == DashBoardType.SCAN_NOT_FOUND) {
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
          if (state.request == DashBoardType.SCAN_ERROR) {
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
          if (state.request == DashBoardType.SCAN) {
            if (state.typeQR == TypeQR.QR_BANK) {
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
            } else if (state.typeQR == TypeQR.QR_BARCODE) {
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
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              _buildAppBar(),
              Column(
                children: [
                  Expanded(
                    child: Consumer<PageSelectProvider>(
                        builder: (context, page, child) {
                      return Padding(
                        padding: (page.indexSelected == 3)
                            ? EdgeInsets.zero
                            : const EdgeInsets.only(top: 110),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
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
                              children: _listScreens,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar:
              Consumer<PageSelectProvider>(builder: (context, page, child) {
            return Container(
              decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(color: AppColor.GREY_TOP_TAB_BAR)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  page.listItem.length,
                  (index) {
                    var item = page.listItem.elementAt(index);

                    String url = (item.index == page.indexSelected)
                        ? item.assetsActive
                        : item.assetsUnActive;

                    return _buildShortcut(
                      index: item.index,
                      url: url,
                      label: item.label,
                      context: context,
                      select: item.index == page.indexSelected,
                    );
                  },
                ).toList(),
              ),
            );
          }),
        ),
      ),
    );
  }

  //build shorcuts in bottom bar
  Widget _buildShortcut({
    required int index,
    required String url,
    required String label,
    bool select = false,
    required BuildContext context,
  }) {
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
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 80,
        decoration: BoxDecoration(
          color: AppColor.TRANSPARENT,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              url,
              width: 42,
              height: 36,
              fit: BoxFit.cover,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: select ? AppColor.BLUE_TEXT : AppColor.BLACK,
              ),
            ),
          ],
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
    if (indexSelected == 0 || indexSelected == 1) {
      titleWidget = Consumer<BankCardSelectProvider>(
        builder: (context, provider, child) {
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
        },
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
          ],
        ),
      );
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
    return BackgroundAppBarHome(
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
                          width: 40,
                          height: 40,
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
                                NotificationUpdateStatusEvent(),
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
    double size = 40;
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
