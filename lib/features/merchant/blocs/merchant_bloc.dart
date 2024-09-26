import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/merchant/responsitory/merchant_responsitory.dart';
import 'package:vierqr/models/response_message_dto.dart';

import '../merchant.dart';

class MerchantBloc extends Bloc<MerchantEvent, MerchantState> with BaseManager {
  @override
  final BuildContext context;

  MerchantBloc(this.context)
      : super(const MerchantState(
          responseDTO: ResponseMessageDTO(status: '', message: ''),
        )) {
    on<InsertMerchantEvent>(_insertMerchant);
    on<RequestOTPEvent>(_requestOTP);
    on<ConfirmOTPEvent>(_confirmOTP);
    on<UnRegisterMerchantEvent>(_unRegisterMerchant);
  }

  MerchantRepository repository = const MerchantRepository();

  void _requestOTP(MerchantEvent event, Emitter emit) async {
    try {
      if (event is RequestOTPEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: MerchantType.NONE));
        ResponseMessageDTO result = await repository.requestOTP(event.param);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
            request: MerchantType.REQUEST_OTP,
            status: BlocStatus.UNLOADING,
            responseDTO: result,
          ));
        } else {
          if (result.message == 'E05') {
            emit(
              state.copyWith(
                  request: MerchantType.ERROR,
                  status: BlocStatus.UNLOADING,
                  msg: 'Vui lòng kiểm tra lại thông tin đăng ký là hợp lệ.'),
            );
          } else if (result.message == 'E114') {
            emit(
              state.copyWith(
                  request: MerchantType.ERROR,
                  status: BlocStatus.UNLOADING,
                  msg:
                      'Tài khoản chưa được liên kết trong hệ thống VietQR VN. Vui lòng liên kết tài khoản trước khi đăng ký dịch vụ này.'),
            );
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
        state.copyWith(
            status: BlocStatus.UNLOADING,
            request: MerchantType.ERROR,
            msg: 'Vui lòng kiểm tra lại thông tin đăng ký là hợp lệ.'),
      );
    }
  }

  void _confirmOTP(MerchantEvent event, Emitter emit) async {
    try {
      if (event is ConfirmOTPEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: MerchantType.NONE));

        ResponseMessageDTO result = await repository.confirmOTP(event.param);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
            request: MerchantType.CONFIRM_OTP,
            status: BlocStatus.UNLOADING,
            vaNumber: result.message,
          ));
        } else {
          emit(state.copyWith(
              request: MerchantType.ERROR,
              status: BlocStatus.UNLOADING,
              msg: 'Lỗi không xác định.'));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          request: MerchantType.ERROR,
          status: BlocStatus.UNLOADING,
          msg: 'Lỗi không xác định.'));
    }
  }

  void _unRegisterMerchant(MerchantEvent event, Emitter emit) async {
    try {
      if (event is UnRegisterMerchantEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: MerchantType.NONE));

        ResponseMessageDTO result =
            await repository.unRegisterMerchant(event.merchantId, userId);

        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
            request: MerchantType.UNREGISTER_MERCHANT,
            status: BlocStatus.UNLOADING,
          ));
        } else {
          emit(state.copyWith(
              request: MerchantType.ERROR,
              status: BlocStatus.UNLOADING,
              msg: 'Lỗi không xác định.'));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          request: MerchantType.ERROR,
          status: BlocStatus.UNLOADING,
          msg: 'Lỗi không xác định.'));
    }
  }

  void _insertMerchant(MerchantEvent event, Emitter emit) async {
    try {
      if (event is InsertMerchantEvent) {
        emit(state.copyWith(status: BlocStatus.LOADING_PAGE));

        ResponseMessageDTO result =
            await repository.insertMerchant(event.param);

        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
            request: MerchantType.INSERT_MERCHANT,
            status: BlocStatus.UNLOADING,
          ));
        } else {
          emit(state.copyWith(
              request: MerchantType.ERROR,
              status: BlocStatus.UNLOADING,
              msg: 'Lỗi không xác định.'));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
        state.copyWith(
            status: BlocStatus.UNLOADING,
            request: MerchantType.ERROR,
            msg: 'Lỗi không xác định.'),
      );
    }
  }
}
