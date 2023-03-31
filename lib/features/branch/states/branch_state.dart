import 'package:equatable/equatable.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/business_branch_choice_dto.dart';

class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object?> get props => [];
}

class BranchInitialState extends BranchState {}

class BranchChoiceLoadingState extends BranchState {}

class BranchChoiceSuccessfulState extends BranchState {
  final List<BusinessBranchChoiceDTO> list;

  const BranchChoiceSuccessfulState({required this.list});

  @override
  List<Object?> get props => [list];
}

class BranchChoiceFailedState extends BranchState {}

class BranchGetFilterSuccessState extends BranchState {
  final List<BranchFilterDTO> list;

  const BranchGetFilterSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class BranchGetFilterFailedState extends BranchState {}
