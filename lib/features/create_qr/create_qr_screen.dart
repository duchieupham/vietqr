import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/file_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/printer_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/features/create_qr/blocs/create_qr_bloc.dart';
import 'package:vierqr/features/create_qr/events/create_qr_event.dart';
import 'package:vierqr/features/create_qr/states/create_qr_state.dart';
import 'package:vierqr/features/printer/views/printing_view.dart';
import 'package:vierqr/features/transaction/widgets/transaction_sucess_widget.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/services/providers/water_mark_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:vierqr/services/sqflite/local_database.dart';

import 'views/dialog_exits_view.dart';
import 'views/dialog_more_view.dart';

class CreateQrScreen extends StatelessWidget {
  const CreateQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    BankAccountDTO? data;
    QRGeneratedDTO? qrDto;
    if (args.containsKey('bankInfo')) {
      data = args['bankInfo'];
    } else if (args.containsKey('qr')) {
      qrDto = args['qr'];
    }

    return BlocProvider<CreateQRBloc>(
      create: (_) => CreateQRBloc(context, data, qrDto),
      child: ChangeNotifierProvider(
        create: (context) => CreateQRProvider(),
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
  final _waterMarkProvider = WaterMarkProvider(false);

  final imagePicker = ImagePicker();
  final GlobalKey globalKey = GlobalKey();
  final _focusMoney = FocusNode();

  final dto = const QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '');

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
            if (provider.page == 1 || state.page == 1) {
              return Scaffold(
                body: SafeArea(
                  child: RepaintBoundaryWidget(
                    globalKey: globalKey,
                    builder: (key) {
                      return Container(
                        color: AppColor.GREY_BG,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              child: VietQr(qrGeneratedDTO: state.dto ?? dto),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _waterMarkProvider,
                              builder: (_, provider, child) {
                                return Visibility(
                                  visible: provider == true,
                                  child: Container(
                                    width: width,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: RichText(
                                      textAlign: TextAlign.right,
                                      text: const TextSpan(
                                        style: TextStyle(
                                          color: AppColor.GREY_TEXT,
                                          fontSize: 12,
                                        ),
                                        children: [
                                          TextSpan(text: 'Được tạo bởi '),
                                          TextSpan(
                                            text: 'vietqr.vn',
                                            style: TextStyle(
                                              color: AppColor.BLUE_TEXT,
                                              fontSize: 12,
                                            ),
                                          ),
                                          TextSpan(text: ' - '),
                                          TextSpan(text: 'Hotline '),
                                          TextSpan(
                                            text: '19006234',
                                            style: TextStyle(
                                              color: AppColor.BLUE_TEXT,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                bottomSheet: _buildButton(
                  context: context,
                  fileImage: provider.imageFile,
                  progressBar: provider.progressBar,
                  onClick: (index) {
                    onClick(index, state.dto!);
                  },
                  onPaid: () {
                    _bloc.add(QREventPaid(state.dto?.transactionId ?? ''));
                  },
                ),
              );
            }
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                appBar: const MAppBar(title: 'Tạo QR'),
                body: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: AppColor.WHITE,
                        ),
                        child: Row(
                          children: [
                            if (state.bankAccountDTO?.imgId != null &&
                                state.bankAccountDTO!.imgId.isNotEmpty)
                              Container(
                                width: 60,
                                height: 30,
                                margin: const EdgeInsets.only(left: 4),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: ImageUtils.instance.getImageNetWork(
                                        state.bankAccountDTO?.imgId ?? ''),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    '${state.bankAccountDTO?.bankCode ?? ''} - ${state.bankAccountDTO?.bankName ?? ''}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.BLACK),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.bankAccountDTO?.bankAccount ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.BLACK),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.bankAccountDTO?.userBankName ?? '',
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
                            suffixIcon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  'VND',
                                  style: TextStyle(
                                      fontSize: 14, color: AppColor.gray),
                                ),
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
                                    color: AppColor.RED_TEXT, fontSize: 13),
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
                                FocusManager.instance.primaryFocus?.unfocus();
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mẫu nội dung: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: SizedBox(
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
                                      if (state.bankAccountDTO?.type == 1) ...[
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
                                      if (state.bankAccountDTO?.type == 0) ...[
                                        _buildItemSuggest(
                                          onChange: provider.updateSuggest,
                                          text:
                                              'Chuyen khoan cho ${state.bankAccountDTO?.userBankName ?? ''}',
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          if (provider.imageFile == null)
                            GestureDetector(
                              onTap: () async {
                                await Permission.mediaLibrary.request();
                                await imagePicker
                                    .pickImage(source: ImageSource.gallery)
                                    .then(
                                  (pickedFile) async {
                                    if (pickedFile != null) {
                                      File? file = File(pickedFile.path);
                                      File? compressedFile = FileUtils.instance
                                          .compressImage(file);
                                      provider.setImage(compressedFile);
                                    }
                                  },
                                );
                              },
                              child: Container(
                                height: 40,
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
                                        'assets/images/ic-file-blue.png'),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Định kèm hoá đơn',
                                      style: TextStyle(
                                        color: AppColor.BLUE_TEXT,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          else
                            _buildImage(provider.imageFile!)
                        ],
                      ),
                    ],
                  ),
                ),
                bottomSheet: MButtonWidget(
                  title: 'Tạo mã QR',
                  isEnable: provider.amountErr,
                  colorEnableText:
                      provider.amountErr ? AppColor.WHITE : AppColor.GREY_TEXT,
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    String money = provider.money.replaceAll('.', '');

                    QRCreateDTO dto = QRCreateDTO(
                      bankId: state.bankAccountDTO?.id ?? '',
                      amount: money,
                      content: provider.contentController.text,
                      branchId: state.bankAccountDTO?.branchId ?? '',
                      businessId: state.bankAccountDTO?.businessId ?? '',
                      userId: UserInformationHelper.instance.getUserId(),
                    );

                    _bloc.add(QREventGenerate(dto: dto));
                  },
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
      if (data == TypeQR.NEGATIVE_TWO.value) {
        DialogWidget.instance.openMsgDialog(
          title: 'Không thể xác nhận mã QR',
          msg: 'Ảnh QR không đúng định dạng, vui lòng chọn ảnh khác.',
          function: () {
            Navigator.pop(context);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      } else {
        if (!mounted) return;
        _bloc.add(QrEventScanGetBankType(code: data));
      }
    }
  }

  Widget _buildButton(
      {File? fileImage,
      double progressBar = 0,
      required BuildContext context,
      GestureTapCallback? onPaid,
      required Function(int) onClick}) {
    double width = MediaQuery.of(context).size.width;
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    ButtonIconWidget(
                      width: width * 0.2,
                      height: 40,
                      icon: Icons.print_rounded,
                      title: '',
                      function: () async {
                        onClick(0);
                      },
                      bgColor: Theme.of(context).cardColor,
                      textColor: AppColor.ORANGE,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    ButtonIconWidget(
                      width: width * 0.2,
                      height: 40,
                      icon: Icons.photo_rounded,
                      title: '',
                      function: () {
                        onClick(1);
                      },
                      bgColor: Theme.of(context).cardColor,
                      textColor: AppColor.RED_CALENDAR,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    ButtonIconWidget(
                      width: width * 0.2,
                      height: 40,
                      icon: Icons.copy_rounded,
                      title: '',
                      function: () async {
                        onClick(2);
                      },
                      bgColor: Theme.of(context).cardColor,
                      textColor: AppColor.BLUE_TEXT,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    ButtonIconWidget(
                      width: width * 0.2,
                      height: 40,
                      icon: Icons.share_rounded,
                      title: '',
                      function: () {
                        onClick(3);
                      },
                      bgColor: Theme.of(context).cardColor,
                      textColor: AppColor.BLUE_TEXT,
                    ),
                  ],
                )),
            const SizedBox(height: 10),
            MButtonWidget(
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ic-home-blue.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    color: AppColor.WHITE,
                  ),
                  const Text(
                    'Trang chủ',
                    style: TextStyle(
                      color: AppColor.WHITE,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              isEnable: true,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              onTap: () {
                if (fileImage != null) {
                  dialogExits();
                } else {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              title: '',
            ),
            if (fileImage != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * progressBar,
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColor.BLUE_TEXT, width: 4),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.file(
                            fileImage,
                            height: 60,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Đang lưu tệp đính kèm.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  final List<DataModel> list = [
    DataModel(url: 'assets/images/ic-print-blue.png', text: 'In mã QR'),
    DataModel(url: 'assets/images/ic-img-blue.png', text: 'Lưu ảnh QR'),
    DataModel(
        url: 'assets/images/ic-copy-blue.png', text: 'Sao chép thông tin'),
    DataModel(url: 'assets/images/ic-share-blue.png', text: 'Chia sẻ'),
  ];

  void dialog({required Function(int) onClick}) async {
    final data = await showDialog(
      barrierDismissible: true,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return const DialogMoreView();
      },
    );

    if (data is int) {
      onClick(data);
    }
  }

  void dialogExits() async {
    await showDialog(
      barrierDismissible: true,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return const DialogExitsView();
      },
    );
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

  onClick(
    int index,
    QRGeneratedDTO qrGeneratedDTO,
  ) {
    switch (index) {
      case 0:
        onPrint(qrGeneratedDTO);
        return;
      case 1:
        saveImage(context);
        return;
      case 2:
        onCopy(dto: qrGeneratedDTO);
        return;
      case 3:
        share(dto: qrGeneratedDTO);
        return;
    }
  }

  onPrint(QRGeneratedDTO qrGeneratedDTO) async {
    String userId = UserInformationHelper.instance.getUserId();
    BluetoothPrinterDTO bluetoothPrinterDTO =
        await LocalDatabase.instance.getBluetoothPrinter(userId);
    if (bluetoothPrinterDTO.id.isNotEmpty) {
      bool isPrinting = false;
      if (!isPrinting) {
        isPrinting = true;
        DialogWidget.instance
            .showFullModalBottomContent(widget: const PrintingView());
        await PrinterUtils.instance.print(qrGeneratedDTO).then((value) {
          Navigator.pop(context);
          isPrinting = false;
        });
      }
    } else {
      DialogWidget.instance.openMsgDialog(
          title: 'Không thể in',
          msg: 'Vui lòng kết nối với máy in để thực hiện việc in.');
    }
  }

  Future<void> saveImage(BuildContext context) async {
    _waterMarkProvider.updateWaterMark(true);
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.saveImageToGallery(globalKey).then((value) {
        _waterMarkProvider.updateWaterMark(false);
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: 'Đã lưu ảnh',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).cardColor,
          fontSize: 15,
        );
      });
    });
  }

  Future<void> share({required QRGeneratedDTO dto}) async {
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.shareImage(
        key: globalKey,
        textSharing:
            '${dto.bankAccount} - ${dto.bankName}\nĐược tạo bởi vietqr.vn - Hotline 19006234'
                .trim(),
      );
    });
  }

  void onCopy({required QRGeneratedDTO dto}) async {
    await FlutterClipboard.copy(ShareUtils.instance.getTextSharing(dto)).then(
      (value) => Fluttertoast.showToast(
        msg: 'Đã sao chép',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Colors.black,
        fontSize: 15,
        webBgColor: 'rgba(255, 255, 255)',
        webPosition: 'center',
      ),
    );
  }
}
