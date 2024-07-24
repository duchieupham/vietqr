import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/file_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/bank_detail_new/blocs/transaction_bloc.dart';
import 'package:vierqr/features/bank_detail_new/events/transaction_event.dart';
import 'package:vierqr/features/bank_detail_new/states/transaction_state.dart';
import 'package:vierqr/features/bank_detail_new/widgets/update_hashtag_widget.dart';
import 'package:vierqr/features/bank_detail_new/widgets/update_note_widget.dart';
import 'package:vierqr/features/create_qr/create_qr_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/trans_update/trans_update_screen.dart';
import 'package:vierqr/features/transaction_detail/repositories/transaction_repository.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/notify_trans_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/qr_recreate_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/models/trans_list_dto.dart';
import 'package:path/path.dart' as path;
import 'package:vierqr/models/transaction_log_dto.dart';
import 'package:vierqr/models/transaction_receive_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../../models/bank_account_dto.dart';

class TransactionDetailScreen extends StatefulWidget {
  final String id;
  final BankAccountDTO bankDto;
  const TransactionDetailScreen(
      {super.key, required this.id, required this.bankDto});

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  ValueNotifier<bool> isScrollNotifier = ValueNotifier<bool>(true);
  ScrollController scrollController = ScrollController();
  String get userId => SharePrefUtils.getProfile().userId;

  final NewTransactionBloc _bloc = getIt.get<NewTransactionBloc>();
  File? imageSelect;

  MerchantRole role = MerchantRole();
  List<TransactionLogDTO> transLogList = [];

  String note = '';

  void initData() async {
    _bloc.add(GetTransDetailEvent(id: widget.id, isLoading: true));
    scrollController.addListener(
      () {
        isScrollNotifier.value = scrollController.offset == 0.0;
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        initData();
      },
    );
  }

  void onRole(String bankId) {
    bool isOwner = false;
    final banks = [
      ...Provider.of<AuthProvider>(context, listen: false).listBank
    ];
    BankAccountDTO bankDTO = banks.firstWhere((element) => element.id == bankId,
        orElse: () => BankAccountDTO());
    setState(() {
      isOwner = bankDTO.isOwner;
      role.isOwner = bankDTO.isOwner;
    });
    if (isOwner) return;

    SettingAccountDTO settingDTO =
        Provider.of<AuthProvider>(context, listen: false).settingDTO;
    List<MerchantRole> merchantRoles = [...settingDTO.merchantRoles];
    MerchantRole merchantDTO = merchantRoles.firstWhere(
        (element) => element.bankId == bankDTO.id,
        orElse: () => MerchantRole())
      ..isOwner = isOwner;
    if (merchantDTO.bankId.isEmpty) return;
    role = merchantDTO;
    setState(() {});
  }

  void _handleImage({required bool isCamera}) async {
    XFile? xFile;
    if (isCamera) {
      final data = await _handleTapCamera();
      if (data != null) {
        xFile = data;
      }
    } else {
      final imagePicker = ImagePicker();
      await Permission.mediaLibrary.request();
      await imagePicker.pickImage(source: ImageSource.gallery).then(
        (pickedFile) async {
          if (pickedFile != null) {
            xFile = pickedFile;

            // Navigator.of(context).pop(pickedFile);
          }
        },
      );
    }
    if (xFile != null) {
      File? file = File(xFile!.path);
      setState(() {
        imageSelect = file;
      });
      File? compressedFile = FileUtils.instance.compressImage(file);
      await Future.delayed(const Duration(milliseconds: 200), () {
        if (compressedFile != null) {
          // widget.onChangeLogo!(compressedFile);
        }
      });
    }
  }

  Future<XFile?> _handleTapCamera() async {
    int startRequestTime = DateTime.now().millisecondsSinceEpoch;
    PermissionStatus cameraPermission = await Permission.camera.request();
    int endRequestTime = DateTime.now().millisecondsSinceEpoch;
    int requestDuration = endRequestTime - startRequestTime;
    if (cameraPermission.isDenied) return null;
    if ((cameraPermission.isPermanentlyDenied && requestDuration < 300) ||
        cameraPermission.isRestricted) {
      openAppSettings();
    }
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) return null;
      return pickedFile;
      // widget.onPhotoTaken(File(pickedFile.path));
    } catch (err) {
      LOG.error("Camera Photo Err: " + err.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewTransactionBloc, TransactionState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.requestDetail == TransDetail.GET_DETAIL &&
            state.status == BlocStatus.SUCCESS) {
          if (state.transDetail != null) {
            note = state.transDetail!.note;
            onRole(state.transDetail!.bankId);
          }
        }
        if (state.requestDetail == TransDetail.REGENERATE_QR &&
            state.status == BlocStatus.SUCCESS) {
          NavigatorUtils.navigatePage(
              context, CreateQrScreen(qrDto: state.generateQr, page: 1),
              routeName: CreateQrScreen.routeName);
        }
        if (state.transLogList != null) {
          transLogList = [...state.transLogList!];
        }
      },
      builder: (context, state) {
        TransactionItemDetailDTO? detail;
        if (state.requestDetail == TransDetail.GET_DETAIL &&
            state.status == BlocStatus.SUCCESS) {
          detail = state.transDetail;
        }

        return Scaffold(
          bottomNavigationBar:
              state.status != BlocStatus.LOADING_PAGE && detail != null
                  ? bottomBar(detail)
                  : const SizedBox.shrink(),
          body: Column(
            children: [
              appbar(detail),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      color: AppColor.WHITE,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFE1EFFF),
                          Color(0xFFE5F9FF),
                        ],
                        end: Alignment.centerRight,
                        begin: Alignment.centerLeft,
                      ),
                    ),
                    child: state.status == BlocStatus.LOADING_PAGE
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            physics: const ClampingScrollPhysics(),
                            children: [
                              if (detail != null) _buildDetail(detail),
                              const SizedBox(height: 10),
                              VietQRButton.suggest(
                                  margin: const EdgeInsets.only(right: 50),
                                  height: 30,
                                  onPressed: () {
                                    if (detail != null) {
                                      onUpdateTerminal(detail);
                                    }
                                  },
                                  text:
                                      'Bạn có muốn cập nhật điểm bán cho GD này?'),
                              const SizedBox(height: 30),
                              if (detail != null) _buildNote(detail),
                              const SizedBox(height: 30),
                              _buildSelectImg(),
                              const SizedBox(height: 30),
                              if (state.transLogList != null &&
                                  state.transLogList!.isNotEmpty)
                                _transLog(transLogList),
                              // const SizedBox(height: 100),
                            ],
                          )),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _transLog(List<TransactionLogDTO> log) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
          color: AppColor.WHITE.withOpacity(0.6),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColor.WHITE)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                  child: Text(
                'LOG Biến động số dư',
                style: TextStyle(fontSize: 12),
              )),
              VietQRButton.solid(
                borderRadius: 50,
                onPressed: () {},
                isDisabled: false,
                width: 40,
                size: VietQRButtonSize.medium,
                child: const XImage(
                  imagePath: 'assets/images/ic-i-black.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const MySeparator(color: AppColor.GREY_DADADA),
          const SizedBox(height: 20),
          ...log.asMap().map(
            (index, e) {
              bool isReaMored = e.isReaMore;
              return MapEntry(
                  index,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            e.type == 0 ? 'GET TOKEN' : 'TRAN-SYNC',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          )),
                          Text(
                            e.status == 'SUCCESS' ? 'Thành công' : 'Thất bại',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 12,
                            child: VerticalDivider(
                              color: AppColor.GREY_DADADA,
                            ),
                          ),
                          Text(
                            e.statusCode == 0 ? '-' : e.statusCode.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.circle,
                              size: 15,
                              color: e.status == 'SUCCESS'
                                  ? AppColor.GREEN
                                  : AppColor.RED_TEXT)
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        height: 76,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Thời gian gửi',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColor.GREY_TEXT),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateFormat('HH:mm:ss dd/MM/yyyy').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          e.timeRequest * 1000)),
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColor.GREY_TEXT),
                                ),
                              ],
                            ),
                            const VerticalDivider(color: AppColor.GREY_DADADA),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Thời gian phản hồi',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColor.GREY_TEXT),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  e.timeResponse == 0
                                      ? '-'
                                      : DateFormat('HH:mm:ss dd/MM/yyyy')
                                          .format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  e.timeResponse * 1000)),
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColor.GREY_TEXT),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (e.status == 'FAILED') ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColor.RED_TEXT.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'LỖI:',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.message,
                                      style: const TextStyle(
                                          fontSize: 12, color: AppColor.BLACK),
                                      maxLines: !isReaMored ? 1 : 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (isReaMored)
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            transLogList[index].isReaMore =
                                                false;
                                          });
                                        },
                                        child: const Text(
                                          'Đóng',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.RED_TEXT,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  AppColor.RED_TEXT),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              if (!isReaMored)
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      transLogList[index].isReaMore = true;
                                    });
                                  },
                                  child: const Text(
                                    ' Xem thêm',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.RED_TEXT,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColor.RED_TEXT),
                                  ),
                                )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (index + 1 < log.length) ...[
                        const MySeparator(
                          color: AppColor.GREY_DADADA,
                        ),
                        const SizedBox(height: 20)
                      ]
                    ],
                  ));
            },
          ).values,
        ],
      ),
    );
  }

  Widget _buildSelectImg() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
          color: AppColor.WHITE.withOpacity(0.6),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColor.WHITE)),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                  child: Text(
                'Đính kèm ảnh giao dịch',
                style: TextStyle(fontSize: 12),
              )),
              if (imageSelect == null) ...[
                VietQRButton.solid(
                  borderRadius: 50,
                  onPressed: () {
                    _handleImage(isCamera: true);
                  },
                  isDisabled: false,
                  width: 40,
                  size: VietQRButtonSize.medium,
                  child: const XImage(
                    imagePath: 'assets/images/ic-camera-black.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                VietQRButton.solid(
                  borderRadius: 50,
                  onPressed: () {
                    _handleImage(isCamera: false);
                  },
                  isDisabled: false,
                  width: 40,
                  size: VietQRButtonSize.medium,
                  child: const XImage(
                    imagePath: 'assets/images/ic-select-image.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ]
            ],
          ),
          if (imageSelect != null) ...[
            const SizedBox(height: 15),
            const MySeparator(color: AppColor.GREY_DADADA),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {},
                  child: Text(
                    path.basename(imageSelect!.path),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColor.BLUE_TEXT,
                        color: AppColor.BLUE_TEXT),
                  ),
                )),
                const SizedBox(width: 10),
                // VietQRButton.solid(
                //   borderRadius: 50,
                //   onPressed: () {
                //     _handleImage(isCamera: true);
                //   },
                //   isDisabled: false,
                //   width: 40,
                //   size: VietQRButtonSize.medium,
                //   child: const XImage(
                //     imagePath: 'assets/images/ic-dowload.png',
                //     width: 30,
                //     height: 30,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                // const SizedBox(width: 10),
                // VietQRButton.solid(
                //   borderRadius: 50,
                //   onPressed: () {},
                //   isDisabled: false,
                //   width: 40,
                //   size: VietQRButtonSize.medium,
                //   child: const XImage(
                //     imagePath: 'assets/images/ic-remove-black.png',
                //     width: 30,
                //     height: 30,
                //     fit: BoxFit.cover,
                //   ),
                // ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildNote(TransactionItemDetailDTO detail) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: BoxDecoration(
          color: AppColor.WHITE.withOpacity(0.6),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColor.WHITE)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ghi chú',
                style: TextStyle(fontSize: 12),
              ),
              VietQRButton.solid(
                borderRadius: 50,
                onPressed: () async {
                  await DialogWidget.instance
                      .showModelBottomSheet(
                    widget: UpdateNoteWidget(
                      text: detail.note,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    bgrColor: AppColor.TRANSPARENT,
                    padding: EdgeInsets.zero,
                  )
                      .then(
                    (text) async {
                      Map<String, dynamic> body = {
                        'note': text as String,
                        'id': widget.id,
                      };
                      _updateNote(body).then(
                        (value) {
                          if (value) {
                            setState(() {
                              note = text;
                            });
                            // _bloc.add(GetTransDetailEvent(
                            //     id: widget.id, isLoading: false));
                          }
                        },
                      );
                    },
                  );
                },
                padding: const EdgeInsets.symmetric(horizontal: 15),
                isDisabled: false,
                size: VietQRButtonSize.small,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    XImage(
                      imagePath: 'assets/images/ic-edit.png',
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      'Cập nhật ghi chú',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const MySeparator(color: AppColor.GREY_DADADA),
          const SizedBox(height: 20),
          Text(
            note.isNotEmpty ? note : 'Chưa có ghi chú nào cho giao dịch này.',
            style: TextStyle(
                fontSize: 12,
                color: detail.note.isNotEmpty
                    ? AppColor.BLACK
                    : AppColor.GREY_TEXT),
          ),
        ],
      ),
    );
  }

  Future<bool> _updateNote(Map<String, dynamic> body) async {
    final transactionRepository = getIt.get<TransactionRepository>();

    final result = await transactionRepository.updateNote(body);
    if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
      return true;
    }
    return false;
  }

  Widget _buildDetail(TransactionItemDetailDTO detail) {
    String amount = '${detail.transType == 'D' ? '-' : '+'} ${detail.amount}';
    Color color = AppColor.GREEN;
    String text = '';

    switch (detail.transType) {
      case "C":
        switch (detail.status) {
          case 0:
            // - Giao dịch chờ thanh toán
            color = AppColor.ORANGE_TRANS;
            text = 'Thanh toán thành công';
            break;
          case 1:
            switch (detail.type) {
              case 2:
                // - Giao dịch đến (+) không đối soát
                color = AppColor.BLUE_TEXT;
                text = 'Thanh toán thành công';
                break;
              default:
                // - Giao dịch đến (+) có đối soát
                color = AppColor.GREEN;
                text = 'Thanh toán thành công';
                break;
            }
            break;
          case 2:
            // Giao dịch hết hạn thanh toán;
            color = AppColor.GREY_TEXT;
            text = 'Hết hạn thanh toán';
            break;
        }
        break;
      case "D":
        // - Giao dịch đi (-)
        color = AppColor.RED_TEXT;
        text = 'Thanh toán thành công';
        break;
    }

    String transType = '';
    switch (detail.type) {
      case 0:
        transType = 'VietQR động';
        break;
      case 1:
        transType = 'VietQR tĩnh';
        break;
      case 2:
        transType = 'GD khác';
        break;
      case 3:
        transType = 'VietQR bán động';
        break;
      default:
        transType = 'GD khác';
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColor.WHITE.withOpacity(0.6),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColor.WHITE)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const XImage(
            imagePath: 'assets/images/ic-viet-qr.png',
            width: 85,
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 20),
          RichText(
              text: TextSpan(
                  text: amount,
                  style: TextStyle(fontSize: 20, color: color),
                  children: const [
                TextSpan(
                  text: ' VND',
                  style: TextStyle(fontSize: 20, color: AppColor.GREY_TEXT),
                )
              ])),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 30),
          _buildItem(text: 'Mã GD:', value: detail.referenceNumber),
          const SizedBox(height: 10),
          const MySeparator(color: AppColor.GREY_DADADA),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thời gian tạo',
                      style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('HH:mm:ss dd/MM/yyyy').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              detail.time * 1000)),
                      style: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                  ],
                ),
                const VerticalDivider(color: AppColor.GREY_DADADA),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Thời gian TT',
                      style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('HH:mm:ss dd/MM/yyyy').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              detail.timePaid * 1000)),
                      style: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const MySeparator(color: AppColor.GREY_DADADA),
          const SizedBox(height: 10),
          _buildItem(
              text: 'Tài khoản:',
              value: '${detail.bankShortName} - ${detail.bankAccount}'),
          _buildItem(text: 'Chủ TK:', value: detail.userBankName),
          _buildItem(text: 'Loại GD:', value: transType),
          _buildItem(
              text: 'Mã đơn:',
              value: detail.orderId.isNotEmpty ? detail.orderId : '-'),
          _buildItem(
              text: 'Điểm bán:',
              value:
                  detail.terminalCode.isNotEmpty ? detail.terminalCode : '-'),
          _buildItem(
              text: 'Sản phẩm:',
              value: detail.serviceCode.isNotEmpty ? detail.serviceCode : '-'),
          const SizedBox(height: 10),
          const MySeparator(color: AppColor.GREY_DADADA),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nội dung TT:',
                  style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
                const SizedBox(height: 6),
                Text(
                  detail.content,
                  style:
                      const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem({
    required String text,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget bottomBar(TransactionItemDetailDTO detail) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      height: 110,
      color: AppColor.WHITE.withOpacity(0.6),
      alignment: Alignment.topCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          detail.transType != 'D'
              ? Expanded(
                  child: InkWell(
                    onTap: () {
                      // BankAccountDTO bankAccountDTO = BankAccountDTO();
                      // NavigatorUtils.navigatePage(context,
                      //     CreateQrScreen(bankAccountDTO: bankAccountDTO),
                      //     routeName: CreateQrScreen.routeName);
                      if (detail.status != 0) {
                        QRRecreateDTO qrRecreateDTO = QRRecreateDTO(
                            terminalCode: detail.terminalCode,
                            bankId: detail.bankId,
                            amount: detail.amount.replaceAll(',', ''),
                            content: detail.content,
                            userId: userId,
                            newTransaction: false);
                        _bloc.add(RegenerateQREvent(qrDto: qrRecreateDTO));
                      } else {
                        QRGeneratedDTO qrGeneratedDTO = QRGeneratedDTO(
                          bankCode: detail.bankCode,
                          bankName: detail.bankName,
                          bankAccount: detail.bankAccount,
                          userBankName: detail.userBankName,
                          bankId: detail.bankId,
                          imgId: detail.imgId,
                          amount: detail.amount,
                          content: detail.content,
                          qrCode: detail.qrCode,
                          qrLink: detail.qrLink,
                        );

                        NavigatorUtils.navigatePage(
                            context,
                            CreateQrScreen(
                              qrDto: qrGeneratedDTO,
                              page: 1,
                              // bankAccountDTO: widget.bankDto,
                            ),
                            routeName: CreateQrScreen.routeName);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF00C6FF),
                            Color(0xFF0072FF),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const XImage(
                            imagePath:
                                'assets/images/qr-contact-other-white.png',
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            detail.status == 0
                                ? "Hiển thị mã VietQR giao dịch"
                                : 'Thực hiện lại giao dịch',
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(width: 10),
          if (detail.transType != 'D' && detail.status != 2) ...[
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(4),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: const LinearGradient(
                        colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: const XImage(imagePath: 'assets/images/ic-dowload.png'),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(4),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: const LinearGradient(
                        colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child:
                    const XImage(imagePath: 'assets/images/ic-share-black.png'),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget appbar(TransactionItemDetailDTO? detail) {
    return ValueListenableBuilder<bool>(
      valueListenable: isScrollNotifier,
      builder: (context, value, child) {
        return Container(
          height: 110,
          padding:
              const EdgeInsets.only(top: 60, bottom: 0, left: 10, right: 20),
          // color: AppColor.TRANSPARENT,
          decoration: BoxDecoration(
            color: AppColor.WHITE,
            gradient: value
                ? const LinearGradient(
                    colors: [
                      Color(0xFFE1EFFF),
                      Color(0xFFE5F9FF),
                    ],
                    end: Alignment.centerRight,
                    begin: Alignment.centerLeft,
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  height: 50,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ),
                      Text(
                        'Trở về',
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
              ),
              if (detail != null)
                VietQRButton.solid(
                  onPressed: () async {
                    await DialogWidget.instance
                        .showModelBottomSheet(
                      widget: UpdateHashtagWidget(
                        transType: detail.transType,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      bgrColor: AppColor.TRANSPARENT,
                      padding: EdgeInsets.zero,
                    )
                        .then(
                      (value) {
                        print(value);
                      },
                    );
                  },
                  isDisabled: false,
                  shadow: [
                    BoxShadow(
                      color: AppColor.BLACK.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                    )
                  ],
                  size: VietQRButtonSize.medium,
                  borderRadius: 100,
                  child: const Center(
                    child: XImage(
                      imagePath: 'assets/images/ic-hastag.png',
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  void onUpdateTerminal(TransactionItemDetailDTO dto) async {
    NotifyTransDTO data = NotifyTransDTO(
      traceId: '',
      transactionReceiveId: dto.id,
      bankAccount: dto.bankAccount,
      bankName: dto.bankName,
      bankCode: dto.bankCode,
      amount: dto.amount.toString(),
      bankId: dto.bankId,
      time: dto.time,
      timePaid: dto.timePaid,
      refId: '',
      referenceNumber: dto.referenceNumber,
      terminalCode: dto.terminalCode,
      transType: dto.transType,
    );

    await NavigatorUtils.navigatePage(
        context, TransUpdateScreen(dto: data, role: role),
        routeName: TransUpdateScreen.routeName);
  }
}
