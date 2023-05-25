import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/fcm_token_update_dto.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class TokenRepository {
  const TokenRepository();

  //return
  //0: ignore
  //1: success
  //2: maintain
  //3: connection failed
  //4: token expired
  Future<int> checkValidToken() async {
    int result = 0;
    try {
      String url = '${EnvConfig.getBaseUrl()}token';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      if (response.statusCode == 200) {
        result = 1;
      } else if (response.statusCode == 404 || response.statusCode == 400) {
        result = 2;
      } else if (response.statusCode == 403) {
        result = 4;
      }
    } catch (e) {
      LOG.error(e.toString());
      if (e.toString().contains('Connection failed')) {
        result = 3;
      }
    }
    return result;
  }

  Future<bool> updateFcmToken() async {
    bool result = false;
    try {
      String userId = UserInformationHelper.instance.getUserId();
      String oldToken = AccountHelper.instance.getFcmToken();
      String newToken = await FirebaseMessaging.instance.getToken() ?? '';
      if (oldToken.trim() != newToken.trim()) {
        FcmTokenUpdateDTO dto = FcmTokenUpdateDTO(
            userId: userId, oldToken: oldToken, newToken: newToken);
        final String url = '${EnvConfig.getBaseUrl()}fcm-token/update';
        final response = await BaseAPIClient.postAPI(
          url: url,
          body: dto.toJson(),
          type: AuthenticationType.SYSTEM,
        );
        if (response.statusCode == 200) {
          result = true;
        }
      } else {
        result = true;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
