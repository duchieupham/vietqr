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
import 'package:vierqr/models/response_message_dto.dart';

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
          ),
        ) {
    on<GetBusinessAvailDTOEvent>(_getBusinessAvailDTO);
    on<ConnectBranchEvent>(_connectBranch);
    on<GetMemberEvent>(_getMember);
    on<DeleteMemberEvent>(_removeMember);
    on<GetInfoTelegramEvent>(_getInfoTeleConnected);
    on<GetInfoLarkEvent>(_getInfoLarkConnected);
    on<AddBankLarkEvent>(_addBankLark);
    on<AddBankTelegramEvent>(_addBankTelegram);
    on<RemoveBankTelegramEvent>(_removeBankTelegram);
    on<RemoveBankLarkEvent>(_removeBankLark);
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
        emit(state.copyWith(
            status: BlocStatus.NONE,
            listBusinessAvailDTO: list,
            request: ShareBDSDType.Avail));
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
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: ShareBDSDType.NONE));
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
              status: BlocStatus.LOADING, request: ShareBDSDType.NONE),
        );
        String branchId = '';

        if (state.branchId != null) {
          branchId = state.branchId ?? '';
        } else {
          branchId = event.branchId ?? '';
        }

        final List<MemberBranchModel> list =
            await repository.getMemberBranch(branchId);
        emit(state.copyWith(
          status: BlocStatus.UNLOADING,
          listMember: list,
          request: ShareBDSDType.MEMBER,
          branchId: event.branchId,
          businessId: event.businessId,
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
      if (event is DeleteMemberEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ShareBDSDType.NONE));
        Map<String, dynamic> body = {
          'userId': event.userId,
          'businessId': event.businessId,
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
}
