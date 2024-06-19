import 'dart:async';
import 'dart:isolate';

import 'package:float_bubble/float_bubble.dart';
import 'package:flutter/material.dart';
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
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_card/bank_screen.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/contact/contact_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/blocs/isolate_stream.dart';
import 'package:vierqr/features/dashboard/curved_navi_bar/curved_nav_bar_model.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/features/dashboard/widget/background_app_bar_home.dart';
import 'package:vierqr/features/dashboard/widget/maintain_widget.dart';
import 'package:vierqr/features/home/home.dart';
import 'package:vierqr/features/home/widget/dialog_update.dart';
import 'package:vierqr/features/network/network_bloc.dart';
import 'package:vierqr/features/network/network_state.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/features/store/store_screen.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/splash_screen.dart';

import '../../commons/utils/encrypt_utils.dart';
import '../../commons/utils/navigator_utils.dart';
import '../../models/account_login_dto.dart';
import '../../services/firebase_dynamic_link/firebase_dynamic_link_service.dart';
import '../../services/firebase_dynamic_link/uni_links_listener_mixins.dart';
import '../../services/providers/pin_provider.dart';
import '../bank_card/blocs/bank_bloc.dart';
import '../maintain_charge/views/dynamic_active_key_screen.dart';
import 'curved_navi_bar/custom_navigation_bar.dart';
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
        UniLinksListenerMixin,
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
    const StoreScreen(key: const PageStorageKey('STORE_PAGE')),
  ];

  StreamSubscription? _subscription;
  StreamSubscription? _subReloadWallet;
  StreamSubscription? _subSyncContact;

  //
  final _bottomBarController = StreamController<int>.broadcast();

  //blocs
  // late final BankBloc = getIt.get<BankBloc>(param1: context);
  late final BankBloc _bankBloc = getIt.get<BankBloc>();

  late DashBoardBloc _bloc;
  late AuthProvider _provider;
  late Stream<int> bottomBarStream;
  late IsolateStream _isolateStream;
  StreamSubscription<Uri>? _linkSubscription;

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
    _bloc = BlocProvider.of(context);

    _provider = Provider.of<AuthProvider>(context, listen: false);
    _isolateStream = IsolateStream(context, getIt.get<AppConfig>());
    _pageController =
        PageController(initialPage: _provider.pageSelected, keepPage: true);

    Future.delayed(const Duration(seconds: 1), requestNotificationPermission);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(const TokenEventCheckValid());
      listenNewNotification();
      onUpdateApp();
      onRenderUI();
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

  void initialServices({bool isLogin = false}) {
    if (isLogin) {
      // context.read<BankBloc>().add(BankCardEventGetList());
      // context.read<BankBloc>().add(LoadDataBankEvent());
      _bankBloc.add(BankCardEventGetList());
      _bankBloc.add(LoadDataBankEvent());
    }
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
    Future.delayed(const Duration(milliseconds: 1500), () {
      _provider.updateRenderUI();
    });
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
          _bloc.add(GetCountNotifyEvent());
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
        context: NavigationService.context!,
        builder: (BuildContext context) {
          return DialogUpdateView(
            isHideClose: true,
            onCheckUpdate: () {
              _bloc.add(GetVersionAppEventDashboard(isCheckVer: true));
            },
          );
        },
      );
    }
  }

  void _updateFcmToken(bool isFromLogin) {
    if (!isFromLogin) _bloc.add(const TokenFcmUpdateEvent());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!PlatformUtils.instance.isWeb()) {}
    }
  }

  void _onHandleAppSystem(AppInfoDTO dto, AuthProvider authProvider) async {
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

        if (state.request == DashBoardType.GET_USER_SETTING) {
          final settingAccountDTO = SharePrefUtils.getAccountSetting();
          _provider.updateSettingDTO(settingAccountDTO);
          String themeVerLocal = SharePrefUtils.getThemeVersion();
          String themeSystem = state.appInfoDTO.themeVersion;
          List<ThemeDTO> listLocal = await UserRepository.instance.getThemes();
          if (!settingAccountDTO.notificationMobile) {
            DialogWidget.instance.openNotificationMobile(context);
          }
          if (themeVerLocal != themeSystem || listLocal.isEmpty) {
            _bloc.add(GetListThemeEvent());
          } else {}
        }
        if (state.request == DashBoardType.CLOSE_NOTIFICATION) {
          Navigator.of(context).pop();
        }
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
            _bloc.add(GetVersionAppEventDashboard());
            _updateFcmToken(widget.isFromLogin);
          } else {
            _provider.updateRenderUI();
            if (state.typeToken == TokenType.MainSystem) {
              await DialogWidget.instance.showFullModalBottomContent(
                isDissmiss: false,
                widget: MaintainWidget(
                  onRetry: () {
                    _bloc.add(TokenEventCheckValid());
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
      },
      child: Consumer<AuthProvider>(builder: (context, provider, _) {
        if (!provider.isRenderUI)
          return SplashScreen(isFromLogin: widget.isFromLogin);
        return Scaffold(
          // floatingActionButton: MyFloatingButton(),
          body: Stack(
            children: [
              const BackgroundAppBarHome(),
              Container(
                padding: const EdgeInsets.only(top: kToolbarHeight * 2),
                child: Listener(
                  onPointerMove: (moveEvent) {
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
                    onPageChanged: (index) async {
                      // if (index != PageType.STORE.pageIndex) {
                      provider.updateIndex(index);
                      sendDataFromBottomBar(index);
                      // }
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
                  bloc: getIt.get<NetworkBloc>(),
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
          ),
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
        );
      }),
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
      label: 'Cửa hàng',
      urlSelect: 'assets/images/ic-store-bottom-bar-blue.png',
      urlUnselect: 'assets/images/ic-store-bottom-bar-grey.png',
      index: PageType.STORE.pageIndex,
    ),
    // CurvedNavigationBarItem(
    //   label: 'Cửa hàng',
    //   urlSelect: '',
    //   urlUnselect: '',
    //   index: PageType.PERSON.pageIndex,
    //   child: Consumer<AuthProvider>(builder: (context, provider, _) {
    //     String imgId = SharePrefUtils.getProfile().imgId;
    //     return Container(
    //       width: 28,
    //       height: 28,
    //       padding: EdgeInsets.all(1),
    //       decoration: provider.pageSelected == PageType.PERSON.pageIndex
    //           ? BoxDecoration(
    //               border: Border.all(color: AppColor.BLUE_TEXT, width: 1),
    //               borderRadius: BorderRadius.circular(28),
    //               color: Colors.white,
    //             )
    //           : BoxDecoration(),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           shape: BoxShape.circle,
    //           image: DecorationImage(
    //             fit: BoxFit.cover,
    //             image: provider.avatarUser.path.isEmpty
    //                 ? (imgId.isNotEmpty
    //                     ? ImageUtils.instance.getImageNetWork(imgId)
    //                     : Image.asset('assets/images/ic-avatar.png').image)
    //                 : Image.file(provider.avatarUser).image,
    //           ),
    //         ),
    //       ),
    //     );
    //   }),
    // ),
  ];

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

class SaveImageData {
  SaveImageData({required this.progress, this.index, this.isDone = false});

  Uint8List progress;
  int? index;
  bool isDone;
}
