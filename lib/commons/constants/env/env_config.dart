import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vierqr/commons/enums/env_type.dart';

import 'evn.dart';
import 'prod_evn.dart';
import 'stg_env.dart';

class EnvConfig {
  static final Env _env = (getEnv() == EnvType.STG) ? StgEnv() : ProdEnv();

  static String getBankUrl() {
    return _env.getBankUrl();
  }

  static String getBaseUrl() {
    return _env.getBaseUrl();
  }

  static String getUrl() {
    return _env.getUrl();
  }

  static FirebaseOptions getFirebaseConfig() {
    return _env.getFirebaseCongig();
  }

  static EnvType getEnv() {
    // const EnvType env = EnvType.STG;
    const EnvType env = EnvType.PROD;
    return env;
  }
}

class AppConfig {
  EnvType _env = EnvType.PROD;

  String? _bankUrl;

  String? _url;

  String? _baseUrl;

  FirebaseOptions? _firebaseWebOptions;

  EnvType get getEnv => _env;

  setEnvConfig(EnvType env) async {
    try {
      await dotenv.load(fileName: "assets/environment/.env_${env.toValue}");
      _env = env;

      //
      _bankUrl = dotenv.env['BANK_URL'];
      _url = dotenv.env['URL'];
      _baseUrl = dotenv.env['BASE_URL'];

      //
      _firebaseWebOptions = FirebaseOptions(
        apiKey: dotenv.env['API_KEY_FB_WEB'] ?? '',
        appId: dotenv.env['APP_ID_FB_WEB'] ?? '',
        messagingSenderId: dotenv.env['MESSAGING_SENDER_ID_FB_WEB'] ?? '',
        projectId: dotenv.env['PROJECT_ID_FB_WEB'] ?? '',
      );
    } catch (e) {
      //
    }
  }

  String get getBankUrl => _bankUrl ?? '';

  String get getBaseUrl => _baseUrl ?? '';

  String get getUrl => _url ?? '';

  FirebaseOptions get getFirebaseConfig =>
      _firebaseWebOptions ??
      FirebaseOptions(
        apiKey: '',
        appId: '',
        messagingSenderId: '',
        projectId: '',
      );
}
