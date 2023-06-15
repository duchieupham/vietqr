import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/features/business/repositories/business_information_repository.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/models/business_item_dto.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState>
    with BaseManager {
  @override
  final BuildContext context;

  DashboardBloc(this.context) : super(const DashboardState()) {
    on<DashboardInitEvent>(_initData);
  }

  void _initData(DashboardEvent event, Emitter emit) async {
    try {
      if (event is DashboardInitEvent) {
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
}

const BusinessInformationRepository businessInformationRepository =
    BusinessInformationRepository();
