import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_account_terminal.dart';
import 'package:vierqr/models/store/merchant_dto.dart';

enum StoreType {
  NONE,
  RANDOM_CODE,
  UPDATE_CODE,
  UPDATE_ADDRESS,
  GET_BANK,
  GET_MERCHANT,
  CREATE_SUCCESS,
}

class CreateStoreState extends Equatable {
  final BlocStatus status;
  final String? msg;
  final StoreType request;
  final bool isLoading;
  final bool isEmpty;
  final bool isLoadMore;
  final String codeStore;
  final String merchantId;
  final String addressStore;
  final int offset;
  final List<BankAccountTerminal> banks;
  final List<MerchantDTO> merchants;

  CreateStoreState({
    this.status = BlocStatus.NONE,
    this.msg,
    this.request = StoreType.NONE,
    this.isLoading = false,
    this.isEmpty = false,
    this.isLoadMore = true,
    this.codeStore = '',
    this.addressStore = '',
    this.merchantId = '',
    this.offset = 0,
    required this.banks,
    required this.merchants,
  });

  CreateStoreState copyWith({
    BlocStatus? status,
    StoreType? request,
    String? msg,
    bool? isLoading,
    bool? isEmpty,
    bool? isLoadMore,
    String? merchantId,
    String? codeStore,
    String? addressStore,
    List<BankAccountTerminal>? banks,
    List<MerchantDTO>? merchants,
    int? offset,
  }) {
    return CreateStoreState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      isLoading: isLoading ?? this.isLoading,
      isEmpty: isEmpty ?? this.isEmpty,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      codeStore: codeStore ?? this.codeStore,
      merchantId: merchantId ?? this.merchantId,
      addressStore: addressStore ?? this.addressStore,
      banks: banks ?? this.banks,
      merchants: merchants ?? this.merchants,
      offset: offset ?? this.offset,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        request,
        isEmpty,
        codeStore,
        addressStore,
        banks,
        merchants,
        offset,
        merchantId,
        isLoadMore
      ];
}
