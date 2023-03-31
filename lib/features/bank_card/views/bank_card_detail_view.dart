import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
import 'package:vierqr/features/bank_card/states/bank_card_state.dart';
import 'package:vierqr/features/generate_qr/views/create_qr.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/business_item_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class BankCardDetailView extends StatelessWidget {
  static late BankCardBloc bankCardBloc;

  static QRGeneratedDTO qrGeneratedDTO = const QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '');

  static AccountBankDetailDTO dto = AccountBankDetailDTO(
    id: '',
    bankAccount: '',
    userBankName: '',
    bankCode: '',
    bankName: '',
    imgId: '',
    type: 0,
    nationalId: '',
    qrCode: '',
    phoneAuthenticated: '',
    businessDetails: [],
    transactions: [],
    authenticated: false,
  );

  static String bankId = '';

  const BankCardDetailView({super.key});

  void initialServives(BuildContext context, String bankId) {
    bankCardBloc = BlocProvider.of(context);
    bankCardBloc.add(BankCardGetDetailEvent(bankId: bankId));
  }

  Future<void> _refresh() async {
    bankCardBloc.add(BankCardGetDetailEvent(bankId: bankId));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    bankId = arg['bankId'] ?? '';
    initialServives(context, bankId);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          SubHeader(title: 'Chi tiết TK ngân hàng'),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: BlocBuilder<BankCardBloc, BankCardState>(
                builder: (context, state) {
                  if (state is BankCardGetDetailLoadingState) {
                    return const UnconstrainedBox(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: DefaultTheme.GREEN,
                        ),
                      ),
                    );
                  }
                  if (state is BankCardGetDetailSuccessState) {
                    dto = state.dto;
                    qrGeneratedDTO = QRGeneratedDTO(
                        bankCode: dto.bankCode,
                        bankName: dto.bankName,
                        bankAccount: dto.bankAccount,
                        userBankName: dto.userBankName,
                        amount: '',
                        content: '',
                        qrCode: dto.qrCode,
                        imgId: dto.imgId);
                  }
                  return ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      VietQRWidget(
                          width: width,
                          qrGeneratedDTO: qrGeneratedDTO,
                          content: ''),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      _buildElement(
                        context: context,
                        width: width,
                        title: 'Trạng thái',
                        isAuthenticated: dto.authenticated,
                        description: (dto.authenticated)
                            ? 'Đã liên kết'
                            : 'Chưa liên kết',
                      ),
                      if (dto.nationalId.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: DividerWidget(width: width),
                        ),
                        _buildElement(
                          context: context,
                          width: width,
                          title: 'CCCD/CMT',
                          description: dto.nationalId,
                        ),
                      ],
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      if (dto.transactions.isNotEmpty) ...[
                        _buildTitle(title: 'Giao dịch gần dây'),
                        _buildRelatedTransaction(context, dto.transactions),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.TRANSACTION_HISTORY_VIEW);
                          },
                          child: BoxLayout(
                            width: width,
                            height: 40,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(0),
                            bgColor: DefaultTheme.TRANSPARENT,
                            child: const Text(
                              'Xem thêm',
                              style: TextStyle(
                                fontSize: 15,
                                color: DefaultTheme.GREEN,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (dto.authenticated) ...[
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        _buildTitle(title: 'VietQRPlus cho Doanh Nghiệp'),
                        _buildBusinessInformation(context, dto.businessDetails),
                      ],
                      const Padding(padding: EdgeInsets.only(bottom: 50)),
                      if (dto.authenticated) ...[
                        DividerWidget(width: width),
                        ButtonIconWidget(
                          width: width,
                          height: 40,
                          bgColor: DefaultTheme.TRANSPARENT,
                          textColor: DefaultTheme.RED_TEXT,
                          icon: Icons.remove_circle_rounded,
                          alignment: Alignment.centerLeft,
                          title: 'Huỷ liên kết tài khoản',
                          function: () {
                            DialogWidget.instance.openMsgDialog(
                              title: 'Bảo trì',
                              msg:
                                  'Tính năng đang bảo trì, vui lòng thử lại sau',
                            );
                          },
                        ),
                      ],
                      DividerWidget(width: width),
                      ButtonIconWidget(
                        width: width,
                        height: 40,
                        bgColor: DefaultTheme.TRANSPARENT,
                        textColor: DefaultTheme.RED_TEXT,
                        icon: Icons.delete_rounded,
                        alignment: Alignment.centerLeft,
                        title: 'Xoá tài khoản',
                        function: () {
                          DialogWidget.instance.openMsgDialog(
                            title: 'Bảo trì',
                            msg: 'Tính năng đang bảo trì, vui lòng thử lại sau',
                          );
                        },
                      ),
                      DividerWidget(width: width),
                      const Padding(padding: EdgeInsets.only(bottom: 50)),
                    ],
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
              children: [
                const Padding(padding: EdgeInsets.only(left: 20)),
                ButtonIconWidget(
                  width: width / 2 - 25,
                  height: 40,
                  icon: Icons.copy_rounded,
                  title: 'Sao chép nội dung',
                  function: () async {
                    await FlutterClipboard.copy(
                            ShareUtils.instance.getTextSharing(qrGeneratedDTO))
                        .then(
                      (value) => Fluttertoast.showToast(
                        msg: 'Đã sao chép',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).hintColor,
                        fontSize: 15,
                        webBgColor: 'rgba(255, 255, 255)',
                        webPosition: 'center',
                      ),
                    );
                  },
                  bgColor: Theme.of(context).cardColor,
                  textColor: DefaultTheme.BLUE_TEXT,
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                ButtonIconWidget(
                  width: width / 2 - 25,
                  height: 40,
                  icon: Icons.share_rounded,
                  title: 'Chia sẻ mã QR',
                  function: () {
                    Navigator.pushNamed(context, Routes.QR_SHARE_VIEW,
                        arguments: {'qrGeneratedDTO': qrGeneratedDTO});
                  },
                  bgColor: Theme.of(context).cardColor,
                  textColor: DefaultTheme.GREEN,
                ),
                const Padding(padding: EdgeInsets.only(left: 20)),
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateQR(
                    bankAccountDTO: bankAccountDTO,
                  ),
                ),
              );
            },
            textColor: DefaultTheme.WHITE,
            bgColor: DefaultTheme.GREEN,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
        ],
      ),
    );
  }

  Widget _buildBusinessInformation(
      BuildContext context, List<BusinessDetails> list) {
    final double width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        String heroId = list[index].businessId;
        return Hero(
          tag: heroId,
          child: BoxLayout(
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
                const Padding(padding: EdgeInsets.only(top: 30)),
                ListView.separated(
                  itemCount: list[index].branchDetails.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index2) {
                    return BoxLayout(
                        width: width,
                        borderRadius: 10,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        bgColor: Theme.of(context).canvasColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              list[index].branchDetails[index2].branchName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 10)),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text('Code'),
                                ),
                                Expanded(
                                  child: Text(
                                    list[index].branchDetails[index2].code,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await FlutterClipboard.copy(list[index]
                                            .branchDetails[index2]
                                            .code)
                                        .then(
                                      (value) => Fluttertoast.showToast(
                                        msg: 'Đã sao chép',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        textColor: Theme.of(context).hintColor,
                                        fontSize: 15,
                                        webBgColor: 'rgba(255, 255, 255)',
                                        webPosition: 'center',
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.copy_rounded,
                                    color: DefaultTheme.GREY_TEXT,
                                    size: 15,
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
                        ));
                  },
                  separatorBuilder: (context, index2) {
                    return DividerWidget(width: width);
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                DividerWidget(width: width),
                ButtonWidget(
                  width: width,
                  height: 40,
                  text: 'Chi tiết doanh nghiệp',
                  textColor: DefaultTheme.GREEN,
                  bgColor: DefaultTheme.TRANSPARENT,
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
                    );
                    Navigator.pushNamed(
                      context,
                      Routes.BUSINESS_INFORMATION_VIEW,
                      arguments: {
                        'heroId': heroId,
                        'img': list[index].coverImgId,
                        'businessItem': businessItemDTO,
                      },
                    ).then((value) {
                      heroId = value.toString();
                      bankCardBloc.add(BankCardGetDetailEvent(bankId: bankId));
                    });
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRelatedTransaction(
      BuildContext context, List<Transactions> transactions) {
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
            return Container(
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
                            color: DefaultTheme.GREY_TEXT,
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
            width: 80,
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
              color:
                  (isAuthenticated) ? DefaultTheme.GREEN : DefaultTheme.ORANGE,
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
          ],
          Text(
            description,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 15,
              color: (isAuthenticated != null && isAuthenticated)
                  ? DefaultTheme.GREEN
                  : (isAuthenticated != null && !isAuthenticated)
                      ? DefaultTheme.ORANGE
                      : Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
