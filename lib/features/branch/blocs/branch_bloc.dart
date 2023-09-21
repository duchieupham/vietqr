import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/branch/events/branch_event.dart';
import 'package:vierqr/features/branch/repositories/branch_repository.dart';
import 'package:vierqr/features/branch/states/branch_state.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_bank_branch_dto.dart';
import 'package:vierqr/models/account_bank_connect_branch_dto.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/branch_information_dto.dart';
import 'package:vierqr/models/business_branch_choice_dto.dart';
import 'package:vierqr/models/business_member_dto.dart';
import 'package:vierqr/models/member_branch_model.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  BranchBloc() : super(BranchInitialState()) {
    on<BranchEventGetChoice>(_getBusinessBranchChoice);
    on<BranchEventGetFilter>(_getFilter);
    on<BranchEventGetDetail>(_getDetail);
    on<BranchEventGetBanks>(_getBanks);
    on<BranchEventGetMembers>(_getMembers);
    on<BranchEventSearchMember>(_searchMember);
    on<BranchEventInitial>(_initial);
    on<BranchEventInsertMember>(_insertMember);
    on<BranchEventRemove>(_deleteMember);
    on<BranchEventGetConnectBanks>(_getConnectBanks);
    on<BranchEventConnectBank>(_connectBank);
    on<BranchEventRemoveBank>(_removeBank);
  }

  void _getMembers(BranchEvent event, Emitter emit) async {
    try {
      if (event is BranchEventGetMembers) {
        emit(BranchGetMembersLoadingState());
        List<BusinessMemberDTO> list =
            await branchRepository.getBranchMembers(event.id);
        emit(BranchGetMembersSuccessState(list: list));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(BranchGetMembersFailedState());
    }
  }

  void _getBusinessBranchChoice(BranchEvent event, Emitter emit) async {
    try {
      if (event is BranchEventGetChoice) {
        List<BusinessBranchChoiceDTO> result =
            await branchRepository.getBusinessBranchChoices(event.userId);
        emit(BranchChoiceSuccessfulState(list: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(BranchChoiceFailedState());
    }
  }

  void _getFilter(BranchEvent event, Emitter emit) async {
    try {
      if (event is BranchEventGetFilter) {
        List<BranchFilterDTO> result =
            await branchRepository.getBranchFilters(event.dto);
        emit(BranchGetFilterSuccessState(list: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(BranchGetFilterFailedState());
    }
  }

  void _getDetail(BranchEvent event, Emitter emit) async {
    try {
      if (event is BranchEventGetDetail) {
        emit(BranchDetailLoadingState());
        BranchInformationDTO dto =
            await branchRepository.getBranchDetail(event.id);
        emit(BranchDetailSuccessState(dto: dto));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(BranchDetailFailedState());
    }
  }

  void _getBanks(BranchEvent event, Emitter emit) async {
    try {
      if (event is BranchEventGetBanks) {
        emit(BranchGetBanksLoadingState());
        List<AccountBankBranchDTO> list =
            await branchRepository.getBranchBanks(event.id);
        final List<Color> colors = [];
        PaletteGenerator? paletteGenerator;
        BuildContext context = NavigationService.navigatorKey.currentContext!;
        if (list.isNotEmpty) {
          for (AccountBankBranchDTO dto in list) {
            NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
            paletteGenerator = await PaletteGenerator.fromImageProvider(image);
            if (paletteGenerator.dominantColor != null) {
              colors.add(paletteGenerator.dominantColor!.color);
            } else {
              colors.add(Theme.of(context).cardColor);
            }
          }
        }
        emit(BranchGetBanksSuccessState(list: list, colors: colors));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(BranchGetBanksFailedState());
    }
  }

  void _searchMember(BranchEvent event, Emitter emit) async {
    try {
      if (event is BranchEventSearchMember) {
        emit(BranchSeachMemberLoadingState());
        final responseDTO = await branchRepository.searchMemberBranch(
            event.phoneNo, event.businessId, event.type);
        if (responseDTO is BusinessMemberDTO) {
          BusinessMemberDTO result = responseDTO;
          emit(BranchSearchMemberSuccessState(dto: result, listMember: []));
        } else if (responseDTO is ResponseMessageDTO) {
          ResponseMessageDTO result = responseDTO;
          emit(BranchSearchMemberNotFoundState(
              message: CheckUtils.instance.getCheckMessage(result.message)));
        } else if (responseDTO is List<MemberBranchModel>) {
          emit(BranchSearchMemberSuccessState(
              dto: null, listMember: responseDTO));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(BranchSeachMemberFailedState());
    }
  }

  void _initial(BranchEvent event, Emitter emit) async {
    emit(BranchInitialState());
  }

  void _insertMember(BranchEvent event, Emitter emit) async {
    try {
      if (event is BranchEventInsertMember) {
        emit(BranchInsertMemberLoadingState());
        final ResponseMessageDTO result =
            await branchRepository.insertMember(event.dto);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(BranchInsertMemberSuccessState());
        } else {
          emit(
            BranchInsertMemberFailedState(
              message: ErrorUtils.instance.getErrorMessage(result.message),
            ),
          );
        }
      }
    } catch (e) {
      ResponseMessageDTO result =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      LOG.error(e.toString());
      emit(
        BranchInsertMemberFailedState(
          message: ErrorUtils.instance.getErrorMessage(result.message),
        ),
      );
    }
  }

  void _deleteMember(BranchEvent event, Emitter emit) async {
    try {
      if (event is BranchEventRemove) {
        emit(BranchDeleteMemberLoadingState(index: event.index));
        final ResponseMessageDTO result =
            await branchRepository.deleteMember(event.dto);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(BranchDeleteMemberSuccessState(index: event.index));
        } else {
          emit(
            BranchDeleteMemberFailedState(
              message: ErrorUtils.instance.getErrorMessage(result.message),
              index: event.index,
            ),
          );
        }
      }
    } catch (e) {
      ResponseMessageDTO result =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      LOG.error(e.toString());
      emit(
        BranchDeleteMemberFailedState(
          message: ErrorUtils.instance.getErrorMessage(result.message),
          index: 0,
        ),
      );
    }
  }

  void _getConnectBanks(BranchEvent event, Emitter emit) async {
    try {
      if (event is BranchEventGetConnectBanks) {
        emit(BranchGetConnectBankLoadingState());
        final List<AccountBankConnectBranchDTO> list =
            await branchRepository.getBranchConnectBanks(event.userId);
        final List<Color> colors = [];
        PaletteGenerator? paletteGenerator;
        BuildContext context = NavigationService.navigatorKey.currentContext!;
        if (list.isNotEmpty) {
          for (AccountBankConnectBranchDTO dto in list) {
            NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
            paletteGenerator = await PaletteGenerator.fromImageProvider(image);
            if (paletteGenerator.dominantColor != null) {
              colors.add(paletteGenerator.dominantColor!.color);
            } else {
              colors.add(Theme.of(context).cardColor);
            }
          }
        }
        emit(BranchGetConnectBankSuccessState(list: list, colors: colors));
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO result =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      LOG.error(e.toString());
      emit(
        BranchGetConnectBankFailedState(
          message: ErrorUtils.instance.getErrorMessage(result.message),
        ),
      );
    }
  }

  void _connectBank(BranchEvent event, Emitter emit) async {
    try {
      if (event is BranchEventConnectBank) {
        emit(BranchConnectBankLoadingState());
        final ResponseMessageDTO result =
            await branchRepository.addBankConnectBranch(event.dto);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(BranchConnectBankSuccessState());
        } else {
          emit(
            BranchConnectBankFailedState(
              message: ErrorUtils.instance.getErrorMessage(result.message),
            ),
          );
        }
      }
    } catch (e) {
      ResponseMessageDTO result =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      LOG.error(e.toString());
      emit(
        BranchConnectBankFailedState(
          message: ErrorUtils.instance.getErrorMessage(result.message),
        ),
      );
    }
  }

  void _removeBank(BranchEvent event, Emitter emit) async {
    try {
      if (event is BranchEventRemoveBank) {
        emit(BranchRemoveBankLoadingState());
        final ResponseMessageDTO result =
            await branchRepository.removeBankConnectBranch(event.dto);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(BranchRemoveBankSuccessState());
        } else {
          emit(
            BranchRemoveBankFailedState(
              message: ErrorUtils.instance.getErrorMessage(result.message),
            ),
          );
        }
      }
    } catch (e) {
      ResponseMessageDTO result =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      LOG.error(e.toString());
      emit(
        BranchRemoveBankFailedState(
          message: ErrorUtils.instance.getErrorMessage(result.message),
        ),
      );
    }
  }
}

const BranchRepository branchRepository = BranchRepository();
