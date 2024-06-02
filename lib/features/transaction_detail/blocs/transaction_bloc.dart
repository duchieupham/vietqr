import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/transaction_detail/events/transaction_event.dart';
import 'package:vierqr/features/transaction_detail/repositories/transaction_repository.dart';
import 'package:vierqr/features/transaction_detail/states/transaction_state.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/transaction_receive_dto.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final String transactionId;
  final TransactionRepository transactionRepository;

  TransactionBloc(
      {required this.transactionId, required this.transactionRepository})
      : super(const TransactionState(list: [], listImage: [])) {
    on<TransactionEventGetDetail>(_getDetail);
    on<TransactionEventGetImage>(_loadImage);
    on<TransEventQRRegenerate>(_regenerateQR);
    on<UpdateNoteEvent>(_updateNote);

    // on<TransactionEventGetListBranch>(_getTransactionsBranch);
    // on<TransactionEventFetchBranch>(_fetchTransactionsBranch);
    // on<TransactionEventGetList>(_getTransactions);
    // on<TransactionEventFetch>(_fetchTransactions);
  }

  void _getDetail(TransactionEvent event, Emitter emit) async {
    try {
      if (event is TransactionEventGetDetail) {
        emit(state.copyWith(
          status: event.isLoading ? BlocStatus.LOADING_PAGE : BlocStatus.NONE,
          type: TransactionType.NONE,
        ));
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
            type: TransactionType.REFRESH,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _updateNote(TransactionEvent event, Emitter emit) async {
    ResponseMessageDTO result;
    try {
      if (event is UpdateNoteEvent) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        result = await transactionRepository.updateNote(event.param);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
            type: TransactionType.UPDATE_NOTE,
            status: BlocStatus.UNLOADING,
          ));
        } else {
          String msg = ErrorUtils.instance.getErrorMessage(result.message);
          emit(state.copyWith(type: TransactionType.ERROR, msg: msg));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO responseMessageDTO =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      String msg =
          ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
      emit(state.copyWith(type: TransactionType.ERROR, msg: msg));
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

// const TransactionRepository transactionRepository = TransactionRepository();

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
