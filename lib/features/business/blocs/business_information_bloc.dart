import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/business/events/business_information_event.dart';
import 'package:vierqr/features/business/repositories/business_information_repository.dart';
import 'package:vierqr/features/business/states/business_information_state.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/business_item_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BusinessInformationBloc
    extends Bloc<BusinessInformationEvent, BusinessInformationState> {
  BusinessInformationBloc() : super(const BusinessInformationState()) {
    on<BusinessInformationEventInsert>(_insertBusinessInformation);
    on<BusinessInformationEventGetList>(_getBusinessItems);
    on<BusinessGetDetailEvent>(_getDetail);
    on<BusinessEventGetFilter>(_getFilter);
  }

  void _getDetail(BusinessInformationEvent event, Emitter emit) async {
    try {
      if (event is BusinessGetDetailEvent) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        BusinessDetailDTO result = await businessInformationRepository
            .getBusinessDetail(event.businessId, event.userId);
        emit(state.copyWith(dto: result, status: BlocStatus.SUCCESS));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(msg: '', status: BlocStatus.ERROR));
    }
  }

  void _getFilter(BusinessInformationEvent event, Emitter emit) async {
    try {
      if (event is BusinessEventGetFilter) {
        List<BranchFilterDTO> result =
            await businessInformationRepository.getBranchFilters(event.dto);
        emit(state.copyWith(listBranch: result, status: BlocStatus.DONE));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _insertBusinessInformation(
      BusinessInformationEvent event, Emitter emit) async {
    try {
      if (event is BusinessInformationEventInsert) {
        final ResponseMessageDTO result = await businessInformationRepository
            .insertBusinessInformation(event.dto);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(status: BlocStatus.SUCCESS));
        } else {
          emit(state.copyWith(
              msg: ErrorUtils.instance.getErrorMessage(result.message),
              status: BlocStatus.ERROR));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO responseMessageDTO =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(state.copyWith(
          msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
          status: BlocStatus.ERROR));
    }
  }

  void _getBusinessItems(BusinessInformationEvent event, Emitter emit) async {
    try {
      if (event is BusinessInformationEventGetList) {
        List<BusinessItemDTO> result =
            await businessInformationRepository.getBusinessItems(event.userId);
        emit(state.copyWith(list: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }
}

const BusinessInformationRepository businessInformationRepository =
    BusinessInformationRepository();
