import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/features/invoice/blocs/invoice_bloc.dart';
import 'package:vierqr/features/invoice/events/invoice_events.dart';
import 'package:vierqr/features/invoice/widgets/popup_invoice_success.dart';
import 'package:vierqr/features/invoice/widgets/popup_invoice_widget.dart';
import 'package:vierqr/models/invoice_detail_dto.dart';

import '../../../commons/constants/configurations/app_images.dart';
import '../../../commons/constants/configurations/stringify.dart';
import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/utils/currency_utils.dart';
import '../../../commons/utils/log.dart';
import '../../../commons/utils/navigator_utils.dart';
import '../../../commons/widgets/separator_widget.dart';
import '../../../models/qr_generated_dto.dart';
import '../../../services/local_notification/notification_service.dart';
import '../../popup_bank/popup_bank_share.dart';
import '../states/invoice_states.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final String invoiceId;
  const InvoiceDetailScreen({
    super.key,
    required this.invoiceId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceBloc>(
      create: (BuildContext context) => InvoiceBloc(context),
      child: _InvoiceDetailScreen(
        invoiceId: invoiceId,
      ),
    );
  }
}

class _InvoiceDetailScreen extends StatefulWidget {
  final String invoiceId;
  const _InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  State<_InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<_InvoiceDetailScreen> {
  InvoiceDetailDTO? _data;
  @override
  void initState() {
    super.initState();
    context.read<InvoiceBloc>().add(GetInvoiceDetail(widget.invoiceId));
  }

  void _onQrCreate() async {
    if (_data != null) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) => PopupQrCreate(
          onSave: () {
            onSaveImage(context);
          },
          onShare: () {
            onShare(context);
          },
          invoiceName: _data!.invoiceName!,
          totalAmount: _data!.totalAmount.toString(),
          billNumber: _data!.billNumber!,
          qr: _data!.qrCode!,
        ),
      );
    }
  }

  void onShare(BuildContext context) {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: _data!.bankCode!,
      bankName: _data!.bankName!,
      bankAccount: _data!.bankAccount!,
      userBankName: _data!.userBankName!,
      qrCode: _data!.qrCode!,
      imgId: '',
      amount: _data!.totalAmount.toString(),
    );
    NavigatorUtils.navigatePage(
        context, PopupBankShare(dto: dto, type: TypeImage.SHARE),
        routeName: PopupBankShare.routeName);
  }

  void onSaveImage(BuildContext context) {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: _data!.bankCode!,
      bankName: _data!.bankName!,
      bankAccount: _data!.bankAccount!,
      userBankName: _data!.userBankName!,
      qrCode: _data!.qrCode!,
      imgId: '',
      amount: _data!.totalAmount.toString(),
    );
    NavigatorUtils.navigatePage(
        context, PopupBankShare(dto: dto, type: TypeImage.SAVE),
        routeName: PopupBankShare.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvoiceBloc, InvoiceStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return _buildBody(state);
      },
    );
  }

  Widget _buildBody(InvoiceStates state) {
    if (state.status == BlocStatus.SUCCESS) {
      _data = state.invoiceDetailDTO;
    }
    int timestamp = _data != null ? _data!.timePaid! : 0;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String timePaid = _data?.status == 1 ? DateFormat('dd/MM/yyyy HH:mm').format(date) : '-';
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      bottomNavigationBar:
          _data?.status == 0 ? _bottom(context) : const SizedBox.shrink(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            leadingWidth: 100,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                      size: 25,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      "Trở về",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  AppImages.icLogoVietQr,
                  width: 95,
                  fit: BoxFit.fitWidth,
                ),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                state.invoiceDetailDTO != null
                    ? Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Text(
                                _data?.invoiceName ?? '',
                                style: TextStyle(
                                  color: AppColor.BLACK,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              child: Text(
                                '${CurrencyUtils.instance.getCurrencyFormatted(_data!.totalAmount.toString())} VND',
                                style: TextStyle(
                                  color: _data?.status == 1
                                      ? AppColor.GREEN
                                      : AppColor.ORANGE_DARK,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            IntrinsicHeight(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 15),
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: IntrinsicHeight(
                                        child: Container(
                                          margin: EdgeInsets.only(right: 4),
                                          width: double.infinity,
                                          child: Text(
                                            'Trạng thái',
                                            style: TextStyle(
                                              color: AppColor.BLACK,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    IntrinsicHeight(
                                      child: Text(
                                        _data?.status == 1
                                            ? 'Đã thanh toán'
                                            : 'Chưa thanh toán',
                                        style: TextStyle(
                                          color: _data?.status == 1
                                              ? AppColor.GREEN
                                              : AppColor.ORANGE_DARK,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            MySeparator(
                              color: AppColor.GREY_DADADA,
                            ),
                            _buildItem('Mã hoá đơn', _data!.billNumber!,
                                FontWeight.normal),
                            MySeparator(
                              color: AppColor.GREY_DADADA,
                            ),
                            _buildItem(
                                'Tài khoản',
                                '${_data?.bankShortName} - ${_data?.bankAccount}',
                                FontWeight.normal),
                            MySeparator(
                              color: AppColor.GREY_DADADA,
                            ),
                            _buildItem(
                                'Tổng tiền hàng',
                                '${CurrencyUtils.instance.getCurrencyFormatted(_data!.amount.toString())} VND',
                                FontWeight.normal),
                            MySeparator(
                              color: AppColor.GREY_DADADA,
                            ),
                            _buildItem(
                                'Tiền thuế GTGT (VAT)',
                                '${_data?.vat?.toStringAsFixed(0)}% - ${CurrencyUtils.instance.getCurrencyFormatted(_data!.vatAmount.toString())} VND',
                                FontWeight.normal),
                            MySeparator(
                              color: AppColor.GREY_DADADA,
                            ),
                            _buildItem(
                                'Tổng tiền thanh toán',
                                '${CurrencyUtils.instance.getCurrencyFormatted(_data!.totalAmount.toString())} VND',
                                FontWeight.bold),
                            MySeparator(
                              color: AppColor.GREY_DADADA,
                            ),
                            _buildItem(
                                'Thời gian TT', timePaid, FontWeight.normal),
                            MySeparator(
                              color: AppColor.GREY_DADADA,
                            ),
                            const SizedBox(height: 30),
                            Container(
                              child: Text(
                                'Danh mục hàng hoá, dịch vụ',
                                style: TextStyle(
                                  color: AppColor.BLACK,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ..._data!.items!
                                .map((e) => _buildItemBottom(
                                    e.invoiceItemName!,
                                    e.quantity.toString(),
                                    e.itemAmount.toString(),
                                    e.totalItemAmount.toString()))
                                .toList(),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemBottom(String invoiceItemName, String quantity,
      String itemAmount, String totalItemAmount) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Container(
              margin: EdgeInsets.only(bottom: 35),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: IntrinsicHeight(
                      child: Container(
                        margin: EdgeInsets.only(right: 4),
                        width: double.infinity,
                        child: Text(
                          invoiceItemName,
                          style: TextStyle(color: AppColor.BLACK, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  IntrinsicHeight(
                    child: Text(
                      '${CurrencyUtils.instance.getCurrencyFormatted(itemAmount.toString())} VND',
                      style: TextStyle(color: AppColor.BLACK, fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
          ),
          IntrinsicHeight(
            child: Container(
              margin: EdgeInsets.only(bottom: 16, left: 200),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IntrinsicHeight(
                    child: Text(
                      'x$quantity',
                      style: TextStyle(color: AppColor.BLACK, fontSize: 15),
                    ),
                  ),
                  IntrinsicHeight(
                    child: Text(
                      '${CurrencyUtils.instance.getCurrencyFormatted(totalItemAmount.toString())} VND',
                      style: TextStyle(color: AppColor.BLACK, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          MySeparator(),
        ],
      ),
    );
  }

  Widget _buildItem(
      String leftText, String rightText, FontWeight rightTextFontWeight) {
    return IntrinsicHeight(
      child: Container(
        margin: EdgeInsets.only(bottom: 15, top: 15),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: IntrinsicHeight(
                child: Container(
                  margin: EdgeInsets.only(right: 4),
                  width: double.infinity,
                  child: Text(
                    leftText,
                    style: TextStyle(
                      color: AppColor.BLACK,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            IntrinsicHeight(
              child: Text(
                rightText,
                style: TextStyle(
                  color: AppColor.BLACK,
                  fontSize: 15,
                  fontWeight:
                      rightTextFontWeight, // Sử dụng biến fontWeight mới
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bottom(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, top: 20, right: 40, bottom: 30),
      child: InkWell(
        onTap: _onQrCreate,
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColor.BLUE_TEXT,
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code,
                color: AppColor.WHITE,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "QR thanh toán",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
