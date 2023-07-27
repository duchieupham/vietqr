import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/printer_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/views/dialog_otp.dart';
import 'package:vierqr/features/printer/views/printing_view.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_account_remove_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/models/business_item_dto.dart';
import 'package:vierqr/models/confirm_otp_bank_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/action_share_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:vierqr/services/sqflite/local_database.dart';

import 'states/bank_card_state.dart';

class BankCardDetailScreen extends StatelessWidget {
  final String bankId;

  const BankCardDetailScreen({super.key, required this.bankId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BankCardBloc>(
      create: (BuildContext context) => BankCardBloc(bankId),
      child: const BankCardDetailState(),
    );
  }
}

class BankCardDetailState extends StatefulWidget {
  const BankCardDetailState({super.key});

  @override
  State<BankCardDetailState> createState() => _BankCardDetailState();
}

class _BankCardDetailState extends State<BankCardDetailState> {
  late BankCardBloc bankCardBloc;

  final otpController = TextEditingController();

  String userId = UserInformationHelper.instance.getUserId();

  QRGeneratedDTO qrGeneratedDTO = const QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '');

  AccountBankDetailDTO dto = AccountBankDetailDTO(
    id: '',
    bankAccount: '',
    userBankName: '',
    bankCode: '',
    bankName: '',
    imgId: '',
    type: 0,
    userId: '',
    bankTypeId: '',
    bankTypeStatus: 0,
    nationalId: '',
    qrCode: '',
    phoneAuthenticated: '',
    businessDetails: [],
    transactions: [],
    authenticated: false,
    caiValue: '',
  );

  void initData(BuildContext context) {
    bankCardBloc.add(const BankCardGetDetailEvent());
  }

  Future<void> _refresh() async {
    bankCardBloc.add(const BankCardGetDetailEvent());
  }

  @override
  void initState() {
    super.initState();
    bankCardBloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const MAppBar(title: 'Chi tiết ngân hàng'),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: StreamBuilder<bool>(
                stream: notificationController.stream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == true) {
                      bankCardBloc.add(const BankCardGetDetailEvent());
                    }
                  }
                  return BlocConsumer<BankCardBloc, BankCardState>(
                    listener: (context, state) async {
                      if (state.status == BlocStatus.LOADING) {
                        DialogWidget.instance.openLoadingDialog();
                      }

                      if (state.status == BlocStatus.UNLOADING) {
                        Navigator.pop(context);
                      }

                      if (state.request == BankDetailType.UN_LINK) {
                        showDialog(
                          barrierDismissible: false,
                          context:
                              NavigationService.navigatorKey.currentContext!,
                          builder: (BuildContext context) {
                            return DialogOTPView(
                              phone: dto.phoneAuthenticated,
                              onResend: () {
                                bankCardBloc.add(BankCardEventUnlink(
                                    accountNumber: dto.bankAccount));
                              },
                              onChangeOTP: (value) {
                                otpController.value =
                                    otpController.value.copyWith(text: value);
                              },
                              onTap: () {
                                ConfirmOTPBankDTO confirmDTO =
                                    ConfirmOTPBankDTO(
                                  requestId: state.requestId ?? '',
                                  otpValue: otpController.text,
                                  applicationType: 'MOBILE',
                                  bankAccount: state.bankDetailDTO?.bankAccount,
                                );
                                bankCardBloc.add(
                                    BankCardEventUnConfirmOTP(dto: confirmDTO));
                              },
                            );
                          },
                        );
                      }

                      if (state.request == BankDetailType.OTP) {
                        Navigator.of(context).pop();
                        bankCardBloc.add(const BankCardGetDetailEvent());
                      }

                      if (state.request == BankDetailType.DELETED) {
                        Fluttertoast.showToast(
                          msg: 'Đã xoá TK ngân hàng',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Theme.of(context).cardColor,
                          textColor: Theme.of(context).hintColor,
                          fontSize: 15,
                        );

                        Navigator.pop(context, true);
                      }

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
                      if (state.request == BankDetailType.ERROR) {
                        await DialogWidget.instance.openMsgDialog(
                          title: 'Không thể xoá tài khoản',
                          msg: state.msg ?? '',
                        );
                      }

                      if (state.status != BlocStatus.NONE ||
                          state.request != BankDetailType.NONE) {
                        bankCardBloc.add(UpdateEvent());
                      }
                    },
                    builder: (context, state) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VietQr(qrGeneratedDTO: qrGeneratedDTO),
                            const Padding(padding: EdgeInsets.only(top: 30)),
                            BoxLayout(
                              width: width,
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 20,
                                bottom: (state.bankDetailDTO?.authenticated ??
                                        false ||
                                            state.bankDetailDTO?.bankCode
                                                    .trim()
                                                    .toUpperCase() !=
                                                'MB')
                                    ? 20
                                    : 0,
                              ),
                              child: Column(
                                children: [
                                  _buildElement(
                                    context: context,
                                    width: width,
                                    title: 'Trạng thái',
                                    isAuthenticated: dto.authenticated,
                                    description: (dto.authenticated)
                                        ? 'Đã liên kết'
                                        : 'Chưa liên kết',
                                  ),
                                  if (!dto.authenticated) ...[
                                    const Padding(
                                        padding: EdgeInsets.only(top: 10)),
                                    const Text(
                                      'Liên kết TK ngân hàng để nhận thông báo biến động số dư',
                                      style: TextStyle(
                                        // fontSize: 12,
                                        color: AppColor.GREY_TEXT,
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 10)),
                                  ],
                                  if (dto.nationalId.isNotEmpty) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: DividerWidget(width: width),
                                    ),
                                    _buildElement(
                                      context: context,
                                      width: width,
                                      title: 'CCCD/CMT',
                                      description: dto.nationalId,
                                    ),
                                  ],
                                  if (dto.phoneAuthenticated.isNotEmpty) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: DividerWidget(width: width),
                                    ),
                                    _buildElement(
                                      context: context,
                                      width: width,
                                      title: 'SĐT xác thực',
                                      description: dto.phoneAuthenticated,
                                    ),
                                  ],
                                  const SizedBox(height: 10),
                                  if (!dto.authenticated &&
                                      dto.bankCode.trim().toUpperCase() ==
                                          'MB') ...[
                                    DividerWidget(width: width),
                                    const SizedBox(height: 10),
                                    ButtonIconWidget(
                                      width: width,
                                      icon: Icons.link_rounded,
                                      title: 'Liên kết ngay',
                                      function: () {
                                        BankTypeDTO bankTypeDTO = BankTypeDTO(
                                            id: dto.bankTypeId,
                                            bankCode: dto.bankCode,
                                            bankName: dto.bankName,
                                            imageId: dto.imgId,
                                            bankShortName: dto.bankCode,
                                            status: dto.bankTypeStatus,
                                            caiValue: dto.caiValue);
                                        Navigator.pushNamed(
                                          context,
                                          Routes.ADD_BANK_CARD,
                                          arguments: {
                                            'step': 1,
                                            'bankAccount': dto.bankAccount,
                                            'name': dto.userBankName,
                                            'bankDTO': bankTypeDTO,
                                            'bankId': dto.id,
                                          },
                                        ).then((value) {
                                          if (value is bool) {
                                            bankCardBloc.add(
                                                const BankCardGetDetailEvent());
                                          }
                                        });
                                      },
                                      bgColor: AppColor.TRANSPARENT,
                                      textColor: AppColor.GREEN,
                                    ),
                                  ],
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 30)),
                            if (dto.transactions.isNotEmpty) ...[
                              _buildTitle(title: 'Giao dịch gần dây'),
                              _buildRelatedTransaction(context,
                                  dto.transactions, state.bankId ?? ''),
                              const Padding(padding: EdgeInsets.only(top: 10)),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.TRANSACTION_HISTORY_VIEW,
                                    arguments: {'bankId': state.bankId ?? ''},
                                  );
                                },
                                child: BoxLayout(
                                  width: width,
                                  height: 40,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(0),
                                  bgColor: AppColor.TRANSPARENT,
                                  child: const Text(
                                    'Xem thêm',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColor.BLUE_TEXT,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (dto.authenticated &&
                                dto.businessDetails.isNotEmpty) ...[
                              const Padding(padding: EdgeInsets.only(top: 24)),
                              _buildTitle(title: 'Doanh nghiệp'),
                              _buildBusinessInformation(
                                  context, dto.businessDetails),
                            ],
                            const Padding(padding: EdgeInsets.only(bottom: 16)),
                            if (dto.authenticated &&
                                (userId == dto.userId)) ...[
                              DividerWidget(width: width),
                              ButtonIconWidget(
                                width: width,
                                height: 40,
                                bgColor: AppColor.TRANSPARENT,
                                textColor: AppColor.RED_TEXT,
                                icon: Icons.remove_circle_rounded,
                                alignment: Alignment.centerLeft,
                                title: 'Huỷ liên kết TK ngân hàng',
                                function: () {
                                  DialogWidget.instance.openMsgDialog(
                                    title: 'Huỷ liên kết',
                                    msg: 'Bạn có chắc chắn muốn huỷ liên kết?',
                                    isSecondBT: true,
                                    functionConfirm: () {
                                      Navigator.of(context).pop();
                                      bankCardBloc.add(
                                        BankCardEventUnlink(
                                            accountNumber: dto.bankAccount),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                            if (userId == dto.userId) ...[
                              DividerWidget(width: width),
                              ButtonIconWidget(
                                width: width,
                                height: 40,
                                bgColor: AppColor.TRANSPARENT,
                                textColor: AppColor.RED_TEXT,
                                icon: Icons.delete_rounded,
                                alignment: Alignment.centerLeft,
                                title: 'Xoá TK ngân hàng',
                                function: () {
                                  if (dto.authenticated) {
                                    DialogWidget.instance.openMsgDialog(
                                      title: 'Cảnh báo',
                                      msg:
                                          'Bạn phải huỷ liên kết Tk ngân hàng này trước khi xoá',
                                    );
                                  } else {
                                    BankAccountRemoveDTO bankAccountRemoveDTO =
                                        BankAccountRemoveDTO(
                                      bankId: state.bankId ?? '',
                                      type: dto.type,
                                      isAuthenticated: dto.authenticated,
                                    );
                                    bankCardBloc.add(BankCardEventRemove(
                                        dto: bankAccountRemoveDTO));
                                  }
                                },
                              ),
                              DividerWidget(width: width),
                            ],
                            const Padding(padding: EdgeInsets.only(bottom: 50)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          SizedBox(
            width: width,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonIconWidget(
                  width: width * 0.2,
                  height: 40,
                  icon: Icons.print_rounded,
                  title: '',
                  function: () async {
                    BluetoothPrinterDTO bluetoothPrinterDTO =
                        await LocalDatabase.instance
                            .getBluetoothPrinter(userId);
                    if (bluetoothPrinterDTO.id.isNotEmpty) {
                      bool isPrinting = false;
                      if (!isPrinting) {
                        isPrinting = true;
                        DialogWidget.instance.showFullModalBottomContent(
                            widget: const PrintingView());
                        await PrinterUtils.instance
                            .print(qrGeneratedDTO)
                            .then((value) {
                          Navigator.pop(context);
                          isPrinting = false;
                        });
                      }
                    } else {
                      DialogWidget.instance.openMsgDialog(
                          title: 'Không thể in',
                          msg:
                              'Vui lòng kết nối với máy in để thực hiện việc in.');
                    }
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
                    Provider.of<ActionShareProvider>(context, listen: false)
                        .updateAction(false);
                    Navigator.pushNamed(
                      context,
                      Routes.QR_SHARE_VIEW,
                      arguments: {
                        'qrGeneratedDTO': qrGeneratedDTO,
                        'action': 'SAVE'
                      },
                    );
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
                    await FlutterClipboard.copy(
                            ShareUtils.instance.getTextSharing(qrGeneratedDTO))
                        .then(
                      (value) => Fluttertoast.showToast(
                        msg: 'Đã sao chép',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Theme.of(context).cardColor,
                        textColor: Theme.of(context).hintColor,
                        fontSize: 15,
                        webBgColor: 'rgba(255, 255, 255)',
                        webPosition: 'center',
                      ),
                    );
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
                    Provider.of<ActionShareProvider>(context, listen: false)
                        .updateAction(false);
                    Navigator.pushNamed(context, Routes.QR_SHARE_VIEW,
                        arguments: {'qrGeneratedDTO': qrGeneratedDTO});
                  },
                  bgColor: Theme.of(context).cardColor,
                  textColor: AppColor.BLUE_TEXT,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          ButtonIconWidget(
            width: width - 40,
            height: 40,
            icon: Icons.add_rounded,
            title: 'Tạo QR giao dịch',
            function: () {
              BankAccountDTO bankAccountDTO = BankAccountDTO(
                id: dto.id,
                bankAccount: dto.bankAccount,
                userBankName: dto.userBankName,
                bankCode: dto.bankCode,
                bankName: dto.bankName,
                imgId: dto.imgId,
                type: dto.type,
                branchId: (dto.businessDetails.isEmpty)
                    ? ''
                    : dto.businessDetails.first.branchDetails.first.branchId,
                businessId: (dto.businessDetails.isEmpty)
                    ? ''
                    : dto.businessDetails.first.businessId,
                branchName: (dto.businessDetails.isEmpty)
                    ? ''
                    : dto.businessDetails.first.branchDetails.first.branchName,
                businessName: (dto.businessDetails.isEmpty)
                    ? ''
                    : dto.businessDetails.first.businessName,
                isAuthenticated: dto.authenticated,
              );
              Navigator.pushNamed(
                context,
                Routes.CREATE_QR,
                arguments: {'bankInfo': bankAccountDTO},
              );
            },
            textColor: AppColor.WHITE,
            bgColor: AppColor.BLUE_TEXT,
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: (PlatformUtils.instance.isIOsApp()) ? 20 : 10)),
        ],
      ),
    );
  }

  Widget _buildBusinessInformation(
      BuildContext context, List<BusinessDetails> list) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: List.generate(list.length, (index) {
        String heroId = list[index].businessId;
        return BoxLayout(
          width: width,
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (list[index].imgId.isNotEmpty)
                                ? ImageUtils.instance
                                    .getImageNetWork(list[index].imgId)
                                : Image.asset(
                                    'assets/images/ic-avatar-business.png',
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,
                                  ).image),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: Text(
                        list[index].businessName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Column(
                children:
                    List.generate(list[index].branchDetails.length, (index2) {
                  return BoxLayout(
                    width: width,
                    borderRadius: 10,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    bgColor: Theme.of(context).canvasColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 100,
                              child: Text('Chi nhánh'),
                            ),
                            Expanded(
                              child: Text(
                                list[index].branchDetails[index2].branchName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Row(
                          children: [
                            const SizedBox(
                              width: 100,
                              child: Text('Địa chỉ'),
                            ),
                            Expanded(
                              child: Text(
                                list[index].branchDetails[index2].address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              DividerWidget(width: width),
              ButtonWidget(
                width: width,
                height: 40,
                text: 'Chi tiết doanh nghiệp',
                textColor: AppColor.BLUE_TEXT,
                bgColor: AppColor.TRANSPARENT,
                function: () {
                  BusinessItemDTO businessItemDTO = BusinessItemDTO(
                      businessId: list[index].businessId,
                      code: '',
                      role: 0,
                      imgId: list[index].imgId,
                      coverImgId: list[index].coverImgId,
                      name: list[index].businessName,
                      address: '',
                      taxCode: '',
                      transactions: [],
                      totalMember: 0,
                      totalBranch: 0,
                      branchs: [],
                      bankAccounts: []);
                  Navigator.pushNamed(
                    context,
                    Routes.BUSINESS_INFORMATION_VIEW,
                    arguments: {
                      'heroId': heroId,
                      'img': list[index].coverImgId,
                      'businessItem': businessItemDTO,
                    },
                  ).then((value) {
                    bankCardBloc
                        .add(const BankCardGetDetailEvent(isLoading: false));
                  });
                },
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRelatedTransaction(
      BuildContext context, List<Transactions> transactions, String bankId) {
    final double width = MediaQuery.of(context).size.width;

    return Visibility(
      visible: transactions.isNotEmpty,
      child: BoxLayout(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.TRANSACTION_DETAIL,
                  arguments: {
                    'transactionId': transactions[index].transactionId,
                    'bankCardBloc': bankCardBloc,
                    'bankId': bankId,
                  },
                );
              },
              child: Container(
                width: width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: Icon(
                        TransactionUtils.instance.getIconStatus(
                          transactions[index].status,
                          transactions[index].transType,
                        ),
                        color: TransactionUtils.instance.getColorStatus(
                          transactions[index].status,
                          transactions[index].type,
                          transactions[index].transType,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${TransactionUtils.instance.getTransType(transactions[index].transType)} ${CurrencyUtils.instance.getCurrencyFormatted(transactions[index].amount)}',
                            style: TextStyle(
                              fontSize: 18,
                              color: TransactionUtils.instance.getColorStatus(
                                transactions[index].status,
                                transactions[index].type,
                                transactions[index].transType,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 3)),
                          Text(
                            transactions[index].content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColor.GREY_TEXT,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      TimeUtils.instance
                          .formatDateFromInt(transactions[index].time, true),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return DividerWidget(width: width);
          },
        ),
      ),
    );
  }

  Widget _buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildElement(
      {required BuildContext context,
      required double width,
      required String title,
      required String description,
      bool? isAuthenticated}) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          const Spacer(),
          if (isAuthenticated != null) ...[
            Icon(
              (isAuthenticated)
                  ? Icons.check_rounded
                  : Icons.pending_actions_rounded,
              size: 18,
              color: (isAuthenticated) ? AppColor.BLUE_TEXT : AppColor.ORANGE,
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
          ],
          Text(
            description,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 15,
              color: (isAuthenticated != null && isAuthenticated)
                  ? AppColor.BLUE_TEXT
                  : (isAuthenticated != null && !isAuthenticated)
                      ? AppColor.ORANGE
                      : Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
