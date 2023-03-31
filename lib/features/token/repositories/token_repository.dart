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

  Future<bool> checkValidToken() async {
    bool result = false;
    try {
      String url = '${EnvConfig.getBaseUrl()}token';
      final response =
          await BaseAPIClient.getAPI(url: url, type: AuthenticationType.SYSTEM);
      if (response.statusCode == 200) {
        result = true;
      }
    } catch (e) {
      LOG.error(e.toString());
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
