import 'dart:convert';
import 'dart:io';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/business_branch_dto.dart';
import 'package:vierqr/models/member_branch_model.dart';
import 'package:vierqr/models/response_message_dto.dart';

class ShareBDSDRepository {
  const ShareBDSDRepository();

  Future<List<BusinessAvailDTO>> getBusinessAndBrand(String userId) async {
    List<BusinessAvailDTO> listBusinessAvailDTO = [];

    try {
      String url = '${EnvConfig.getBaseUrl()}business/valid/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          listBusinessAvailDTO = data
              .map<BusinessAvailDTO>((json) => BusinessAvailDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return listBusinessAvailDTO;
  }

  Future<ResponseMessageDTO> connectBranch(body) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}bank-branch';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: body,
        type: AuthenticationType.SYSTEM,
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

  Future<ResponseMessageDTO> removeMember(body) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}branch-member/remove';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: body,
        type: AuthenticationType.SYSTEM,
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

  Future<ResponseMessageDTO> addBankLark(body) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}service/lark/bank';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: body,
        type: AuthenticationType.SYSTEM,
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

  Future<ResponseMessageDTO> addBankTelegram(body) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}service/telegram/bank';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: body,
        type: AuthenticationType.SYSTEM,
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

  Future<ResponseMessageDTO> removeBankTelegram(body) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}service/telegram/bank';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: body,
        type: AuthenticationType.SYSTEM,
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

  Future<ResponseMessageDTO> removeBankLark(body) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}service/lark/bank';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: body,
        type: AuthenticationType.SYSTEM,
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

  Future<List<MemberBranchModel>> getMemberBranch(String branchId) async {
    List<MemberBranchModel> listMembers = [];

    try {
      String url = '${EnvConfig.getBaseUrl()}branch-member/$branchId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          listMembers = data
              .map<MemberBranchModel>(
                  (json) => MemberBranchModel.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return listMembers;
  }
}
