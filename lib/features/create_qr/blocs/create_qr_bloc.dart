import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/create_qr/events/create_qr_event.dart';
import 'package:vierqr/features/create_qr/states/create_qr_state.dart';
import 'package:vierqr/features/generate_qr/repositories/qr_repository.dart';
import 'package:vierqr/features/home/blocs/home_bloc.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/notify_trans_dto.dart';
import 'package:vierqr/models/qr_box_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/terminal_qr_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';

class CreateQRBloc extends Bloc<CreateQREvent, CreateQRState> with BaseManager {
  @override
  final BuildContext context;
  final BankAccountDTO? bankAccountDTO;
  final QRGeneratedDTO? qrDTO;

  CreateQRBloc(this.context, this.bankAccountDTO, this.qrDTO)
      : super(const CreateQRState(
          listBanks: [],
          listTerminal: [],
          listQrBox: [],
        )) {
    on<QrEventGetBankDetail>(_initData);
    on<QREventGetList>(_getBankAccounts);
    on<QREventGetTerminals>(_getTerminals);
    on<QREventGenerate>(_generateQR);
    on<QREventUploadImage>(_uploadImage);
    on<QREventPaid>(_onPaid);
    on<QrEventScanGetBankType>(_getDataScan);
    on<QREventSetBankAccountDTO>(_setBankAccountDTO);
    on<QREventGetQrBox>(_getQrBox);
  }

  final qrRepository = const QRRepository();

  void _initData(CreateQREvent event, Emitter emit) async {
    try {
      if (event is QrEventGetBankDetail) {
        emit(state.copyWith(status: BlocStatus.NONE, type: CreateQRType.NONE));
        if (bankAccountDTO != null) {
          emit(
            state.copyWith(
                status: BlocStatus.NONE,
                type: CreateQRType.LOAD_DATA,
                bankAccountDTO: bankAccountDTO,
                page: 0),
          );
        } else if (qrDTO != null) {
          BankAccountDTO bankDTO = BankAccountDTO(
            id: qrDTO!.bankId ?? '',
            bankAccount: qrDTO!.bankAccount,
            userBankName: qrDTO!.userBankName,
            bankCode: qrDTO!.bankAccount,
            bankName: qrDTO!.bankName,
            imgId: qrDTO!.imgId,
            type: 0,
            isAuthenticated: false,
          );

          emit(
            state.copyWith(
              dto: qrDTO,
              status: BlocStatus.NONE,
              type: CreateQRType.LOAD_DATA,
              bankAccountDTO: bankDTO,
              page: 1,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
        state.copyWith(
          status: BlocStatus.NONE,
          type: CreateQRType.ERROR,
        ),
      );
    }
  }

  void _getQrBox(CreateQREvent event, Emitter emit) async {
    try {
      if (event is QREventGetQrBox) {
        emit(state.copyWith(status: BlocStatus.NONE));
        List<QRBoxDTO> list = await bankCardRepository.getQrBox(
            userId, state.bankAccountDTO?.id ?? '');

        QRBoxDTO qrBoxDTO =
            QRBoxDTO(subRawTerminalCode: 'Chọn QR Box để tạo mã VietQR');
        list = [qrBoxDTO, ...list];

        emit(state.copyWith(
            type: CreateQRType.LIST_QR_BOX,
            listQrBox: list,
            status: BlocStatus.NONE));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
    }
  }

  void _getTerminals(CreateQREvent event, Emitter emit) async {
    try {
      if (event is QREventGetTerminals) {
        emit(state.copyWith(status: BlocStatus.NONE));
        List<TerminalQRDTO> list = await bankCardRepository.getTerminals(
            userId, state.bankAccountDTO?.id ?? '');

        TerminalQRDTO terminalQRDTO =
            TerminalQRDTO(terminalName: 'Nhập hoặc chọn mã cửa hàng');
        list = [terminalQRDTO, ...list];

        emit(state.copyWith(
            type: CreateQRType.LIST_TERMINAL,
            listTerminal: list,
            status: BlocStatus.NONE));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
    }
  }

  void _getBankAccounts(CreateQREvent event, Emitter emit) async {
    try {
      if (event is QREventGetList) {
        emit(state.copyWith(status: BlocStatus.NONE));
        List<BankAccountDTO> list =
            await bankCardRepository.getListBankAccount(userId);
        PaletteGenerator? paletteGenerator;
        BuildContext context = NavigationService.context!;
        if (list.isNotEmpty) {
          List<BankAccountDTO> listLinked =
              list.where((e) => e.isAuthenticated).toList();
          List<BankAccountDTO> listNotLinked =
              list.where((e) => !e.isAuthenticated).toList();

          list = [...listLinked, ...listNotLinked];

          for (BankAccountDTO dto in list) {
            NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
            paletteGenerator = await PaletteGenerator.fromImageProvider(image);
            if (paletteGenerator.dominantColor != null) {
              dto.setColor(paletteGenerator.dominantColor!.color);
            } else {
              if (!mounted) return;
              dto.setColor(Theme.of(context).cardColor);
            }
          }
        }

        emit(state.copyWith(
            type: CreateQRType.LIST_BANK,
            listBanks: list,
            status: BlocStatus.NONE));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
    }
  }

  void _setBankAccountDTO(CreateQREvent event, Emitter emit) async {
    try {
      if (event is QREventSetBankAccountDTO) {
        emit(state.copyWith(
            bankAccountDTO: event.dto,
            status: BlocStatus.NONE,
            type: CreateQRType.NONE));
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

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

  void _onPaid(CreateQREvent event, Emitter emit) async {
    try {
      if (event is QREventPaid) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, type: CreateQRType.NONE));
        final dto = await qrRepository.paid(event.id);
        if (dto != null && dto is NotifyTransDTO) {
          emit(state.copyWith(
              type: CreateQRType.PAID,
              transDTO: dto,
              status: BlocStatus.UNLOADING));
        } else {
          emit(state.copyWith(
              type: CreateQRType.NONE, status: BlocStatus.UNLOADING));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _getDataScan(CreateQREvent event, Emitter emit) {
    if (event is QrEventScanGetBankType) {
      emit(state.copyWith(type: CreateQRType.NONE, status: BlocStatus.LOADING));
      NationalScannerDTO nationalScannerDTO =
          homeRepository.getNationalInformation(event.code);
      if (nationalScannerDTO.nationalId.trim().isNotEmpty) {
        String code = event.code.replaceAll('|', '').substring(0, 50);
        emit(
          state.copyWith(
            barCode: code,
            type: CreateQRType.SCAN_QR,
            status: BlocStatus.UNLOADING,
          ),
        );
      } else if (event.code.isNotEmpty) {
        if (event.code.length > 50) {
          emit(state.copyWith(
            barCode: event.code.substring(0, 50),
            type: CreateQRType.SCAN_QR,
            status: BlocStatus.UNLOADING,
          ));
        } else {
          emit(state.copyWith(
            barCode: event.code,
            type: CreateQRType.SCAN_QR,
            status: BlocStatus.UNLOADING,
          ));
        }
      } else {
        emit(state.copyWith(
          type: CreateQRType.SCAN_NOT_FOUND,
          status: BlocStatus.UNLOADING,
        ));
      }
    }
  }
}
