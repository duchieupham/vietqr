import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail/events/detail_group_event.dart';
import 'package:vierqr/features/bank_detail/repositories/detail_group_repository.dart';
import 'package:vierqr/features/bank_detail/states/detail_group_state.dart';
import 'package:vierqr/models/detail_group_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class DetailGroupBloc extends Bloc<DetailGroupEvent, DetailGroupState> {
  DetailGroupBloc() : super(DetailGroupInitialState()) {
    on<GetDetailGroup>(_getDetail);
    on<RemoveMemberGroup>(_removeMember);
    on<AddMemberGroup>(_addMember);
    on<AddBankToGroup>(_addBankToGroupMember);
    on<RemoveBankToGroup>(_removeBankToGroupMember);
  }
}

const DetailGroupRepository _detailGroupRepository = DetailGroupRepository();

void _getDetail(DetailGroupEvent event, Emitter emit) async {
  GroupDetailDTO detailDTO = GroupDetailDTO(banks: [], members: []);
  try {
    if (event is GetDetailGroup) {
      if (event.loadingPage) {
        emit(DetailGroupLoadingPageState());
      }

      detailDTO = await _detailGroupRepository.getDetail(event.id);
      emit(DetailGroupSuccessState(data: detailDTO));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(DetailGroupFailedState());
  }
}

void _removeMember(DetailGroupEvent event, Emitter emit) async {
  ResponseMessageDTO responseMessageDTO =
      ResponseMessageDTO(status: '', message: '');
  try {
    if (event is RemoveMemberGroup) {
      emit(DetailGroupLoadingState());
      Map<String, dynamic> param = {};
      param['userId'] = event.userId;
      param['terminalId'] = event.terminalId;
      responseMessageDTO =
          await _detailGroupRepository.removeMemberGroup(param);

      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(RemoveMemberSuccessState(dto: responseMessageDTO));
      } else {
        emit(RemoveMemberFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(RemoveMemberFailedState());
  }
}

void _addMember(DetailGroupEvent event, Emitter emit) async {
  ResponseMessageDTO responseMessageDTO =
      ResponseMessageDTO(status: '', message: '');
  try {
    if (event is AddMemberGroup) {
      emit(DetailGroupLoadingState());
      responseMessageDTO =
          await _detailGroupRepository.addMemberGroup(event.param);

      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(AddMemberSuccessState());
      } else {
        emit(AddMemberFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(AddMemberFailedState());
  }
}

void _addBankToGroupMember(DetailGroupEvent event, Emitter emit) async {
  ResponseMessageDTO responseMessageDTO =
      ResponseMessageDTO(status: '', message: '');
  try {
    if (event is AddBankToGroup) {
      emit(DetailGroupLoadingState());
      responseMessageDTO =
          await _detailGroupRepository.addBankToGroup(event.param);

      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(AddBankToGroupSuccessState());
      } else {
        emit(AddBankToGroupFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(AddBankToGroupFailedState());
  }
}

void _removeBankToGroupMember(DetailGroupEvent event, Emitter emit) async {
  ResponseMessageDTO responseMessageDTO =
      ResponseMessageDTO(status: '', message: '');
  try {
    if (event is RemoveBankToGroup) {
      emit(DetailGroupLoadingState());
      responseMessageDTO =
          await _detailGroupRepository.removeBankToGroup(event.param);

      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(RemoveBankToGroupSuccessState());
      } else {
        emit(RemoveBankToGroupFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(RemoveBankToGroupFailedState());
  }
}
