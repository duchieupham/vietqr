//env version 1.0
//env will upgrade to 2.0 version that is using flavor to manage multiple environments.

import 'package:firebase_core/firebase_core.dart';

abstract class Env {
  String getBaseUrl();
  String getBankUrl();
  String getUrl();
  FirebaseOptions getFirebaseCongig();
}
