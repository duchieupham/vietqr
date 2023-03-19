import 'package:firebase_core/firebase_core.dart';
import 'package:vierqr/commons/constants/env/evn.dart';

class ProdEnv implements Env {
  @override
  String getBankUrl() {
    return '';
  }

  @override
  String getBaseUrl() {
    return 'http://112.78.1.209:8084/vqr/api/';
  }

  @override
  String getUrl() {
    return 'http://112.78.1.209:8084/vqr/';
  }

  @override
  FirebaseOptions getFirebaseCongig() {
    return const FirebaseOptions(
      apiKey: 'AIzaSyCns_zmKTZ2O66TK-loHlvbWPvoAA3Ffu0',
      appId: '1:723381873229:web:5fb20affd823d725fbca04',
      messagingSenderId: '723381873229',
      projectId: 'bns-stagging',
    );
  }
}
