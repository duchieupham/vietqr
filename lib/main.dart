import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/helper/media_helper.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_card/views/search_bank_view.dart';
import 'package:vierqr/features/bank_type/select_bank_type_screen.dart';
import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/features/branch/views/branch_detail_view.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/business/blocs/business_member_bloc.dart';
import 'package:vierqr/features/business/views/add_business_view.dart';
import 'package:vierqr/features/business/views/business_information_view.dart';
import 'package:vierqr/features/business/views/business_screen.dart';
import 'package:vierqr/features/business/views/business_transaction_view.dart';
import 'package:vierqr/features/connect_lark/connect_lark_screen.dart';
import 'package:vierqr/features/connect_telegram/connect_telegram_screen.dart';
import 'package:vierqr/features/connect_telegram/widget/connect_screen.dart';
import 'package:vierqr/features/contact/contact_screen.dart';
import 'package:vierqr/features/contact/views/contact_detail.dart';
import 'package:vierqr/features/contact_us/contact_us_screen.dart';
import 'package:vierqr/features/create_qr/create_qr_screen.dart';
import 'package:vierqr/features/create_qr_un_authen/create_qr_un_quthen.dart';
import 'package:vierqr/features/create_qr_un_authen/show_qr.dart';
import 'package:vierqr/features/dashboard/blocs/dash_board_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/theme_setting.dart';
import 'package:vierqr/features/generate_qr/views/qr_share_view.dart';
import 'package:vierqr/features/introduce/views/introduce_screen.dart';
import 'package:vierqr/features/login/login_screen.dart';
import 'package:vierqr/features/mobile_recharge/mobile_recharge_screen.dart';
import 'package:vierqr/features/mobile_recharge/qr_mobile_recharge.dart';
import 'package:vierqr/features/mobile_recharge/widget/recharege_success.dart';
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features/notification/views/notification_view.dart';
import 'package:vierqr/features/personal/blocs/user_edit_bloc.dart';
import 'package:vierqr/features/personal/views/national_information_view.dart';
import 'package:vierqr/features/personal/views/user_edit_view.dart';
import 'package:vierqr/features/personal/views/user_update_password_view.dart';
import 'package:vierqr/features/printer/views/printer_setting_screen.dart';
import 'package:vierqr/features/report/report_screen.dart';
import 'package:vierqr/features/scan_qr/scan_qr_lib.dart';
import 'package:vierqr/features/setting_bdsd/setting_bdsd_screen.dart';
// import 'package:vierqr/features/scan_qr/scan_qr_screen.dart';
import 'package:vierqr/features/top_up/qr_top_up.dart';
import 'package:vierqr/features/top_up/top_up_screen.dart';
import 'package:vierqr/features/top_up/widget/pop_up_top_up_sucsess.dart';
import 'package:vierqr/features/transaction/transaction_detail_screen.dart';
import 'package:vierqr/features/transaction/widgets/transaction_sucess_widget.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/notification_transaction_success_dto.dart';
import 'package:vierqr/models/respone_top_up_dto.dart';
import 'package:vierqr/models/top_up_sucsess_dto.dart';
import 'package:vierqr/services/local_notification/notification_service.dart';
import 'package:vierqr/services/providers/auth_provider.dart';
import 'package:vierqr/services/providers/avatar_provider.dart';
import 'package:vierqr/services/providers/business_inforamtion_provider.dart';
import 'package:vierqr/services/providers/pin_provider.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';
import 'package:vierqr/services/shared_references/bank_arrangement_helper.dart';
import 'package:vierqr/services/shared_references/create_qr_helper.dart';
import 'package:vierqr/services/shared_references/event_bloc_helper.dart';
import 'package:vierqr/services/shared_references/qr_scanner_helper.dart';
import 'package:vierqr/services/shared_references/theme_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'features/connect_lark/widget/connect_screen.dart';
import 'features/transaction_wallet/trans_wallet_screen.dart';
import 'models/qr_generated_dto.dart';

//Share Preferences
late SharedPreferences sharedPrefs;
List<CameraDescription> cameras = [];

//go into EnvConfig to change env
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  // await SharedPrefs.instance.init();
  await _initialServiceHelper();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: EnvConfig.getFirebaseConfig(),
    );
  } else {
    await Firebase.initializeApp();
  }
  cameras = await availableCameras();
  LOG.verbose('Config Environment: ${EnvConfig.getEnv()}');
  runApp(VietQRApp());
}

Future<void> _initialServiceHelper() async {
  await sharedPrefs.setString('TOKEN_FREE', '');

  if (!sharedPrefs.containsKey('THEME_SYSTEM') ||
      sharedPrefs.getString('THEME_SYSTEM') == null) {
    await ThemeHelper.instance.initialTheme();
  }
  if (!sharedPrefs.containsKey('BANK_TOKEN') ||
      sharedPrefs.getString('BANK_TOKEN') == null) {
    await AccountHelper.instance.initialAccountHelper();
  }
  if (!sharedPrefs.containsKey('TRANSACTION_AMOUNT') ||
      sharedPrefs.getString('TRANSACTION_AMOUNT') == null) {
    await CreateQRHelper.instance.initialCreateQRHelper();
  }
  if (!sharedPrefs.containsKey('USER_ID') ||
      sharedPrefs.getString('USER_ID') == null) {
    await UserInformationHelper.instance.initialUserInformationHelper();
  }
  if (!sharedPrefs.containsKey('BANK_ARRANGEMENT') ||
      sharedPrefs.getInt('BANK_ARRANGEMENT') == null) {
    await BankArrangementHelper.instance.initialBankArr();
  }
  if (!sharedPrefs.containsKey('QR_INTRO') ||
      sharedPrefs.getBool('QR_INTRO') == null) {
    await QRScannerHelper.instance.initialQrScanner();
  }
  await EventBlocHelper.instance.initialEventBlocHelper();
}

//true => new transaction
//false => initial
var notificationController = BehaviorSubject<bool>();

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class VietQRApp extends StatefulWidget {
  const VietQRApp({super.key});

  @override
  State<StatefulWidget> createState() => _VietQRApp();
}

class _VietQRApp extends State<VietQRApp> {
  static Widget _mainScreen = const Login();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
    );

    if (notificationController.isClosed) {
      notificationController = BehaviorSubject<bool>();
    }
    notificationController.sink.add(false);
    // Đăng ký callback onMessage
    onFcmMessage();
    // Đăng ký callback onMessageOpenedApp
    onFcmMessageOpenedApp();
    //
    requestNotificationPermission();
    handleMessageOnBackground();
  }

  void requestNotificationPermission() async {
    await Permission.notification.request();
  }

  void onFcmMessage() async {
    await NotificationService().initialNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Xử lý push notification nếu ứng dụng đang chạy
      LOG.info(
          "Push notification received: ${message.notification?.title} - ${message.notification?.body}");
      LOG.info("receive data: ${message.data}");
      NotificationService().showNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        payload: json.encode(message.data),
      );

      //process when receive data
      if (message.data.isNotEmpty) {
        if (message.data['notificationType'] != null &&
            message.data['notificationType'] == Stringify.NOTI_TYPE_TOPUP) {
          DialogWidget.instance.showModelBottomSheet(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 32, top: 12),
            height: 500,
            widget: PopupTopUpSuccess(
              dto: TopUpSuccessDTO.fromJson(message.data),
            ),
          );
        }
        if (message.data['notificationType'] != null &&
            message.data['notificationType'] ==
                Stringify.NOTI_TYPE_MOBILE_RECHARGE) {
          if (message.data['paymentMethod'] == "1") {
            DialogWidget.instance.showModelBottomSheet(
              padding:
                  EdgeInsets.only(left: 12, right: 12, bottom: 32, top: 12),
              height: 500,
              widget: PopupTopUpSuccess(
                dto: TopUpSuccessDTO.fromJson(message.data),
              ),
            );
          }
        }
        //process success transcation
        if (message.data['notificationType'] != null &&
            message.data['notificationType'] ==
                Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
          Map<String, dynamic> param = {};
          param['userId'] = UserInformationHelper.instance.getUserId();
          param['amount'] = message.data['amount'];
          param['type'] = 0;
          param['transactionId'] = message.data['transactionReceiveId'];
          MediaHelper.instance.playAudio(param);
          DialogWidget.instance.openWidgetDialog(
            child: TransactionSuccessWidget(
              dto: NotificationTransactionSuccessDTO.fromJson(message.data),
            ),
          );
        }
      }
      notificationController.sink.add(true);
    });
  }

  void onFcmMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Xử lý push notification nếu ứng dụng không đang chạy
      if (message.data['transactionReceiveId'] != null) {
        Navigator.pushNamed(
          NavigationService.navigatorKey.currentContext!,
          Routes.TRANSACTION_DETAIL,
          arguments: {
            'transactionId': message.data['transactionReceiveId'],
            // 'bankId': bankId,
          },
        );
      }
      if (message.notification != null) {
        LOG.info(
            "Push notification clicked: ${message.notification?.title.toString()} - ${message.notification?.body}");
      }
    });
  }

  void handleMessageOnBackground() {
    FirebaseMessaging.instance.getInitialMessage().then(
      (remoteMessage) {
        if (remoteMessage != null) {
          if (remoteMessage.data['transactionReceiveId'] != null) {
            Navigator.pushNamed(
              NavigationService.navigatorKey.currentContext!,
              Routes.TRANSACTION_DETAIL,
              arguments: {
                'transactionId': remoteMessage.data['transactionReceiveId'],
                // 'bankId': bankId,
              },
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _mainScreen = (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
        ? const DashBoardScreen()
        : const Login();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<UserEditBloc>(
            create: (BuildContext context) => UserEditBloc(),
          ),
          BlocProvider<NotificationBloc>(
            create: (BuildContext context) => NotificationBloc(context),
          ),
          BlocProvider<DashBoardBloc>(
            create: (BuildContext context) => DashBoardBloc(context)
              ..add(GetPointEvent())
              ..add(GetVersionAppEvent()),
          ),
          BlocProvider<BusinessMemberBloc>(
            create: (BuildContext context) => BusinessMemberBloc(),
          ),
          BlocProvider<BusinessInformationBloc>(
            create: (BuildContext context) => BusinessInformationBloc(),
          ),
          BlocProvider<BranchBloc>(
            create: (BuildContext context) => BranchBloc(),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AuthProvider()),
            ChangeNotifierProvider(create: (context) => DashBoardProvider()),
            ChangeNotifierProvider(create: (context) => PinProvider()),
            ChangeNotifierProvider(create: (context) => UserEditProvider()),
            ChangeNotifierProvider(
                create: (context) => BusinessInformationProvider()),
            ChangeNotifierProvider(create: (context) => AvatarProvider()),
          ],
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.typeBankArr != 0) {
                authProvider.updateBankArr(0);
              }

              if (authProvider.getThemeIndex() != 0) {
                authProvider.updateThemeByIndex(0);
              }

              return MaterialApp(
                navigatorKey: NavigationService.navigatorKey,
                debugShowCheckedModeBanner: false,
                builder: (context, child) {
                  //ignore system scale factor
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: 1.0,
                    ),
                    child: child ?? Container(),
                  );
                },
                initialRoute: '/',
                routes: {
                  Routes.APP: (context) => VietQRApp(),
                  Routes.LOGIN: (context) => const Login(),
                  Routes.DASHBOARD: (context) => const DashBoardScreen(),
                  Routes.USER_EDIT: (context) => const UserEditView(),
                  Routes.UPDATE_PASSWORD: (context) =>
                      const UserUpdatePassword(),
                  Routes.UI_SETTING: (context) => const ThemeSettingView(),
                  Routes.ADD_BANK_CARD: (context) => const AddBankScreen(),
                  Routes.SELECT_BANK_TYPE: (context) =>
                      const SelectBankTypeScreen(),
                  Routes.QR_SHARE_VIEW: (context) => QRShareView(),
                  Routes.BUSINESS_INFORMATION_VIEW: (context) =>
                      const BusinessInformationView(),
                  Routes.ADD_BUSINESS_VIEW: (context) => AddBusinessView(),
                  Routes.SCAN_QR_VIEW: (context) => const ScanQrScreen(),
                  Routes.PRINTER_SETTING: (context) => PrinterSettingScreen(),
                  Routes.SEARCH_BANK: (context) => SearchBankView(),
                  Routes.NOTIFICATION_VIEW: (context) =>
                      const NotificationView(),
                  Routes.TRANSACTION_DETAIL: (context) =>
                      const TransactionDetailScreen(),
                  Routes.NATIONAL_INFORMATION: (context) =>
                      const NationalInformationView(),
                  Routes.BUSINESS_TRANSACTION: (context) =>
                      const BusinessTransactionView(),
                  Routes.BRANCH_DETAIL: (context) => const BranchDetailView(),
                  Routes.CREATE_QR: (context) => const CreateQrScreen(),
                  Routes.INTRODUCE_SCREEN: (context) => const IntroduceScreen(),
                  Routes.PHONE_BOOK: (context) => const ContactScreen(),
                  Routes.TOP_UP: (context) => const TopUpScreen(),
                  Routes.MOBILE_RECHARGE: (context) => MobileRechargeScreen(),
                  Routes.CONNECT_TELEGRAM: (context) => ConnectTelegramScreen(),
                  Routes.CONNECT_STEP_TELE_SCREEN: (context) =>
                      ConnectTeleStepScreen(),
                  Routes.CONNECT_STEP_LARK_SCREEN: (context) =>
                      ConnectLarkStepScreen(),
                  Routes.CONNECT_LARK: (context) => ConnectLarkScreen(),
                  Routes.CONTACT_US_SCREEN: (context) =>
                      const ContactUSScreen(),
                  Routes.CREATE_UN_AUTHEN: (context) =>
                      const CreateQrUnQuthen(),
                  Routes.REPORT_SCREEN: (context) => const ReportScreen(),
                  Routes.SETTING_BDSD: (context) => const SettingBDSD(),
                  Routes.TRANSACTION_WALLET: (context) =>
                      const TransWalletScreen(),

                  Routes.BUSINESS: (context) => const BusinessScreen(),
                  // Routes.RECHARGE_SUCCESS: (context) => const RechargeSuccess(),
                },
                onGenerateRoute: (settings) {
                  if (settings.name == Routes.BUSINESS_INFORMATION_VIEW) {
                    return PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const BusinessInformationView(),
                      transitionDuration: const Duration(milliseconds: 300),
                    );
                  }
                  if (settings.name == Routes.PHONE_BOOK_DETAIL) {
                    ContactDTO dto = settings.arguments as ContactDTO;

                    return MaterialPageRoute(
                      builder: (context) {
                        return ContactDetailScreen(
                          dto: dto,
                        );
                      },
                    );
                  }
                  if (settings.name == Routes.SHOW_QR) {
                    QRGeneratedDTO dto = settings.arguments as QRGeneratedDTO;
                    return MaterialPageRoute(
                      builder: (context) {
                        return ShowQr(
                          dto: dto,
                        );
                      },
                    );
                  }

                  if (settings.name == Routes.QR_TOP_UP) {
                    Map<String, dynamic> param =
                        settings.arguments as Map<String, dynamic>;
                    ResponseTopUpDTO dto = param['dto'] as ResponseTopUpDTO;
                    String phoneNo = param['phoneNo'] as String;

                    return MaterialPageRoute(
                      builder: (context) {
                        return QRTopUpScreen(
                          dto: dto,
                          phoneNo: phoneNo,
                        );
                      },
                    );
                  }
                  if (settings.name == Routes.QR_MOBILE_CHARGE) {
                    Map<String, dynamic> param =
                        settings.arguments as Map<String, dynamic>;
                    ResponseTopUpDTO dto = param['dto'] as ResponseTopUpDTO;
                    String phoneNo = param['phoneNo'] as String;
                    String nwProviders = param['nwProviders'] as String;
                    return MaterialPageRoute(
                      builder: (context) {
                        return QRMobileRechargeScreen(
                          dto: dto,
                          phoneNo: phoneNo,
                          nwProviders: nwProviders,
                        );
                      },
                    );
                  }
                  if (settings.name == Routes.RECHARGE_SUCCESS) {
                    Map<String, dynamic> data =
                        settings.arguments as Map<String, dynamic>;

                    return MaterialPageRoute(
                      builder: (context) {
                        return RechargeSuccess(
                          phoneNo: data['phoneNo'],
                          money: data['money'],
                        );
                      },
                    );
                  }
                  // if (settings.name == Routes.UPDATE_PHONE_BOOK) {
                  //   PhoneBookDetailDTO _dto =
                  //       settings.arguments as PhoneBookDetailDTO;
                  //
                  //   return MaterialPageRoute(
                  //     builder: (context) {
                  //       return EditPhoneBookScreen(
                  //         dto: _dto,
                  //       );
                  //     },
                  //   );
                  // }
                  return null;
                },
                themeMode: ThemeMode.light,
                darkTheme: DefaultThemeData(context: context).lightTheme,
                theme: DefaultThemeData(context: context).lightTheme,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  //  Locale('en'), // English
                  Locale('vi'), // Vietnamese
                ],
                home: Builder(
                  builder: (context) {
                    authProvider.setContext(context);

                    return Title(
                      title: 'VietQR',
                      color: AppColor.BLACK,
                      child: _mainScreen,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
