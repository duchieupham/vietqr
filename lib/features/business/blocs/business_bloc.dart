import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/features/business/events/business_event.dart';
import 'package:vierqr/features/business/repositories/business_information_repository.dart';
import 'package:vierqr/features/business/states/business_state.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/models/business_item_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> with BaseManager {
  @override
  final BuildContext context;

  BusinessBloc(this.context) : super(const BusinessState()) {
    on<BusinessInitEvent>(_initData);
    on<BusinessRemoveBusinessEvent>(_removeBusiness);
  }

  void _initData(BusinessEvent event, Emitter emit) async {
    try {
      if (event is BusinessInitEvent) {
        if (event.isLoading) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        List<BusinessItemDTO> result =
            await businessInformationRepository.getBusinessItems(userId);

        emit(state.copyWith(list: result, status: BlocStatus.SUCCESS));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.ERROR, msg: e.toString()));
    }
  }

  void _removeBusiness(BusinessEvent event, Emitter emit) async {
    try {
      if (event is BusinessRemoveBusinessEvent) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        ResponseMessageDTO result = await businessInformationRepository
            .removeBusinessItems(event.businessId);
        if (result.status == 'SUCCESS') {
          emit(state.copyWith(status: BlocStatus.DELETED));
        } else {
          emit(state.copyWith(
              status: BlocStatus.DELETED_ERROR, msg: result.message));
        }
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.DELETED_ERROR, msg: e.toString()));
    }
  }
}

const BusinessInformationRepository businessInformationRepository =
    BusinessInformationRepository();
