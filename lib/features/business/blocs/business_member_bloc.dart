import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/business/events/business_member_event.dart';
import 'package:vierqr/features/business/repositories/business_member_repository.dart';
import 'package:vierqr/features/business/states/business_member_state.dart';
import 'package:vierqr/models/business_member_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BusinessMemberBloc
    extends Bloc<BusinessMemberEvent, BusinessMemberState> {
  BusinessMemberBloc() : super(BusinessMemberInitialState()) {
    on<BusinessMemberEventSearch>(_searchMember);
    on<BusinessMemberEventInitial>(_initial);
  }
}

const BusinessMemberRepository businessMemberRepository =
    BusinessMemberRepository();

void _initial(BusinessMemberEvent event, Emitter emit) {
  emit(BusinessMemberInitialState());
}

void _searchMember(BusinessMemberEvent event, Emitter emit) async {
  try {
    if (event is BusinessMemberEventSearch) {
      final responseDTO =
          await businessMemberRepository.searchMember(event.phone);
      if (responseDTO.status.isNotEmpty) {
        ResponseMessageDTO result = responseDTO;
        emit(BusinessMemberSearchNotFoundState(
            message: CheckUtils.instance.getCheckMessage(result.message)));
      } else {
        BusinessMemberDTO result = responseDTO;
        emit(BusinessMemberSearchState(dto: result));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO result = const ResponseMessageDTO(
      status: 'CHECK',
      message: 'C02',
    );
    emit(BusinessMemberSearchNotFoundState(
        message: CheckUtils.instance.getCheckMessage(result.message)));
  }
}
