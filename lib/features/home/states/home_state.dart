import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';

enum HomeType { GET_BANK, NONE }

class HomeState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final HomeType request;
  final TypePermission type;
  final NationalScannerDTO? nationalScannerDTO;
  final String? codeQR;
  final BankTypeDTO? bankTypeDTO;
  final String bankAccount;
  final List<BankTypeDTO>? listBanks;

  const HomeState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = HomeType.NONE,
    this.type = TypePermission.None,
    this.nationalScannerDTO,
    this.codeQR,
    this.listBanks,
    this.bankTypeDTO,
    this.bankAccount = '',
  });

  HomeState copyWith({
    BlocStatus? status,
    String? msg,
    TypePermission? type,
    NationalScannerDTO? nationalScannerDTO,
    String? codeQR,
    BankTypeDTO? bankTypeDTO,
    String? bankAccount,
    HomeType? request,
    List<BankTypeDTO>? listBanks,
  }) {
    return HomeState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      type: type ?? this.type,
      nationalScannerDTO: nationalScannerDTO ?? this.nationalScannerDTO,
      codeQR: codeQR ?? this.codeQR,
      bankTypeDTO: bankTypeDTO ?? this.bankTypeDTO,
      bankAccount: bankAccount ?? this.bankAccount,
      request: request ?? this.request,
      listBanks: listBanks ?? this.listBanks,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        type,
        nationalScannerDTO,
        codeQR,
        bankTypeDTO,
        bankAccount,
        request,
        listBanks
      ];
}
