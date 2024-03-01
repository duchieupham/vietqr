import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:vierqr/models/terminal_qr_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import 'widgets/calculator_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:float_bubble/float_bubble.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/commons/utils/file_utils.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/create_qr/blocs/create_qr_bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vierqr/features/create_qr/events/create_qr_event.dart';
import 'package:vierqr/features/create_qr/states/create_qr_state.dart';
import 'package:vierqr/features/create_qr/views/create_success_view.dart';
import 'package:vierqr/features/create_qr/widgets/bottom_sheet_image.dart';
import 'package:vierqr/features/transaction/widgets/transaction_sucess_widget.dart';

import 'widgets/select_bank_view.dart';

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
        create: (context) => CreateQRProvider(context)..updatePage(page),
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
  late CreateQRProvider _provider;

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
    _provider = Provider.of<CreateQRProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(context);
    });
  }

  initData(BuildContext context) {
    _bloc.add(QrEventGetBankDetail());
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
          _provider.updatePage(1);
          File? file = _provider.imageFile;
          if (file != null) {
            _bloc.add(QREventUploadImage(dto: state.dto, file: file));
          }
        }

        if (state.type == CreateQRType.LOAD_DATA) {
          _bloc.add(QREventGetList());
          _bloc.add(QREventGetTerminals());
          _provider.updatePage(state.page);
          if (state.page == 0) {
            _focusMoney.requestFocus();
          }
        }

        if (state.type == CreateQRType.LIST_TERMINAL) {
          _provider.updateTerminalQRDTO(state.listTerminal.first,
              isFirst: true);
        }

        if (state.type == CreateQRType.UPLOAD_IMAGE) {
          _provider.setImage(null);
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
            _provider.content = state.barCode ?? '';
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
                listBanks: provider.listBank,
                onCreate: () {
                  provider.reset();
                  provider.updatePage(0);
                  provider.updateTerminalQRDTO(state.listTerminal.first,
                      isFirst: true);
                  // _bloc.add(QREventPaid(state.dto?.transactionId ?? ''));
                },
              );
            }
            return GestureDetector(
              onTap: _onEnableList,
              child: Scaffold(
                appBar: const MAppBar(title: 'Tạo QR giao dịch'),
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
                                ...[
                                  Text(
                                    'Tài khoản ngân hàng',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  SelectBankView(
                                    dto: state.bankAccountDTO ??
                                        BankAccountDTO(),
                                    onTap: _onHandleTap,
                                    isShowIconDrop: true,
                                  ),
                                ],
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
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Text('VND',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColor.textBlack)),
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
                                    MTextFieldCustom(
                                      isObscureText: false,
                                      maxLines: 1,
                                      fillColor: AppColor.WHITE,
                                      value: provider.content,
                                      maxLength: 50,
                                      textFieldType: TextfieldType.LABEL,
                                      title:
                                          'Nội dung (${provider.content.length}/50 ký tự)',
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
                                      onChange: provider.updateSuggest,
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
                                  ],
                                ),
                                const SizedBox(height: 30),
                                ...[
                                  GestureDetector(
                                    onTap: _provider.updateExtra,
                                    child: Row(
                                      children: [
                                        if (!_provider.isExtra) ...[
                                          Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              color: AppColor.BLUE_TEXT),
                                          Text(
                                            'Tuỳ chọn thêm',
                                            style: TextStyle(
                                                color: AppColor.BLUE_TEXT,
                                                fontSize: 15),
                                          ),
                                        ] else ...[
                                          Icon(Icons.keyboard_arrow_up_outlined,
                                              color: AppColor.BLUE_TEXT),
                                          Text(
                                            'Đóng tuỳ chọn',
                                            style: TextStyle(
                                                color: AppColor.BLUE_TEXT,
                                                fontSize: 15),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                  if (_provider.isExtra)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 24),
                                        MTextFieldCustom(
                                          isObscureText: false,
                                          maxLines: 1,
                                          value: provider.orderCode,
                                          fillColor: AppColor.WHITE,
                                          textFieldType: TextfieldType.LABEL,
                                          maxLength: 13,
                                          title:
                                              'Mã đơn hàng (${provider.orderCode.length}/13 ký tự)',
                                          hintText: 'Nhập mã đơn hàng',
                                          inputType: TextInputType.number,
                                          keyboardAction: TextInputAction.next,
                                          onChange: provider.updateOrderCode,
                                        ),
                                        const SizedBox(height: 30),
                                        MTextFieldCustom(
                                          isObscureText: false,
                                          maxLines: 1,
                                          fillColor: AppColor.WHITE,
                                          value: provider.branchCode,
                                          textFieldType: TextfieldType.LABEL,
                                          maxLength: 10,
                                          title:
                                              'Mã cửa hàng (${provider.branchCode.length}/10 ký tự)',
                                          hintText:
                                              'Nhập hoặc chọn mã cửa hàng',
                                          inputType: TextInputType.text,
                                          keyboardAction: TextInputAction.next,
                                          onChange: provider.updateBranchCode,
                                          child: _buildDropListTerminal(
                                              state.listTerminal,
                                              provider.terminalQRDTO),
                                        )
                                      ],
                                    ),
                                ]
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: AppColor.WHITE),
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            children: [
                              if (provider.imageFile != null) ...[
                                _buildImage(provider.imageFile!),
                                const SizedBox(height: 8),
                                const Divider(color: AppColor.GREY_TEXT),
                                const SizedBox(height: 8),
                              ],
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: _onSelectImage,
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: provider.imageFile == null
                                            ? AppColor.WHITE
                                            : AppColor.grey979797
                                                .withOpacity(0.6),
                                        border: provider.imageFile == null
                                            ? Border.all(
                                                color: AppColor.BLUE_TEXT)
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/images/ic-bill.png',
                                            color: provider.imageFile == null
                                                ? AppColor.BLUE_TEXT
                                                : AppColor.GREY_TEXT,
                                          ),
                                          Text(
                                            'Kèm hoá đơn',
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
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: MButtonWidget(
                                      title: 'Tạo QR giao dịch',
                                      isEnable: true,
                                      margin: EdgeInsets.zero,
                                      colorEnableText: AppColor.WHITE,
                                      onTap: () =>
                                          _onCreateQR(state.bankAccountDTO),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned.fill(
                      bottom: 85,
                      child: FloatBubble(
                        show: true,
                        initialAlignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: GestureDetector(
                            onTap: _onUpdateMoney,
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
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.file(url, width: 30, height: 40, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 8),
          Center(
            child: const Text(
              ' 1 tệp đính kèm',
              style: TextStyle(fontSize: 15),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _provider.setImage(null),
            child: Image.asset(
              'assets/images/ic-trash.png',
              color: AppColor.error700,
              width: 40,
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

                    return SelectBankView(
                      dto: dto,
                      onTap: () => _onChanged(dto),
                      isDivider: (position != list.length - 1),
                      isSelect:
                          (bankAccountDTO?.bankAccount == dto.bankAccount),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildDropListTerminal(List<TerminalQRDTO> list, TerminalQRDTO? dto) =>
      DropdownButtonHideUnderline(
        child: DropdownButton2<TerminalQRDTO>(
          isExpanded: true,
          selectedItemBuilder: (context) {
            return list
                .map(
                  (item) => DropdownMenuItem<TerminalQRDTO>(
                    value: item,
                    child: MTextFieldCustom(
                      isObscureText: false,
                      maxLines: 1,
                      fillColor: AppColor.WHITE,
                      value: _provider.branchCode,
                      textFieldType: TextfieldType.DEFAULT,
                      maxLength: 10,
                      contentPadding: EdgeInsets.zero,
                      title:
                          'Mã chi nhánh (${_provider.branchCode.length}/10 ký tự)',
                      hintText: 'Nhập hoặc chọn mã cửa hàng',
                      inputType: TextInputType.text,
                      keyboardAction: TextInputAction.next,
                      onChange: _provider.updateBranchCode,
                    ),
                  ),
                )
                .toList();
          },
          onMenuStateChange: _provider.onMenuStateChange,
          items: list.map((item) {
            return DropdownMenuItem<TerminalQRDTO>(
              value: item,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            item.terminalName,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          if (item.terminalCode.isEmpty)
                            Icon(Icons.expand_more),
                        ],
                      ),
                    ),
                  ),
                  if (item.terminalCode.isNotEmpty) ...[
                    Text(
                      item.terminalCode,
                      style: const TextStyle(
                          fontSize: 11, color: AppColor.grey979797),
                    ),
                    const Divider()
                  ]
                ],
              ),
            );
          }).toList(),
          value: _provider.terminalQRDTO,
          onChanged: _provider.updateTerminalQRDTO,
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.WHITE,
            ),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.expand_more),
            iconSize: 24,
            iconEnabledColor: AppColor.BLACK,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            width: MediaQuery.of(context).size.width - 40,
            offset: Offset(0, 50),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      );

  void _onUpdateMoney() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final data = await NavigatorUtils.navigatePage(context, CalculatorScreen(),
        routeName: CalculatorScreen.routeName);

    if (data != null && data is String) {
      double money = double.parse(data);

      _provider.updateMoney(money.round().toString());
    }
  }

  void _onEnableList() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (enableList) {
      enableList = false;
      updateState();
    }
  }

  void updateState() {
    setState(() {});
  }

  void _onCreateQR(BankAccountDTO? bankAccountDTO) {
    FocusManager.instance.primaryFocus?.unfocus();
    String money = _provider.money.replaceAll(',', '');

    String formattedName =
        StringUtils.instance.removeDiacritic(_provider.content);

    QRCreateDTO dto = QRCreateDTO(
      bankId: bankAccountDTO?.id ?? '',
      amount: money,
      content: formattedName,
      userId: SharePrefUtils.getProfile().userId,
      orderId: _provider.orderCode,
      terminalCode: _provider.branchCode,
    );

    _bloc.add(QREventGenerate(dto: dto));
  }

  void _onSelectImage() async {
    if (_provider.imageFile == null) {
      FocusManager.instance.primaryFocus?.unfocus();
      final data = await DialogWidget.instance.showModelBottomSheet(
        context: context,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        widget: BottomSheetImage(),
      );

      if (data is XFile) {
        File? file = File(data.path);
        File? compressedFile = FileUtils.instance.compressImage(file);
        _provider.setImage(compressedFile);
      }
    }
  }
}
