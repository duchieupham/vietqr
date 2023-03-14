import 'package:equatable/equatable.dart';

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
