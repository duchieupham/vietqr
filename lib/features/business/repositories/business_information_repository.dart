import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/branch_filter_insert_dto.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/business_information_insert_dto.dart';
import 'package:vierqr/models/business_item_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BusinessInformationRepository {
  const BusinessInformationRepository();

  Future<ResponseMessageDTO> insertBusinessInformation(
      BusinessInformationInsertDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}business-information';
      final List<http.MultipartFile> files = [];
      if (dto.image != null) {
        final imageFile =
            await http.MultipartFile.fromPath('image', dto.image!.path);
        files.add(imageFile);
      }
      if (dto.coverImage != null) {
        final imageFile = await http.MultipartFile.fromPath(
            'coverImage', dto.coverImage!.path);
        files.add(imageFile);
      }
      final response = await BaseAPIClient.postMultipartAPI(
        url: url,
        fields: dto.toJson(),
        files: files,
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

  Future<List<BusinessItemDTO>> getBusinessItems(String userId) async {
    List<BusinessItemDTO> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}business-informations/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<BusinessItemDTO>((json) => BusinessItemDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<BusinessDetailDTO> getBusinessDetail(
      String businessId, String userId) async {
    BusinessDetailDTO result = const BusinessDetailDTO(
      id: '',
      name: '',
      address: '',
      code: '',
      imgId: '',
      coverImgId: '',
      taxCode: '',
      userRole: 0,
      managers: [],
      branchs: [],
      transactions: [],
      active: false,
    );
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}business-information/detail/$businessId/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = BusinessDetailDTO.fromJson(data);
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

  Future<ResponseMessageDTO> removeBusinessItems(String businessId) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}business/remove/$businessId';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: {},
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }
}
