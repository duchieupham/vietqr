import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/helper/app_data_helper.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/states/bank_card_state.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_input_money.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_bank_detail.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class MyQrWidget extends StatefulWidget {
  final BankAccountDTO dto;
  final GlobalKey globalKey;
  final BankCardBloc bloc;

  const MyQrWidget(
      {super.key,
      required this.dto,
      required this.globalKey,
      required this.bloc});

  @override
  State<MyQrWidget> createState() => _MyQrWidgetState();
}

class _MyQrWidgetState extends State<MyQrWidget> {
  // late BankCardBloc bankCardBloc;

  @override
  void initState() {
    super.initState();
    // bankCardBloc = getIt.get<BankCardBloc>(param1: widget.dto.id, param2: true);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        // widget.bloc
        //     .add(const BankCardGetDetailEvent(isLoading: true, isInit: true));
      },
    );
  }

  void updateAmount() async {
    final result = await DialogWidget.instance.showModelBottomSheet(
      borderRadius: BorderRadius.circular(16),
      widget: BottomSheetInputMoney(
        dto: qrGeneratedDTO,
      ),
    );
    if (result != null && result is QRDetailBank) {
      Map<String, dynamic> data = {};
      data['bankAccount'] = dto.bankAccount;
      data['userBankName'] = dto.userBankName;
      data['bankCode'] = dto.bankCode;
      data['amount'] = result.money.replaceAll(',', '');
      data['content'] = StringUtils.instance.removeDiacritic(result.content);
      widget.bloc.add(BankCardGenerateDetailQR(dto: data));
    }
  }

  late QRGeneratedDTO qrGeneratedDTO = QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '');
  late AccountBankDetailDTO dto = AccountBankDetailDTO();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BankCardBloc, BankCardState>(
      bloc: widget.bloc,
      listener: (context, state) async {
        if (state.request == BankDetailType.SUCCESS) {
          if (state.bankDetailDTO != null) {
            dto = state.bankDetailDTO!;
          }
          qrGeneratedDTO = QRGeneratedDTO(
            bankCode: dto.bankCode,
            bankName: dto.bankName,
            bankAccount: dto.bankAccount,
            userBankName: dto.userBankName,
            amount: '',
            content: '',
            qrCode: dto.qrCode,
            imgId: dto.imgId,
          );
        }
        if (state.request == BankDetailType.CREATE_QR) {
          qrGeneratedDTO = state.qrGeneratedDTO!;
          if (state.qrGeneratedDTO!.amount.isNotEmpty &&
              state.qrGeneratedDTO!.amount != '0') {
            // QRDetailBank qrDetailBank = QRDetailBank(
            //     money: qrGeneratedDTO.amount,
            //     content: qrGeneratedDTO.content,
            //     qrCode: qrGeneratedDTO.qrCode,
            //     bankAccount: qrGeneratedDTO.bankAccount);
            // AppDataHelper.instance.addListQRDetailBank(qrDetailBank);
          }
        }
        if (state.request == BankDetailType.ERROR) {
          await DialogWidget.instance.openMsgDialog(
            title: 'Thông báo',
            msg: state.msg ?? '',
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              RepaintBoundaryWidget(
                globalKey: widget.globalKey,
                builder: (key) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(50, 30, 50, 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColor.WHITE.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColor.WHITE)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (state.status != BlocStatus.LOADING_PAGE)
                          SizedBox(
                            width: 250,
                            height: 250,
                            child: QrImageView(
                              padding: EdgeInsets.zero,
                              data: dto.qrCode,
                              size: 200,
                              version: QrVersions.auto,
                              backgroundColor: AppColor.TRANSPARENT,
                              errorCorrectionLevel: QrErrorCorrectLevel.M,
                              embeddedImage: const AssetImage(
                                  'assets/images/ic-viet-qr-small.png'),
                              dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: AppColor.BLACK),
                              eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: AppColor.BLACK),
                              embeddedImageStyle: const QrEmbeddedImageStyle(
                                size: Size(30, 30),
                              ),
                            ),
                          )
                        else
                          const ShimmerBlock(
                            height: 250,
                            width: 250,
                            borderRadius: 10,
                          ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                  'assets/images/logo-napas-trans-bgr.png',
                                  height: 42),
                              widget.dto.imgId.isNotEmpty
                                  ? Container(
                                      width: 80,
                                      height: 40,
                                      margin: const EdgeInsets.only(top: 2),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: ImageUtils.instance
                                                .getImageNetWork(
                                                    widget.dto.imgId),
                                            fit: BoxFit.cover),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Image.asset(
                                          'assets/images/logo_vietgr_payment.png',
                                          height: 40),
                                    ),
                              // const SizedBox(width: 30),
                            ],
                          ),
                        ),
                        if (qrGeneratedDTO.amount.isNotEmpty &&
                            qrGeneratedDTO.amount != '0') ...[
                          const SizedBox(height: 20),
                          const MySeparator(color: AppColor.GREY_DADADA),
                          const SizedBox(height: 20),
                          RichText(
                              text: TextSpan(
                                  text: CurrencyUtils.instance
                                      .getCurrencyFormatted(
                                          qrGeneratedDTO.amount),
                                  style: const TextStyle(
                                      fontSize: 25,
                                      color: AppColor.ORANGE_TRANS,
                                      fontWeight: FontWeight.bold),
                                  children: const [
                                TextSpan(
                                    text: ' VND',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: AppColor.GREY_TEXT,
                                        fontWeight: FontWeight.normal))
                              ])),
                          const SizedBox(height: 15),
                          if (qrGeneratedDTO.content.isNotEmpty)
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                qrGeneratedDTO.content,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColor.BLACK),
                              ),
                            )
                        ]
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              _updateAmount()
            ],
          ),
        );
      },
    );
  }

  Widget _updateAmount() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              // height: 40,
              decoration: BoxDecoration(
                  color: AppColor.WHITE.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppColor.WHITE)),
              child: GestureDetector(
                onTap: () {
                  updateAmount();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    qrGeneratedDTO.amount.isNotEmpty
                        ? const XImage(
                            imagePath: 'assets/images/ic-edit.png',
                            height: 30,
                          )
                        : const Image(
                            height: 30,
                            image: AssetImage(
                                'assets/images/ic-add-money-content.png'),
                          ),
                    Text(
                      qrGeneratedDTO.amount.isNotEmpty
                          ? 'Chỉnh sửa số tiền và nội dụng'
                          : 'Thêm số tiền và nội dung',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () async {
              await FlutterClipboard.copy(
                      'số tiền: ${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND ${qrGeneratedDTO.content.isNotEmpty ? '\nnội dung: ${qrGeneratedDTO.content}' : ''}')
                  .then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).hintColor,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255, 0.5)',
                  webPosition: 'center',
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.WHITE),
                borderRadius: BorderRadius.circular(100),
                color: AppColor.WHITE.withOpacity(0.6),
              ),
              child: const Image(
                image: AssetImage('assets/images/ic-copy-black.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
