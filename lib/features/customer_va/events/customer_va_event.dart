import 'package:equatable/equatable.dart';

import '../../../models/bank_name_search_dto.dart';

class CustomerVaEvent extends Equatable {
  const CustomerVaEvent();

  @override
  List<Object?> get props => [];
}

class BankCardSearchNameEvent extends CustomerVaEvent {
  final BankNameSearchDTO dto;

  const BankCardSearchNameEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}
