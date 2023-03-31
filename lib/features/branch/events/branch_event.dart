import 'package:equatable/equatable.dart';
import 'package:vierqr/models/branch_filter_insert_dto.dart';

class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object?> get props => [];
}

class BranchEventGetChoice extends BranchEvent {
  final String userId;

  const BranchEventGetChoice({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BranchEventGetFilter extends BranchEvent {
  final BranchFilterInsertDTO dto;

  const BranchEventGetFilter({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}
