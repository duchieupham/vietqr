import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/account/blocs/account_bloc.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_card/views/search_bank_view.dart';
import 'package:vierqr/features/bank_member/blocs/bank_member_bloc.dart';
import 'package:vierqr/features/bank_member/views/bank_member_view.dart';
import 'package:vierqr/features/bank_type/select_bank_type_screen.dart';
import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/features/branch/views/branch_detail_view.dart';
import 'package:vierqr/features/business/blocs/business_bloc.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/business/blocs/business_member_bloc.dart';
import 'package:vierqr/features/business/views/add_business_view.dart';
import 'package:vierqr/features/business/views/business_information_view.dart';
import 'package:vierqr/features/business/views/business_transaction_view.dart';
import 'package:vierqr/features/create_qr/create_qr_screen.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/dashboard/theme_setting.dart';
import 'package:vierqr/features/generate_qr/views/qr_share_view.dart';
import 'package:vierqr/features/home/blocs/home_bloc.dart';
import 'package:vierqr/features/introduce/views/introduce_screen.dart';
import 'package:vierqr/features/notification/views/notification_view.dart';
import 'package:vierqr/features/personal/views/national_information_view.dart';
import 'package:vierqr/features/phone_book/phone_book_screen.dart';
import 'package:vierqr/features/phone_book/save_phone_book_screen.dart';
import 'package:vierqr/features/printer/blocs/printer_bloc.dart';
import 'package:vierqr/features/printer/views/printer_setting_view.dart';
import 'package:vierqr/features/logout/blocs/log_out_bloc.dart';
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features/login/views/login.dart';
import 'package:vierqr/features/bank_card/blocs/bank_manage_bloc.dart';
import 'package:vierqr/features/personal/blocs/user_edit_bloc.dart';
import 'package:vierqr/features/personal/views/user_edit_view.dart';
import 'package:vierqr/features/personal/views/user_update_password_view.dart';
import 'package:vierqr/features/scan_qr/blocs/scan_qr_bloc.dart';
import 'package:vierqr/features/scan_qr/views/qr_scan_view.dart';
import 'package:vierqr/features/token/blocs/token_bloc.dart';
import 'package:vierqr/features/transaction/transaction_detail_screen.dart';
import 'package:vierqr/features/transaction/widgets/transaction_sucess_widget.dart';
import 'package:vierqr/models/notification_transaction_success_dto.dart';
import 'package:vierqr/services/local_notification/notification_service.dart';
import 'package:vierqr/services/providers/action_share_provider.dart';
import 'package:vierqr/services/providers/add_business_provider.dart';
import 'package:vierqr/services/providers/avatar_provider.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/bank_card_select_provider.dart';
import 'package:vierqr/services/providers/bank_select_provider.dart';
import 'package:vierqr/services/providers/business_inforamtion_provider.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/home_tab_provider.dart';
import 'package:vierqr/services/providers/login_provider.dart';
import 'package:vierqr/services/providers/memeber_manage_provider.dart';
import 'package:vierqr/services/providers/page_select_provider.dart';
import 'package:vierqr/services/providers/pin_provider.dart';
import 'package:vierqr/services/providers/search_clear_provider.dart';
import 'package:vierqr/services/providers/shortcut_provider.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/providers/theme_provider.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/providers/verify_otp_provider.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';
import 'package:vierqr/services/shared_references/bank_arrangement_helper.dart';
import 'package:vierqr/services/shared_references/create_qr_helper.dart';
import 'package:vierqr/services/shared_references/event_bloc_helper.dart';
import 'package:vierqr/services/shared_references/qr_scanner_helper.dart';
import 'package:vierqr/services/shared_references/theme_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

//Share Preferences
late SharedPreferences sharedPrefs;

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
  LOG.verbose('Config Environment: ${EnvConfig.getEnv()}');
  runApp(const VietQRApp());
}

Future<void> _initialServiceHelper() async {
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
      );

      //process when receive data
      if (message.data.isNotEmpty) {
        //process success transcation
        if (message.data['notificationType'] != null &&
            message.data['notificationType'] ==
                Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
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
      if (message.notification != null) {
        LOG.info(
            "Push notification clicked: ${message.notification?.title.toString()} - ${message.notification?.body}");
      }
    });
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
          BlocProvider<BankManageBloc>(
            create: (BuildContext context) => BankManageBloc(),
          ),
          BlocProvider<UserEditBloc>(
            create: (BuildContext context) => UserEditBloc(),
          ),
          BlocProvider<NotificationBloc>(
            create: (BuildContext context) => NotificationBloc(context),
          ),
          BlocProvider<HomeBloc>(
            create: (BuildContext context) => HomeBloc(context),
          ),
          BlocProvider<DashBoardBloc>(
            create: (BuildContext context) => DashBoardBloc(context),
          ),
          BlocProvider<BusinessBloc>(
            create: (BuildContext context) => BusinessBloc(context),
          ),
          BlocProvider<TokenBloc>(
            create: (BuildContext context) => TokenBloc(),
          ),
          BlocProvider<BankMemberBloc>(
            create: (BuildContext context) => BankMemberBloc(),
          ),
          BlocProvider<LogoutBloc>(
            create: (BuildContext context) => LogoutBloc(),
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
          BlocProvider<ScanQrBloc>(
            create: (BuildContext context) => ScanQrBloc(),
          ),
          BlocProvider<PrinterBloc>(
            create: (BuildContext context) => PrinterBloc(),
          ),
          BlocProvider<AccountBloc>(
            create: (BuildContext context) => AccountBloc(),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ThemeProvider()),
            ChangeNotifierProvider(create: (context) => PageSelectProvider()),
            ChangeNotifierProvider(
                create: (context) => CreateQRPageSelectProvider()),
            ChangeNotifierProvider(create: (context) => BankAccountProvider()),
            ChangeNotifierProvider(create: (context) => BankSelectProvider()),
            ChangeNotifierProvider(create: (context) => PinProvider()),
            ChangeNotifierProvider(create: (context) => UserEditProvider()),
            ChangeNotifierProvider(create: (context) => HomeTabProvider()),
            ChangeNotifierProvider(create: (context) => ShortcutProvider()),
            ChangeNotifierProvider(
                create: (context) => SuggestionWidgetProvider()),
            ChangeNotifierProvider(
                create: (context) => MemeberManageProvider()),
            ChangeNotifierProvider(create: (context) => AddBusinessProvider()),
            ChangeNotifierProvider(
                create: (context) => BusinessInformationProvider()),
            ChangeNotifierProvider(
                create: (context) => BankCardSelectProvider()),
            ChangeNotifierProvider(create: (context) => ActionShareProvider()),
            ChangeNotifierProvider(create: (context) => AvatarProvider()),
            ChangeNotifierProvider(create: (context) => ValidProvider()),
            ChangeNotifierProvider(create: (context) => SearchProvider()),
            ChangeNotifierProvider(create: (context) => VerifyOtpProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeSelect, child) {
              if (themeSelect.typeBankArr != 0) {
                themeSelect.updateBankArr(0);
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
                  Routes.APP: (context) => const VietQRApp(),
                  Routes.LOGIN: (context) => const Login(),
                  Routes.DASHBOARD: (context) => const DashBoardScreen(),
                  Routes.USER_EDIT: (context) => const UserEditView(),
                  Routes.UPDATE_PASSWORD: (context) =>
                      const UserUpdatePassword(),
                  // Routes.BANK_MANAGE: (context) => const BankManageView(),
                  Routes.UI_SETTING: (context) => const ThemeSettingView(),
                  // Routes.TRANSACTION_HISTORY: (context) =>
                  //     const TransactionHistory(),
                  Routes.ADD_BANK_CARD: (context) => const AddBankScreen(),
                  Routes.SELECT_BANK_TYPE: (context) =>
                      const SelectBankTypeScreen(),
                  Routes.BANK_MEMBER_VIEW: (context) => const BankMemberView(),
                  Routes.QR_SHARE_VIEW: (context) => QRShareView(),
                  // Routes.QR_GENERATED: (context) => const QRGenerated(),
                  Routes.BUSINESS_INFORMATION_VIEW: (context) =>
                      const BusinessInformationView(),
                  Routes.ADD_BUSINESS_VIEW: (context) =>
                      const AddBusinessView(),
                  // Routes.BANK_CARD_DETAIL_VEW: (context) =>
                  //     const BankCardDetailScreen(),
                  // Routes.TRANSACTION_HISTORY_VIEW: (context) =>
                  //     const TransactionHistoryView(),
                  Routes.SCAN_QR_VIEW: (context) => const QRScanView(),
                  Routes.PRINTER_SETTING: (context) => PrinterSettingView(),
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
                  Routes.PHONE_BOOK: (context) => const PhoneBookScreen(),
                  // Routes.PHONE_BOOK: (context) => const SavePhoneBookScreen(),
                },
                onGenerateRoute: (settings) {
                  if (settings.name == Routes.BUSINESS_INFORMATION_VIEW) {
                    return PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const BusinessInformationView(),
                      transitionDuration: const Duration(milliseconds: 300),
                    );
                  }

                  return null;
                },
                themeMode: (themeSelect.themeSystem == AppColor.THEME_SYSTEM)
                    ? ThemeMode.system
                    : (themeSelect.themeSystem == AppColor.THEME_LIGHT)
                        ? ThemeMode.light
                        : ThemeMode.dark,
                darkTheme: DefaultThemeData(context: context).darkTheme,
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
                home: Title(
                  title: 'VietQR',
                  color: AppColor.BLACK,
                  child: _mainScreen,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
