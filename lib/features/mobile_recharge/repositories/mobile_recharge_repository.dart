import 'dart:convert';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/network_providers_dto.dart';

class MobileRechargeRepository {
  const MobileRechargeRepository();

  Future<List<NetworkProviders>> getListNetworkProviders() async {
    List<NetworkProviders> results = [];
    try {
      final String url = '${EnvConfig.getBaseUrl()}mobile-carrier/type';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        results = data
            .map<NetworkProviders>((json) => NetworkProviders.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return results;
  }
}
