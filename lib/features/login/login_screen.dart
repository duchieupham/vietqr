import 'dart:async';
import 'dart:io';

import 'package:float_bubble/float_bubble.dart';
import 'package:flutter/foundation.dart';
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
import 'package:vierqr/commons/constants/configurations/stringify.dart'
    as Constants;
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/helper/dialog_helper.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/phone_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/home/widget/nfc_adr_widget.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/login/events/login_event.dart';
import 'package:vierqr/features/login/states/login_state.dart';
import 'package:vierqr/features/login/widgets/login_account_screen.dart';
import 'package:vierqr/features/login/widgets/quick_login_screen.dart';
import 'package:vierqr/features/register/register_screen.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/info_user_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/user_profile.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/register_provider.dart';
import 'package:vierqr/splash_screen.dart';

import '../bank_card/events/bank_event.dart';
import 'widgets/bgr_app_bar_login.dart';

part 'widgets/form_first_login.dart';

enum FlowType {
  FIRST_LOGIN,
  NEAREST_LOGIN,
  QUICK_LOGIN,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with DialogHelper {
  final passController = TextEditingController();
  final PageController pageController = PageController();

  final passFocus = FocusNode();

  String code = '';

  Uuid uuid = const Uuid();

  NfcTag? tag;

  Map<String, dynamic>? additionalData;
  final BankBloc _bankBloc = getIt.get<BankBloc>();
  late final LoginBloc _bloc = getIt.get<LoginBloc>(param1: context);
  late AuthProvider _authProvider;
  var controller = StreamController<AccountLoginDTO?>.broadcast();

  //0: trang login ban đầu
  // 1: trang login gần nhất
  // 2 : quickLogin
  final ValueNotifier<FlowType> isQuickLogin =
      ValueNotifier(FlowType.NEAREST_LOGIN);
  final ValueNotifier<List<InfoUserDTO>> listInfoUsers = ValueNotifier([]);
  final ValueNotifier<InfoUserDTO?> infoUserDTO = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      passController.text = '';
    }

    init();

    _authProvider = Provider.of<AuthProvider>(context, listen: false);
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
      if (!mounted) return;
    });

    _bloc.add(const GetFreeToken());
  }

  @override
  void dispose() {
    controller.close();
    isQuickLogin.dispose();
    listInfoUsers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLogoutEnterHome = false;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final arg = ModalRoute.of(context)!.settings.arguments as Map;
      isLogoutEnterHome = arg['isLogout'] ?? false;
    }
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: _bloc,
      listener: (context, state) =>
          onListener(context, state, isLogoutEnterHome),
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
                renderFormLogin(),
                renderLoginByAccountBeforeThat(),
                renderPasswordBeforeThat(),
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
                                      mode: LaunchMode.externalApplication)) {}
                                },
                                child: const XImage(
                                  imagePath: ImageConstant.bannerUpdate,
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
                                  child: const XImage(
                                    imagePath: ImageConstant.icCloseBanner,
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
  }

  Widget renderLoginByAccountBeforeThat() {
    final height = MediaQuery.of(context).size.height;
    return ValueListenableBuilder(
        valueListenable: isQuickLogin,
        builder: (context, value, child) {
          if (value != FlowType.NEAREST_LOGIN &&
              value != FlowType.QUICK_LOGIN) {
            return Positioned(
              bottom: height < 800 ? 50 : 66,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const XImage(
                          imagePath: 'assets/images/ic-suggest.png',
                          width: 30,
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF458BF8),
                              Color(0xFFFF8021),
                              Color(0xFFFF3751),
                              Color(0xFFC958DB),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: Text(
                            'Gợi ý cho bạn',
                            style: TextStyle(
                              fontSize: 15,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color(0xFF458BF8),
                                    Color(0xFFFF8021),
                                    Color(0xFFFF3751),
                                    Color(0xFFC958DB),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ValueListenableBuilder<List<InfoUserDTO>>(
                      valueListenable: listInfoUsers,
                      builder: (context, users, _) {
                        if (users.isNotEmpty) {
                          InfoUserDTO user = users.first;
                          return InkWell(
                            onTap: () {
                              onSetIsQuickLogin(FlowType.QUICK_LOGIN);
                              updateInfoUser(user);
                              // onLoginCard();
                            },
                            child: Container(
                              height: 40,
                              // width: 240,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFD8ECF8),
                                    Color(0xFFFFEAD9),
                                    Color(0xFFF5C9D1),
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const XImage(
                                    imagePath:
                                        'assets/images/ic-person@-black.png',
                                    width: 30,
                                  ),
                                  const Text(
                                    'Bạn có phải là ',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  Text(
                                    user.fullName,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    //  const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        onLoginCard();
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: 240,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFD8ECF8),
                              Color(0xFFFFEAD9),
                              Color(0xFFF5C9D1),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          children: [
                            XImage(
                              imagePath: 'assets/images/ic-info-black.png',
                              width: 30,
                            ),
                            Text(
                              'Đăng nhập bằng',
                              style: TextStyle(fontSize: 11),
                            ),
                            Text(
                              ' VietQR ID Card',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        _onRegister();
                      },
                      child: Container(
                        width: 180,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFD8ECF8),
                              Color(0xFFFFEAD9),
                              Color(0xFFF5C9D1),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              XImage(
                                imagePath: 'assets/images/ic-person-black.png',
                                width: 30,
                              ),
                              Text(
                                'Tôi là người dùng mới',
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // const SizedBox(height: 16),
                    // Container(
                    //   margin: const EdgeInsets.symmetric(horizontal: 40),
                    //   child: MButtonWidget(
                    //     title: 'Tôi là người dùng mới',
                    //     isEnable: true,
                    //     // width: 350,
                    //     height: 50,
                    //     colorEnableBgr: AppColor.WHITE,
                    //     border: Border.all(
                    //       width: 1,
                    //       color: AppColor.BLUE_TEXT,
                    //     ),
                    //     margin: EdgeInsets.zero,
                    //     colorEnableText: AppColor.BLUE_TEXT,
                    //     onTap: () {
                    //       _onRegister();
                    //     },
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    SizedBox(height: height < 800 ? 16 : 5),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        });
  }

  Widget renderPasswordBeforeThat() {
    final height = MediaQuery.of(context).size.height;
    return ValueListenableBuilder(
        valueListenable: isQuickLogin,
        builder: (context, value, child) {
          if (value != FlowType.NEAREST_LOGIN &&
              value != FlowType.FIRST_LOGIN) {
            return Positioned(
              bottom: height < 800 ? 50 : 66,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const XImage(
                          imagePath: 'assets/images/ic-suggest.png',
                          width: 30,
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF458BF8),
                              Color(0xFFFF8021),
                              Color(0xFFFF3751),
                              Color(0xFFC958DB),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: Text(
                            'Gợi ý cho bạn',
                            style: TextStyle(
                              fontSize: 15,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color(0xFF458BF8),
                                    Color(0xFFFF8021),
                                    Color(0xFFFF3751),
                                    Color(0xFFC958DB),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    //  const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        // onLoginCard();
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: 230,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFD8ECF8),
                              Color(0xFFFFEAD9),
                              Color(0xFFF5C9D1),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          children: [
                            XImage(
                              imagePath: 'assets/images/ic-password-black.png',
                              width: 30,
                            ),
                            Text(
                              'Bạn quên mật khẩu đăng nhập?',
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        passController.clear();
                        onSetIsQuickLogin(FlowType.FIRST_LOGIN);
                        updateInfoUser(null);
                        // _onRegister();
                      },
                      child: Container(
                        width: 270,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFD8ECF8),
                              Color(0xFFFFEAD9),
                              Color(0xFFF5C9D1),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              XImage(
                                imagePath: 'assets/images/ic-person@-black.png',
                                width: 30,
                              ),
                              Text(
                                'Đăng nhập bằng tài khoản VietQR khác',
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // const SizedBox(height: 16),
                    // Container(
                    //   margin: const EdgeInsets.symmetric(horizontal: 40),
                    //   child: MButtonWidget(
                    //     title: 'Tôi là người dùng mới',
                    //     isEnable: true,
                    //     // width: 350,
                    //     height: 50,
                    //     colorEnableBgr: AppColor.WHITE,
                    //     border: Border.all(
                    //       width: 1,
                    //       color: AppColor.BLUE_TEXT,
                    //     ),
                    //     margin: EdgeInsets.zero,
                    //     colorEnableText: AppColor.BLUE_TEXT,
                    //     onTap: () {
                    //       _onRegister();
                    //     },
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    SizedBox(height: height < 800 ? 16 : 5),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        });
  }

  Widget renderFormLogin() {
    return ValueListenableBuilder(
      valueListenable: isQuickLogin,
      builder: (context, value, child) {
        if (value == FlowType.FIRST_LOGIN) {
          return FormFirstLogin(
            bloc: _bloc,
            onLoginCard: onLoginCard,
          );
        }
        if (value == FlowType.NEAREST_LOGIN) {
          return ValueListenableBuilder<List<InfoUserDTO>>(
              valueListenable: listInfoUsers,
              builder: (context, value, _) {
                return LoginAccountScreen(
                  list: value,
                  onRemoveAccount: (dto) async {
                    List<InfoUserDTO> list = value;
                    list.removeAt(dto);
                    if (list.length >= 2) {
                      list.sort((a, b) =>
                          a.expiryAsDateTime.compareTo(b.expiryAsDateTime));
                    }

                    await SharePrefUtils.saveLoginAccountList(list);

                    updateListInfoUser();

                    if (list.isEmpty) {
                      onSetIsQuickLogin(FlowType.FIRST_LOGIN);
                    }
                  },
                  onQuickLogin: (dto) async {
                    onSetIsQuickLogin(FlowType.QUICK_LOGIN);
                    updateInfoUser(dto);
                  },
                  onBackLogin: () async {
                    updateInfoUser(null);
                    onSetIsQuickLogin(FlowType.FIRST_LOGIN);
                  },
                  onRegister: () => _onRegister(),
                  onLoginCard: onLoginCard,
                  buttonNext: MButtonWidget(
                    height: 50,
                    width: 350,
                    title: 'Tiếp tục',
                    isEnable: true,
                    onTap: () async {
                      await updateInfoUser(value.first);
                      onSetIsQuickLogin(FlowType.QUICK_LOGIN);
                    },
                  ),
                  // child: _buildButtonBottom(state.appInfoDTO),
                  child: const Padding(padding: EdgeInsets.all(0)),
                );
              });
        }

        if (value == FlowType.QUICK_LOGIN) {
          return ValueListenableBuilder<InfoUserDTO?>(
              valueListenable: infoUserDTO,
              builder: (context, value, _) {
                return QuickLoginScreen(
                  pinController: passController,
                  passFocus: passFocus,
                  isFocus: true,
                  userName: value?.fullName ?? '',
                  phone: value?.phoneNo ?? '',
                  imgId: value?.imgId ?? '',
                  onLogin: (dto) {
                    _bloc.add(LoginEventByPhone(dto: dto));
                  },
                  onQuickLogin: () {
                    passController.clear();
                    onSetIsQuickLogin(FlowType.FIRST_LOGIN);
                    updateInfoUser(null);
                  },
                );
              });
        }

        return const SizedBox.shrink();
      },
    );
  }
}

extension _LoginScreenFunction on _LoginScreenState {
  onListener(
      BuildContext context, LoginState state, bool isLogoutEnterHome) async {
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
      _authProvider.updateAppInfoDTO(state.appInfoDTO);

      _onHandleAppSystem(state.appInfoDTO);

      if (_authProvider.isUpdateVersion) {
        if (!state.appInfoDTO.isCheckApp) {
          showDialogUpdateApp(
            context,
            isHideClose: true,
            onCheckUpdate: () {
              _bloc.add(const GetFreeToken(isCheckVer: true));
            },
          );
          // showDialog(
          //   barrierDismissible: false,
          //   context: context,
          //   builder: (BuildContext context) {
          //     return DialogUpdateView(
          //       isHideClose: true,
          //       onCheckUpdate: () {
          //         _bloc.add(GetFreeToken(isCheckVer: true));
          //       },
          //     );
          //   },
          // );
        }
      }
    }

    if (state.request == LoginType.LOGIN) {
      Provider.of<RegisterProvider>(context, listen: false)
          .updateErrs(phoneErr: false, passErr: false, confirmPassErr: false);
      _authProvider.updateRenderUI(isLogout: true);
      UserProfile userProfile = SharePrefUtils.getProfile();

      if (infoUserDTO.value != null) {
        InfoUserDTO infoUser = infoUserDTO.value!;

        infoUser.imgId = userProfile.imgId;
        infoUser.firstName = userProfile.firstName;
        infoUser.middleName = userProfile.middleName;
        infoUser.lastName = userProfile.lastName;
        infoUser.middleName = userProfile.middleName;

        updateInfoUser(infoUser);
        _saveAccount();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SplashScreen(isFromLogin: true),
          settings: RouteSettings(name: SplashScreen.routeName),
        ),
      );
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => DashBoardScreen(
      //         isFromLogin: true,
      //         isLogoutEnterHome: isLogoutEnterHome,
      //       ),
      //       settings: RouteSettings(name: SplashScreen.routeName),
      //     ),
      //     (route) => route.isFirst);

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
      onSetIsQuickLogin(FlowType.QUICK_LOGIN);
      updateInfoUser(state.infoUserDTO);
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
      if (state.phone != '') {
        Provider.of<RegisterProvider>(context, listen: false).updatePage(2);
      }
      final data = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Register(
            pageController: pageController,
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
          password:
              EncryptUtils.instance.encrypted(data['phone'], data['password']),
        );
        if (!mounted) return;
        _bloc.add(LoginEventByPhone(dto: dto, isToast: true));
      }

      // if (state.request != LoginType.NONE || state.status != BlocStatus.NONE) {
      //   _bloc.add(UpdateEvent());
      // }
    }
  }

  init() async {
    await updateListInfoUser();
    if (listInfoUsers.value.isNotEmpty) {
      onSetIsQuickLogin(FlowType.FIRST_LOGIN);
    }
  }

  Future<void> updateListInfoUser() async {
    // print(SharePrefUtils.getLoginAccountList());
    final res = await SharePrefUtils.getLoginAccountList() ?? [];
    listInfoUsers.value = res;
  }

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
      final data = await DialogWidget.instance
          .openDialogIntroduce(child: const NFCDialog());
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

  void _saveAccount() async {
    List<InfoUserDTO> listCheck =
        await SharePrefUtils.getLoginAccountList() ?? [];

    if (listCheck.isNotEmpty) {
      if (listCheck.length >= 3) {
        listCheck.removeWhere(
            (element) => element.phoneNo!.trim() == infoUserDTO.value!.phoneNo);

        if (listCheck.length < 3) {
          listCheck.add(infoUserDTO.value!);
        } else {
          listCheck
              .sort((a, b) => a.expiryAsDateTime.compareTo(b.expiryAsDateTime));
          listCheck.removeLast();
          listCheck.add(infoUserDTO.value!);
        }
      } else {
        listCheck.removeWhere(
            (element) => element.phoneNo!.trim() == infoUserDTO.value!.phoneNo);

        listCheck.add(infoUserDTO.value!);
      }
    } else {
      listCheck.add(infoUserDTO.value!);
    }

    if (listCheck.length >= 2) {
      listCheck
          .sort((a, b) => a.expiryAsDateTime.compareTo(b.expiryAsDateTime));
    }

    await SharePrefUtils.saveLoginAccountList(listCheck);
    updateListInfoUser();
  }

  void _onHandleAppSystem(AppInfoDTO dto) async {
    String logoApp = SharePrefUtils.getLogoApp();
    bool isEvent = SharePrefUtils.getBannerEvent();
    ThemeDTO themeDTO = await SharePrefUtils.getSingleTheme() ?? ThemeDTO();

    if (logoApp.isEmpty) {
      String path = dto.logoUrl.split('/').last;

      for (var type in Constants.PictureType.values) {
        if (path.contains(type.pictureValue)) {
          path.replaceAll(type.pictureValue, '');
          break;
        }
      }

      String localPath = await downloadAndSaveImage(dto.logoUrl, path);

      await SharePrefUtils.saveLogoApp(localPath);
      _authProvider.updateLogoApp(localPath);
    }

    if (dto.isEventTheme && !isEvent) {
      String path = dto.themeImgUrl.split('/').last;
      for (var type in Constants.PictureType.values) {
        if (path.contains(type.pictureValue)) {
          path.replaceAll(type.pictureValue, '');
          break;
        }
      }

      String localPath = await downloadAndSaveImage(dto.themeImgUrl, path);

      await SharePrefUtils.saveBannerApp(localPath);
      _authProvider.updateBannerApp(localPath);
    } else if (!dto.isEventTheme && themeDTO.type == 0) {
      SharePrefUtils.removeSingleTheme();
      SharePrefUtils.saveBannerApp('');
      _authProvider.updateBannerApp('');
    }

    if (isEvent != dto.isEventTheme) {
      await SharePrefUtils.saveBannerEvent(dto.isEventTheme);
      _authProvider.updateEventTheme(dto.isEventTheme);
    }
  }

  void _onRegister() async {
    updateInfoUser(null);
    Provider.of<RegisterProvider>(context, listen: false).updatePage(0);

    final data = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            Register(pageController: pageController, isFocus: true),
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
      );
      if (!mounted) return;
      _bloc.add(LoginEventByPhone(dto: dto, isToast: true));
    } else if (data != null && data is InfoUserDTO) {
      onSetIsQuickLogin(FlowType.QUICK_LOGIN);
      updateInfoUser(data);
    }
  }

  onSetIsQuickLogin(value) {
    if (value != isQuickLogin.value) {
      isQuickLogin.value = value;
    }
  }

  updateInfoUser(value) {
    if (value != infoUserDTO.value) {
      infoUserDTO.value = value;
    }
  }

  String readTagToKey(NfcTag tag, String userId) {
    String card = '';
    Object? tech;
    if (Platform.isIOS) {
      tech = FeliCa.from(tag);
      if (tech is FeliCa) {
        card = tech.currentSystemCode.toHexString().replaceAll(' ', '');
        return card;
      }

      tech = Iso15693.from(tag);
      if (tech is Iso15693) {
        card = tech.identifier.toHexString().replaceAll(' ', '');
        return card;
      }

      tech = Iso7816.from(tag);
      if (tech is Iso7816) {
        card = tech.identifier.toHexString().replaceAll(' ', '');
        return card;
      }

      tech = MiFare.from(tag);
      if (tech is MiFare) {
        card = tech.identifier.toHexString().replaceAll(' ', '');
        return card;
      }
      tech = Ndef.from(tag);
      if (tech is Ndef) {
        return card;
      }
    } else if (Platform.isAndroid) {
      tech = IsoDep.from(tag);
      if (tech is NfcA) {
        card = tech.identifier.toHexString().replaceAll(' ', '');
        return card;
      }

      tech = NfcA.from(tag);
      if (tech is NfcA) {
        card = tech.identifier.toHexString().replaceAll(' ', '');
        return card;
      }
      tech = NfcB.from(tag);
      if (tech is NfcB) {
        card = tech.identifier.toHexString().replaceAll(' ', '');
        return card;
      }
      tech = NfcF.from(tag);
      if (tech is NfcF) {
        card = tech.identifier.toHexString().replaceAll(' ', '');
        return card;
      }
      tech = NfcV.from(tag);
      if (tech is NfcV) {
        card = tech.identifier.toHexString().replaceAll(' ', '');
        return card;
      }

      tech = MifareClassic.from(tag);
      if (tech is MifareClassic) {
        card = tech.identifier.toHexString().replaceAll(' ', '');
        return card;
      }
      tech = MifareUltralight.from(tag);
      if (tech is MifareUltralight) {
        card = tech.identifier.toHexString().replaceAll(' ', '');
        return card;
      }
    }

    return card;
  }
}
