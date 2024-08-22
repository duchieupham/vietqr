import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

import '../../../commons/enums/enum_type.dart';

class RegisterRepository {
  RegisterRepository();

  final auth = FirebaseAuth.instance;

  static const String countryCode = '+84';

  Future<ResponseMessageDTO> register(AccountLoginDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}accounts/register';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }


  Future<dynamic> verifyOTP(String otp, String verificationId) async {
    try {
      var credentials = await auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: otp));
      // updateResendToken(null);
      return credentials.user != null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'session-expired') {
        // updateResendToken(null);
      }
      return e.code;
    }
  }
}
