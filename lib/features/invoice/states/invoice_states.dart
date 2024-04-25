import 'package:equatable/equatable.dart';

import '../../../commons/enums/enum_type.dart';

class InvoiceStates extends Equatable {
  final BlocStatus status;

  const InvoiceStates({
    this.status = BlocStatus.NONE,
  });

  @override
  List<Object?> get props => [
        status,
      ];
}
