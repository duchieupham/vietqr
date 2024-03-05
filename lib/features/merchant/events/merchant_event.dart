import 'package:equatable/equatable.dart';

class MerchantEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestOTPEvent extends MerchantEvent {
  final Map<String, dynamic> param;

  RequestOTPEvent(this.param);

  @override
  List<Object?> get props => [param];
}

class InsertMerchantEvent extends MerchantEvent {
  final Map<String, dynamic> param;

  InsertMerchantEvent(this.param);

  @override
  List<Object?> get props => [param];
}

class ConfirmOTPEvent extends MerchantEvent {
  final Map<String, dynamic> param;

  ConfirmOTPEvent(this.param);

  @override
  List<Object?> get props => [param];
}

class UpdateNationalEvent extends MerchantEvent {
  final String national;

  UpdateNationalEvent(this.national);

  @override
  List<Object?> get props => [national];
}

class UpdatePhoneEvent extends MerchantEvent {
  final String phone;

  UpdatePhoneEvent(this.phone);

  @override
  List<Object?> get props => [phone];
}

class UpdateAddressStoreEvent extends MerchantEvent {
  final String addressStore;

  UpdateAddressStoreEvent(this.addressStore);

  @override
  List<Object?> get props => [addressStore];
}

class GetMerchantInfoEvent extends MerchantEvent {
  final String bankId;

  GetMerchantInfoEvent(this.bankId);

  @override
  List<Object?> get props => [bankId];
}

class RegisterMerchantEvent extends MerchantEvent {
  final Map<String, dynamic> param;

  RegisterMerchantEvent(this.param);

  @override
  List<Object?> get props => [param];
}

class UnRegisterMerchantEvent extends MerchantEvent {
  final String merchantId;

  UnRegisterMerchantEvent(this.merchantId);

  @override
  List<Object?> get props => [merchantId];
}
