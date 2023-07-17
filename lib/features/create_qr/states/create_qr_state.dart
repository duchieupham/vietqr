import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';

enum CreateQRType {
  NONE,
}

class CreateQRState extends Equatable {
  final BlocStatus status;
  final CreateQRType type;
  final String? msg;

  const CreateQRState({
    this.status = BlocStatus.NONE,
    this.type = CreateQRType.NONE,
    this.msg,
  });

  CreateQRState copyWith({
    BlocStatus? status,
    CreateQRType? type,
    String? msg,
  }) {
    return CreateQRState(
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
    );
  }

  @override
  List<Object?> get props => [];
}
