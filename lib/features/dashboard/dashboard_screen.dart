import 'dart:async';

import 'package:float_bubble/float_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/ambient_avatar_widget.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/account/account_screen.dart';
import 'package:vierqr/features/bank_card/bank_screen.dart';
import 'package:vierqr/features/business/views/business_screen.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/features/dashboard/widget/background_app_bar_home.dart';
import 'package:vierqr/features/dashboard/widget/maintain_widget.dart';
import 'package:vierqr/features/home/home.dart';
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features/notification/events/notification_event.dart';
import 'package:vierqr/features/notification/states/notification_state.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_card_insert_unauthenticated.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/services/providers/account_balance_home_provider.dart';
import 'package:vierqr/services/providers/avatar_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dash_board_provider.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/providers/auth_provider.dart';
import 'package:vierqr/services/shared_references/qr_scanner_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'events/dashboard_event.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _dashBoardBloc = BlocProvider.of(context);
    _notificationBloc = BlocProvider.of(context);
    _pageController = PageController(
      initialPage:
          Provider.of<DashBoardProvider>(context, listen: false).indexSelected,
      keepPage: true,
    );
    _listScreens.addAll(
      [
        const BankScreen(key: PageStorageKey('QR_GENERATOR_PAGE')),
        const HomeScreen(key: PageStorageKey('HOME_PAGE')),
        const BusinessScreen(key: PageStorageKey('SMS_LIST_PAGE')),
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
  }

  void startBarcodeScanStream() async {
    final data = await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
    if (data is Map<String, dynamic>) {
      if (!mounted) return;
      QRScannerUtils.instance.onScanNavi(
        data,
        context,
        onTapSave: (data) {
          _dashBoardBloc.add(DashBoardEventAddContact(dto: data));
        },
        onTapAdd: (data) {
          _dashBoardBloc.add(DashBoardCheckExistedEvent(
              bankAccount: data['bankAccount'],
              bankTypeId: data['bankTypeId']));
        },
      );
    }
  }

  void initialServices(BuildContext context) {
    checkUserInformation();
    _dashBoardBloc.add(const TokenEventCheckValid());
    _dashBoardBloc.add(const PermissionEventRequest());
    if (Provider.of<AuthProvider>(context, listen: false).introduceDTO ==
        null) {
      _dashBoardBloc.add(GetPointEvent());
    }
    _dashBoardBloc.add(GetVersionAppEvent());
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
        _dashBoardBloc.add(const PermissionEventGetStatus());
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
      _dashBoardBloc.add(const TokenFcmUpdateEvent());
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

    return BlocListener<DashBoardBloc, DashBoardState>(
      listener: (context, state) async {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state.status == BlocStatus.UNLOADING) {
          Navigator.pop(context);
        }

        if (state.request == DashBoardType.POINT) {
          Provider.of<AuthProvider>(context, listen: false)
              .updateIntroduceDTO(state.introduceDTO);
        }

        if (state.request == DashBoardType.APP_VERSION) {
          Provider.of<AuthProvider>(context, listen: false)
              .updateAppInfoDTO(state.appInfoDTO, isCheckApp: state.isCheckApp);
        }

        if (state.request == DashBoardType.TOKEN) {
          if (state.typeToken == TokenType.Valid) {
            _updateFcmToken(isFromLogin);
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
              StringUtils.instance.capitalFirstCharacter(
                  state.informationDTO?.accountName ?? ''));
          BankCardInsertUnauthenticatedDTO dto =
              BankCardInsertUnauthenticatedDTO(
            bankTypeId: state.bankTypeDTO?.id ?? '',
            userId: userId,
            userBankName: formattedName,
            bankAccount: state.bankAccount,
          );
          _dashBoardBloc.add(DashBoardEventInsertUnauthenticated(dto: dto));
        }

        if (state.request == DashBoardType.INSERT_BANK) {
          if (!mounted) return;
          eventBus.fire(ChangeThemeEvent());
          Navigator.of(context).pop(true);
        }

        if (state.request == DashBoardType.ERROR) {
          await DialogWidget.instance
              .openMsgDialog(title: 'Không thể thêm TK', msg: state.msg ?? '');
        }

        if (state.status != BlocStatus.NONE ||
            state.request != DashBoardType.NONE ||
            state.typeQR != TypeQR.NONE ||
            state.typePermission == DashBoardTypePermission.None) {
          _dashBoardBloc.add(UpdateEvent());
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildAppBar(),
            Column(
              children: [
                Expanded(
                  child: Consumer<DashBoardProvider>(
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
                              Provider.of<DashBoardProvider>(context,
                                      listen: false)
                                  .updateMoveEvent(TypeMoveEvent.RIGHT);
                            } else {
                              Provider.of<DashBoardProvider>(context,
                                      listen: false)
                                  .updateMoveEvent(TypeMoveEvent.LEFT);
                            }
                          },
                          child: PageView(
                            key: const PageStorageKey('PAGE_VIEW'),
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _pageController,
                            onPageChanged: (index) async {
                              Provider.of<DashBoardProvider>(context,
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
            Consumer<AuthProvider>(
              builder: (context, provider, child) {
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
                );
              },
            )
          ],
        ),
        bottomNavigationBar: Consumer<DashBoardProvider>(
          builder: (context, page, child) {
            return Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(color: AppColor.GREY_TOP_TAB_BAR)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          },
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
        initialPage: Provider.of<DashBoardProvider>(context, listen: false)
            .indexSelected,
        keepPage: true,
      );
      _animatedToPage(index);
    }
  }

//get title page
  Widget _getTitlePaqe(BuildContext context, int indexSelected) {
    Widget titleWidget = const SizedBox();
    if (indexSelected == 0 || indexSelected == 1 || indexSelected == 2) {
      titleWidget = ButtonIconWidget(
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
    }

    if (indexSelected == 3) {
      titleWidget = const SizedBox.shrink();
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
    return BackgroundAppBarHome(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Consumer<DashBoardProvider>(builder: (context, page, child) {
          if (page.indexSelected == 3) {
            return const SizedBox.shrink();
          }
          return Row(
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _getTitlePaqe(context, page.indexSelected),
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
                    Provider.of<DashBoardProvider>(context, listen: false)
                        .updateIndex(4);

                    _animatedToPage(4);
                  },
                  child: _buildAvatarWidget(context)),
            ],
          );
        }),
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
