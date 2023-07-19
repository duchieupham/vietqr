import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/transaction/events/transaction_event.dart';
import 'package:vierqr/features/transaction/repositories/transaction_repository.dart';
import 'package:vierqr/features/transaction/states/transaction_state.dart';
import 'package:vierqr/models/transaction_receive_dto.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState>
    with BaseManager {
  @override
  final BuildContext context;

  final String transactionId;

  TransactionBloc(this.context, this.transactionId)
      : super(const TransactionState(list: [])) {
    on<TransactionEventGetDetail>(_getDetail);
    on<TransactionEventGetImage>(_loadImage);
    // on<TransactionEventGetListBranch>(_getTransactionsBranch);
    // on<TransactionEventFetchBranch>(_fetchTransactionsBranch);
    // on<TransactionEventGetList>(_getTransactions);
    // on<TransactionEventFetch>(_fetchTransactions);
  }

  void _getDetail(TransactionEvent event, Emitter emit) async {
    try {
      if (event is TransactionEventGetDetail) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        TransactionReceiveDTO dto =
            await transactionRepository.getTransactionDetail(transactionId);
        emit(state.copyWith(
          transactionReceiveDTO: dto,
          status: BlocStatus.UNLOADING,
          type: TransactionType.LOAD_DATA,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _loadImage(TransactionEvent event, Emitter emit) async {
    try {
      if (event is TransactionEventGetImage) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        final result = await transactionRepository.loadImage(transactionId);
        emit(state.copyWith(
          status: BlocStatus.UNLOADING,
          type: TransactionType.NONE,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }
}

const TransactionRepository transactionRepository = TransactionRepository();

// void _getTransactionsBranch(TransactionEvent event, Emitter emit) async {
//   try {
//     if (event is TransactionEventGetListBranch) {
//       emit(TransactionLoadingState());
//       List<BusinessTransactionDTO> result =
//           await transactionRepository.getTransactionByBranchId(event.dto);
//       emit(TransactionGetListBranchSuccessState(list: result));
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//     emit(TransactionGetListBranchFailedState());
//   }
// }
//
// void _fetchTransactionsBranch(TransactionEvent event, Emitter emit) async {
//   try {
//     if (event is TransactionEventFetchBranch) {
//       emit(TransactionLoadingFetchState());
//       List<BusinessTransactionDTO> result =
//           await transactionRepository.getTransactionByBranchId(event.dto);
//       emit(TransactionFetchBranchSuccessState(list: result));
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//     emit(TransactionGetListBranchFailedState());
//   }
// }
//
// void _getTransactions(TransactionEvent event, Emitter emit) async {
//   try {
//     if (event is TransactionEventGetList) {
//       emit(TransactionLoadingState());
//       final List<RelatedTransactionReceiveDTO> result =
//           await transactionRepository.getTransactionByBankId(event.dto);
//       emit(TransactionGetListSuccessState(list: result));
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//     emit(TransactionGetListFailedState());
//   }
// }
//
// void _fetchTransactions(TransactionEvent event, Emitter emit) async {
//   try {
//     if (event is TransactionEventFetch) {
//       emit(TransactionLoadingState());
//       final List<RelatedTransactionReceiveDTO> result =
//           await transactionRepository.getTransactionByBankId(event.dto);
//       emit(TransactionFetchSuccessState(list: result));
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//     emit(TransactionFetchFailedState());
//   }
// }
