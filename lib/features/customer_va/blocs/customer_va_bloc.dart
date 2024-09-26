import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail/repositories/bank_card_repository.dart';
import 'package:vierqr/features/customer_va/events/customer_va_event.dart';

import '../../../commons/enums/enum_type.dart';
import '../../../models/bank_name_information_dto.dart';
import '../states/customer_va_state.dart';

class CustomerVaBloc extends Bloc<CustomerVaEvent, CustomerVaState>
    with BaseManager {
  @override
  final BuildContext context;

  CustomerVaBloc(this.context) : super(CustomerVaState()) {
    on<BankCardSearchNameEvent>(_searchBankName);
  }

  void _searchBankName(CustomerVaEvent event, Emitter emit) async {
    BankCardRepository bankCardRepository = BankCardRepository();

    try {
      if (event is BankCardSearchNameEvent) {
        emit(
            state.copyWith(status: BlocStatus.NONE, request: AddBankType.NONE));
        BankNameInformationDTO dto =
            await bankCardRepository.searchBankName(event.dto);
        if (dto.accountName.trim().isNotEmpty) {
          emit(state.copyWith(
              status: BlocStatus.NONE,
              informationDTO: dto,
              request: AddBankType.SEARCH_BANK));
        } else {
          emit(
            state.copyWith(
              msg: 'Tài khoản ngân hàng không tồn tại.',
              request: AddBankType.ERROR_SEARCH_NAME,
              status: BlocStatus.NONE,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        msg: 'Tài khoản ngân hàng không tồn tại.',
        request: AddBankType.ERROR_SEARCH_NAME,
        status: BlocStatus.NONE,
      ));
    }
  }
}
