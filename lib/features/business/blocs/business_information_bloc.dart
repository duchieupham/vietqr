import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/business/events/business_information_event.dart';
import 'package:vierqr/features/business/repositories/business_information_repository.dart';
import 'package:vierqr/features/business/states/business_information_state.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/business_item_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BusinessInformationBloc
    extends Bloc<BusinessInformationEvent, BusinessInformationState> {
  BusinessInformationBloc() : super(BusinessInformationInitialState()) {
    on<BusinessInformationEventInsert>(_insertBusinessInformation);
    on<BusinessInformationEventGetList>(_getBusinessItems);
    on<BusinessGetDetailEvent>(_getDetail);
  }
}

const BusinessInformationRepository businessInformationRepository =
    BusinessInformationRepository();

void _getDetail(BusinessInformationEvent event, Emitter emit) async {
  try {
    if (event is BusinessGetDetailEvent) {
      emit(BusinessGetDetailLoadingState());
      BusinessDetailDTO result = await businessInformationRepository
          .getBusinessDetail(event.businessId, event.userId);
      emit(BusinessGetDetailSuccessState(dto: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BusinessGetDetailFailedState());
  }
}

void _insertBusinessInformation(
    BusinessInformationEvent event, Emitter emit) async {
  try {
    if (event is BusinessInformationEventInsert) {
      emit(BusinessInformationLoadingState());
      final ResponseMessageDTO result = await businessInformationRepository
          .insertBusinessInformation(event.dto);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BusinessInformationInsertSuccessfulState());
      } else {
        emit(
          BusinessInformationInsertFailedState(
            msg: ErrorUtils.instance.getErrorMessage(result.message),
          ),
        );
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO responseMessageDTO =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    emit(
      BusinessInformationInsertFailedState(
        msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
      ),
    );
  }
}

void _getBusinessItems(BusinessInformationEvent event, Emitter emit) async {
  try {
    if (event is BusinessInformationEventGetList) {
      emit(BusinessLoadingListState());
      List<BusinessItemDTO> result =
          await businessInformationRepository.getBusinessItems(event.userId);
      emit(BusinessGetListSuccessfulState(list: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BusinessGetListFailedState());
  }
}
