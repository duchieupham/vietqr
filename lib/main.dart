import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/features/bank_card/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_card/views/bank_card_generated_view.dart';
import 'package:vierqr/features/bank_member/blocs/bank_member_bloc.dart';
import 'package:vierqr/features/bank_member/views/bank_member_view.dart';
import 'package:vierqr/features/bank_type/blocs/bank_type_bloc.dart';
import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/business/blocs/business_member_bloc.dart';
import 'package:vierqr/features/business/views/add_business_view.dart';
import 'package:vierqr/features/business/views/business_information_view.dart';
import 'package:vierqr/features/generate_qr/blocs/qr_blocs.dart';
import 'package:vierqr/features/generate_qr/views/qr_generated.dart';
import 'package:vierqr/features/generate_qr/views/qr_share_view.dart';
import 'package:vierqr/features/home/home.dart';
import 'package:vierqr/features/home/theme_setting.dart';
// import 'package:vierqr/features/log_sms/blocs/sms_bloc.dart';
import 'package:vierqr/features/log_sms/blocs/transaction_bloc.dart';
import 'package:vierqr/features/logout/blocs/log_out_bloc.dart';
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/login/views/login.dart';
import 'package:vierqr/features/permission/blocs/permission_bloc.dart';
import 'package:vierqr/features/bank_card/blocs/bank_manage_bloc.dart';
import 'package:vierqr/features/personal/blocs/user_edit_bloc.dart';
import 'package:vierqr/features/bank_card/views/add_bank_card_view.dart';
import 'package:vierqr/features/bank_card/views/bank_manage_view.dart';
import 'package:vierqr/features/personal/views/qr_scanner.dart';
import 'package:vierqr/features/personal/views/transaction_history.dart';
import 'package:vierqr/features/personal/views/user_edit_view.dart';
import 'package:vierqr/features/personal/views/user_update_password_view.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/token/blocs/token_bloc.dart';
import 'package:vierqr/services/local_notification/notification_service.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';
import 'package:vierqr/services/providers/add_business_provider.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/bank_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/services/providers/home_tab_provider.dart';
import 'package:vierqr/services/providers/memeber_manage_provider.dart';
import 'package:vierqr/services/providers/page_select_provider.dart';
import 'package:vierqr/services/providers/pin_provider.dart';
import 'package:vierqr/services/providers/register_provider.dart';
import 'package:vierqr/services/providers/shortcut_provider.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/providers/theme_provider.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';
import 'package:vierqr/services/shared_references/create_qr_helper.dart';
import 'package:vierqr/services/shared_references/event_bloc_helper.dart';
import 'package:vierqr/services/shared_references/theme_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

//Share Preferences
late SharedPreferences sharedPrefs;

//go into EnvConfig to change env
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
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
  await EventBlocHelper.instance.initialEventBlocHelper();
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class VietQRApp extends StatefulWidget {
  const VietQRApp({super.key});

  @override
  State<StatefulWidget> createState() => _VietQRApp();
}

class _VietQRApp extends State<VietQRApp> {
  static Widget _homeScreen = const Login();

  _VietQRApp();

  @override
  void initState() {
    super.initState();

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
      if (message.notification != null) {
        LOG.info(
            "Push notification received: ${message.notification?.title} - ${message.notification?.body}");
        NotificationService().showNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
      }
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _homeScreen = (UserInformationHelper.instance.getUserId() != '')
        ? const HomeScreen()
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
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(),
          ),
          BlocProvider<RegisterBloc>(
            create: (BuildContext context) => RegisterBloc(),
          ),
          BlocProvider<UserEditBloc>(
            create: (BuildContext context) => UserEditBloc(),
          ),
          // BlocProvider<MemberManageBloc>(
          //   create: (BuildContext context) => MemberManageBloc(),
          // ),
          // BlocProvider<SMSBloc>(
          //   create: (BuildContext context) => SMSBloc(),
          // ),
          BlocProvider<TransactionBloc>(
            create: (BuildContext context) => TransactionBloc(),
          ),
          BlocProvider<NotificationBloc>(
            create: (BuildContext context) => NotificationBloc(),
          ),
          BlocProvider<PermissionBloc>(
            create: (BuildContext context) => PermissionBloc(),
          ),
          BlocProvider<BankTypeBloc>(
            create: (BuildContext context) => BankTypeBloc(),
          ),
          BlocProvider<TokenBloc>(
            create: (BuildContext context) => TokenBloc(),
          ),
          BlocProvider<BankCardBloc>(
            create: (BuildContext context) => BankCardBloc(),
          ),
          BlocProvider<BankMemberBloc>(
            create: (BuildContext context) => BankMemberBloc(),
          ),
          BlocProvider<QRBloc>(
            create: (BuildContext context) => QRBloc(),
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
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ThemeProvider()),
            ChangeNotifierProvider(create: (context) => PageSelectProvider()),
            ChangeNotifierProvider(
                create: (context) => CreateQRPageSelectProvider()),
            ChangeNotifierProvider(create: (context) => CreateQRProvider()),
            ChangeNotifierProvider(create: (context) => BankAccountProvider()),
            ChangeNotifierProvider(create: (context) => BankSelectProvider()),
            ChangeNotifierProvider(create: (context) => RegisterProvider()),
            ChangeNotifierProvider(create: (context) => PinProvider()),
            ChangeNotifierProvider(create: (context) => UserEditProvider()),
            ChangeNotifierProvider(create: (context) => HomeTabProvider()),
            ChangeNotifierProvider(create: (context) => ShortcutProvider()),
            ChangeNotifierProvider(
                create: (context) => SuggestionWidgetProvider()),
            ChangeNotifierProvider(
                create: (context) => MemeberManageProvider()),
            ChangeNotifierProvider(create: (context) => AddBankProvider()),
            ChangeNotifierProvider(create: (context) => AddBusinessProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeSelect, child) {
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
                  Routes.HOME: (context) => const HomeScreen(),
                  Routes.USER_EDIT: (context) => const UserEditView(),
                  Routes.UPDATE_PASSWORD: (context) =>
                      const UserUpdatePassword(),
                  Routes.QR_SCAN: (context) => const QRScanner(),
                  Routes.BANK_MANAGE: (context) => const BankManageView(),
                  Routes.UI_SETTING: (context) => const ThemeSettingView(),
                  Routes.TRANSACTION_HISTORY: (context) =>
                      const TransactionHistory(),
                  Routes.ADD_BANK_CARD: (context) => const AddBankCardView(),
                  Routes.BANK_CARD_GENERATED_VIEW: (context) =>
                      const BankCardGeneratedView(),
                  Routes.BANK_MEMBER_VIEW: (context) => const BankMemberView(),
                  Routes.QR_SHARE_VIEW: (context) => const QRShareView(),
                  Routes.QR_GENERATED: (context) => const QRGenerated(),
                  Routes.BUSINESS_INFORMATION_VIEW: (context) =>
                      const BusinessInformationView(),
                  Routes.ADD_BUSINESS_VIEW: (context) =>
                      const AddBusinessView(),
                },
                onGenerateRoute: (settings) {
                  if (settings.name == Routes.BUSINESS_INFORMATION_VIEW) {
                    return PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const BusinessInformationView(),
                      transitionDuration: const Duration(milliseconds: 300),
                    );
                  }
                },
                themeMode:
                    (themeSelect.themeSystem == DefaultTheme.THEME_SYSTEM)
                        ? ThemeMode.system
                        : (themeSelect.themeSystem == DefaultTheme.THEME_LIGHT)
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
                  color: DefaultTheme.BLACK,
                  child: _homeScreen,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
