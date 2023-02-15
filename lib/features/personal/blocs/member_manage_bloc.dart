import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/features/bank_card/events/member_manage_event.dart';
import 'package:vierqr/features/personal/repositories/member_manage_repository.dart';
import 'package:vierqr/features/personal/states/member_manage_state.dart';
import 'package:vierqr/models/user_bank_dto.dart';

class MemberManageBloc extends Bloc<MemberManageEvent, MemberManageState> {
  MemberManageBloc() : super(MemberManageInitialState()) {
    on<MemberManageEventGetList>(_getListBankAccount);
    on<MemberManageEventRemove>(_removeUserFromBank);
    on<MemberManageEventAdd>(_addUserIntoBank);
  }
  final MemberManageRepository memberManageRepository =
      const MemberManageRepository();

  void _getListBankAccount(MemberManageEvent event, Emitter emit) async {
    try {
      if (event is MemberManageEventGetList) {
        emit(MemberManageLoadingState());
        final List<UserBankDTO> result =
            await memberManageRepository.getUsersIntoBank(event.bankId);
        emit(MemberManageGetListSuccessState(users: result));
      }
    } catch (e) {
      print('Error at _getListBankAccount - MemberManageBloc: $e');
      emit(MemberManageGetListFailedState());
    }
  }

  void _addUserIntoBank(MemberManageEvent event, Emitter emit) async {
    try {
      if (event is MemberManageEventAdd) {
        emit(MemberManageAddingState());
        bool check = await memberManageRepository.addMemberIntoBank(
            event.bankId, event.phoneNo, event.role);
        if (check) {
          emit(MemberManageAddSuccessfulState());
        } else {
          emit(MemberManageAddFailedStateState());
        }
      }
    } catch (e) {
      print('Error at _addUserIntoBank - MemberManageBloc: $e');
      emit(MemberManageAddFailedStateState());
    }
  }

  void _removeUserFromBank(MemberManageEvent event, Emitter emit) async {
    try {
      if (event is MemberManageEventRemove) {
        emit(MemberManageRemovingState());
        bool check = await memberManageRepository.removeMemberFromBank(
            event.bankId, event.userId);
        if (check) {
          emit(MemberManageRemoveSuccessState());
        } else {
          emit(MemberManageRemoveFailedState());
        }
      }
    } catch (e) {
      print('Error at _removeUserFromBank - MemberManageBloc: $e');
      emit(MemberManageRemoveFailedState());
    }
  }
}
