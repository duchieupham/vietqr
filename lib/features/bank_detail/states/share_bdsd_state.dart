import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/business_branch_dto.dart';
import 'package:vierqr/models/info_tele_dto.dart';
import 'package:vierqr/models/member_branch_model.dart';
import 'package:vierqr/models/member_search_dto.dart';

class ShareBDSDState extends Equatable {
  final BlocStatus status;
  final String? msg;
  final ShareBDSDType request;
  final List<BusinessAvailDTO> listBusinessAvailDTO;
  final List<MemberBranchModel> listMember;
  final List<MemberSearchDto> listMemberSearch;
  final String? branchId;
  final String? businessId;
  final List<InfoTeleDTO> listTelegram;
  final List<InfoLarkDTO> listLark;
  final bool isTelegram;
  final bool isLark;
  final bool isLoading;

  ShareBDSDState({
    this.status = BlocStatus.NONE,
    this.msg,
    this.request = ShareBDSDType.NONE,
    required this.listBusinessAvailDTO,
    required this.listMember,
    required this.listMemberSearch,
    this.businessId,
    this.branchId,
    required this.listTelegram,
    required this.listLark,
    this.isLark = false,
    this.isTelegram = false,
    this.isLoading = false,
  });

  ShareBDSDState copyWith({
    BlocStatus? status,
    ShareBDSDType? request,
    String? msg,
    List<BusinessAvailDTO>? listBusinessAvailDTO,
    List<MemberBranchModel>? listMember,
    List<MemberSearchDto>? listMemberSearch,
    String? branchId,
    String? businessId,
    List<InfoTeleDTO>? listTelegram,
    List<InfoLarkDTO>? listLark,
    bool? isTelegram,
    bool? isLark,
    bool? isLoading,
  }) {
    return ShareBDSDState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      listBusinessAvailDTO: listBusinessAvailDTO ?? this.listBusinessAvailDTO,
      listMember: listMember ?? this.listMember,
      branchId: branchId ?? this.branchId,
      businessId: businessId ?? this.businessId,
      listMemberSearch: listMemberSearch ?? this.listMemberSearch,
      listTelegram: listTelegram ?? this.listTelegram,
      listLark: listLark ?? this.listLark,
      isLark: isLark ?? this.isLark,
      isTelegram: isTelegram ?? this.isTelegram,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        request,
        listBusinessAvailDTO,
        listMember,
        listMemberSearch,
      ];
}
