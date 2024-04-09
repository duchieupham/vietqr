import 'package:firebase_core/firebase_core.dart';
import 'package:vierqr/commons/constants/env/evn.dart';

class StgEnv implements Env {
  @override
  String getBankUrl() {
    return 'https://api-sandbox.mbbank.com.vn/';
  }

  @override
  String getBaseUrl() {
    // return 'https://dev.vietqr.org/vqr/';
    return 'https://dev.vietqr.org/vqr/api/';
  }

  @override
  String getUrl() {
    return 'https://dev.vietqr.org/vqr/';
  }

  @override
  FirebaseOptions getFirebaseCongig() {
    return const FirebaseOptions(
      apiKey: 'AIzaSyAjPP6Mc3baFUgEsO8o0-J-qmSVegmw2TQ',
      appId: '1:84188087131:web:cd322a3f4796be944ed07e',
      messagingSenderId: '84188087131',
      projectId: 'vietqr-product',
    );
  }

  // @override
  // FirebaseOptions getFirebaseCongig() {
  //   return const FirebaseOptions(
  //     apiKey: 'AIzaSyCns_zmKTZ2O66TK-loHlvbWPvoAA3Ffu0',
  //     appId: '1:723381873229:web:5fb20affd823d725fbca04',
  //     messagingSenderId: '723381873229',
  //     projectId: 'bns-stagging',
  //   );
  // }
}
