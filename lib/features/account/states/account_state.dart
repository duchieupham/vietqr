import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/introduce_dto.dart';

enum AccountType {
  NONE,
  LOG_OUT,
}

class AccountState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final AccountType request;
  final IntroduceDTO? introduceDTO;

  const AccountState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = AccountType.NONE,
    this.introduceDTO,
  });

  AccountState copyWith({
    BlocStatus? status,
    String? msg,
    IntroduceDTO? introduceDTO,
    AccountType? request,
  }) {
    return AccountState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      introduceDTO: introduceDTO ?? this.introduceDTO,
      request: request ?? this.request,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        introduceDTO,
        request,
      ];
}
