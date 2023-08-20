import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/transaction/events/transaction_event.dart';
import 'package:vierqr/features/transaction/repositories/transaction_repository.dart';
import 'package:vierqr/features/transaction/states/transaction_state.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/transaction_receive_dto.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState>
    with BaseManager {
  @override
  final BuildContext context;

  final String transactionId;

  TransactionBloc(this.context, this.transactionId)
      : super(const TransactionState(list: [], listImage: [])) {
    on<TransactionEventGetDetail>(_getDetail);
    on<TransactionEventGetImage>(_loadImage);
    on<TransEventQRRegenerate>(_regenerateQR);
    // on<TransactionEventGetListBranch>(_getTransactionsBranch);
    // on<TransactionEventFetchBranch>(_fetchTransactionsBranch);
    // on<TransactionEventGetList>(_getTransactions);
    // on<TransactionEventFetch>(_fetchTransactions);
  }

  void _getDetail(TransactionEvent event, Emitter emit) async {
    try {
      if (event is TransactionEventGetDetail) {
        emit(state.copyWith(status: BlocStatus.NONE));
        TransactionReceiveDTO dto =
            await transactionRepository.getTransactionDetail(transactionId);
        emit(state.copyWith(
          dto: dto,
          status: BlocStatus.NONE,
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
        if (event.isLoading) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        final result = await transactionRepository.loadImage(transactionId);
        emit(state.copyWith(
          status: event.isLoading ? BlocStatus.UNLOADING : BlocStatus.NONE,
          type: TransactionType.NONE,
          listImage: result,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _regenerateQR(TransactionEvent event, Emitter emit) async {
    try {
      if (event is TransEventQRRegenerate) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, type: TransactionType.NONE));
        final QRGeneratedDTO dto =
            await transactionRepository.regenerateQR(event.dto);
        emit(
          state.copyWith(
              qrGeneratedDTO: dto,
              newTransaction: event.dto.newTransaction,
              status: BlocStatus.UNLOADING,
              type: TransactionType.REFRESH),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

//   void _getTransactionsBranch(TransactionEvent event, Emitter emit) async {
//     try {
//       if (event is TransactionEventGetListBranch) {
//         emit(state.copyWith(
//             status: BlocStatus.LOADING, type: TransactionType.NONE));
//         List<BusinessTransactionDTO> result =
//             await transactionRepository.getTransactionByBranchId(event.dto);
//         emit(state.copyWith(
//             list: result,
//             status: BlocStatus.UNLOADING,
//             type: TransactionType.GET_LIST));
//       }
//     } catch (e) {
//       LOG.error(e.toString());
//     }
//   }
}

const TransactionRepository transactionRepository = TransactionRepository();

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
