import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/branch_filter_insert_dto.dart';
import 'package:vierqr/models/business_branch_choice_dto.dart';

class BranchRepository {
  const BranchRepository();

  Future<List<BusinessBranchChoiceDTO>> getBusinessBranchChoices(
      String userId) async {
    List<BusinessBranchChoiceDTO> result = [];
    try {
      final String url = '${EnvConfig.getBaseUrl()}branch-manage/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<BusinessBranchChoiceDTO>(
                (json) => BusinessBranchChoiceDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<BranchFilterDTO>> getBranchFilters(
      BranchFilterInsertDTO dto) async {
    List<BranchFilterDTO> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}business-information/branch/filter';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<BranchFilterDTO>((json) => BranchFilterDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
