import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/business_detail_dto.dart';

class BusinessTransState extends Equatable {
  final BusinessDetailDTO? dto;
  final String? msg;
  final List<BusinessTransactionDTO> listTrans;
  final BlocStatus status;
  final TransType type;
  final List<BranchFilterDTO> listBranch;
  final bool isLoadMore;
  final int offset;

  const BusinessTransState({
    this.dto,
    this.msg,
    this.listTrans = const [],
    this.listBranch = const [],
    this.status = BlocStatus.NONE,
    this.type = TransType.NONE,
    this.isLoadMore = false,
    this.offset = 0,
  });

  BusinessTransState copyWith({
    BlocStatus? status,
    TransType? type,
    String? msg,
    List<BusinessTransactionDTO>? listTrans,
    BusinessDetailDTO? dto,
    List<BranchFilterDTO>? listBranch,
    bool? isLoadMore,
    int? offset,
  }) {
    return BusinessTransState(
      listTrans: listTrans ?? this.listTrans,
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      dto: dto ?? this.dto,
      listBranch: listBranch ?? this.listBranch,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      offset: offset ?? this.offset,
    );
  }

  @override
  List<Object?> get props => [
        listTrans,
        status,
        msg,
        dto,
        listBranch,
        type,
        isLoadMore,
        offset,
      ];
}
