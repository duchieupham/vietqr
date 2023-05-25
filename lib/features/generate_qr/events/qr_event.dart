import 'package:equatable/equatable.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/models/qr_recreate_dto.dart';

class QREvent extends Equatable {
  const QREvent();

  @override
  List<Object?> get props => [];
}

class QREventGenerateList extends QREvent {
  final List<QRCreateDTO> list;

  const QREventGenerateList({required this.list});

  @override
  List<Object?> get props => [list];
}

class QREventGenerate extends QREvent {
  final QRCreateDTO dto;

  const QREventGenerate({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class QREventRegenerate extends QREvent {
  final QRRecreateDTO dto;

  const QREventRegenerate({required this.dto});

  @override
  List<Object?> get props => [dto];
}
