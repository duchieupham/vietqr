import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/business_branch_dto.dart';
import 'package:vierqr/models/detail_group_dto.dart';
import 'package:vierqr/models/member_branch_model.dart';
import 'package:vierqr/models/member_search_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';

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

  Future<ResponseMessageDTO> removeMember(Map<String, dynamic> body) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}member/remove';
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

  Future<ResponseMessageDTO> removeAllMember(Map<String, dynamic> body) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}member/remove-all';
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

  Future<List<MemberBranchModel>> getMemberBranch(String bankID) async {
    List<MemberBranchModel> listMembers = [];

    try {
      String url = '${EnvConfig.getBaseUrl()}member/$bankID';
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

  Future<List<MemberSearchDto>> searchMember(
    String terminalId,
    String value,
    int type,
  ) async {
    List<MemberSearchDto> listMembers = [];

    try {
      String url =
          '${EnvConfig.getBaseUrl()}terminal-member/search?type=$type&value=$value&terminalId=$terminalId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          listMembers = data
              .map<MemberSearchDto>((json) => MemberSearchDto.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      return listMembers;
    }
    return listMembers;
  }

  Future<List<AccountMemberDTO>> searchMemberNew(
    String terminalId,
    String value,
    int type,
  ) async {
    List<AccountMemberDTO> listMembers = [];

    try {
      String url =
          '${EnvConfig.getBaseUrl()}terminal-member/search?type=$type&value=$value&terminalId=$terminalId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          listMembers = data
              .map<AccountMemberDTO>((json) => AccountMemberDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      return listMembers;
    }
    return listMembers;
  }

  Future<ResponseMessageDTO> shareBDSD(Map<String, dynamic> param) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}member';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
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

  Future<TerminalDto> getListGroup(String userId, int type, int offset) async {
    TerminalDto result = TerminalDto(terminals: []);
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}terminal?userId=$userId&type=$type&offset=$offset';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = TerminalDto.fromJson(data);
        }
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }

  Future<TerminalDto> getMyListGroup(
      String userId, String type, int offset) async {
    TerminalDto result = TerminalDto(terminals: []);
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}terminal/bank?userId=$userId&bankId=$type&offset=$offset';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = TerminalDto.fromJson(data);
        }
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }

    Future<TerminalDto> getMyListGroup1(
      String userId, String type, int offset) async {
    TerminalDto result = TerminalDto(terminals: []);
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}account-bank/terminal?userId=$userId&bankId=$type';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = TerminalDto.fromJson(data);
        }
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }

  Future<BankTerminalDto> getListBankShare(
      String userId, int type, int offset) async {
    BankTerminalDto result = BankTerminalDto(bankShares: []);
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}terminal?userId=$userId&type=$type&offset=$offset';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = BankTerminalDto.fromJson(data);
        }
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }
}
