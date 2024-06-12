import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/add_contact_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_account_remove_dto.dart';
import 'package:vierqr/models/bank_account_terminal.dart';
import 'package:vierqr/models/bank_card_insert_dto.dart';
import 'package:vierqr/models/bank_card_insert_unauthenticated.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/confirm_otp_bank_dto.dart';
import 'package:vierqr/models/merchant_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/models/qr_create_list_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/register_authentication_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/terminal_qr_dto.dart';

import '../../../models/qr_box_dto.dart';

class BankCardRepository {
  const BankCardRepository();

  Future<List<BankTypeDTO>> getBankTypes() async {
    List<BankTypeDTO> listBanks = [];

    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}bank-type';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          listBanks = data
              .map<BankTypeDTO>((json) => BankTypeDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return listBanks;
  }

  Future<List<TerminalQRDTO>> getTerminals(String userId, String bankId) async {
    List<TerminalQRDTO> listTerminals = [];

    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}account-bank/terminal?userId=$userId&bankId=$bankId';
      final response =
          await BaseAPIClient.getAPI(url: url, type: AuthenticationType.SYSTEM);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          listTerminals = data
              .map<TerminalQRDTO>((json) => TerminalQRDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return listTerminals;
  }

  Future<List<QRBoxDTO>> getQrBox(String userId, String bankId) async {
    List<QRBoxDTO> listQrBox = [];

    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}tid/tid-box/$bankId?userId=$userId';
      final response =
          await BaseAPIClient.getAPI(url: url, type: AuthenticationType.SYSTEM);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          listQrBox =
              data.map<QRBoxDTO>((json) => QRBoxDTO.fromJson(json)).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return listQrBox;
  }

  Future<List<QRGeneratedDTO>> generateQRList(List<QRCreateDTO> list) async {
    List<QRGeneratedDTO> result = [];
    try {
      final QRCreateListDTO qrCreateListDTO = QRCreateListDTO(dtos: list);
      final String url = '${getIt.get<AppConfig>().getBaseUrl}qr/generate-list';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: qrCreateListDTO.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<QRGeneratedDTO>((json) => QRGeneratedDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> insertBankCard(BankCardInsertDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${getIt.get<AppConfig>().getBaseUrl}account-bank';
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

  Future<ResponseMessageDTO> insertBankCardUnauthenticated(
      BankCardInsertUnauthenticatedDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}account-bank/unauthenticated';
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

  Future<ResponseMessageDTO> checkExistedBank(
    String bankAccount,
    String bankTypeId,
    String type,
    String userId,
  ) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}account-bank/check-existed?bankAccount='
          '$bankAccount&bankTypeId=$bankTypeId&userId=$userId&type=$type';
      final response = await BaseAPIClient.getAPI(
        url: url,
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

  Future<List<BankAccountDTO>> getListBankAccount(String userId) async {
    List<BankAccountDTO> result = [];

    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}account-bank/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data.map<BankAccountDTO>((json) {
            return BankAccountDTO.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<BankAccountTerminal>> getListBankAccountTerminal(
      String userId, String terminalId) async {
    List<BankAccountTerminal> result = [];

    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}terminal/bank-account?terminalId=$terminalId&userId=$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data.map<BankAccountTerminal>((json) {
            return BankAccountTerminal.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> removeBankAccount(BankAccountRemoveDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${getIt.get<AppConfig>().getBaseUrl}account-bank';
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
    }
    return result;
  }

  Future<ResponseMessageDTO> unRegisterBDSD(
      {required String userId, required String bankId}) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final body = {'userId': userId, 'bankId': bankId};
      final String url = '${getIt.get<AppConfig>().getBaseUrl}member/remove';
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
    }
    return result;
  }

  Future<ResponseMessageDTO> removeMemberFromBankAccount(
      String bankId, String userId) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}account-bank/remove';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: {'bankId': bankId, 'userId': userId},
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

  //

  //request OTP
  Future<ResponseMessageDTO> requestOTP(BankCardRequestOTP dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      print(dto.toJson());
      final String url =
          '${getIt.get<AppConfig>().getUrl}bank/api/account-bank/linked/request_otp';
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

  //confirm OTP
  Future<ResponseMessageDTO> confirmOTP(ConfirmOTPBankDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getUrl}bank/api/account-bank/linked/confirm_otp';
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

  //get detail
  Future<AccountBankDetailDTO> getAccountBankDetail(String bankId) async {
    AccountBankDetailDTO result = AccountBankDetailDTO();
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}account-bank/detail/web/$bankId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = AccountBankDetailDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  //get detail
  Future<dynamic> getMerchantInfo(String bankId) async {
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}customer-va/information?bankId=$bankId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return MerchantDTO.fromJson(data);
      } else {
        var data = jsonDecode(response.body);
        return ResponseMessageDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<ResponseMessageDTO> updateRegisterAuthenticationBank(
      RegisterAuthenticationDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}account-bank/register-authentication';
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

  Future<BankNameInformationDTO> searchBankName(BankNameSearchDTO dto) async {
    String generateCheckSum(
        String bankCode, String accountType, String accountNumber) {
      String key = "VietQRAccesskey";
      String toHash = bankCode + accountType + accountNumber + key;
      // Tạo hash MD5
      var bytes = utf8.encode(toHash);
      var digest = md5.convert(bytes);
      return digest.toString();
    }

    String checkSum =
        generateCheckSum(dto.bankCode, dto.accountType, dto.accountNumber);

    BankNameInformationDTO result = const BankNameInformationDTO(
      accountName: '',
      customerName: '',
      customerShortName: '',
    );
    try {
      final String url =
          '${getIt.get<AppConfig>().getUrl}bank/api/account/info';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: {
          'bankCode': dto.bankCode,
          'accountNumber': dto.accountNumber,
          'accountType': dto.accountType,
          'transferType': dto.transferType,
          'checkSum': checkSum,
        },
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = BankNameInformationDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> unRequestOTP(body) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getUrl}bank/api/unregister_request';
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
    }
    return result;
  }

  Future<ResponseMessageDTO> unLinked(body) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getUrl}bank/api/account-bank/unlinked';
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
    }
    return result;
  }

  Future<ResponseMessageDTO> unConfirmOTP(ConfirmOTPBankDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getUrl}bank/api/unregister_confirm';
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

  Future<ResponseMessageDTO> addContact(AddContactDTO dto, {File? file}) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${getIt.get<AppConfig>().getBaseUrl}contacts';

      Map<String, dynamic> body = {};

      body = dto.toJson();

      final List<http.MultipartFile> files = [];

      if (file != null) {
        final imageFile = await http.MultipartFile.fromPath('image', file.path);
        files.add(imageFile);
      }

      final response = await BaseAPIClient.postMultipartAPI(
        url: url,
        fields: body,
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

  Future<ResponseMessageDTO> requestRegisterBankAccount(
      Map<String, dynamic> param) async {
    ResponseMessageDTO dto = ResponseMessageDTO(status: '', message: '');

    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}account-bank-request';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          dto = ResponseMessageDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return dto;
  }

  Future<List<BankTypeDTO>> getBankTypesAuthen() async {
    List<BankTypeDTO> listBanks = [];

    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}bank-type/unauthenticated';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          listBanks = data
              .map<BankTypeDTO>((json) => BankTypeDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return listBanks;
  }

  Future<QRGeneratedDTO> generateQR(Map<String, dynamic> data) async {
    QRGeneratedDTO result = QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '',
    );
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr/generate/unauthenticated';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: data,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = QRGeneratedDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
