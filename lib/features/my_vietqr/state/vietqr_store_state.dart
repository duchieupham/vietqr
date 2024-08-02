import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/vietqr_store_dto.dart';

class VietQRStoreState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final VietQrStore request;
  final List<VietQRStoreDTO> listStore;
  final VietQRStoreDTO? storeSelect;
  final TerminalDTO? terminal;
  final MetaDataDTO? metadata;

  const VietQRStoreState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = VietQrStore.NONE,
    required this.listStore,
    this.storeSelect,
    this.terminal,
    this.metadata,
  });

  VietQRStoreState copyWith({
    BlocStatus? status,
    VietQrStore? request,
    String? msg,
    List<VietQRStoreDTO>? listStore,
    VietQRStoreDTO? storeSelect,
    TerminalDTO? terminal,
    MetaDataDTO? metadata,
  }) {
    return VietQRStoreState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      listStore: listStore ?? this.listStore,
      storeSelect: storeSelect ?? this.storeSelect,
      terminal: terminal ?? this.terminal,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props =>
      [msg, status, request, listStore, storeSelect, terminal, metadata];
}
