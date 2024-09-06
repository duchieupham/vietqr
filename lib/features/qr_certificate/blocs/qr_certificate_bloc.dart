import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/features/qr_certificate/events/qr_certificate_event.dart';
import 'package:vierqr/features/qr_certificate/repositories/qr_certificate_repository.dart';
import 'package:vierqr/features/qr_certificate/states/qr_certificate_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/models/ecommerce_request_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class QrCertificateBloc extends Bloc<QrCertificateEvent, QrCertificateState> {
  // @override
  // final BuildContext context;

  final QrCertificateRepository qrCertificateRepository;

  QrCertificateBloc(this.qrCertificateRepository)
      : super(QrCertificateState(
            ecommerceRequest:
                EcommerceRequest(fullName: '', name: '', certificate: ''))) {
    on<ScanQrCertificateEvent>(_onScanQr);
    on<EcomActiveQrCertificateEvent>(_onEcomActive);
  }

  void _onScanQr(QrCertificateEvent event, Emitter emit) async {
    try {
      if (event is ScanQrCertificateEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: QrCertificateType.SCAN));
        final result =
            await qrCertificateRepository.scanEcommerceCode(event.qrCode);
        if (result is EcommerceRequest) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: QrCertificateType.SCAN,
              ecommerceRequest: result));
        } else if (result is ResponseMessageDTO) {
          if (result.message == 'E165') {
            emit(state.copyWith(
                status: BlocStatus.ERROR,
                request: QrCertificateType.SCAN,
                msg: 'Mã QR không khả dụng trên hệ thống'));
          } else {
            emit(state.copyWith(
                status: BlocStatus.ERROR,
                request: QrCertificateType.ERROR,
                msg: 'Đã có lỗi xảy ra, Vui lòng kiểm tra lại kết nối.'));
          }
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Đã có lỗi xảy ra, Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: QrCertificateType.ERROR));
    }
  }

  void _onEcomActive(QrCertificateEvent event, Emitter emit) async {
    try {
      if (event is EcomActiveQrCertificateEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING,
            request: QrCertificateType.ECOM_ACTIVE));
        final result = await qrCertificateRepository.ecomActive(event.request);
        if (result.status == 'SUCCESS') {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: QrCertificateType.ECOM_ACTIVE,
          ));
        } else if(state.msg == 'E163'){
            emit(state.copyWith(
              status: BlocStatus.ERROR,
              request: QrCertificateType.ECOM_ACTIVE,
              msg: 'Mã QR ecommerce không tồn tại.'));
        }{
          emit(state.copyWith(
              status: BlocStatus.ERROR,
              request: QrCertificateType.ERROR,
              msg: 'Đã có lỗi xảy ra, Vui lòng kiểm tra lại kết nối.'));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Đã có lỗi xảy ra, Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: QrCertificateType.ERROR));
    }
  }
}
