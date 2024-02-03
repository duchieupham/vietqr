import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail/events/invite_bdsd_event.dart';
import 'package:vierqr/features/bank_detail/repositories/invite_bdsd_repository.dart';
import 'package:vierqr/features/bank_detail/states/invite_bdsd_state.dart';
import 'package:vierqr/models/response_message_dto.dart';

class InviteBDSDBloc extends Bloc<InviteBDSDEvent, InviteBDSDState> {
  InviteBDSDBloc() : super(InviteBDSDInitialState()) {
    on<GetRanDomCode>(_getInviteCode);
    on<CreateNewGroup>(_createNewGroup);
    on<RemoveGroup>(_removeGroup);
    on<UpdateGroup>(_updateGroup);
  }
}

const InviteBDSDRepository _inviteBDSDRepository = InviteBDSDRepository();

void _getInviteCode(InviteBDSDEvent event, Emitter emit) async {
  String code = '';
  try {
    if (event is GetRanDomCode) {
      emit(InviteBDSDLoadingState());
      code = await _inviteBDSDRepository.getRandomCode();
      emit(InviteBDSDGetRandomCodeSuccessState(data: code));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(InviteBDSDGetRandomCodeFailedState());
  }
}

void _createNewGroup(InviteBDSDEvent event, Emitter emit) async {
  ResponseMessageDTO responseMessageDTO =
      ResponseMessageDTO(status: '', message: '');
  try {
    if (event is CreateNewGroup) {
      emit(InviteBDSDLoadingState());
      responseMessageDTO =
          await _inviteBDSDRepository.createNewGroup(event.param);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(CreateNewGroupSuccessState(dto: responseMessageDTO));
      } else {
        emit(CreateNewGroupFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(CreateNewGroupFailedState());
  }
}

void _removeGroup(InviteBDSDEvent event, Emitter emit) async {
  ResponseMessageDTO responseMessageDTO =
      ResponseMessageDTO(status: '', message: '');
  try {
    if (event is RemoveGroup) {
      emit(InviteBDSDLoadingState());
      responseMessageDTO = await _inviteBDSDRepository.removeGroup(event.param);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(RemoveGroupSuccessState(dto: responseMessageDTO));
      } else {
        emit(RemoveGroupFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(RemoveGroupFailedState());
  }
}

void _updateGroup(InviteBDSDEvent event, Emitter emit) async {
  ResponseMessageDTO responseMessageDTO =
      ResponseMessageDTO(status: '', message: '');
  try {
    if (event is UpdateGroup) {
      emit(InviteBDSDLoadingState());
      responseMessageDTO = await _inviteBDSDRepository.updateGroup(event.param);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(UpdateGroupSuccessState(dto: responseMessageDTO));
      } else {
        emit(UpdateGroupFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(UpdateGroupFailedState());
  }
}
