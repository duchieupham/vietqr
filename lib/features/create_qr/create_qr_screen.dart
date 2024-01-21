import 'dart:io';

import 'package:float_bubble/float_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/file_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/create_qr/blocs/create_qr_bloc.dart';
import 'package:vierqr/features/create_qr/events/create_qr_event.dart';
import 'package:vierqr/features/create_qr/states/create_qr_state.dart';
import 'package:vierqr/features/create_qr/views/create_success_view.dart';
import 'package:vierqr/features/create_qr/widgets/bottom_sheet_image.dart';
import 'package:vierqr/features/transaction/widgets/transaction_sucess_widget.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'widgets/calculator_view.dart';

class CreateQrScreen extends StatelessWidget {
  static const routeName = '/create_qr';

  final BankAccountDTO? bankAccountDTO;
  final QRGeneratedDTO? qrDto;
  final int page;

  const CreateQrScreen({
    super.key,
    this.bankAccountDTO,
    this.qrDto,
    this.page = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateQRBloc>(
      create: (_) => CreateQRBloc(context, bankAccountDTO, qrDto),
      child: ChangeNotifierProvider(
        create: (context) => CreateQRProvider()..updatePage(page),
        child: _CreateQRScreen(),
      ),
    );
  }
}

class _CreateQRScreen extends StatefulWidget {
  @override
  State<_CreateQRScreen> createState() => _CreateQRScreenState();
}

class _CreateQRScreenState extends State<_CreateQRScreen> {
  late CreateQRBloc _bloc;

  final imagePicker = ImagePicker();
  final _focusMoney = FocusNode();

  final dto = QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '');

  bool enableList = false;
  BankAccountDTO? _bankAccountDTO;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(context);
    });
  }

  initData(BuildContext context) {
    _bloc.add(QrEventGetBankDetail());
    _bloc.add(QREventGetList());
  }

  _onHandleTap() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      enableList = !enableList;
    });
  }

  _onChanged(BankAccountDTO bankAccountDTO) {
    setState(() {
      enableList = !enableList;
      if (_bankAccountDTO != bankAccountDTO) {
        _bankAccountDTO = bankAccountDTO;
        _bloc.add(QREventSetBankAccountDTO(bankAccountDTO));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return BlocConsumer<CreateQRBloc, CreateQRState>(
      listener: (context, state) async {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state.status == BlocStatus.UNLOADING) {
          Navigator.pop(context);
        }

        if (state.type == CreateQRType.CREATE_QR) {
          Provider.of<CreateQRProvider>(context, listen: false).updatePage(1);
          File? file =
              Provider.of<CreateQRProvider>(context, listen: false).imageFile;
          if (file != null) {
            _bloc.add(QREventUploadImage(dto: state.dto, file: file));
          }
        }

        if (state.type == CreateQRType.LOAD_DATA) {
          Provider.of<CreateQRProvider>(context, listen: false)
              .updatePage(state.page);
          if (state.page == 0) {
            _focusMoney.requestFocus();
          }
        }

        if (state.type == CreateQRType.UPLOAD_IMAGE) {
          Provider.of<CreateQRProvider>(context, listen: false).setImage(null);
        }

        if (state.type == CreateQRType.PAID) {
          if (state.transDTO?.status == 1) {
            await DialogWidget.instance.openWidgetDialog(
              child: TransactionSuccessWidget(
                dto: state.transDTO!,
              ),
            );
            if (!mounted) return;
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pop();
          }
        }

        if (state.type == CreateQRType.SCAN_QR) {
          if (state.barCode != '-1') {
            if (!mounted) return;
            Provider.of<CreateQRProvider>(context, listen: false)
                    .contentController
                    .value =
                Provider.of<CreateQRProvider>(context, listen: false)
                    .contentController
                    .value
                    .copyWith(text: state.barCode);
          }
        }

        if (state.type == CreateQRType.SCAN_NOT_FOUND) {
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể xác nhận mã QR',
            msg:
                'Không tìm thấy thông tin trong đoạn mã QR. Vui lòng kiểm tra lại thông tin.',
            function: () {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          );
        }

        if (state.type == CreateQRType.ERROR) {
          await DialogWidget.instance.openMsgDialog(
              title: 'Đã có lỗi xảy ra', msg: 'Vui lòng thử lại');
        }
      },
      builder: (context, state) {
        return Consumer<CreateQRProvider>(
          builder: (context, provider, child) {
            if (provider.page == 1) {
              return CreateQRSuccess(
                dto: state.dto ?? dto,
                onPaid: () {
                  _bloc.add(QREventPaid(state.dto?.transactionId ?? ''));
                },
              );
            }
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (enableList) {
                  setState(() {
                    enableList = false;
                  });
                }
              },
              child: Scaffold(
                appBar: const MAppBar(title: 'Tạo QR'),
                body: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: _onHandleTap,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      color: AppColor.WHITE,
                                    ),
                                    child: Row(
                                      children: [
                                        if (state.bankAccountDTO != null &&
                                            state.bankAccountDTO!.imgId
                                                .isNotEmpty)
                                          Container(
                                            width: 60,
                                            height: 30,
                                            margin:
                                                const EdgeInsets.only(left: 4),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: ImageUtils.instance
                                                    .getImageNetWork(state
                                                        .bankAccountDTO!.imgId),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      '${state.bankAccountDTO?.bankCode ?? ''} - ${state.bankAccountDTO?.bankName ?? ''}',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              AppColor.BLACK),
                                                    ),
                                                  ),
                                                  Icon(Icons
                                                      .keyboard_arrow_down_outlined),
                                                  const SizedBox(width: 8),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                state.bankAccountDTO
                                                        ?.bankAccount ??
                                                    '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColor.BLACK),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                state.bankAccountDTO
                                                        ?.userBankName ??
                                                    '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColor.BLACK),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MTextFieldCustom(
                                      isObscureText: false,
                                      maxLines: 1,
                                      value: provider.money,
                                      fillColor: AppColor.WHITE,
                                      textFieldType: TextfieldType.LABEL,
                                      title: 'Số tiền',
                                      focusNode: _focusMoney,
                                      hintText: 'Nhập số tiền thanh toán',
                                      inputType: TextInputType.number,
                                      keyboardAction: TextInputAction.next,
                                      onChange: provider.updateMoney,
                                      suffixIcon: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'VND',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColor.textBlack),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () =>
                                                _onUpdateMoney(provider),
                                            child: Image.asset(
                                              'assets/images/logo-calculator.png',
                                              width: 28,
                                              height: 28,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                      ),
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                    Visibility(
                                      visible: provider.errorAmount != null,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 5, right: 30),
                                        child: Text(
                                          provider.errorAmount ?? '',
                                          style: const TextStyle(
                                              color: AppColor.RED_TEXT,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    TextFieldCustom(
                                      isObscureText: false,
                                      maxLines: 1,
                                      fillColor: AppColor.WHITE,
                                      controller: provider.contentController,
                                      textFieldType: TextfieldType.LABEL,
                                      title: 'Nội dung',
                                      hintText: 'Nhập nội dung thanh toán',
                                      inputType: TextInputType.text,
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          startBarcodeScanStream(context);
                                        },
                                        child: Image.asset(
                                          'assets/images/ic-scan-content.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      keyboardAction: TextInputAction.next,
                                      onChange: (value) {},
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: width,
                                      child: Wrap(
                                        alignment: WrapAlignment.start,
                                        spacing: 6,
                                        runSpacing: 10,
                                        children: [
                                          _buildItemSuggest(
                                            text: 'Thanh toan',
                                            onChange: provider.updateSuggest,
                                          ),
                                          _buildItemSuggest(
                                            onChange: provider.updateSuggest,
                                            text:
                                                'Chuyen khoan den ${state.bankAccountDTO?.bankAccount ?? ''}',
                                          ),
                                          if (state.bankAccountDTO?.type ==
                                              1) ...[
                                            _buildItemSuggest(
                                              onChange: provider.updateSuggest,
                                              text:
                                                  'Thanh toan cho ${state.bankAccountDTO?.businessName ?? ''}',
                                            ),
                                            _buildItemSuggest(
                                              onChange: provider.updateSuggest,
                                              text:
                                                  'Giao dich ${state.bankAccountDTO?.branchName ?? ''}',
                                            ),
                                          ],
                                          if (state.bankAccountDTO?.type ==
                                              0) ...[
                                            _buildItemSuggest(
                                              onChange: provider.updateSuggest,
                                              text:
                                                  'Chuyen khoan cho ${state.bankAccountDTO?.userBankName ?? ''}',
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    if (provider.imageFile != null)
                                      _buildImage(provider.imageFile!)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () async {
                                if (provider.imageFile == null) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  final data = await DialogWidget.instance
                                      .showModelBottomSheet(
                                    context: context,
                                    padding: EdgeInsets.zero,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    widget: BottomSheetImage(),
                                  );

                                  if (data is XFile) {
                                    File? file = File(data.path);
                                    File? compressedFile =
                                        FileUtils.instance.compressImage(file);
                                    provider.setImage(compressedFile);
                                  }
                                }
                              },
                              child: Container(
                                height: 40,
                                width: width,
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                padding:
                                    const EdgeInsets.only(left: 8, right: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColor.WHITE,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/ic-file-blue.png',
                                      color: provider.imageFile == null
                                          ? AppColor.BLUE_TEXT
                                          : AppColor.GREY_TEXT,
                                    ),
                                    Text(
                                      'Đính kèm hoá đơn',
                                      style: TextStyle(
                                        color: provider.imageFile == null
                                            ? AppColor.BLUE_TEXT
                                            : AppColor.GREY_TEXT,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            MButtonWidget(
                              title: 'Tạo mã QR',
                              isEnable: true,
                              colorEnableText: AppColor.WHITE,
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                String money =
                                    provider.money.replaceAll(',', '');

                                String formattedName = StringUtils.instance
                                    .removeDiacritic(
                                        provider.contentController.text);

                                QRCreateDTO dto = QRCreateDTO(
                                  bankId: state.bankAccountDTO?.id ?? '',
                                  amount: money,
                                  content: formattedName,
                                  branchId:
                                      state.bankAccountDTO?.branchId ?? '',
                                  businessId:
                                      state.bankAccountDTO?.businessId ?? '',
                                  userId: UserInformationHelper.instance
                                      .getUserId(),
                                );

                                _bloc.add(QREventGenerate(dto: dto));
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                    Positioned(
                      bottom: 120,
                      left: 0,
                      right: 0,
                      child: FloatBubble(
                        show: true,
                        initialAlignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: GestureDetector(
                            onTap: () => _onUpdateMoney(provider),
                            child: Opacity(
                              opacity: 0.6,
                              child: Container(
                                padding: const EdgeInsets.only(top: 30),
                                alignment: Alignment.bottomRight,
                                child: Image.asset(
                                  'assets/images/logo-calculator.png',
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    enableList
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: _buildDropList(
                                state.listBanks, state.bankAccountDTO),
                          )
                        : Container(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> startBarcodeScanStream(BuildContext context) async {
    String data = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    if (data.isNotEmpty) {
      if (data == TypeQR.NEGATIVE_ONE.value) {
        return;
      } else if (data == TypeQR.NEGATIVE_TWO.value) {
        DialogWidget.instance.openMsgDialog(
          title: 'Không thể xác nhận mã QR',
          msg: 'Ảnh QR không đúng định dạng, vui lòng chọn ảnh khác.',
          function: () {
            Navigator.pop(context);
          },
        );
      } else {
        if (!mounted) return;
        _bloc.add(QrEventScanGetBankType(code: data));
      }
    }
  }

  Widget _buildImage(File url) {
    return SizedBox(
      width: 140,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Đính kèm',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: 130,
                  height: 160,
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.file(
                      url,
                      width: 125,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<CreateQRProvider>(context, listen: false)
                            .setImage(null);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/ic-trash.png',
                          color: Colors.black,
                          width: 30,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemSuggest({
    ValueChanged<String>? onChange,
    required String text,
  }) {
    return GestureDetector(
      onTap: () {
        onChange!(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColor.BLUE_TEXT, width: 0.4),
          color: AppColor.BLUE_TEXT.withOpacity(0.3),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildDropList(
          List<BankAccountDTO> list, BankAccountDTO? bankAccountDTO) =>
      Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(
                      parent: NeverScrollableScrollPhysics()),
                  itemCount: list.length,
                  itemBuilder: (context, position) {
                    BankAccountDTO dto = list[position];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () => _onChanged(dto),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: AppColor.WHITE,
                            ),
                            child: Row(
                              children: [
                                if (dto.imgId.isNotEmpty)
                                  Container(
                                    width: 60,
                                    height: 30,
                                    margin: const EdgeInsets.only(left: 4),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: ImageUtils.instance
                                            .getImageNetWork(dto.imgId),
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${dto.bankCode} - ${dto.bankName}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor.BLACK),
                                            ),
                                          ),
                                          if (bankAccountDTO != null)
                                            if (bankAccountDTO.bankAccount ==
                                                dto.bankAccount)
                                              Icon(Icons.check,
                                                  color: AppColor.BLUE_TEXT),
                                          const SizedBox(width: 8),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dto.bankAccount,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.BLACK),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dto.userBankName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.BLACK),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (position != list.length - 1) const Divider(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

  void _onUpdateMoney(provider) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final data = await NavigatorUtils.navigatePage(context, CalculatorScreen(),
        routeName: CalculatorScreen.routeName);

    if (data != null && data is String) {
      double money = double.parse(data);

      provider.updateMoney(money.round().toString());
    }
  }
}
