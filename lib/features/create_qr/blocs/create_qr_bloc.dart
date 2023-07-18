import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/create_qr/events/create_qr_event.dart';
import 'package:vierqr/features/create_qr/states/create_qr_state.dart';
import 'package:vierqr/features/generate_qr/repositories/qr_repository.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class CreateQRBloc extends Bloc<CreateQREvent, CreateQRState> with BaseManager {
  @override
  final BuildContext context;

  CreateQRBloc(this.context) : super(const CreateQRState()) {
    on<QREventGenerate>(_generateQR);
    on<QREventUploadImage>(_uploadImage);
  }

  final qrRepository = const QRRepository();

  void _generateQR(CreateQREvent event, Emitter emit) async {
    try {
      if (event is QREventGenerate) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, type: CreateQRType.NONE));
        final result = await qrRepository.generateQR(event.dto);
        if (result != null && result is QRGeneratedDTO) {
          emit(state.copyWith(
              type: CreateQRType.CREATE_QR,
              dto: result,
              status: BlocStatus.UNLOADING));
        } else {
          emit(state.copyWith(
              type: CreateQRType.ERROR, status: BlocStatus.UNLOADING));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _uploadImage(CreateQREvent event, Emitter emit) async {
    try {
      if (event is QREventUploadImage) {
        emit(state.copyWith(status: BlocStatus.NONE, type: CreateQRType.NONE));
        final ResponseMessageDTO dto = await qrRepository.uploadImage(
            event.dto?.transactionId ?? '', event.file);
        if (dto.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(type: CreateQRType.UPLOAD_IMAGE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }
}
