import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/business_item_dto.dart';

class BusinessInformationState extends Equatable {
  final BusinessDetailDTO? dto;
  final String? msg;
  final List<BusinessItemDTO> list;
  final BlocStatus status;
  final List<BranchFilterDTO> listBranch;

  const BusinessInformationState({
    this.dto,
    this.msg,
    this.list = const [],
    this.listBranch = const [],
    this.status = BlocStatus.NONE,
  });

  BusinessInformationState copyWith(
      {List<BusinessItemDTO>? list,
      BlocStatus? status,
      String? msg,
      BusinessDetailDTO? dto,
      List<BranchFilterDTO>? listBranch}) {
    return BusinessInformationState(
      list: list ?? this.list,
      status: status ?? this.status,
      msg: msg ?? this.msg,
      dto: dto ?? this.dto,
      listBranch: listBranch ?? this.listBranch,
    );
  }

  @override
  List<Object?> get props => [list, status, msg, dto, listBranch];
}
