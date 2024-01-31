import 'dart:async';
import 'dart:io';

import 'package:float_bubble/float_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/phone_widget.dart';
import 'package:vierqr/features/contact_us/contact_us_screen.dart';
import 'package:vierqr/features/create_qr_un_authen/create_qr_un_quthen.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/home/widget/dialog_update.dart';
import 'package:vierqr/features/home/widget/nfc_adr_widget.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/login/blocs/login_provider.dart';
import 'package:vierqr/features/login/events/login_event.dart';
import 'package:vierqr/features/login/states/login_state.dart';
import 'package:vierqr/features/login/views/login_account_screen.dart';
import 'package:vierqr/features/login/views/quick_login_screen.dart';
import 'package:vierqr/features/register/register_screen.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/info_user_dto.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';
import 'package:vierqr/services/shared_references/theme_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'views/bgr_app_bar_login.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => LoginBloc(),
      child: ChangeNotifierProvider<LoginProvider>(
        create: (_) => LoginProvider()..init(),
        child: _Login(),
      ),
    );
  }
}

class _Login extends StatefulWidget {
  @override
  State<_Login> createState() => _LoginState();
}

class _LoginState extends State<_Login> {
  final phoneNoController = TextEditingController();
  final passController = TextEditingController();

  final passFocus = FocusNode();

  String code = '';

  Uuid uuid = const Uuid();

  late LoginBloc _bloc;

  var controller = StreamController<AccountLoginDTO?>.broadcast();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    code = uuid.v1();
    controller.stream.listen((value) async {
      if (value != null) {
        if (value.method == 'NFC_CARD') {
          RawKeyboard.instance.removeListener(_onListenerRFID);
        } else {
          if (Platform.isAndroid) {
            await NfcManager.instance.stopSession();
          } else {
            await NfcManager.instance.stopSession(alertMessage: '');
          }
        }

        _bloc.add(LoginEventByNFC(dto: value));
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).updateEventTheme(null);
      Provider.of<AuthProvider>(context, listen: false)
          .updateFileThemeLogin('');
      Provider.of<AuthProvider>(context, listen: false).initThemeDTO();
      Provider.of<AuthProvider>(context, listen: false).updateFileLogo('');
    });

    _bloc.add(GetFreeToken());
  }

  @override
  void dispose() {
    phoneNoController.clear();
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLogoutEnterHome = false;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final arg = ModalRoute.of(context)!.settings.arguments as Map;
      isLogoutEnterHome = arg['isLogout'] ?? false;
    }
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        return BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state.status == BlocStatus.LOADING) {
              DialogWidget.instance.openLoadingDialog();
            }
            if (state.status == BlocStatus.UNLOADING) {
              Navigator.of(context).pop();
            }

            if (state.request == LoginType.FREE_TOKEN) {
              _bloc.add(GetVersionAppEvent(isCheckVer: state.isCheckApp));
            }
            if (state.request == LoginType.APP_VERSION) {
              if (state.appInfoDTO != null) {
                provider.updateAppInfo(state.appInfoDTO);

                int logoVersion = ThemeHelper.instance.getLogoVer();
                int themeVersion = ThemeHelper.instance.getThemeVerLogin();
                bool isEventTheme = ThemeHelper.instance.getEventTheme();

                if (logoVersion != state.appInfoDTO!.logoVer) {
                  ThemeHelper.instance.updateLogoVer(state.appInfoDTO!.logoVer);
                  String path = state.appInfoDTO!.logoUrl.split('/').last;
                  if (path.contains('.png')) {
                    path.replaceAll('.png', '');
                  }
                  String localPath = await downloadAndSaveImage(
                      state.appInfoDTO!.logoUrl, path);

                  ThemeHelper.instance.updateLogoTheme(localPath);
                  Provider.of<AuthProvider>(context, listen: false)
                      .updateFileLogo(localPath);
                }

                if (themeVersion != state.appInfoDTO!.themeVer) {
                  if (state.appInfoDTO!.isEventTheme) {
                    String path = state.appInfoDTO!.themeImgUrl.split('/').last;
                    if (path.contains('.png')) {
                      path.replaceAll('.png', '');
                    }
                    String localPath = await downloadAndSaveImage(
                        state.appInfoDTO!.themeImgUrl, path);

                    ThemeHelper.instance.updateThemeLogin(localPath);
                    ThemeHelper.instance
                        .updateThemeVerLogin(state.appInfoDTO!.themeVer);
                    Provider.of<AuthProvider>(context, listen: false)
                        .updateFileThemeLogin(localPath);
                  }
                }

                if (isEventTheme != state.appInfoDTO!.isEventTheme) {
                  ThemeHelper.instance
                      .updateEventTheme(state.appInfoDTO!.isEventTheme);
                  Provider.of<AuthProvider>(context, listen: false)
                      .updateEventTheme(state.appInfoDTO!.isEventTheme);
                }
              }
              Provider.of<AuthProvider>(context, listen: false)
                  .updateAppInfoDTO(state.appInfoDTO,
                      isCheckApp: state.isCheckApp);
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
                          _bloc.add(GetFreeToken(isCheckVer: true));
                        },
                      );
                    },
                  );
              }
            }

            if (state.request == LoginType.TOAST) {
              if (provider.infoUserDTO != null) {
                List<String> list = _saveAccount(provider);

                await UserInformationHelper.instance.setLoginAccount(list);
                provider.updateListInfoUser();
              }

              Provider.of<AuthProvider>(context, listen: false).initThemeDTO();

              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DashBoardScreen(
                    isFromLogin: true,
                    isLogoutEnterHome: isLogoutEnterHome,
                  ),
                  settings: RouteSettings(name: DashBoardScreen.routeName),
                ),
              );

              if (state.isToast) {
                Fluttertoast.showToast(
                  msg: 'Đăng ký thành công',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Theme.of(context).hintColor,
                  fontSize: 15,
                );
              }
            }
            if (state.request == LoginType.CHECK_EXIST) {
              provider.updateQuickLogin(2);
              provider.updateInfoUser(state.infoUserDTO);
            }

            if (state.request == LoginType.ERROR) {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.of(context).pop();
              //pop loading dialog
              //show msg dialog
              await DialogWidget.instance.openMsgDialog(
                title: 'Không thể đăng nhập',
                msg: state.msg ?? '',
                // 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập.',
              );

              passController.clear();
              passFocus.requestFocus();
            }
            if (state.request == LoginType.REGISTER) {
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              if (keyboardHeight > 0.0) {
                FocusManager.instance.primaryFocus?.unfocus();
              }

              if (!mounted) return;
              final data = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Register(
                    phoneNo: state.phone ?? '',
                    isFocus: false,
                  ),
                  settings: const RouteSettings(
                    name: Routes.REGISTER,
                  ),
                ),
              );

              if (data is Map) {
                AccountLoginDTO dto = AccountLoginDTO(
                  phoneNo: data['phone'],
                  password: EncryptUtils.instance.encrypted(
                    data['phone'],
                    data['password'],
                  ),
                  device: '',
                  fcmToken: '',
                  platform: '',
                  sharingCode: '',
                );
                if (!mounted) return;
                context
                    .read<LoginBloc>()
                    .add(LoginEventByPhone(dto: dto, isToast: true));
              }

              if (state.request != LoginType.NONE ||
                  state.status != BlocStatus.NONE) {
                _bloc.add(UpdateEvent());
              }
            }
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                if (!mounted) return;
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    Visibility(
                      visible: provider.isQuickLogin == 0,
                      child: Scaffold(
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Consumer<AuthProvider>(
                                      builder: (context, page, child) {
                                        return BackgroundAppBarLogin(
                                          file: page.isEventTheme
                                              ? page.fileThemeLogin
                                              : page.file,
                                          url: provider.appInfoDTO.themeImgUrl,
                                          isEventTheme:
                                              provider.appInfoDTO.isEventTheme,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              height: 100,
                                              width: width / 2,
                                              margin: const EdgeInsets.only(
                                                  top: 50),
                                              decoration: BoxDecoration(
                                                image: page.fileLogo.path
                                                        .isNotEmpty
                                                    ? DecorationImage(
                                                        image: FileImage(
                                                            page.fileLogo),
                                                        fit: BoxFit.contain,
                                                      )
                                                    : DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/logo_vietgr_payment.png'),
                                                        fit: BoxFit.contain,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Column(
                                        children: [
                                          PhoneWidget(
                                            phoneController: phoneNoController,
                                            onChanged: provider.updatePhone,
                                            autoFocus:
                                                provider.isQuickLogin == 0,
                                          ),
                                          Visibility(
                                            visible:
                                                provider.errorPhone != null,
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              padding: const EdgeInsets.only(
                                                  left: 5, top: 5, right: 30),
                                              child: Text(
                                                provider.errorPhone ?? '',
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    color: AppColor.RED_TEXT,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                    height: 0.5,
                                                    color: AppColor.BLACK
                                                        .withOpacity(0.6)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(
                                                  'Hoặc',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                    height: 0.5,
                                                    color: AppColor.BLACK
                                                        .withOpacity(0.6)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: MButtonWidget(
                                                  title: '',
                                                  isEnable: true,
                                                  colorEnableBgr:
                                                      AppColor.WHITE,
                                                  margin: EdgeInsets.zero,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                          'assets/images/ic-card.png'),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        'VQR ID Card',
                                                        style: height < 800
                                                            ? TextStyle(
                                                                fontSize: 10)
                                                            : TextStyle(
                                                                fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: onLoginCard,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            MButtonWidget(
                              title: 'Tiếp tục',
                              isEnable: provider.isEnableButton,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              colorEnableText: provider.isEnableButton
                                  ? AppColor.WHITE
                                  : AppColor.GREY_TEXT,
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                _bloc.add(CheckExitsPhoneEvent(
                                    phone: provider.phone));
                              },
                            ),
                            SizedBox(height: height < 800 ? 0 : 16),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: provider.isQuickLogin == 1,
                      child: LoginAccountScreen(
                        list: provider.listInfoUsers,
                        appInfoDTO: provider.appInfoDTO,
                        onRemoveAccount: (dto) async {
                          List<String> listString = [];
                          List<InfoUserDTO> list = provider.listInfoUsers;
                          list.removeAt(dto);
                          if (list.length >= 2) {
                            list.sort((a, b) => a.expiryAsDateTime
                                .compareTo(b.expiryAsDateTime));
                          }

                          list.forEach((element) {
                            listString.add(element.toSPJson().toString());
                          });

                          await UserInformationHelper.instance
                              .setLoginAccount(listString);

                          provider.updateListInfoUser();

                          if (list.isEmpty) {
                            provider.updateQuickLogin(0);
                          }
                        },
                        onQuickLogin: (dto) {
                          provider.updateQuickLogin(2);
                          provider.updateInfoUser(dto);
                        },
                        onBackLogin: () {
                          provider.updateInfoUser(null);
                          provider.updateQuickLogin(0);
                        },
                        onRegister: () async {
                          provider.updateInfoUser(null);
                          final data = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Register(
                                phoneNo: '',
                                isFocus: true,
                              ),
                              settings: const RouteSettings(
                                name: Routes.REGISTER,
                              ),
                            ),
                          );

                          if (data is Map) {
                            AccountLoginDTO dto = AccountLoginDTO(
                              phoneNo: data['phone'],
                              password: EncryptUtils.instance.encrypted(
                                data['phone'],
                                data['password'],
                              ),
                              device: '',
                              fcmToken: '',
                              platform: '',
                              sharingCode: '',
                            );
                            if (!mounted) return;
                            context.read<LoginBloc>().add(
                                LoginEventByPhone(dto: dto, isToast: true));
                          }
                        },
                        onLoginCard: onLoginCard,
                        child: _buildButtonBottom(state.appInfoDTO),
                        buttonNext: MButtonWidget(
                          title: 'Tiếp tục',
                          isEnable: true,
                          onTap: () async {
                            await provider
                                .updateInfoUser(provider.listInfoUsers.first);
                            provider.updateQuickLogin(2);
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: provider.isQuickLogin == 2,
                      child: QuickLoginScreen(
                        pinController: passController,
                        passFocus: passFocus,
                        userName: provider.infoUserDTO?.fullName ?? '',
                        phone: provider.infoUserDTO?.phoneNo ?? '',
                        onLogin: (dto) {
                          context
                              .read<LoginBloc>()
                              .add(LoginEventByPhone(dto: dto));
                        },
                        onQuickLogin: () {
                          passController.clear();
                          provider.updateQuickLogin(0);
                          provider.updateInfoUser(null);
                        },
                        appInfoDTO: provider.appInfoDTO,
                      ),
                    ),
                    Positioned(
                      bottom: height < 800 ? 50 : 66,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          if (provider.isQuickLogin != 1)
                            _buildButtonBottom(state.appInfoDTO),
                          SizedBox(height: 16),
                          if (provider.isQuickLogin == 0 ||
                              provider.isQuickLogin == 2)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Consumer<LoginProvider>(
                                  builder: (context, auth, child) {
                                    if (auth.listInfoUsers.isNotEmpty) {
                                      return Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: GestureDetector(
                                          onTap: () async {
                                            provider.updateQuickLogin(1);
                                          },
                                          child: const Text(
                                            'Đăng nhập bằng tài khoản trước đó',
                                            style: TextStyle(
                                                color: AppColor.BLUE_TEXT,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                              ],
                            ),
                          SizedBox(height: height < 800 ? 16 : 20),
                        ],
                      ),
                    ),
                    Consumer<AuthProvider>(
                      builder: (context, provider, child) {
                        return Positioned(
                          bottom: 80,
                          left: 0,
                          right: 0,
                          top: 0,
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
                                          mode: LaunchMode
                                              .externalApplication)) {}
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
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildButtonBottom(AppInfoDTO? appInfoDTO) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCustomButtonIcon(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              _bloc.add(GetFreeToken());
              final data = await Navigator.pushNamed(
                context,
                Routes.SCAN_QR_VIEW,
              );
              if (data != null) {
                if (data is Map<String, dynamic>) {
                  if (!mounted) return;
                  await QRScannerUtils.instance.onScanNavi(
                    data,
                    context,
                    isShowIconFirst: false,
                  );
                  await AccountHelper.instance.setTokenFree('');
                }
              }
            },
            title: 'Quét QR',
            pathIcon: 'assets/images/qr-contact-other-blue.png',
          ),
          _buildCustomButtonIcon(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              NavigatorUtils.navigatePage(
                  context, CreateQrUnQuthen(appInfo: appInfoDTO),
                  routeName: CreateQrUnQuthen.routeName);
            },
            title: 'Tạo mã VietQR',
            pathIcon: 'assets/images/ic-viet-qr-small.png',
          ),
          _buildCustomButtonIcon(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              NavigatorUtils.navigatePage(
                  context,
                  ContactUSScreen(
                    appInfoDTO: appInfoDTO ?? AppInfoDTO(),
                  ),
                  routeName: ContactUSScreen.routeName);
            },
            title: 'Liên hệ',
            pathIcon: 'assets/images/ic-introduce.png',
          ),
          _buildCustomButtonIcon(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              showDialog(
                barrierDismissible: false,
                context: NavigationService.navigatorKey.currentContext!,
                builder: (BuildContext context) {
                  return DialogUpdateView(
                    onCheckUpdate: () {
                      _bloc.add(GetFreeToken(isCheckVer: true));
                    },
                  );
                },
              );
            },
            title: 'Phiên bản app',
            pathIcon: 'assets/images/ic-gear.png',
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButtonIcon({
    required String title,
    required Function() onTap,
    required String pathIcon,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColor.WHITE,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                pathIcon,
                height: 36,
                width: 36,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }

  String readTagToKey(NfcTag tag, String userId) {
    String card = '';
    Object? tech;
    if (Platform.isIOS) {
      tech = FeliCa.from(tag);
      if (tech is FeliCa) {
        card = '${tech.currentSystemCode.toHexString()}'.replaceAll(' ', '');
        return card;
      }

      tech = Iso15693.from(tag);
      if (tech is Iso15693) {
        card = '${tech.identifier.toHexString()}'.replaceAll(' ', '');
        return card;
      }

      tech = Iso7816.from(tag);
      if (tech is Iso7816) {
        card = '${tech.identifier.toHexString()}'.replaceAll(' ', '');
        return card;
      }

      tech = MiFare.from(tag);
      if (tech is MiFare) {
        card = '${tech.identifier.toHexString()}'.replaceAll(' ', '');
        return card;
      }
      tech = Ndef.from(tag);
      if (tech is Ndef) {
        return card;
      }
    } else if (Platform.isAndroid) {
      tech = IsoDep.from(tag);
      if (tech is NfcA) {
        card = '${tech.identifier.toHexString()}'.replaceAll(' ', '');
        return card;
      }

      tech = NfcA.from(tag);
      if (tech is NfcA) {
        card = '${tech.identifier.toHexString()}'.replaceAll(' ', '');
        return card;
      }
      tech = NfcB.from(tag);
      if (tech is NfcB) {
        card = '${tech.identifier.toHexString()}'.replaceAll(' ', '');
        return card;
      }
      tech = NfcF.from(tag);
      if (tech is NfcF) {
        card = '${tech.identifier.toHexString()}'.replaceAll(' ', '');
        return card;
      }
      tech = NfcV.from(tag);
      if (tech is NfcV) {
        card = '${tech.identifier.toHexString()}'.replaceAll(' ', '');
        return card;
      }

      tech = MifareClassic.from(tag);
      if (tech is MifareClassic) {
        card = '${tech.identifier.toHexString()}'.replaceAll(' ', '');
        return card;
      }
      tech = MifareUltralight.from(tag);
      if (tech is MifareUltralight) {
        card = '${tech.identifier.toHexString()}'.replaceAll(' ', '');
        return card;
      }
    }

    return card;
  }

  NfcTag? tag;

  Map<String, dynamic>? additionalData;

  Future<Map<String, dynamic>?> handleTag(NfcTag tag) async {
    String card = readTagToKey(tag, '');

    return {
      'message': 'Hoàn tất.',
      'value': card,
    };
  }

  void onReadNFC() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(await NfcManager.instance.isAvailable())) {
      return DialogWidget.instance.openMsgDialog(
        title: 'Thông báo',
        msg: 'NFC có thể không được hỗ trợ hoặc có thể tạm thời bị tắt.',
        function: () {
          Navigator.pop(context);
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      );
    }

    await NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
        NfcPollingOption.iso18092,
      },
      onDiscovered: (tag) async {
        try {
          final result = await handleTag(tag);
          if (result == null) return;
          if (Platform.isAndroid) {
            await NfcManager.instance.stopSession();
          } else {
            await NfcManager.instance
                .stopSession(alertMessage: result['message']);
          }

          Future.delayed(const Duration(seconds: 2), () {
            AccountLoginDTO dto = AccountLoginDTO(
              phoneNo: '',
              password: '',
              device: '',
              fcmToken: '',
              platform: '',
              sharingCode: '',
              method: 'NFC_CARD',
              userId: '',
              cardNumber: result['value'],
            );
            controller.sink.add(dto); //
          });
        } catch (e) {
          if (Platform.isAndroid) {
            await NfcManager.instance.stopSession();
          } else {
            await NfcManager.instance.stopSession(alertMessage: '');
          }
        }
      },
      onError: (e) async {
        RawKeyboard.instance.removeListener(_onListenerRFID);
        if (Platform.isAndroid) {
          await NfcManager.instance.stopSession();
        } else {
          await NfcManager.instance.stopSession(alertMessage: '');
        }
      },
    ).catchError((e) {});
  }

  void onReadRFID() async {
    FocusManager.instance.primaryFocus?.unfocus();
    RawKeyboard.instance.addListener(_onListenerRFID);
  }

  void _onListenerRFID(RawKeyEvent event) async {
    String card = event.character ?? '';
    if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
      Future.delayed(
        const Duration(seconds: 2),
        () {
          AccountLoginDTO dto = AccountLoginDTO(
            phoneNo: '',
            password: '',
            device: '',
            fcmToken: '',
            platform: '',
            sharingCode: '',
            method: 'CARD',
            userId: '',
            cardNumber: card,
          );
          controller.sink.add(dto); //
        },
      );
    }
  }

  void onLoginCard() async {
    if (Platform.isAndroid) {
      final data =
          await DialogWidget.instance.openDialogIntroduce(child: NFCDialog());
      if (data != null && data is NfcTag) {
        Future.delayed(const Duration(milliseconds: 500), () {
          String cardNumber = readTagToKey(data, '');

          AccountLoginDTO dto = AccountLoginDTO(
            phoneNo: '',
            password: '',
            device: '',
            fcmToken: '',
            platform: '',
            sharingCode: '',
            method: 'NFC_CARD',
            userId: '',
            cardNumber: cardNumber,
          );
          controller.sink.add(dto);
        });
      }
    } else {
      onReadNFC();
    }
    onReadRFID();
  }

  List<String> _saveAccount(provider) {
    List<String> list = [];
    List<InfoUserDTO> listCheck =
        UserInformationHelper.instance.getLoginAccount();

    if (listCheck.isNotEmpty) {
      if (listCheck.length == 3) {
        listCheck.removeWhere((element) =>
            element.phoneNo!.trim() == provider.infoUserDTO!.phoneNo);

        if (listCheck.length < 3) {
          listCheck.add(provider.infoUserDTO!);
        } else {
          listCheck
              .sort((a, b) => a.expiryAsDateTime.compareTo(b.expiryAsDateTime));
          listCheck.removeAt(2);
        }
      } else {
        listCheck.removeWhere((element) =>
            element.phoneNo!.trim() == provider.infoUserDTO!.phoneNo);

        listCheck.add(provider.infoUserDTO!);
      }
    } else {
      listCheck.add(provider.infoUserDTO!);
    }

    if (listCheck.length >= 2) {
      listCheck
          .sort((a, b) => a.expiryAsDateTime.compareTo(b.expiryAsDateTime));
    }

    listCheck.forEach((element) {
      list.add(element.toSPJson().toString());
    });

    return list;
  }
}
