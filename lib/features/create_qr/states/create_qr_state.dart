import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/notification_transaction_success_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

enum CreateQRType {
  NONE,
  CREATE_QR,
  UPLOAD_IMAGE,
  ERROR,
  PAID,
  LOAD_DATA,
  SCAN_QR,
  SCAN_NOT_FOUND,
}

class CreateQRState extends Equatable {
  final BlocStatus status;
  final CreateQRType type;
  final String? msg;
  final QRGeneratedDTO? dto;
  final BankAccountDTO? bankAccountDTO;
  final AccountBankDetailDTO? bankDetailDTO;
  final NotificationTransactionSuccessDTO? transDTO;
  final int page;
  final String? barCode;

  const CreateQRState({
    this.status = BlocStatus.NONE,
    this.type = CreateQRType.NONE,
    this.msg,
    this.dto,
    this.bankAccountDTO,
    this.bankDetailDTO,
    this.transDTO,
    this.page = -1,
    this.barCode,
  });

  CreateQRState copyWith({
    BlocStatus? status,
    CreateQRType? type,
    String? msg,
    QRGeneratedDTO? dto,
    BankAccountDTO? bankAccountDTO,
    AccountBankDetailDTO? bankDetailDTO,
    NotificationTransactionSuccessDTO? transDTO,
    int? page,
    String? barCode,
  }) {
    return CreateQRState(
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      dto: dto ?? this.dto,
      bankAccountDTO: bankAccountDTO ?? this.bankAccountDTO,
      bankDetailDTO: bankDetailDTO ?? this.bankDetailDTO,
      transDTO: transDTO ?? this.transDTO,
      page: page ?? this.page,
      barCode: barCode ?? this.barCode,
    );
  }

  @override
  List<Object?> get props => [
        status,
        type,
        msg,
        dto,
        bankAccountDTO,
        bankDetailDTO,
        page,
        barCode,
      ];
}
