import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/notify_trans_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/terminal_qr_dto.dart';

class CreateQRState extends Equatable {
  final BlocStatus status;
  final CreateQRType type;
  final String? msg;
  final QRGeneratedDTO? dto;
  final BankAccountDTO? bankAccountDTO;
  final NotifyTransDTO? transDTO;
  final int page;
  final String? barCode;
  final List<BankAccountDTO> listBanks;
  final List<TerminalQRDTO> listTerminal;

  const CreateQRState({
    this.status = BlocStatus.NONE,
    this.type = CreateQRType.NONE,
    this.msg,
    this.dto,
    this.bankAccountDTO,
    this.transDTO,
    this.page = -1,
    this.barCode,
    required this.listBanks,
    required this.listTerminal,
  });

  CreateQRState copyWith(
      {BlocStatus? status,
      CreateQRType? type,
      String? msg,
      QRGeneratedDTO? dto,
      BankAccountDTO? bankAccountDTO,
      NotifyTransDTO? transDTO,
      int? page,
      String? barCode,
      List<BankAccountDTO>? listBanks,
      List<TerminalQRDTO>? listTerminal}) {
    return CreateQRState(
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      dto: dto ?? this.dto,
      bankAccountDTO: bankAccountDTO ?? this.bankAccountDTO,
      transDTO: transDTO ?? this.transDTO,
      page: page ?? this.page,
      barCode: barCode ?? this.barCode,
      listBanks: listBanks ?? this.listBanks,
      listTerminal: listTerminal ?? this.listTerminal,
    );
  }

  @override
  List<Object?> get props => [
        status,
        type,
        msg,
        dto,
        bankAccountDTO,
        page,
        barCode,
        listBanks,
        listTerminal,
      ];
}
