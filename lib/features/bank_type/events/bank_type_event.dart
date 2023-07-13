import 'package:equatable/equatable.dart';

class BankTypeEvent extends Equatable {
  const BankTypeEvent();

  @override
  List<Object?> get props => [];
}

class BankTypeEventGetList extends BankTypeEvent {
  const BankTypeEventGetList();

  @override
  List<Object?> get props => [];
}

class BankTypeEventSearch extends BankTypeEvent {
  final String textSearch;

  const BankTypeEventSearch({required this.textSearch});

  @override
  List<Object?> get props => [textSearch];
}
