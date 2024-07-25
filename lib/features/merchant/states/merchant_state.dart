import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/response_message_dto.dart';

enum MerchantType {
  NONE,
  UPDATE_PHONE,
  UPDATE_NATIONAL,
  GET_MERCHANT,
  CREATE_SUCCESS,
  REQUEST_OTP,
  CONFIRM_OTP,
  INSERT_MERCHANT,
  UNREGISTER_MERCHANT,
  ERROR,
}

class MerchantState extends Equatable {
  final BlocStatus status;
  final String? msg;
  final MerchantType request;
  final bool isLoading;
  final bool isEmpty;
  final String national;
  final String phone;
  final String vaNumber;
  final ResponseMessageDTO responseDTO;

  const MerchantState({
    this.status = BlocStatus.NONE,
    this.msg,
    this.request = MerchantType.NONE,
    this.isLoading = false,
    this.isEmpty = false,
    this.national = '',
    this.phone = '',
    this.vaNumber = '',
    required this.responseDTO,
  });

  MerchantState copyWith({
    BlocStatus? status,
    MerchantType? request,
    String? msg,
    bool? isLoading,
    bool? isEmpty,
    String? phone,
    String? vaNumber,
    String? national,
    ResponseMessageDTO? responseDTO,
  }) {
    return MerchantState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      isLoading: isLoading ?? this.isLoading,
      isEmpty: isEmpty ?? this.isEmpty,
      national: national ?? this.national,
      phone: phone ?? this.phone,
      vaNumber: vaNumber ?? this.vaNumber,
      responseDTO: responseDTO ?? this.responseDTO,
    );
  }

  @override
  List<Object?> get props =>
      [status, msg, request, isEmpty, phone, national, vaNumber, responseDTO];
}
