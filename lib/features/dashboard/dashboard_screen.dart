import 'dart:async';
import 'dart:isolate';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:float_bubble/float_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/account/account_screen.dart';
import 'package:vierqr/features/bank_card/bank_screen.dart';
import 'package:vierqr/features/contact/contact_screen.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/curved_navi_bar/curved_nav_bar_model.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/features/dashboard/widget/background_app_bar_home.dart';
import 'package:vierqr/features/dashboard/widget/maintain_widget.dart';
import 'package:vierqr/features/home/home.dart';
import 'package:vierqr/features/home/widget/dialog_update.dart';
import 'package:vierqr/features/network/network_bloc.dart';
import 'package:vierqr/features/network/network_state.dart';
import 'package:vierqr/features/notification/views/notification_screen.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/services/shared_references/qr_scanner_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'curved_navi_bar/custom_navigation_bar.dart';
import 'events/dashboard_event.dart';
import 'widget/disconnect_widget.dart';

class DashBoardScreen extends StatefulWidget {
  final bool isFromLogin;
  final bool isLogoutEnterHome;

  const DashBoardScreen({
    Key? key,
    this.isFromLogin = false,
    this.isLogoutEnterHome = false,
  }) : super(key: key);

  static String routeName = '/dashboard_screen';

  @override
  State<DashBoardScreen> createState() => _DashBoardScreen();
}

class _DashBoardScreen extends State<DashBoardScreen>
    with
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin {
  //page controller
  late PageController _pageController;

  //list page
  final List<Widget> _listScreens = [
    const BankScreen(key: PageStorageKey('QR_GENERATOR_PAGE')),
    const HomeScreen(key: PageStorageKey('HOME_PAGE')),
    const ContactScreen(key: PageStorageKey('CONTACT_PAGE')),
    const AccountScreen(key: const PageStorageKey('USER_SETTING_PAGE')),
  ];

  StreamSubscription? _subscription;
  StreamSubscription? _subReloadWallet;
  StreamSubscription? _subSyncContact;

  //
  final _bottomBarController = StreamController<int>.broadcast();

  //blocs
  late DashBoardBloc _dashBoardBloc;
  late AuthProvider _provider;
  late Stream<int> bottomBarStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _dashBoardBloc = BlocProvider.of(context);
    _provider = Provider.of<AuthProvider>(context, listen: false);

    _pageController =
        PageController(initialPage: _provider.pageSelected, keepPage: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialServices(context);
      listenNewNotification();
      onUpdateApp();
    });

    _subscription = eventBus.on<ChangeBottomBarEvent>().listen((data) {
      _animatedToPage(data.page);
    });

    _subReloadWallet = eventBus.on<ReloadWallet>().listen((_) {
      _dashBoardBloc.add(GetPointEvent());
    });
    _subSyncContact = eventBus.on<SyncContactEvent>().listen((data) {
      _heavyTaskStreamReceiver(data.list);
    });

    bottomBarStream = _bottomBarController.stream;
  }

  void initialServices(BuildContext context) {
    _dashBoardBloc.add(const TokenEventCheckValid());
    _dashBoardBloc.add(GetPointEvent());
    _dashBoardBloc.add(GetCountNotifyEvent());
  }

  void sendDataFromBottomBar(int data) {
    _bottomBarController.add(data);
  }

  static void heavyTask(List<dynamic> args) async {
    SendPort sendPort = args[0];
    List<ContactDTO> list = args[1];

    double progress = 0;
    if (list.isNotEmpty) {
      double amount = 1 / list.length;
      for (int i = 0; i < list.length; i++) {
        progress += amount;
        if (i == list.length - 1) {
          if (progress < 1) {
            progress = 1;
          }
        } else if (progress > 1) {
          progress = 1;
        }

        sendPort.send(HeavyTaskData(progress: progress, index: i));
      }
      sendPort.send(HeavyTaskData(progress: progress));
    } else {
      sendPort.send(HeavyTaskData(progress: 1.0));
    }
  }

  Future<void> _heavyTaskStreamReceiver(List<ContactDTO> list) async {
    List<VCardModel> listVCards = [];
    final receivePort = ReceivePort();
    Isolate.spawn(heavyTask, [receivePort.sendPort, list]);
    await for (var message in receivePort) {
      if (message is HeavyTaskData) {
        if (message.index != null) {
          final e = await FlutterContacts.getContact(list[message.index!].id);
          if (e != null) {
            final contact = VCardModel(
              fullname: e.displayName.isNotEmpty ? e.displayName : '',
              phoneNo: e.phones.isNotEmpty ? e.phones.first.number : '',
              email: e.emails.isNotEmpty ? e.emails.first.address : '',
              companyName: e.organizations.isNotEmpty
                  ? e.organizations.first.company
                  : '',
              website: e.websites.isNotEmpty ? e.websites.first.url : '',
              address: e.addresses.isNotEmpty ? e.addresses.first.address : '',
              userId: UserHelper.instance.getUserId(),
              additionalData: e.notes.isNotEmpty ? e.notes.first.note : '',
            );

            listVCards.add(contact);
          }
        }

        if (message.progress >= 1) {
          receivePort.close();
          eventBus.fire(SentDataToContact(listVCards, list.length));
          _provider.updateSync(false);
          return;
        }
      }
    }
  }

  void startBarcodeScanStream() async {
    final data = await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
    if (data is Map<String, dynamic>) {
      if (!mounted) return;
      QRScannerUtils.instance.onScanNavi(data, context);
    }
  }

  void listenNewNotification() {
    notificationController.listen((isNotificationPushed) {
      if (isNotificationPushed) {
        notificationController.sink.add(false);
        Future.delayed(const Duration(milliseconds: 1000), () {
          _dashBoardBloc.add(GetCountNotifyEvent());
        });
      }
    });
  }

  void onUpdateApp() async {
    bool isUpdateVersion = _provider.isUpdateVersion;
    AppInfoDTO? appInfoDTO = _provider.appInfoDTO;
    bool isCheckApp = appInfoDTO.isCheckApp;

    if (isUpdateVersion && !isCheckApp) {
      showDialog(
        barrierDismissible: false,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return DialogUpdateView(
            isHideClose: true,
            onCheckUpdate: () {
              _dashBoardBloc.add(GetVersionAppEvent(isCheckVer: true));
            },
          );
        },
      );
    }
  }

  void _updateFcmToken(bool isFromLogin) {
    if (!isFromLogin) _dashBoardBloc.add(const TokenFcmUpdateEvent());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!PlatformUtils.instance.isWeb()) {}
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_bottomBarController.hasListener) {
      _bottomBarController.close();
    }
    _subscription?.cancel();
    _subscription = null;
    _subReloadWallet?.cancel();
    _subReloadWallet = null;
    _subSyncContact?.cancel();
    _subSyncContact = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<DashBoardBloc, DashBoardState>(
      listener: (context, state) async {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state.status == BlocStatus.UNLOADING) {
          Navigator.pop(context);
        }

        if (state.request == DashBoardType.KEEP_BRIGHT) {
          _provider.updateKeepBright(state.keepValue);
        }

        if (state.request == DashBoardType.POINT) {
          _provider.updateIntroduceDTO(state.introduceDTO);
        }

        if (state.request == DashBoardType.APP_VERSION) {
          if (state.appInfoDTO != null) {
            _provider.updateThemeVer(state.appInfoDTO!.themeVer);
            _provider.updateAppInfoDTO(state.appInfoDTO);
          }

          _dashBoardBloc.add(GetListThemeEvent());
        }

        //check lỗi hệ thống
        if (state.request == DashBoardType.TOKEN) {
          if (state.typeToken == TokenType.Valid) {
            _updateFcmToken(widget.isFromLogin);
          } else if (state.typeToken == TokenType.MainSystem) {
            await DialogWidget.instance.showFullModalBottomContent(
              isDissmiss: false,
              widget: MaintainWidget(
                onRetry: () {
                  _dashBoardBloc.add(TokenEventCheckValid());
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state.typeToken == TokenType.Expired) {
            await DialogWidget.instance.openMsgDialog(
                title: 'Phiên đăng nhập hết hạn',
                msg: 'Vui lòng đăng nhập lại ứng dụng',
                function: () {
                  Navigator.pop(context);
                  _dashBoardBloc.add(TokenEventLogout());
                });
          } else if (state.typeToken == TokenType.Logout) {
            Navigator.of(context).pushReplacementNamed(Routes.LOGIN);
          } else if (state.typeToken == TokenType.Logout_failed) {
            await DialogWidget.instance.openMsgDialog(
              title: 'Không thể đăng xuất',
              msg: 'Vui lòng thử lại sau.',
            );
          }
        }

        if (state.request == DashBoardType.ERROR) {
          await DialogWidget.instance
              .openMsgDialog(title: 'Thông báo', msg: state.msg ?? '');
        }
        if (state.request == DashBoardType.UPDATE_THEME_ERROR) {
          await DialogWidget.instance
              .openMsgDialog(title: 'Thông báo', msg: state.msg ?? '');
        }

        if (state.status != BlocStatus.NONE ||
            state.request != DashBoardType.NONE ||
            state.typeQR != TypeQR.NONE ||
            state.typePermission == DashBoardTypePermission.None) {
          _dashBoardBloc.add(UpdateEvent());
        }
      },
      child: Scaffold(
        body: Consumer<AuthProvider>(builder: (context, provider, _) {
          if (!provider.isRenderUI) return const SizedBox();
          return Stack(
            children: [
              _buildAppBar(),
              Container(
                padding: (provider.pageSelected.pageType == PageType.PERSON)
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(top: kToolbarHeight * 2),
                child: Listener(
                  onPointerMove: (moveEvent) {
                    print(moveEvent.delta.dx);
                    if (moveEvent.delta.dx < 0) {
                      if (provider.moveEvent != TypeMoveEvent.RIGHT_TO_LEFT)
                        provider.updateMoveEvent(TypeMoveEvent.RIGHT_TO_LEFT);
                    } else {
                      if (provider.moveEvent != TypeMoveEvent.LEFT_TO_RIGHT)
                        provider.updateMoveEvent(TypeMoveEvent.LEFT_TO_RIGHT);
                    }
                  },
                  child: PageView(
                    key: const PageStorageKey('PAGE_VIEW'),
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      provider.updateIndex(index);
                      sendDataFromBottomBar(index);
                    },
                    children: _listScreens,
                  ),
                ),
              ),
              Positioned(
                child: FloatBubble(
                  show: provider.isUpdateVersion,
                  initialAlignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 100,
                    height: 105,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Uri uri = Uri.parse(Stringify.urlStore);
                            if (!await launchUrl(uri,
                                mode: LaunchMode.externalApplication)) {}
                          },
                          child: Image.asset(
                            'assets/images/banner-update.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: provider.onClose,
                            child: Image.asset(
                              'assets/images/ic-close-banner.png',
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 24,
                left: 20,
                right: 20,
                child: BlocBuilder<NetworkBloc, NetworkState>(
                  builder: (context, state) {
                    if (state is NetworkFailure) {
                      return DisconnectWidget(type: TypeInternet.DISCONNECT);
                    } else if (state is NetworkSuccess) {
                      return DisconnectWidget(type: TypeInternet.CONNECT);
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          );
        }),
        bottomNavigationBar: Consumer<AuthProvider>(
          builder: (context, page, _) {
            return CurvedNavigationBar(
              backgroundColor: AppColor.TRANSPARENT,
              buttonBackgroundColor: AppColor.TRANSPARENT,
              animationDuration: const Duration(milliseconds: 300),
              indexPage: page.pageSelected,
              indexPaint: 0,
              iconPadding: 0.0,
              onTap: onTapPage,
              items: _listNavigation,
              stream: bottomBarStream,
            );
          },
        ),
      ),
    );
  }

  void onTapPage(int index) async {
    if (index.pageType != PageType.SCAN_QR) {
      _animatedToPage(index);
    } else {
      if (QRScannerHelper.instance.getQrIntro()) {
        startBarcodeScanStream();
      } else {
        await DialogWidget.instance.showFullModalBottomContent(
          widget: const QRScanWidget(),
          color: AppColor.BLACK,
        );
        startBarcodeScanStream();
      }
    }
  }

//navigate to page
  void _animatedToPage(int index) {
    try {
      _pageController.jumpToPage(index);
      if (index.pageType == PageType.CARD_QR) {
        eventBus.fire(CheckSyncContact());
      }
    } catch (e) {
      _pageController = PageController(
        initialPage: _provider.pageSelected,
        keepPage: true,
      );
      _animatedToPage(index);
      if (index.pageType == PageType.CARD_QR) {
        eventBus.fire(CheckSyncContact());
      }
    }
  }

//get title page
  Widget _getTitlePage(BuildContext context, int indexSelected) {
    Widget titleWidget = const SizedBox();
    if (indexSelected != PageType.PERSON.pageIndex ||
        indexSelected == PageType.SCAN_QR.pageIndex) {
      titleWidget = ButtonIconWidget(
        width: double.infinity,
        height: 40,
        borderRadius: 40,
        icon: Icons.search_rounded,
        iconSize: 18,
        contentPadding: const EdgeInsets.only(left: 16),
        alignment: Alignment.centerLeft,
        title: 'Tìm kiếm',
        textSize: 11,
        function: () {
          Navigator.pushNamed(context, Routes.SEARCH_BANK);
        },
        bgColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).hintColor,
      );
    }

    if (indexSelected == PageType.PERSON.pageIndex) {
      titleWidget = const SizedBox.shrink();
    }

    return titleWidget;
  }

//header
  Widget _buildAppBar() {
    return Consumer<AuthProvider>(
      builder: (context, page, child) {
        return BackgroundAppBarHome(
          file: page.file,
          url: page.settingDTO.themeImgUrl,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            height: 56,
            child: page.pageSelected.pageType == PageType.PERSON
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (page.settingDTO.logoUrl.isNotEmpty)
                        Container(
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CachedNetworkImage(
                              imageUrl: page.settingDTO.logoUrl, width: 50),
                        )
                      else
                        const SizedBox(width: 60, height: 30),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: _getTitlePage(context, page.pageSelected),
                        ),
                      ),
                      BlocConsumer<DashBoardBloc, DashBoardState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            int lengthNotify =
                                state.countNotify.toString().length;
                            return SizedBox(
                              width: 50,
                              height: 60,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ButtonIconWidget(
                                    width: 40,
                                    height: 40,
                                    borderRadius: 40,
                                    icon: Icons.notifications_outlined,
                                    title: '',
                                    function: _onNotification,
                                    bgColor: Theme.of(context).cardColor,
                                    textColor: Theme.of(context).hintColor,
                                  ),
                                  if (state.countNotify != 0)
                                    Positioned(
                                      top: 4,
                                      right: 0,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: AppColor.RED_CALENDAR,
                                        ),
                                        child: Text(
                                          state.countNotify.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize:
                                                (lengthNotify >= 3) ? 8 : 10,
                                            color: AppColor.WHITE,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void _onNotification() async {
    _dashBoardBloc.add(NotifyUpdateStatusEvent());

    NavigatorUtils.navigatePage(context, NotificationScreen(),
        routeName: NotificationScreen.routeName);
  }

  List<CurvedNavigationBarItem> _listNavigation = [
    CurvedNavigationBarItem(
      label: 'Tài khoản',
      urlSelect: 'assets/images/ic-btm-list-bank-blue.png',
      urlUnselect: 'assets/images/ic-btm-list-bank-grey.png',
      index: PageType.ACCOUNT.pageIndex,
    ),
    CurvedNavigationBarItem(
      label: 'Trang chủ',
      urlSelect: 'assets/images/ic-btm-dashboard-blue.png',
      urlUnselect: 'assets/images/ic-btm-dashboard-grey.png',
      index: PageType.HOME.pageIndex,
    ),
    CurvedNavigationBarItem(
      label: 'Quét QR',
      urlSelect: 'assets/images/ic-menu-slide-home-blue.png',
      urlUnselect: 'assets/images/ic-menu-slide-home-blue.png',
      index: PageType.SCAN_QR.pageIndex,
    ),
    CurvedNavigationBarItem(
      label: 'Ví QR',
      urlSelect: 'assets/images/ic-btm-qr-wallet-blue.png',
      urlUnselect: 'assets/images/ic-btm-qr-wallet-grey.png',
      index: PageType.CARD_QR.pageIndex,
    ),
    CurvedNavigationBarItem(
      label: 'Cá nhân',
      urlSelect: '',
      urlUnselect: '',
      index: PageType.PERSON.pageIndex,
      child: Consumer<AuthProvider>(builder: (context, provider, _) {
        String imgId = UserHelper.instance.getAccountInformation().imgId;
        return Container(
          width: 28,
          height: 28,
          padding: EdgeInsets.all(1),
          decoration: provider.pageSelected == PageType.PERSON.pageIndex
              ? BoxDecoration(
                  border: Border.all(color: AppColor.BLUE_TEXT, width: 1),
                  borderRadius: BorderRadius.circular(28),
                  color: Colors.white,
                )
              : BoxDecoration(),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: provider.avatar.path.isEmpty
                    ? (imgId.isNotEmpty
                        ? ImageUtils.instance.getImageNetWork(imgId)
                        : Image.asset('assets/images/ic-avatar.png').image)
                    : Image.file(provider.avatar).image,
              ),
            ),
          ),
        );
      }),
    ),
  ];

  @override
  bool get wantKeepAlive => true;
}

class SaveImageData {
  SaveImageData({required this.progress, this.index, this.isDone = false});

  Uint8List progress;
  int? index;
  bool isDone;
}
