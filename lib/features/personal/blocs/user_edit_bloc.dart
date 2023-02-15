import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/features/personal/events/user_edit_event.dart';
import 'package:vierqr/features/personal/repositories/user_edit_repository.dart';
import 'package:vierqr/features/personal/states/user_edit_state.dart';
import 'package:vierqr/models/password_update_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class UserEditBloc extends Bloc<UserEditEvent, UserEditState> {
  UserEditBloc() : super(UserEditInitialState()) {
    on<UserEditInformationEvent>(_updateUserInformation);
    on<UserEditPasswordEvent>(_updatePassword);
  }

  final UserEditRepository userEditRepository = const UserEditRepository();

  void _updateUserInformation(UserEditEvent event, Emitter emit) async {
    try {
      if (event is UserEditInformationEvent) {
        emit(UserEditLoadingState());
        final ResponseMessageDTO dto =
            await userEditRepository.updateUserInformation(event.dto);
        if (dto.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(UserEditSuccessfulState());
        } else {
          String msg = ErrorUtils.instance.getErrorMessage(dto.message);
          emit(UserEditFailedState(msg: msg));
        }
      }
    } catch (e) {
      print('Error at _updateUserInformation - UserEditBloc: $e');
      emit(const UserEditFailedState(msg: 'Vui lòng thử lại sau'));
    }
  }

  void _updatePassword(UserEditEvent event, Emitter emit) async {
    try {
      if (event is UserEditPasswordEvent) {
        emit(UserEditLoadingState());
        PasswordUpdateDTO dto = PasswordUpdateDTO(
          userId: event.userId,
          oldPassword: event.oldPassword,
          newPassword: event.newPassword,
          phoneNo: event.phoneNo,
        );
        Map<String, dynamic> result =
            await userEditRepository.updatePassword(dto);
        if (result['check']) {
          emit(UserEditPasswordSuccessfulState());
        } else {
          emit(UserEditPasswordFailedState(msg: result['msg']));
        }
      }
    } catch (e) {
      print('Error at _updatePassworc - UserEditBloc: $e');
      emit(const UserEditPasswordFailedState(
          msg: 'Vui lòng kiểm tra lại kết nối mạng.'));
    }
  }
}
