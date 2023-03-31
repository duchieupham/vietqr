import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/branch/events/branch_event.dart';
import 'package:vierqr/features/branch/repositories/branch_repository.dart';
import 'package:vierqr/features/branch/states/branch_state.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/business_branch_choice_dto.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  BranchBloc() : super(BranchInitialState()) {
    on<BranchEventGetChoice>(_getBusinessBranchChoice);
    on<BranchEventGetFilter>(_getFilter);
  }
}

const BranchRepository branchRepository = BranchRepository();

void _getBusinessBranchChoice(BranchEvent event, Emitter emit) async {
  try {
    if (event is BranchEventGetChoice) {
      List<BusinessBranchChoiceDTO> result =
          await branchRepository.getBusinessBranchChoices(event.userId);
      emit(BranchChoiceSuccessfulState(list: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BranchChoiceFailedState());
  }
}

void _getFilter(BranchEvent event, Emitter emit) async {
  try {
    if (event is BranchEventGetFilter) {
      List<BranchFilterDTO> result =
          await branchRepository.getBranchFilters(event.dto);
      emit(BranchGetFilterSuccessState(list: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BranchGetFilterFailedState());
  }
}
