import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/pref_utils.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/login/login_screen.dart';
import 'package:vierqr/features/network/network_bloc.dart';
import 'package:vierqr/features/network/network_event.dart';
import 'package:vierqr/features/personal/blocs/user_edit_bloc.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/firebase_service/fcm_service.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/connect_gg_chat_provider.dart';
import 'package:vierqr/services/providers/maintain_charge_provider.dart';
import 'package:vierqr/services/providers/pin_provider.dart';
import 'package:vierqr/services/providers/qr_box_provider.dart';
import 'package:vierqr/services/providers/register_provider.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/socket_service/socket_service.dart';

import 'services/providers/invoice_provider.dart';

//Share Preferences
List<CameraDescription> cameras = [];

extension IntExtension on int {
  String toHexString() {
    return '0x' + toRadixString(16).padLeft(2, '0').toUpperCase();
  }
}

extension Uint8ListExtension on Uint8List {
  String toHexString({String empty = '-', String separator = ' '}) {
    return isEmpty ? empty : map((e) => e.toHexString()).join(separator);
  }
}

Future<String> downloadAndSaveImage(String imageUrl, String path) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;

    final directory = await getApplicationDocumentsDirectory();
    final localImagePath = '${directory.path}/$path';

    final file = File(localImagePath);
    file.writeAsBytesSync(bytes);

    print('Image saved to: $localImagePath');
    return localImagePath;
  } catch (e) {
    return '';
  }
}

Future<String> saveImageToLocal(Uint8List uint8list, String path) async {
  final directory = await getApplicationDocumentsDirectory();
  final localImagePath = '${directory.path}/$path';

  final file = File(localImagePath);
  file.writeAsBytesSync(uint8list);

  print('Image saved to: $localImagePath');
  return localImagePath;
}

Future<File> getImageFile(String file) async {
  return File(file);
}

//go into EnvConfig to change env
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Injection.inject();

  await SharePrefUtils.init();
  await SharePrefUtils.onClearCache();

  await HivePrefs.instance.init();

  if (kIsWeb) {
    await Firebase.initializeApp(options: EnvConfig.getFirebaseConfig());
  } else {
    await Firebase.initializeApp();
  }
  cameras = await availableCameras();
  await UserRepository.instance.getBanks();
  await UserRepository.instance.getIntroContact();
  await UserRepository.instance.getThemes();
  LOG.verbose('Config Environment: ${EnvConfig.getEnv()}');
  runApp(VietQRApp());
}

//true => new transaction
//false => initial
var notificationController = BehaviorSubject<bool>();

class VietQRApp extends StatefulWidget {
  const VietQRApp({super.key});

  @override
  State<StatefulWidget> createState() => _VietQRApp();
}

class _VietQRApp extends State<VietQRApp> {
  static Widget _mainScreen = const Login();

  String get userId => SharePrefUtils.getProfile().userId.trim();

  @override
  void initState() {
    super.initState();
    print('User: $userId');
    _mainScreen = (userId.isNotEmpty) ? const DashBoardScreen() : const Login();
    // _mainScreen = const DashBoardScreen();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
    );

    SocketService.instance.init();

    if (notificationController.isClosed) {
      notificationController = BehaviorSubject<bool>();
    }
    notificationController.sink.add(false);
    // Đăng ký callback onMessage
    FCMService.onFcmMessage();
    // Đăng ký callback onMessageOpenedApp
    FCMService.onFcmMessageOpenedApp(context);
    FCMService.handleMessageOnBackground(context);

    getIt.get<NetworkBloc>().add(NetworkObserve());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<UserEditBloc>(
            create: (BuildContext context) => UserEditBloc(),
          ),
          BlocProvider<DashBoardBloc>(
            create: (BuildContext context) => DashBoardBloc(context),
          ),
          // BlocProvider(
          //   create: (context) => NetworkBloc()..add(NetworkObserve()),
          // ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AuthProvider()),
            ChangeNotifierProvider(create: (context) => PinProvider()),
            ChangeNotifierProvider(
                create: (context) => MaintainChargeProvider()),
            ChangeNotifierProvider(create: (context) => InvoiceProvider()),
            ChangeNotifierProvider(
                create: (context) => ConnectGgChatProvider()),
            ChangeNotifierProvider(create: (context) => QRBoxProvider()),
            ChangeNotifierProvider(create: (context) => RegisterProvider()),
            ChangeNotifierProvider(create: (context) => UserEditProvider()),
          ],
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return MaterialApp(
                navigatorKey: NavigationService.navigatorKey,
                debugShowCheckedModeBanner: false,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: 1.0,
                    ),
                    child: child ?? Container(),
                  );
                },
                initialRoute: '/',
                onGenerateRoute: NavigationService.onIniRoute,
                themeMode: ThemeMode.light,
                darkTheme: DefaultThemeData(context: context).lightTheme,
                theme: DefaultThemeData(context: context).lightTheme,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('vi'), // Vietnamese
                ],
                home: Builder(
                  builder: (context) {
                    authProvider.setContext(context);
                    return _mainScreen;
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
