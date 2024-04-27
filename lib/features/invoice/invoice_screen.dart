import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/format_price.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/invoice/states/invoice_states.dart';
import 'package:vierqr/features/invoice/widgets/popup_filter_widget.dart';
import 'package:vierqr/features/invoice/widgets/popup_invoice_widget.dart';
import 'package:vierqr/models/metadata_dto.dart';

import '../../commons/constants/configurations/app_images.dart';
import '../../commons/constants/configurations/route.dart';
import '../../commons/utils/currency_utils.dart';
import '../../commons/utils/navigator_utils.dart';
import '../../models/invoice_detail_dto.dart';
import '../../models/qr_generated_dto.dart';
import '../../services/providers/invoice_provider.dart';
import '../popup_bank/popup_bank_share.dart';
import 'blocs/invoice_bloc.dart';
import 'events/invoice_events.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceBloc>(
      create: (BuildContext context) => InvoiceBloc(context),
      child: const _Invoice(),
    );
  }
}

class _Invoice extends StatefulWidget {
  const _Invoice({super.key});

  @override
  State<_Invoice> createState() => __InvoiceState();
}

class __InvoiceState extends State<_Invoice> {
  late InvoiceBloc _bloc;
  late InvoiceProvider _provider;
  String? selectBankId;
  MetaDataDTO? metadata;
  ScrollController? scrollController;

  initData({bool isRefresh = false}) {
    if (isRefresh) {}

    _bloc.add(GetInvoiceList(
        status: _provider.invoiceStatus?.id,
        bankId: selectBankId ?? '',
        // time: _provider.invoiceTime,
        filterBy: 1,
        page: 1));
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _provider = Provider.of<InvoiceProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
    scrollController = ScrollController();
    scrollController!.addListener(() async {
      if (scrollController!.position.pixels ==
          scrollController!.position.maxScrollExtent) {
        int total_page = (metadata!.total! / 20).ceil();
        if (total_page > metadata!.page!) {
          _bloc.add(LoadMoreInvoice(
              status: _provider.invoiceStatus?.id,
              bankId: _provider.selectBank?.id ?? '',
              time: _provider.invoiceMonth != null
                  ? DateFormat('yyyy-MM').format(_provider.invoiceMonth!)
                  : '',
              filterBy: 1,
              page: 1));
        }
      }
    });
  }

  void _onQrCreate(InvoiceStates state, int index) async {
    InvoiceDetailDTO? _data =
        await _bloc.getDetail(state.listInvoice![index].invoiceId!);

    if (_data != null) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) => PopupQrCreate(
          onSave: () {
            onSaveImage(context, _data);
          },
          onShare: () {
            onShare(context, _data);
          },
          invoiceName: _data.invoiceName!,
          totalAmount: _data.totalAmount.toString(),
          billNumber: _data.billNumber!,
          qr: _data.qrCode!,
        ),
      );
    }
  }

  void onShare(BuildContext context, InvoiceDetailDTO _data) {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: _data.bankCode!,
      bankName: _data.bankName!,
      bankAccount: _data.bankAccount!,
      userBankName: _data.userBankName!,
      qrCode: _data.qrCode!,
      imgId: '',
      amount: _data.totalAmount.toString(),
    );
    NavigatorUtils.navigatePage(
        context, PopupBankShare(dto: dto, type: TypeImage.SHARE),
        routeName: PopupBankShare.routeName);
  }

  void onSaveImage(BuildContext context, InvoiceDetailDTO _data) {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: _data.bankCode!,
      bankName: _data.bankName!,
      bankAccount: _data.bankAccount!,
      userBankName: _data.userBankName!,
      qrCode: _data.qrCode!,
      imgId: '',
      amount: _data.totalAmount.toString(),
    );
    NavigatorUtils.navigatePage(
        context, PopupBankShare(dto: dto, type: TypeImage.SAVE),
        routeName: PopupBankShare.routeName);
  }

  void onFilter() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => PopupFilterWidget(
          bloc: _bloc,
          bank: _provider.selectBank ?? null,
          status: _provider.selectedStatus!,
          bankType: _provider.selectBankType!,
          isMonthSelect: _provider.isMonthSelect!,
          invoiceMonth: _provider.invoiceMonth ?? DateTime.now()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvoiceBloc, InvoiceStates>(
      listener: (context, state) {
        if (state.status == BlocStatus.SUCCESS) {
          metadata = state.metaDataDTO;
        }
      },
      builder: (context, state) {
        return Consumer<InvoiceProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: true,
              body: CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: false,
                    leadingWidth: 100,
                    leading: InkWell(
                      onTap: () {
                        provider.reset();
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
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
                    delegate: SliverChildListDelegate(<Widget>[
                      const SizedBox(height: 30),
                      _invoiceSection(provider, state),
                      // const SizedBox(height: 15),
                      _buildListInvoice(state, provider),
                      loadMoreIcon(state)
                    ]),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _invoiceSection(InvoiceProvider provider, InvoiceStates state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Danh sách hoá đơn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                provider.selectedStatus == 0
                    ? 'chưa thanh toán'
                    : 'đã thanh toán',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              provider.invoiceMonth != null
                  ? Text(
                      'Tháng ${provider.invoiceMonth?.month}/${provider.invoiceMonth?.year}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  : const SizedBox.shrink(),
              provider.selectBank != null
                  ? Text(
                      'TK ${provider.selectBank?.bankShortName} - ${provider.selectBank?.bankAccount}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          GestureDetector(
            onTap: onFilter,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColor.BLACK, width: 1.2),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/ic-filter-black.png',
                  width: 15,
                  height: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListInvoice(InvoiceStates state, InvoiceProvider provider) {
    switch (state.status) {
      case BlocStatus.LOADING:
        return _buildLoading();
      case BlocStatus.ERROR:
        return const SizedBox.shrink();
      case BlocStatus.NONE:
        return Container(
          padding: const EdgeInsets.only(top: 250),
          // height: MediaQuery.of(context).size.height,
          child: Center(
            child: Text('Trống'),
          ),
        );
      default:
        break;
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      height: MediaQuery.of(context).size.height * 0.78,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: state.listInvoice!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(Routes.INVOICE_DETAIL,
                  arguments: {'id': state.listInvoice?[index].invoiceId});
            },
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColor.GREY_DADADA, width: 0.5)),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 260,
                              child: Text(
                                '${state.listInvoice?[index].invoiceName}',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${state.listInvoice?[index].bankShortName} - ${state.listInvoice?[index].bankAccount}',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/images/ic-arrow-right-blue.png',
                          width: 15,
                        )
                      ],
                    ),
                  ),
                  MySeparator(color: AppColor.GREY_DADADA),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${CurrencyUtils.instance.getCurrencyFormatted(state.listInvoice![index].totalAmount.toString())} VND',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: provider.selectedStatus == 0
                                    ? AppColor.ORANGE_DARK
                                    : AppColor.GREEN),
                          ),
                          provider.selectedStatus == 0
                              ? GestureDetector(
                                  onTap: () {
                                    _onQrCreate(state, index);
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColor.BLUE_TEXT.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/ic-tb-qr-blue.png',
                                          width: 15,
                                          height: 15,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'QR thanh toán',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.BLUE_TEXT),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget loadMoreIcon(InvoiceStates state) {
    if (state.status == BlocStatus.LOAD_MORE) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLoading() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: MediaQuery.of(context).size.height,
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColor.GREY_DADADA.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: AppColor.GREY_DADADA.withOpacity(0.2), width: 0.5)),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBlock(
                        width: 200,
                        height: 35,
                      ),
                      const SizedBox(height: 10),
                      ShimmerBlock(
                        width: 160,
                        height: 20,
                      ),
                    ],
                  ),
                ),
                MySeparator(color: AppColor.GREY_DADADA),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBlock(
                          width: 90,
                          height: 30,
                        ),
                        ShimmerBlock(
                          width: 120,
                          height: 30,
                          borderRadius: 15,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
