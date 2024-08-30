import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:float_bubble/float_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart'
    as Constants;
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/helper/dialog_helper.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/bottom_bar_item.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/scroll_to_top_button.dart';
import 'package:vierqr/features/bank_card/bank_screen.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/contact/contact_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/blocs/isolate_stream.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/features/dashboard/widget/background_app_bar_home.dart';
import 'package:vierqr/features/dashboard/widget/maintain_widget.dart';
import 'package:vierqr/features/home/home.dart';
import 'package:vierqr/features/network/network_bloc.dart';
import 'package:vierqr/features/network/network_state.dart';
import 'package:vierqr/features/qr_feed/qr_feed_screen.dart';
import 'package:vierqr/features/scan_qr/scan_qr_view_screen.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/features/store/store_screen.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/invoice_provider.dart';
import 'package:vierqr/services/socket_service/socket_service.dart';
import 'package:vierqr/splash_screen.dart';

import '../../commons/utils/encrypt_utils.dart';
import '../../commons/utils/navigator_utils.dart';
import '../../models/account_login_dto.dart';
import '../../services/firebase_dynamic_link/firebase_dynamic_link_service.dart';
import '../../services/firebase_dynamic_link/uni_links_listener_mixins.dart';
import '../../services/providers/pin_provider.dart';
import '../bank_card/blocs/bank_bloc.dart';
import '../maintain_charge/views/dynamic_active_key_screen.dart';
import 'widget/disconnect_widget.dart';

class DashBoardScreen extends StatefulWidget {
  final bool isFromLogin;
  final bool isLogoutEnterHome;

  const DashBoardScreen({
    super.key,
    this.isFromLogin = false,
    this.isLogoutEnterHome = false,
  });

  static String routeName = '/dashboard_screen';

  @override
  State<DashBoardScreen> createState() => _DashBoardScreen();
}

class _DashBoardScreen extends State<DashBoardScreen>
    with
        UniLinksListenerMixin,
        WidgetsBindingObserver,
        // AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin,
        DialogHelper {
  //page controller
  late PageController _pageController;

  List barItems = [
    {
      "icon": "assets/images/bottom-bar-icons/Artboard.png",
      "active_icon":
          "assets/images/bottom-bar-icons/ic-menu-slide-home-blue 10.png",
      "name": "Tài khoản",
    },
    {
      "icon": "assets/images/bottom-bar-icons/ic-menu-slide-home-blue.png",
      "active_icon":
          "assets/images/bottom-bar-icons/ic-menu-slide-home-blue 9.png",
      "name": "Trang chủ",
    },
    {
      "icon": "assets/images/bottom-bar-icons/ic-qr-scan.gif",
      "active_icon": "assets/images/bottom-bar-icons/ic-qr-scan.gif",
      "name": "Quét QR",
    },
    {
      "icon": "assets/images/bottom-bar-icons/ic-menu-slide-home-blue 2.png",
      "active_icon":
          "assets/images/bottom-bar-icons/ic-menu-slide-home-blue 8.png",
      "name": "Ví QR",
    },
    {
      "icon": "assets/images/bottom-bar-icons/ic-menu-slide-home-blue 3.png",
      "active_icon":
          "assets/images/bottom-bar-icons/ic-menu-slide-home-blue 7.png",
      "name": "Cửa hàng",
    },
  ];

  // List<CurvedNavigationBarItem> _listNavigation = [
  //   CurvedNavigationBarItem(
  //     label: 'Tài khoản',
  //     urlSelect: 'assets/images/ic-btm-list-bank-blue.png',
  //     urlUnselect: 'assets/images/ic-btm-list-bank-grey.png',
  //     index: PageType.ACCOUNT.pageIndex,
  //   ),
  //   CurvedNavigationBarItem(
  //     label: 'Trang chủ',
  //     urlSelect: 'assets/images/ic-btm-dashboard-blue.png',
  //     urlUnselect: 'assets/images/ic-btm-dashboard-grey.png',
  //     index: PageType.HOME.pageIndex,
  //   ),
  //   CurvedNavigationBarItem(
  //     label: 'Quét QR',
  //     urlSelect: 'assets/images/ic-menu-slide-home-blue.png',
  //     urlUnselect: 'assets/images/ic-menu-slide-home-blue.png',
  //     index: PageType.SCAN_QR.pageIndex,
  //   ),
  //   CurvedNavigationBarItem(
  //     label: 'Ví QR',
  //     urlSelect: 'assets/images/ic-btm-qr-wallet-blue.png',
  //     urlUnselect: 'assets/images/ic-btm-qr-wallet-grey.png',
  //     index: PageType.CARD_QR.pageIndex,
  //   ),
  //   CurvedNavigationBarItem(
  //     label: 'Cửa hàng',
  //     urlSelect: 'assets/images/ic-store-bottom-bar-blue.png',
  //     urlUnselect: 'assets/images/ic-store-bottom-bar-grey.png',
  //     index: PageType.STORE.pageIndex,
  //   ),
  //   // CurvedNavigationBarItem(
  //   //   label: 'Cửa hàng',
  //   //   urlSelect: '',
  //   //   urlUnselect: '',
  //   //   index: PageType.PERSON.pageIndex,
  //   //   child: Consumer<AuthProvider>(builder: (context, provider, _) {
  //   //     String imgId = SharePrefUtils.getProfile().imgId;
  //   //     return Container(
  //   //       width: 28,
  //   //       height: 28,
  //   //       padding: EdgeInsets.all(1),
  //   //       decoration: provider.pageSelected == PageType.PERSON.pageIndex
  //   //           ? BoxDecoration(
  //   //               border: Border.all(color: AppColor.BLUE_TEXT, width: 1),
  //   //               borderRadius: BorderRadius.circular(28),
  //   //               color: Colors.white,
  //   //             )
  //   //           : BoxDecoration(),
  //   //       child: Container(
  //   //         decoration: BoxDecoration(
  //   //           shape: BoxShape.circle,
  //   //           image: DecorationImage(
  //   //             fit: BoxFit.cover,
  //   //             image: provider.avatarUser.path.isEmpty
  //   //                 ? (imgId.isNotEmpty
  //   //                     ? ImageUtils.instance.getImageNetWork(imgId)
  //   //                     : Image.asset('assets/images/ic-avatar.png').image)
  //   //                 : Image.file(provider.avatarUser).image,
  //   //           ),
  //   //         ),
  //   //       ),
  //   //     );
  //   //   }),
  //   // ),
  // ];

  StreamSubscription? _subscription;
  StreamSubscription? _subReloadWallet;
  StreamSubscription? _subSyncContact;

  //
  final _bottomBarController = StreamController<int>.broadcast();

  //blocs
  final BankBloc _bankBloc = getIt.get<BankBloc>();
  final DashBoardBloc _bloc = getIt.get<DashBoardBloc>();

  late AuthenProvider _provider;
  late Stream<int> bottomBarStream;
  late IsolateStream _isolateStream;
  StreamSubscription<Uri>? _linkSubscription;
  final scrollController = ScrollController();
  ValueNotifier<bool> scrollNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> scrollToTopNotifier = ValueNotifier<bool>(false);

  final TextEditingController _editingController =
      TextEditingController(text: '');
  bool? isClose = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    DynamicLinkService.initDynamicLinks();
    getInitUniLinks();
    initUniLinks();

    _provider = Provider.of<AuthenProvider>(context, listen: false);
    _isolateStream = IsolateStream(context, getIt.get<AppConfig>());
    _pageController =
        PageController(initialPage: _provider.pageSelected, keepPage: true);

    Future.delayed(const Duration(seconds: 1), requestNotificationPermission);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //thực hiện một số thao tác khi frame hình được vẽ xong

      _bloc.add(const TokenEventCheckValid());
      // listenNewNotification();
      onUpdateApp();
      onRenderUI();
      SocketService.instance.init();
    });

    _subscription = eventBus.on<ChangeBottomBarEvent>().listen((data) {
      _animatedToPage(data.page);
    });

    _subReloadWallet = eventBus.on<ReloadWallet>().listen((_) {
      _bloc.add(GetPointEvent());
    });
    _subSyncContact = eventBus.on<SyncContactEvent>().listen((data) {
      _heavyTaskStreamReceiver(data.list);
    });

    bottomBarStream = _bottomBarController.stream;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_bottomBarController.hasListener) {
      _bottomBarController.close();
    }
    _linkSubscription?.cancel();
    _subscription?.cancel();
    _subscription = null;
    _subReloadWallet?.cancel();
    _subReloadWallet = null;
    _subSyncContact?.cancel();
    _subSyncContact = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // SocketService.instance.init();
      // await SharePrefUtils.setListenTransactionQRWS(false);
      SocketService.instance.closeListenTransaction();
    } else if (state == AppLifecycleState.resumed) {
      SocketService.instance.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).viewPadding.top;
    double width = MediaQuery.of(context).size.width;
    // super.build(context);
    return BlocListener<DashBoardBloc, DashBoardState>(
      bloc: _bloc,
      listener: onListening,
      child: Consumer<AuthenProvider>(builder: (context, provider, _) {
        // if (!provider.isRenderUI) {
        //   return SplashScreen(isFromLogin: widget.isFromLogin);
        // }
        return Scaffold(
          backgroundColor: AppColor.WHITE,
          resizeToAvoidBottomInset: false,
          floatingActionButton: ScrollToTopButton(
              bottom: 80,
              onPressed: () {
                scrollController.animateTo(0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
                scrollNotifier.value = true;
              },
              notifier: scrollToTopNotifier),
          body: Stack(
            children: [
              if (provider.pageSelected != 3 && provider.pageSelected != 0)
                Consumer<AuthenProvider>(builder: (context, page, child) {
                  File file = page.bannerApp;
                  return Container(
                    height: 240,
                    width: width,
                    padding: EdgeInsets.only(top: paddingTop + 4),
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      image: file.path.isNotEmpty
                          ? DecorationImage(
                              image: FileImage(file),
                              fit: BoxFit.fitWidth,
                            )
                          : const DecorationImage(
                              image: AssetImage(ImageConstant.bgrHeader),
                              fit: BoxFit.fitWidth,
                            ),
                    ),
                  );
                }),
              // const BackgroundAppBarHome(),

              Container(
                padding: EdgeInsets.only(
                    top:
                        provider.pageSelected == 3 || provider.pageSelected == 0
                            ? 0
                            : kToolbarHeight * 2),
                decoration: BoxDecoration(
                  gradient: provider.pageSelected == 0
                      ? VietQRTheme.gradientColor.lilyLinear
                      : null,
                  // color: Colors.red
                ),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      scrollToTopNotifier.value = scrollController.offset > 200;
                      if (scrollController.offset > 150 &&
                          scrollController.position.userScrollDirection ==
                              ScrollDirection.reverse) {
                        if (scrollNotifier.value) {
                          scrollNotifier.value = false;
                        }
                      } else if (scrollController
                              .position.userScrollDirection ==
                          ScrollDirection.forward) {
                        if (!scrollNotifier.value) {
                          scrollNotifier.value = true;
                        }
                      }
                    }
                    return true;
                  },
                  child: PageView(
                    key: const PageStorageKey('PAGE_VIEW'),
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) async {
                      // if (index != PageType.STORE.pageIndex) {
                      provider.updateIndex(index);
                      sendDataFromBottomBar(index);
                      // }
                    },
                    children: [
                      BankScreen(
                        scrollController: scrollController,
                        key: const PageStorageKey('QR_GENERATOR_PAGE'),
                        onStore: () {
                          onTapPage(5);
                          // provider.updateIndex(5, isOnTap: true, isHome: false);
                        },
                      ),
                      const HomeScreen(key: PageStorageKey('HOME_PAGE')),
                      // const ContactScreen(key: PageStorageKey('CONTACT_PAGE')),
                      const QrFeedScreen(key: PageStorageKey('QR_WALLET')),

                      const StoreScreen(key: PageStorageKey('STORE_PAGE')),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).viewPadding.top + 4,
                  child:
                      (provider.pageSelected != 3 && provider.pageSelected != 0)
                          ? const BackgroundAppBarHome()
                          : const SizedBox.shrink()),
              renderUpdateDialog(provider),
              renderNetworkDialog(),
              ValueListenableBuilder<bool>(
                valueListenable: scrollNotifier,
                builder: (context, isScroll, child) {
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    bottom: !isScroll ? -100 : 0.0,
                    left: 0,
                    right: 0,
                    child: getBottomBar(
                      provider.pageSelected,
                      onTap: (index) {
                        onTapPage(index);
                        provider.updateIndex(index,
                            isOnTap: true, isHome: index == 2 ? true : false);
                      },
                    ),
                  );
                },
              )
            ],
          ),
          // bottomNavigationBar: Consumer<AuthProvider>(
          //   builder: (context, page, _) {
          //     return CurvedNavigationBar(
          //       backgroundColor: AppColor.TRANSPARENT,
          //       buttonBackgroundColor: AppColor.TRANSPARENT,
          //       animationDuration: const Duration(milliseconds: 300),
          //       indexPage: page.pageSelected,
          //       indexPaint: 0,
          //       iconPadding: 0.0,
          //       onTap: onTapPage,
          //       items: _listNavigation,
          //       stream: bottomBarStream,
          //     );
          //   },
          // ),
        );
      }),
    );
  }

  /// poppup bên dưới hiển thị khi có bản cập nhật mới
  Positioned renderUpdateDialog(AuthenProvider provider) {
    return Positioned(
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
                  ImageConstant.bannerUpdate,
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
                    ImageConstant.icCloseBanner,
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
    );
  }

  ///dialog bên dưới sẽ hiện khi mất kết nối hoặc đã kết nối trở lại
  Positioned renderNetworkDialog() {
    return Positioned(
      bottom: 24,
      left: 20,
      right: 20,
      child: BlocBuilder<NetworkBloc, NetworkState>(
        bloc: getIt.get<NetworkBloc>(),
        builder: (context, state) {
          if (state is NetworkFailure) {
            return const DisconnectWidget(type: TypeInternet.DISCONNECT);
          } else if (state is NetworkSuccess) {
            return const DisconnectWidget(type: TypeInternet.CONNECT);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  // @override
  // bool get wantKeepAlive => true;

  @override
  void getInitUri(Uri? uri) {
    if (uri?.path == '/service-active' && uri?.queryParameters['key'] != null) {
      NavigatorUtils.navigatePage(
          context,
          DynamicActiveKeyScreen(
            activeKey: uri!.queryParameters['key']!,
          ),
          routeName: Routes.DYNAMIC_ACTIVE_KEY_SCREEN);
    }
  }

  @override
  void onUniLink(Uri uri) {
    if (uri.path == '/service-active' && uri.queryParameters['key'] != null) {
      NavigatorUtils.navigatePage(
          context,
          DynamicActiveKeyScreen(
            activeKey: uri.queryParameters['key']!,
          ),
          routeName: Routes.DYNAMIC_ACTIVE_KEY_SCREEN);
    }
  }
}

class SaveImageData {
  SaveImageData({required this.progress, this.index, this.isDone = false});

  Uint8List progress;
  int? index;
  bool isDone;
}

/// phần xử lý dữ liệu của DashBoard
extension _DashBoardExtensionFunction on _DashBoardScreen {
  void initialServices({bool isLogin = false}) {
    if (isLogin) {}
    // _bankBloc.add(LoadDataBankEvent());
    _bloc.add(GetBanksEvent());
    _bloc.add(GetUserInformation());
    _bloc.add(GetUserSettingEvent());
    _bloc.add(GetPointEvent());
    _bloc.add(GetCountNotifyEvent());
  }

  void requestNotificationPermission() async {
    await Permission.notification.request();
  }

  void onRenderUI() async {
    // await getHomeBankAccount();
    Future.delayed(const Duration(milliseconds: 3000), () async {
      _provider.updateRenderUI();
    });
  }

  void sendDataFromBottomBar(int data) {
    _bottomBarController.add(data);
  }

  void heavyTask(List<dynamic> args) async {
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
              userId: SharePrefUtils.getProfile().userId,
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

  // void startBarcodeScanStream() async {
  //   final data = await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
  //   if (data is Map<String, dynamic>) {
  //     if (!mounted) return;
  //     QRScannerUtils.instance.onScanNavi(data, context);
  //   }
  // }

  void listenNewNotification() {
    notificationController.listen((isNotificationPushed) {
      if (isNotificationPushed) {
        notificationController.sink.add(false);
        Future.delayed(const Duration(milliseconds: 1000), () {
          _bloc.add(GetCountNotifyEvent());
        });
      }
    });
  }

  /// description: kiểm tra bản cập nhật app
  void onUpdateApp() async {
    bool isUpdateVersion = _provider.isUpdateVersion;
    AppInfoDTO? appInfoDTO = _provider.appInfoDTO;
    bool isCheckApp = appInfoDTO.isCheckApp;

    if (isUpdateVersion && !isCheckApp) {
      showDialogUpdateApp(
        context,
        isHideClose: true,
      );
      // showDialog(
      //   barrierDismissible: false,
      //   context: context,
      //   builder: (BuildContext context) {
      //     return DialogUpdateView(
      //       isHideClose: true,
      //       onCheckUpdate: () {
      //         _bloc.add(GetVersionAppEventDashboard(isCheckVer: true));
      //       },
      //     );
      //   },
      // );
    }
  }

  void _updateFcmToken(bool isFromLogin) {
    if (!isFromLogin) _bloc.add(const TokenFcmUpdateEvent());
  }

  void _onHandleAppSystem(AppInfoDTO dto, AuthenProvider authProvider) async {
    String logoApp = SharePrefUtils.getLogoApp();
    bool isEvent = SharePrefUtils.getBannerEvent();
    ThemeDTO themeDTO = await SharePrefUtils.getSingleTheme() ?? ThemeDTO();

    if (logoApp.isEmpty) {
      String path = dto.logoUrl.split('/').last;

      for (var type in Constants.PictureType.values) {
        if (path.contains(type.pictureValue)) {
          path.replaceAll(type.pictureValue, '');
          return;
        }
      }

      String localPath = await downloadAndSaveImage(dto.logoUrl, path);

      await SharePrefUtils.saveLogoApp(localPath);
      authProvider.updateLogoApp(localPath);
    }

    if (dto.isEventTheme && !isEvent) {
      String path = dto.themeImgUrl.split('/').last;
      for (var type in Constants.PictureType.values) {
        if (path.contains(type.pictureValue)) {
          path.replaceAll(type.pictureValue, '');
          return;
        }
      }

      String localPath = await downloadAndSaveImage(dto.themeImgUrl, path);

      await SharePrefUtils.saveBannerApp(localPath);
      authProvider.updateBannerApp(localPath);
    } else if (!dto.isEventTheme && themeDTO.type == 0) {
      await SharePrefUtils.removeSingleTheme();
      await SharePrefUtils.saveBannerApp('');
      authProvider.updateBannerApp('');
    }

    if (isEvent != dto.isEventTheme) {
      await SharePrefUtils.saveBannerEvent(dto.isEventTheme);
      authProvider.updateEventTheme(dto.isEventTheme);
    }
  }

  onListening(BuildContext context, DashBoardState state) async {
    if (state.status == BlocStatus.LOADING) {
      DialogWidget.instance.openLoadingDialog();
    }

    if (state.status == BlocStatus.UNLOADING) {
      Navigator.pop(context);
    }

    if (state.request == DashBoardType.GET_USER_SETTING) {
      final settingAccountDTO = SharePrefUtils.getAccountSetting();
      final listBank =
          Provider.of<InvoiceProvider>(context, listen: false).listBank;
      _provider.updateSettingDTO(settingAccountDTO);
      String themeVerLocal = SharePrefUtils.getThemeVersion();
      String themeSystem = state.appInfoDTO.themeVersion;
      List<ThemeDTO> listLocal = await UserRepository.instance.getThemes();
      if (!settingAccountDTO.notificationMobile && listBank!.isNotEmpty) {
        DialogWidget.instance.openNotificationMobile(context);
      }
      if (themeVerLocal != themeSystem || listLocal.isEmpty) {
        _bloc.add(GetListThemeEvent());
      } else {}
    }
    // if (state.request == DashBoardType.CLOSE_NOTIFICATION) {
    //   Navigator.of(context).pop();
    // }
    if (state.request == DashBoardType.LOGIN) {
      _provider.checkStateLogin(false);
      initialServices(isLogin: true);
    }
    if (state.request == DashBoardType.LOGIN_ERROR) {
      _provider.checkStateLogin(true);
      _bloc.add(TokenEventLogout());
    }

    if (state.request == DashBoardType.GET_BANK) {
      _isolateStream.saveBankReceiver(state.listBanks);
    }

    if (state.request == DashBoardType.APP_VERSION) {
      initialServices();
      _provider.updateAppInfoDTO(state.appInfoDTO);
      _onHandleAppSystem(state.appInfoDTO, _provider);
    }

    if (state.request == DashBoardType.THEMES) {
      List<ThemeDTO> list = [...state.themes];
      list.sort((a, b) => a.type.compareTo(b.type));
      _provider.updateThemes(list);

      await UserRepository.instance.clearThemes();
      List<ThemeDTO> datas = await _isolateStream.saveThemeReceiver(list);
      _provider.updateThemes(datas);
      await SharePrefUtils.saveThemeVersion(state.appInfoDTO.themeVersion);
    }

    if (state.request == DashBoardType.KEEP_BRIGHT) {
      _provider.updateKeepBright(state.keepValue);
    }

    if (state.request == DashBoardType.POINT) {
      _provider.updateIntroduceDTO(state.introduceDTO);
    }

    //check lỗi hệ thống
    if (state.request == DashBoardType.TOKEN) {
      if (state.typeToken == TokenType.Valid) {
        _bloc.add(const GetVersionAppEventDashboard());
        _updateFcmToken(widget.isFromLogin);
      } else {
        _provider.updateRenderUI();
        if (state.typeToken == TokenType.MainSystem) {
          await DialogWidget.instance.showFullModalBottomContent(
            isDissmiss: false,
            widget: MaintainWidget(
              onRetry: () {
                _bloc.add(const TokenEventCheckValid());
                Navigator.pop(context);
              },
            ),
          );
        } else if (state.typeToken == TokenType.Expired) {
          String phone = SharePrefUtils.getPhone();
          _provider.checkStateLogin(false);
          await DialogWidget.instance.openConfirmPassDialog(
            editingController: _editingController,
            title: "Phiên đăng nhập hết hạn\nNhập mật khẩu để đăng nhập",
            onClose: () {
              Provider.of<PinProvider>(context, listen: false).reset();
              DialogWidget.instance.openMsgDialog(
                title: 'Phiên đăng nhập hết hạn',
                msg: 'Vui lòng đăng nhập lại ứng dụng',
                function: () => _bloc.add(TokenEventLogout()),
              );
            },
            onDone: (pin) {
              Provider.of<PinProvider>(context, listen: false).reset();
              _editingController.text = '';
              AccountLoginDTO dto = AccountLoginDTO(
                phoneNo: phone,
                password: EncryptUtils.instance.encrypted(phone, pin),
              );
              _bloc.add(DashBoardLoginEvent(dto: dto));
              // if (!mounted) return;
            },
          );
          // context.read<LoginBloc>().add(event)
        } else if (state.typeToken == TokenType.Logout) {
          await SharePrefUtils.resetServices();
        } else if (state.typeToken == TokenType.Logout_failed) {
          await DialogWidget.instance.openMsgDialog(
            title: 'Không thể đăng xuất',
            msg: 'Vui lòng thử lại sau.',
          );
        }
      }
    }

    if (state.request == DashBoardType.ERROR) {
      _provider.updateRenderUI();
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
      _bloc.add(UpdateEventDashboard());
    }
  }

  Widget getBottomBar(int pageSelected, {required Function(int) onTap}) {
    return Container(
      height: 72,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.circular(50),
        // gradient: VietQRTheme.gradientColor.brightBlueLinear,
        boxShadow: [
          BoxShadow(
              color: AppColor.BLACK.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
            barItems.length,
            (index) => BottomBarItem(
                  index,
                  barItems[index]["active_icon"],
                  barItems[index]["icon"],
                  isActive: pageSelected == index,
                  activeColor: AppColor.BLUE_TEXT,
                  onTap: () {
                    onTap(index);
                  },
                )),
      ),
    );
  }

  void onTapPage(int index) async {
    // if (index.pageType == PageType.STORE) {
    //   await DialogWidget.instance.openMsgDialog(
    //     title: 'Thông báo',
    //     msg: 'Chúng tôi sẽ ra mắt tính năng cửa hàng trong thời gian sớm.',
    //   );
    //   return;
    // }

    if (index.pageType != PageType.SCAN_QR) {
      _animatedToPage(index);
    } else {
      if (SharePrefUtils.getQrIntro()) {
        // startBarcodeScanStream();
        scanBarcode();
      } else {
        await DialogWidget.instance.showFullModalBottomContent(
          widget: const QRScanWidget(),
          color: AppColor.BLACK,
        );
        scanBarcode();

        // startBarcodeScanStream();
      }
    }
  }

  void scanBarcode() async {
    Map<String, dynamic> param = {};
    param['typeScan'] = TypeScan.DASHBOARD_SCAN;
    final data = await NavigationService.push(Routes.SCAN_QR_VIEW_SCREEN,
        arguments: param);
    if (data is Map<String, dynamic>) {
      if (!mounted) return;
      QRScannerUtils.instance.onScanNavi(data, context);
    }
  }

//navigate to page
  void _animatedToPage(int index) {
    try {
      if (index < 3) {
        _pageController.jumpToPage(index);
      } else {
        _pageController.jumpToPage(index - 1);
      }

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

  // void _animatedToPage(int index) {
  //   try {
  //     _pageController.jumpToPage(index);
  //     if (index.pageType == PageType.CARD_QR) {
  //       eventBus.fire(CheckSyncContact());
  //     }
  //   } catch (e) {
  //     _pageController = PageController(
  //       initialPage: _provider.pageSelected,
  //       keepPage: true,
  //     );
  //     _animatedToPage(index);
  //     if (index.pageType == PageType.CARD_QR) {
  //       eventBus.fire(CheckSyncContact());
  //     }
  //   }
  // }

  @override
  bool get wantKeepAlive => true;

  @override
  void getInitUri(Uri? uri) {
    print('object================================= ${uri.toString()}');
    if (uri?.path == '/service-active' && uri?.queryParameters['key'] != null) {
      NavigatorUtils.navigatePage(
          context,
          DynamicActiveKeyScreen(
            activeKey: uri!.queryParameters['key']!,
          ),
          routeName: Routes.DYNAMIC_ACTIVE_KEY_SCREEN);
    }
  }

  @override
  void onUniLink(Uri uri) {
    print('object111 ${uri.path.toString()}');
    if (uri.path == '/service-active' && uri.queryParameters['key'] != null) {
      NavigatorUtils.navigatePage(
          context,
          DynamicActiveKeyScreen(
            activeKey: uri.queryParameters['key']!,
          ),
          routeName: Routes.DYNAMIC_ACTIVE_KEY_SCREEN);
    }
  }
}

// class SaveImageData {
//   SaveImageData({required this.progress, this.index, this.isDone = false});

//   Uint8List progress;
//   int? index;
//   bool isDone;
// }
