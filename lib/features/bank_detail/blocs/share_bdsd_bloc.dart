import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail/events/share_bdsd_event.dart';
import 'package:vierqr/features/bank_detail/repositories/share_bdsd_repository.dart';
import 'package:vierqr/features/bank_detail/states/share_bdsd_state.dart';
import 'package:vierqr/features/connect_lark/repositories/connect_lark_repository.dart';
import 'package:vierqr/features/connect_telegram/repositories/connect_telegram_repository.dart';
import 'package:vierqr/models/business_branch_dto.dart';
import 'package:vierqr/models/info_tele_dto.dart';
import 'package:vierqr/models/member_branch_model.dart';
import 'package:vierqr/models/member_search_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';

class ShareBDSDBloc extends Bloc<ShareBDSDEvent, ShareBDSDState>
    with BaseManager {
  final BuildContext context;

  ShareBDSDBloc(this.context)
      : super(
          ShareBDSDState(
            listBusinessAvailDTO: [],
            listMember: [],
            listTelegram: [],
            listLark: [],
            listMemberSearch: [],
          ),
        ) {
    on<GetBusinessAvailDTOEvent>(_getBusinessAvailDTO);
    on<ConnectBranchEvent>(_connectBranch);
    on<GetMemberEvent>(_getMember);
    on<RemoveMemberEvent>(_removeMember);
    on<RemoveAllMemberEvent>(_removeAllMember);
    on<GetInfoTelegramEvent>(_getInfoTeleConnected);
    on<GetInfoLarkEvent>(_getInfoLarkConnected);
    on<AddBankLarkEvent>(_addBankLark);
    on<AddBankTelegramEvent>(_addBankTelegram);
    on<RemoveBankTelegramEvent>(_removeBankTelegram);
    on<RemoveBankLarkEvent>(_removeBankLark);
    on<SearchMemberEvent>(_searchMember);
    on<ShareUserBDSDEvent>(_shareBDSD);
    on<GetListGroupBDSDEvent>(_getListGroup);
  }

  ShareBDSDRepository repository = ShareBDSDRepository();

  ConnectLarkRepository larkRepository = ConnectLarkRepository();
  ConnectTelegramRepository telegramRepository = ConnectTelegramRepository();

  void _getBusinessAvailDTO(ShareBDSDEvent event, Emitter emit) async {
    try {
      if (event is GetBusinessAvailDTOEvent) {
        emit(
          state.copyWith(
            status: BlocStatus.LOADING_PAGE,
            request: ShareBDSDType.NONE,
          ),
        );
        final List<BusinessAvailDTO> list =
            await repository.getBusinessAndBrand(userId);
        emit(
          state.copyWith(
            status: BlocStatus.NONE,
            listBusinessAvailDTO: list,
            request: ShareBDSDType.Avail,
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE));
    }
  }

  void _getInfoTeleConnected(ShareBDSDEvent event, Emitter emit) async {
    List<InfoTeleDTO> result = [];
    bool isLark = false;
    try {
      if (event is GetInfoTelegramEvent) {
        emit(
          state.copyWith(
            status: BlocStatus.LOADING_PAGE,
            request: ShareBDSDType.NONE,
            isLoading: event.isLoading,
          ),
        );
        result = await telegramRepository.getInformation(userId);

        if (event.bankId != null && result.isNotEmpty) {
          for (var e in result) {
            if (e.banks.isNotEmpty && !isLark) {
              for (var i in e.banks) {
                if (i.bankId == event.bankId) {
                  isLark = true;
                  break;
                }
              }
            } else {
              break;
            }
          }
        }
        emit(
          state.copyWith(
            status: BlocStatus.NONE,
            request: ShareBDSDType.TELEGRAM,
            listTelegram: result,
            isTelegram: isLark,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
        state.copyWith(status: BlocStatus.NONE, request: ShareBDSDType.ERROR),
      );
    }
  }

  void _getInfoLarkConnected(ShareBDSDEvent event, Emitter emit) async {
    List<InfoLarkDTO> result = [];
    bool isLark = false;
    try {
      if (event is GetInfoLarkEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: ShareBDSDType.NONE));
        result = await larkRepository.getInformation(userId);

        if (event.bankId != null && result.isNotEmpty) {
          for (var e in result) {
            if (e.banks.isNotEmpty && !isLark) {
              for (var i in e.banks) {
                if (i.bankId == event.bankId) {
                  isLark = true;
                  break;
                }
              }
            } else {
              break;
            }
          }
        }

        emit(
          state.copyWith(
            status: BlocStatus.NONE,
            request: ShareBDSDType.LARK,
            listLark: result,
            isLark: isLark,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
        state.copyWith(status: BlocStatus.NONE, request: ShareBDSDType.ERROR),
      );
    }
  }

  void _getMember(ShareBDSDEvent event, Emitter emit) async {
    try {
      if (event is GetMemberEvent) {
        emit(
          state.copyWith(
              status: BlocStatus.LOADING_PAGE, request: ShareBDSDType.NONE),
        );

        final List<MemberBranchModel> list =
            await repository.getMemberBranch(event.bankId);
        emit(state.copyWith(
          status: BlocStatus.NONE,
          listMember: list,
          request: ShareBDSDType.MEMBER,
          isLoading: false,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE));
    }
  }

  void _getListGroup(ShareBDSDEvent event, Emitter emit) async {
    try {
      if (event is GetListGroupBDSDEvent) {
        emit(
          state.copyWith(
              status: event.loadingPage
                  ? BlocStatus.LOADING_PAGE
                  : BlocStatus.LOADING,
              request: ShareBDSDType.NONE),
        );
        if (event.type == 0 || event.type == 2) {
          final TerminalDto terminalDto = await repository.getListGroup(
              event.userID, event.type, event.offset);
          emit(state.copyWith(
            status: BlocStatus.NONE,
            listGroup: terminalDto,
            request: ShareBDSDType.GET_LIST_GROUP,
            isLoading: false,
          ));
        } else {
          final BankTerminalDto bankTerminalDto = await repository
              .getListBankShare(event.userID, event.type, event.offset);
          emit(state.copyWith(
            status: BlocStatus.NONE,
            bankShareTerminal: bankTerminalDto,
            request: ShareBDSDType.GET_LIST_GROUP,
            isLoading: false,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE));
    }
  }

  void _searchMember(ShareBDSDEvent event, Emitter emit) async {
    try {
      if (event is SearchMemberEvent) {
        emit(
          state.copyWith(
              status: BlocStatus.LOADING, request: ShareBDSDType.SEARCH_MEMBER),
        );

        final List<MemberSearchDto> list = await repository.searchMember(
            event.terminalId, event.value, event.type);
        emit(state.copyWith(
          status: BlocStatus.NONE,
          listMemberSearch: list,
          request: ShareBDSDType.SEARCH_MEMBER,
          isLoading: false,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE));
    }
  }

  void _connectBranch(ShareBDSDEvent event, Emitter emit) async {
    try {
      if (event is ConnectBranchEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ShareBDSDType.NONE));
        Map<String, dynamic> body = {
          'userId': userId,
          'bankId': event.bankId,
          'businessId': event.businessId,
          'branchId': event.branchId,
        };

        final ResponseMessageDTO responseMessageDTO =
            await repository.connectBranch(body);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
            status: BlocStatus.UNLOADING,
            request: ShareBDSDType.CONNECT,
          ));
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance
                  .getErrorMessage(responseMessageDTO.message),
              request: ShareBDSDType.ERROR,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO responseMessageDTO =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(
        state.copyWith(
          msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
          request: ShareBDSDType.ERROR,
          status: BlocStatus.UNLOADING,
        ),
      );
    }
  }

  void _removeMember(ShareBDSDEvent event, Emitter emit) async {
    try {
      if (event is RemoveMemberEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ShareBDSDType.NONE));
        Map<String, dynamic> body = {
          'userId': event.userId,
          'bankId': event.bankId,
        };

        final responseMessageDTO = await repository.removeMember(body);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: ShareBDSDType.DELETE_MEMBER));
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance
                  .getErrorMessage(responseMessageDTO.message),
              request: ShareBDSDType.ERROR,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO responseMessageDTO =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(
        state.copyWith(
          msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
          request: ShareBDSDType.ERROR,
          status: BlocStatus.UNLOADING,
        ),
      );
    }
  }

  void _removeAllMember(ShareBDSDEvent event, Emitter emit) async {
    try {
      if (event is RemoveAllMemberEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ShareBDSDType.NONE));
        Map<String, dynamic> body = {
          'bankId': event.bankId,
        };

        final responseMessageDTO = await repository.removeAllMember(body);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: ShareBDSDType.DELETE_MEMBER));
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance
                  .getErrorMessage(responseMessageDTO.message),
              request: ShareBDSDType.ERROR,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO responseMessageDTO =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(
        state.copyWith(
          msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
          request: ShareBDSDType.ERROR,
          status: BlocStatus.UNLOADING,
        ),
      );
    }
  }

  void _addBankLark(ShareBDSDEvent event, Emitter emit) async {
    try {
      if (event is AddBankLarkEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ShareBDSDType.NONE));

        final responseMessageDTO = await repository.addBankLark(event.body);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING, request: ShareBDSDType.ADD_LARK));
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance
                  .getErrorMessage(responseMessageDTO.message),
              request: ShareBDSDType.ERROR,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO responseMessageDTO =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(
        state.copyWith(
          msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
          request: ShareBDSDType.ERROR,
          status: BlocStatus.UNLOADING,
        ),
      );
    }
  }

  void _addBankTelegram(ShareBDSDEvent event, Emitter emit) async {
    try {
      if (event is AddBankTelegramEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ShareBDSDType.NONE));

        final responseMessageDTO = await repository.addBankTelegram(event.body);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: ShareBDSDType.ADD_TELEGRAM));
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance
                  .getErrorMessage(responseMessageDTO.message),
              request: ShareBDSDType.ERROR,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO responseMessageDTO =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(
        state.copyWith(
          msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
          request: ShareBDSDType.ERROR,
          status: BlocStatus.UNLOADING,
        ),
      );
    }
  }

  void _removeBankLark(ShareBDSDEvent event, Emitter emit) async {
    try {
      if (event is RemoveBankLarkEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ShareBDSDType.NONE));

        final responseMessageDTO = await repository.removeBankLark(event.body);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: ShareBDSDType.REMOVE_LARK));
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance
                  .getErrorMessage(responseMessageDTO.message),
              request: ShareBDSDType.ERROR,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO responseMessageDTO =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(
        state.copyWith(
          msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
          request: ShareBDSDType.ERROR,
          status: BlocStatus.UNLOADING,
        ),
      );
    }
  }

  void _removeBankTelegram(ShareBDSDEvent event, Emitter emit) async {
    try {
      if (event is RemoveBankTelegramEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ShareBDSDType.NONE));

        final responseMessageDTO =
            await repository.removeBankTelegram(event.body);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: ShareBDSDType.REMOVE_TELEGRAM));
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance
                  .getErrorMessage(responseMessageDTO.message),
              request: ShareBDSDType.ERROR,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO responseMessageDTO =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(
        state.copyWith(
          msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
          request: ShareBDSDType.ERROR,
          status: BlocStatus.UNLOADING,
        ),
      );
    }
  }

  void _shareBDSD(ShareBDSDEvent event, Emitter emit) async {
    try {
      if (event is ShareUserBDSDEvent) {
        emit(state.copyWith(
            userIdSelect: event.body['userId'],
            status: BlocStatus.LOADING_SHARE,
            request: ShareBDSDType.SHARE_BDSD));

        final responseMessageDTO = await repository.shareBDSD(event.body);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING, request: ShareBDSDType.SHARE_BDSD));
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance
                  .getErrorMessage(responseMessageDTO.message),
              request: ShareBDSDType.ERROR,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO responseMessageDTO =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(
        state.copyWith(
          msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
          request: ShareBDSDType.ERROR,
          status: BlocStatus.UNLOADING,
        ),
      );
    }
  }
}
