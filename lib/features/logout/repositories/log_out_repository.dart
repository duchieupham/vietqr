import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/services/providers/register_provider.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';
import 'package:vierqr/services/shared_references/event_bloc_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class LogoutRepository {
  const LogoutRepository();

  Future<bool> logout() async {
    bool result = false;
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/logout';
      String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: {'fcmToken': fcmToken},
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        await _resetServices().then((value) => result = true);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<void> _resetServices() async {
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    Provider.of<CreateQRProvider>(context, listen: false).reset();
    Provider.of<CreateQRPageSelectProvider>(context, listen: false).reset();
    Provider.of<BankAccountProvider>(context, listen: false).reset();
    Provider.of<UserEditProvider>(context, listen: false).reset();
    Provider.of<RegisterProvider>(context, listen: false).reset();
    Provider.of<SuggestionWidgetProvider>(context, listen: false).reset();
    await EventBlocHelper.instance.updateLogoutBefore(true);
    await UserInformationHelper.instance.initialUserInformationHelper();
    await AccountHelper.instance.setBankToken('');
    await AccountHelper.instance.setToken('');
  }
}
