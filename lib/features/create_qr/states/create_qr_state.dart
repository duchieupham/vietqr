import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

enum CreateQRType { NONE, CREATE_QR, UPLOAD_IMAGE, ERROR }

class CreateQRState extends Equatable {
  final BlocStatus status;
  final CreateQRType type;
  final String? msg;
  final QRGeneratedDTO? dto;

  const CreateQRState({
    this.status = BlocStatus.NONE,
    this.type = CreateQRType.NONE,
    this.msg,
    this.dto,
  });

  CreateQRState copyWith({
    BlocStatus? status,
    CreateQRType? type,
    String? msg,
    QRGeneratedDTO? dto,
  }) {
    return CreateQRState(
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      dto: dto ?? this.dto,
    );
  }

  @override
  List<Object?> get props => [
        status,
        type,
        msg,
        dto,
      ];
}
