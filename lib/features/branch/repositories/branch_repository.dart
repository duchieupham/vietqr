import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/account_bank_branch_dto.dart';
import 'package:vierqr/models/account_bank_branch_insert_dto.dart';
import 'package:vierqr/models/account_bank_connect_branch_dto.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/branch_filter_insert_dto.dart';
import 'package:vierqr/models/branch_information_dto.dart';
import 'package:vierqr/models/branch_member_delete_dto.dart';
import 'package:vierqr/models/branch_member_insert_dto.dart';
import 'package:vierqr/models/business_branch_choice_dto.dart';
import 'package:vierqr/models/business_member_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

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

  Future<BranchInformationDTO> getBranchDetail(String branchId) async {
    BranchInformationDTO result = const BranchInformationDTO(
      id: '',
      businessId: '',
      code: '',
      name: '',
      address: '',
      isActive: false,
    );
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}branch/information/$branchId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = BranchInformationDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<AccountBankBranchDTO>> getBranchBanks(String id) async {
    List<AccountBankBranchDTO> result = [];
    try {
      final String url = '${EnvConfig.getBaseUrl()}bank-branch/$id';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<AccountBankBranchDTO>(
                (json) => AccountBankBranchDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<BusinessMemberDTO>> getBranchMembers(String id) async {
    List<BusinessMemberDTO> result = [];
    try {
      final String url = '${EnvConfig.getBaseUrl()}branch-member/$id';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<BusinessMemberDTO>((json) => BusinessMemberDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<dynamic> searchMemberBranch(String phoneNo, String businessId) async {
    dynamic result;
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}branch-member/search/$phoneNo/$businessId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        result = BusinessMemberDTO.fromJson(data);
      } else if (response.statusCode == 201) {
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

  Future<ResponseMessageDTO> insertMember(BranchMemberInsertDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}branch-member';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
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
    }
    return result;
  }

  Future<ResponseMessageDTO> deleteMember(BranchMemberDeleteDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}branch-member/remove';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: dto.toJson(),
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

  Future<List<AccountBankConnectBranchDTO>> getBranchConnectBanks(
      String userId) async {
    List<AccountBankConnectBranchDTO> result = [];
    try {
      final String url = '${EnvConfig.getBaseUrl()}bank-branch/search/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<AccountBankConnectBranchDTO>(
                (json) => AccountBankConnectBranchDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> addBankConnectBranch(
      AccountBankBranchInsertDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}bank-branch';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
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

  Future<ResponseMessageDTO> removeBankConnectBranch(
      AccountBankBranchInsertDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}bank-branch/remove';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
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
}
