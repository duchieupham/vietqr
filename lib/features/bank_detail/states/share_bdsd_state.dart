import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/business_branch_dto.dart';
import 'package:vierqr/models/info_tele_dto.dart';
import 'package:vierqr/models/member_branch_model.dart';
import 'package:vierqr/models/member_search_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';

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
  final bool isLoadMore;
  final TerminalDto listTerminal;
  final BankTerminalDto? bankShareTerminal;
  final String userIdSelect;
  final bool isEmpty;
  final int offset;

  const ShareBDSDState({
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
    this.isLoadMore = true,
    this.isEmpty = false,
    this.userIdSelect = '',
    required this.listTerminal,
    this.bankShareTerminal,
    this.offset = 0,
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
    bool? isLoadMore,
    bool? isEmpty,
    TerminalDto? listTerminal,
    String? userIdSelect,
    BankTerminalDto? bankShareTerminal,
    int? offset,
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
      isEmpty: isEmpty ?? this.isEmpty,
      userIdSelect: userIdSelect ?? this.userIdSelect,
      listTerminal: listTerminal ?? this.listTerminal,
      bankShareTerminal: bankShareTerminal ?? this.bankShareTerminal,
      offset: offset ?? this.offset,
      isLoadMore: isLoadMore ?? this.isLoadMore,
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
        listTerminal,
        bankShareTerminal,
        isEmpty,
        offset,
      ];
}
