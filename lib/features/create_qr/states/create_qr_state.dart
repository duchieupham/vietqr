import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/notification_transaction_success_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/transaction_receive_dto.dart';

enum CreateQRType {
  NONE,
  CREATE_QR,
  UPLOAD_IMAGE,
  ERROR,
  PAID,
}

class CreateQRState extends Equatable {
  final BlocStatus status;
  final CreateQRType type;
  final String? msg;
  final QRGeneratedDTO? dto;
  final BankAccountDTO? bankAccountDTO;
  final NotificationTransactionSuccessDTO? transDTO;

  const CreateQRState({
    this.status = BlocStatus.NONE,
    this.type = CreateQRType.NONE,
    this.msg,
    this.dto,
    this.bankAccountDTO,
    this.transDTO,
  });

  CreateQRState copyWith(
      {BlocStatus? status,
      CreateQRType? type,
      String? msg,
      QRGeneratedDTO? dto,
      BankAccountDTO? bankAccountDTO,
      NotificationTransactionSuccessDTO? transDTO}) {
    return CreateQRState(
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      dto: dto ?? this.dto,
      bankAccountDTO: bankAccountDTO ?? this.bankAccountDTO,
      transDTO: transDTO ?? this.transDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        type,
        msg,
        dto,
        bankAccountDTO,
      ];
}
