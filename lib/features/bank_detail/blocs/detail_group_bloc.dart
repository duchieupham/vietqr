import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(RemoveMemberSuccessState(dto: responseMessageDTO));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(RemoveMemberFailedState());
  }
}
