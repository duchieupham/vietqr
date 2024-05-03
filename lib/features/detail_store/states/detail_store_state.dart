import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/store/detail_store_dto.dart';
import 'package:vierqr/models/store/member_store_dto.dart';
import 'package:vierqr/models/store/trans_store_dto.dart';

enum DetailStoreType {
  NONE,
  GET_TRANS,
  GET_DETAIL,
  GET_QR,
  GET_MEMBER,
  ADD_MEMBER,
  REMOVE_MEMBER,
  GET_TERMINAL,
  ERROR
}

class DetailStoreState extends Equatable {
  final BlocStatus status;
  final DetailStoreType request;
  final String? msg;
  final DetailStoreDTO detailStore;
  final List<MemberStoreDTO> members;
  final List<SubTerminal> terminals;
  final bool isEmpty;
  final bool isLoadMore;
  final int page;
  final TransStoreDTO transDTO;

  DetailStoreState({
    this.status = BlocStatus.NONE,
    this.request = DetailStoreType.NONE,
    this.msg,
    required this.detailStore,
    this.isEmpty = false,
    this.isLoadMore = true,
    this.page = 1,
    required this.members,
    required this.terminals,
    required this.transDTO,
  });

  DetailStoreState copyWith({
    BlocStatus? status,
    DetailStoreType? request,
    String? msg,
    DetailStoreDTO? detailStore,
    List<MemberStoreDTO>? members,
    List<SubTerminal>? terminals,
    bool? isEmpty,
    bool? isLoadMore,
    int? page,
    TransStoreDTO? transDTO,
  }) {
    return DetailStoreState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      detailStore: detailStore ?? this.detailStore,
      members: members ?? this.members,
      terminals: terminals ?? this.terminals,
      isEmpty: isEmpty ?? this.isEmpty,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      page: page ?? this.page,
      transDTO: transDTO ?? this.transDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        request,
        msg,
        detailStore,
        members,
        page,
        isEmpty,
        isLoadMore,
        transDTO,
      ];
}
