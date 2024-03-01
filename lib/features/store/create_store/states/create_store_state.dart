import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_account_terminal.dart';

enum StoreType {
  NONE,
  RANDOM_CODE,
  UPDATE_CODE,
  UPDATE_ADDRESS,
  GET_BANK,
  CREATE_SUCCESS,
}

class CreateStoreState extends Equatable {
  final BlocStatus status;
  final String? msg;
  final StoreType request;
  final bool isLoading;
  final bool isEmpty;
  final String codeStore;
  final String addressStore;
  final List<BankAccountTerminal> banks;

  CreateStoreState({
    this.status = BlocStatus.NONE,
    this.msg,
    this.request = StoreType.NONE,
    this.isLoading = false,
    this.isEmpty = false,
    this.codeStore = '',
    this.addressStore = '',
    required this.banks,
  });

  CreateStoreState copyWith({
    BlocStatus? status,
    StoreType? request,
    String? msg,
    bool? isLoading,
    bool? isEmpty,
    String? codeStore,
    String? addressStore,
    List<BankAccountTerminal>? banks,
  }) {
    return CreateStoreState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      isLoading: isLoading ?? this.isLoading,
      isEmpty: isEmpty ?? this.isEmpty,
      codeStore: codeStore ?? this.codeStore,
      addressStore: addressStore ?? this.addressStore,
      banks: banks ?? this.banks,
    );
  }

  @override
  List<Object?> get props =>
      [status, msg, request, isEmpty, codeStore, addressStore, banks];
}
