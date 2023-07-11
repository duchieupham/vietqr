import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/models/introduce_dto.dart';

class AccountState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final IntroduceDTO? introduceDTO;

  const AccountState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.introduceDTO,
  });

  AccountState copyWith({
    BlocStatus? status,
    String? msg,
    IntroduceDTO? introduceDTO,
  }) {
    return AccountState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      introduceDTO: introduceDTO ?? this.introduceDTO,
    );
  }

  @override
  List<Object?> get props => [status, msg, introduceDTO];
}
