import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:float_bubble/float_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
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
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features/notification/events/notification_event.dart';
import 'package:vierqr/features/notification/states/notification_state.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_card_insert_unauthenticated.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/providers/account_balance_home_provider.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/services/shared_references/qr_scanner_helper.dart';
import 'package:vierqr/services/shared_references/theme_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'curved_navi_bar/custom_navigation_bar.dart';
import 'events/dashboard_event.dart';
import 'package:http/http.dart' as http;

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
  StreamSubscription? _subscription;
  StreamSubscription? _subReloadWallet;
  StreamSubscription? _subSyncContact;

  //list page
  final List<Widget> _listScreens = [];

  //focus node
  final FocusNode focusNode = FocusNode();

  //blocs
  late DashBoardBloc _dashBoardBloc;
  late NotificationBloc _notificationBloc;

  //notification count
  int _notificationCount = 0;

  NationalScannerDTO? identityDTO;

  //providers
  final accountBalanceHomeProvider = AccountBalanceHomeProvider('');

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initConnectivity();
    _dashBoardBloc = BlocProvider.of(context);
    _notificationBloc = BlocProvider.of(context);
    _pageController = PageController(
      initialPage:
          Provider.of<AuthProvider>(context, listen: false).pageSelected,
      keepPage: true,
    );
    _listScreens.addAll(
      [
        const BankScreen(key: PageStorageKey('QR_GENERATOR_PAGE')),
        const HomeScreen(key: PageStorageKey('HOME_PAGE')),
        const SizedBox(key: PageStorageKey('SCAN_PAGE')),
        const ContactScreen(key: PageStorageKey('CONTACT_PAGE')),
        const AccountScreen(key: const PageStorageKey('USER_SETTING_PAGE')),
      ],
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialServices(context);
      listenNewNotification();
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

    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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

  static void saveImageTask(List<dynamic> args) async {
    SendPort sendPort = args[0];
    List<ThemeDTO> list = args[1];

    for (var message in list) {
      final response = await http.get(Uri.parse(message.imgUrl));
      final bytes = response.bodyBytes;
      sendPort
          .send(SaveImageData(progress: bytes, index: list.indexOf(message)));
    }
    sendPort.send(SaveImageData(progress: Uint8List(0), isDone: true));
  }

  Future<void> _saveImageTaskStreamReceiver(List<ThemeDTO> list) async {
    List<ThemeDTO> listThemeLocal = [];
    final receivePort = ReceivePort();
    Isolate.spawn(saveImageTask, [receivePort.sendPort, list]);
    await for (var message in receivePort) {
      if (message is SaveImageData) {
        if (message.index != null) {
          ThemeDTO dto = list[message.index!];

          String path = dto.imgUrl.split('/').last;
          if (path.contains('.png')) {
            path.replaceAll('.png', '');
          }

          String localPath = await saveImageToLocal(message.progress, path);
          dto.file = localPath;
          listThemeLocal.add(dto);
        }

        if (message.isDone) {
          receivePort.close();
          if (!mounted) return;
          Provider.of<AuthProvider>(context, listen: false)
              .updateListTheme(listThemeLocal, saveLocal: true);
          return;
        }
      }
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
              userId: UserInformationHelper.instance.getUserId(),
              additionalData: e.notes.isNotEmpty ? e.notes.first.note : '',
            );

            listVCards.add(contact);
          }
        }

        if (message.progress >= 1) {
          receivePort.close();
          eventBus.fire(SentDataToContact(listVCards, list.length));
          Provider.of<AuthProvider>(context, listen: false).updateSync(false);
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

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      LOG.error('Couldn\'t check connectivity status $e');
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future checkConnection() async {
    bool isInternet =
        Provider.of<AuthProvider>(context, listen: false).isInternet;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (isInternet) {
          Provider.of<AuthProvider>(context, listen: false)
              .updateInternet(false, TypeInternet.CONNECT);
          _onChangeInternet(false);
        }
      } else {
        if (!isInternet) {
          Provider.of<AuthProvider>(context, listen: false)
              .updateInternet(true, TypeInternet.DISCONNECT);
          _onChangeInternet(true);
        }
      }
    } on SocketException catch (_) {
      if (!isInternet) {
        Provider.of<AuthProvider>(context, listen: false)
            .updateInternet(true, TypeInternet.DISCONNECT);
        _onChangeInternet(true);
      }
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (!mounted) return;
    bool isInternet =
        Provider.of<AuthProvider>(context, listen: false).isInternet;
    if (result == ConnectivityResult.none) {
      if (!isInternet) {
        Provider.of<AuthProvider>(context, listen: false)
            .updateInternet(true, TypeInternet.DISCONNECT);
        _onChangeInternet(true);
      }
    } else {
      checkConnection();
    }
  }

  Future _onChangeInternet(bool isInternet) async {
    await Future.delayed(Duration(seconds: 3)).then((v) {
      if (!mounted) return;
      Provider.of<AuthProvider>(context, listen: false)
          .updateInternet(isInternet, TypeInternet.NONE);
    });
  }

  void initialServices(BuildContext context) {
    _dashBoardBloc.add(const TokenEventCheckValid());
    _dashBoardBloc.add(GetPointEvent());
    if (Provider.of<AuthProvider>(context, listen: false).introduceDTO ==
        null) {
      _dashBoardBloc.add(GetPointEvent());
    }
    _dashBoardBloc.add(GetUserInformation());
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
        // _dashBoardBloc.add(const PermissionEventGetStatus());
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _subscription = null;
    _subReloadWallet?.cancel();
    _subReloadWallet = null;
    _subSyncContact?.cancel();
    _subSyncContact = null;
    if (_connectivitySubscription != null) {
      _connectivitySubscription!.cancel();
    }
    super.dispose();
  }

  void _updateFcmToken(bool isFromLogin) {
    if (!isFromLogin) {
      _dashBoardBloc.add(const TokenFcmUpdateEvent());
    }
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

        if (state.request == DashBoardType.THEMES) {
          List<ThemeDTO> list = [...state.themes];
          list.sort((a, b) => a.type.compareTo(b.type));

          Provider.of<AuthProvider>(context, listen: false)
              .updateListTheme(list);

          int themeVerLocal = ThemeHelper.instance.getThemeKey();
          int themeVerSetting =
              Provider.of<AuthProvider>(context, listen: false).themeVer;
          List<ThemeDTO> listLocal = await UserRepository.instance.getThemes();

          if (themeVerLocal != themeVerSetting || listLocal.isEmpty) {
            _saveImageTaskStreamReceiver(list);
          }
        }

        if (state.request == DashBoardType.GET_USER_SETTING) {
          Provider.of<AuthProvider>(context, listen: false).updateSettingDTO(
              UserInformationHelper.instance.getAccountSetting());
        }
        if (state.request == DashBoardType.KEEP_BRIGHT) {
          Provider.of<AuthProvider>(context, listen: false)
              .updateKeepBright(state.keepValue);
        }

        if (state.request == DashBoardType.POINT) {
          Provider.of<AuthProvider>(context, listen: false)
              .updateIntroduceDTO(state.introduceDTO);
        }

        if (state.request == DashBoardType.APP_VERSION) {
          if (state.appInfoDTO != null) {
            Provider.of<AuthProvider>(context, listen: false)
                .updateThemeVer(state.appInfoDTO!.themeVer);
          }

          //gọi ở đây để check nếu themeVer có thay đổi hay k
          _dashBoardBloc.add(GetListThemeEvent());

          Provider.of<AuthProvider>(context, listen: false)
              .updateAppInfoDTO(state.appInfoDTO, isCheckApp: state.isCheckApp);
          if (Provider.of<AuthProvider>(context, listen: false)
              .isUpdateVersion) {
            if (!state.isCheckApp)
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
        if (state.request == DashBoardType.TOKEN) {
          if (state.typeToken == TokenType.Valid) {
            _updateFcmToken(widget.isFromLogin);
          } else if (state.typeToken == TokenType.MainSystem) {
            await DialogWidget.instance.showFullModalBottomContent(
              isDissmiss: false,
              widget: MaintainWidget(tokenBloc: _dashBoardBloc),
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

        if (state.request == DashBoardType.ADD_BOOK_CONTACT) {
          if (!mounted) return;
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: 'Đã thêm vào danh bạ',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
            webBgColor: 'rgba(255, 255, 255)',
            webPosition: 'center',
          );

          Future.delayed(const Duration(milliseconds: 400), () {
            Navigator.pushNamed(context, Routes.PHONE_BOOK);
          });
        }
        if (state.request == DashBoardType.ADD_BOOK_CONTACT_EXIST) {
          DialogWidget.instance.openMsgDialog(
            title: 'Thất bại',
            msg: 'Tài khoản đã tồn tại trong danh bạ',
            function: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          );
        }

        if (state.request == DashBoardType.EXIST_BANK) {
          String userId = UserInformationHelper.instance.getUserId();
          String formattedName = StringUtils.instance.removeDiacritic(
              StringUtils.instance
                  .capitalFirstCharacter(state.qrDto?.userBankName ?? ''));
          BankCardInsertUnauthenticatedDTO dto =
              BankCardInsertUnauthenticatedDTO(
            bankTypeId: state.qrDto?.bankTypeId ?? '',
            userId: userId,
            userBankName: formattedName,
            bankAccount: state.qrDto?.bankAccount ?? '',
          );
          _dashBoardBloc.add(DashBoardEventInsertUnauthenticated(dto: dto));
        }

        if (state.request == DashBoardType.INSERT_BANK) {
          if (!mounted) return;
          eventBus.fire(GetListBankScreen());
          Navigator.of(context).pop(true);
          Fluttertoast.showToast(
            msg: 'Thêm TK thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).cardColor,
            fontSize: 15,
          );
        }

        if (state.request == DashBoardType.ERROR) {
          await DialogWidget.instance
              .openMsgDialog(title: 'Không thể thêm TK', msg: state.msg ?? '');
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
              Column(
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          (provider.pageSelected.pageType == PageType.PERSON)
                              ? EdgeInsets.zero
                              : const EdgeInsets.only(top: kToolbarHeight * 2),
                      child: Listener(
                        onPointerMove: (moveEvent) {
                          if (moveEvent.delta.dx > 0) {
                            provider.updateMoveEvent(TypeMoveEvent.RIGHT);
                          } else {
                            provider.updateMoveEvent(TypeMoveEvent.LEFT);
                          }
                        },
                        child: PageView(
                          key: const PageStorageKey('PAGE_VIEW'),
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (index) async {
                            provider.updateIndex(index);
                          },
                          children: _listScreens,
                        ),
                      ),
                    ),
                  ),
                ],
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
                bottom: 10,
                left: 20,
                right: 20,
                child: DisconnectWidget(type: provider.typeInternet),
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
                index: PageType.SCAN_QR.pageIndex,
                iconPadding: 0.0,
                onTap: (index) async {
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
                },
                items: _listNavigation);
          },
        ),
      ),
    );
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
        initialPage:
            Provider.of<AuthProvider>(context, listen: false).pageSelected,
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
                            imageUrl: page.settingDTO.logoUrl,
                            width: 50,
                          ),
                        )
                      else
                        Container(
                          width: 60,
                          height: 30,
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: _getTitlePage(context, page.pageSelected),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 60,
                        child:
                            BlocConsumer<NotificationBloc, NotificationState>(
                          listener: (context, state) {},
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
                                          fontSize: (_notificationCount
                                                      .toString()
                                                      .length >=
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
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  List<CurvedNavigationBarItem> _listNavigation = [
    CurvedNavigationBarItem(
      label: 'Tài khoản',
      urlSelect: 'assets/images/ic-btm-list-bank-blue.png',
      urlUnselect: 'assets/images/ic-btm-list-bank-grey.png',
    ),
    CurvedNavigationBarItem(
      label: 'Trang chủ',
      urlSelect: 'assets/images/ic-btm-dashboard-blue.png',
      urlUnselect: 'assets/images/ic-btm-dashboard-grey.png',
    ),
    CurvedNavigationBarItem(
      label: 'Quét QR',
      urlSelect: 'assets/images/ic-menu-slide-home-blue.png',
      urlUnselect: 'assets/images/ic-menu-slide-home-blue.png',
    ),
    CurvedNavigationBarItem(
      label: 'Ví QR',
      urlSelect: 'assets/images/ic-btm-qr-wallet-blue.png',
      urlUnselect: 'assets/images/ic-btm-qr-wallet-grey.png',
    ),
    CurvedNavigationBarItem(
      label: 'Cá nhân',
      urlSelect: '',
      urlUnselect: '',
      child: Consumer<AuthProvider>(builder: (context, provider, _) {
        String imgId =
            UserInformationHelper.instance.getAccountInformation().imgId;
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: provider.avatar.path.isEmpty
                  ? ImageUtils.instance.getImageNetWork(imgId)
                  : Image.file(provider.avatar).image,
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
