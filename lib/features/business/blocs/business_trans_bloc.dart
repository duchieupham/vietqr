import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/business/events/business_trans_event.dart';
import 'package:vierqr/features/business/repositories/business_information_repository.dart';
import 'package:vierqr/features/business/states/business_trans_state.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/business_detail_dto.dart';

class BusinessTransBloc extends Bloc<BusinessTransEvent, BusinessTransState>
    with BaseManager {
  @override
  final BuildContext context;

  BusinessTransBloc(this.context) : super(const BusinessTransState()) {
    on<TransactionEventGetListBranch>(_getListBranch);
    on<TransactionEventFetchBranch>(_fetchTransactionsBranch);
    // on<BusinessInformationEventGetList>(_getBusinessItems);
    // on<BusinessGetDetailEvent>(_getDetail);
    on<BranchEventGetFilter>(_getFilter);
  }

  void _getListBranch(BusinessTransEvent event, Emitter emit) async {
    try {
      if (event is TransactionEventGetListBranch) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        List<BusinessTransactionDTO> result =
            await businessInformationRepository
                .getTransactionByBranchId(event.dto);
        emit(state.copyWith(
          listTrans: result,
          status: BlocStatus.UNLOADING,
          type: TransType.GET_TRANDS,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(msg: '', status: BlocStatus.ERROR));
    }
  }

  void _fetchTransactionsBranch(BusinessTransEvent event, Emitter emit) async {
    try {
      if (event is TransactionEventFetchBranch) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        List<BusinessTransactionDTO> result =
            await businessInformationRepository
                .getTransactionByBranchId(event.dto);
        emit(state.copyWith(
          listTrans: result,
          status: BlocStatus.UNLOADING,
          type: TransType.GET_TRANDS,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(msg: '', status: BlocStatus.ERROR));
    }
  }

  void _getFilter(BusinessTransEvent event, Emitter emit) async {
    try {
      if (event is BranchEventGetFilter) {
        List<BranchFilterDTO> result =
            await businessInformationRepository.getBranchFilters(event.dto);
        emit(state.copyWith(listBranch: result, status: BlocStatus.UNLOADING));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }
//
// void _insertBusinessInformation(
//     BusinessTransEvent event, Emitter emit) async {
//   try {
//     if (event is BusinessInformationEventInsert) {
//       final ResponseMessageDTO result = await businessInformationRepository
//           .insertBusinessInformation(event.dto);
//       if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
//         emit(state.copyWith(status: BlocStatus.SUCCESS));
//       } else {
//         emit(state.copyWith(
//             msg: ErrorUtils.instance.getErrorMessage(result.message),
//             status: BlocStatus.ERROR));
//       }
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//     ResponseMessageDTO responseMessageDTO =
//         const ResponseMessageDTO(status: 'FAILED', message: 'E05');
//     emit(state.copyWith(
//         msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
//         status: BlocStatus.ERROR));
//   }
// }
//
// void _getBusinessItems(BusinessTransEvent event, Emitter emit) async {
//   try {
//     if (event is BusinessInformationEventGetList) {
//       List<BusinessItemDTO> result =
//           await businessInformationRepository.getBusinessItems(event.userId);
//       emit(state.copyWith(list: result));
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//     emit(state.copyWith(status: BlocStatus.ERROR));
//   }
// }
}

const BusinessInformationRepository businessInformationRepository =
    BusinessInformationRepository();
