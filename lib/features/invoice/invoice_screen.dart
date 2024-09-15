import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/invoice/states/invoice_states.dart';
import 'package:vierqr/features/invoice/widgets/bottom_payment.dart';
import 'package:vierqr/features/invoice/widgets/popup_filter_widget.dart';
import 'package:vierqr/features/invoice/widgets/popup_invoice_widget.dart';
import 'package:vierqr/models/invoice_fee_dto.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/unpaid_invoice_detail_qr_dto.dart';

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
  const _Invoice();

  @override
  State<_Invoice> createState() => __InvoiceState();
}

class __InvoiceState extends State<_Invoice> {
  late InvoiceBloc _bloc;
  late InvoiceProvider _provider;
  String? selectBankId;
  MetaDataDTO? metadata;
  late ScrollController scrollController;
  ValueNotifier<bool> paymentNotifier = ValueNotifier<bool>(false);
  // bool _isPay = false;

  initData({bool isRefresh = false}) {
    if (isRefresh) {}

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        int totalPage = (metadata!.total! / 20).ceil();
        if (totalPage > metadata!.page!) {
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
    _bloc.add(GetInvoiceList(
        status: _provider.invoiceStatus?.id,
        bankId: selectBankId ?? '',
        // time: _provider.invoiceTime,
        filterBy: 1,
        page: 1));
  }

  List<InvoiceFeeDTO> listInvoice = [];
  List<InvoiceGroup> invoiceGroups = [];

  List<String> getListId() {
    Set<String> setId = <String>{};
    if (listInvoice.isEmpty) {
      return setId.toList();
    }
    final list =
        listInvoice.where((element) => element.isSelect == true).toList();
    for (InvoiceFeeDTO selection in list) {
      setId.add(selection.invoiceId);
    }

    return setId.toList();
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    scrollController = ScrollController();
    _provider = Provider.of<InvoiceProvider>(context, listen: false);
    _provider.selectedStatus = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void _openUrl(String invoiceId) async {
    final url =
        '${EnvConfig.getBaseUrl()}images-invoice/download-files?invoiceId=$invoiceId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onQrCreate(InvoiceFeeDTO dto) async {
    InvoiceDetailDTO? data = await _bloc.getDetail(dto.invoiceId);

    if (data != null) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) => PopupQrCreate(
          onSave: () {
            onSaveImage(context, data);
          },
          onShare: () {
            onShare(context, data);
          },
          invoiceName: data.invoiceName!,
          totalAmount: data.totalAmount.toString(),
          billNumber: data.billNumber!,
          qr: data.qrCode!,
        ),
      );
    }
  }

  void onShare(BuildContext context, InvoiceDetailDTO data) {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: data.bankCode!,
      bankName: data.bankName!,
      bankAccount: data.bankAccount!,
      userBankName: data.userBankName!,
      qrCode: data.qrCode!,
      imgId: '',
      amount: data.totalAmount.toString(),
    );
    NavigatorUtils.navigatePage(
        context, PopupBankShare(dto: dto, type: TypeImage.SHARE),
        routeName: PopupBankShare.routeName);
  }

  void onSaveImage(BuildContext context, InvoiceDetailDTO data) {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: data.bankCode!,
      bankName: data.bankName!,
      bankAccount: data.bankAccount!,
      userBankName: data.userBankName!,
      qrCode: data.qrCode!,
      imgId: '',
      amount: data.totalAmount.toString(),
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
          bank: _provider.selectBank,
          status: _provider.selectedStatus,
          bankType: _provider.selectBankType!,
          isMonthSelect: _provider.isMonthSelect!,
          invoiceMonth: _provider.invoiceMonth ?? DateTime.now()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvoiceBloc, InvoiceStates>(
      listener: (context, state) async {
        if (state.status == BlocStatus.SUCCESS) {
          metadata = state.metaDataDTO;
          listInvoice = state.listInvoice ?? [];
          Map<String, List<InvoiceFeeDTO>> groupedInvoices = {};

          for (var invoice in listInvoice) {
            // Convert timeCreated to DateTime
            DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(invoice.timeCreated * 1000);

            String yearMonthKey =
                "${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";

            // Add invoice to the corresponding group
            if (!groupedInvoices.containsKey(yearMonthKey)) {
              groupedInvoices[yearMonthKey] = [];
            }
            groupedInvoices[yearMonthKey]?.add(invoice);
          }

          invoiceGroups = groupedInvoices.entries
              .map((entry) =>
                  InvoiceGroup(monthYear: entry.key, invoices: entry.value))
              .toList();
        }

        if (state.status == BlocStatus.NONE) {
          listInvoice = [];
          invoiceGroups = [];
        }

        if (state.status == BlocStatus.REQUEST &&
            state.request == InvoiceType.PAYMENT) {
          paymentNotifier.value = false;
          final requestPayment = state.unpaidInvoiceDetailQrDTO;
          if (requestPayment != null) {
            QRGeneratedDTO dto = QRGeneratedDTO(
              bankCode: requestPayment.bankCode,
              bankName: requestPayment.bankName,
              bankAccount: requestPayment.bankAccount,
              userBankName: requestPayment.userBankName,
              qrCode: requestPayment.qrCode,
              imgId: '',
              amount: requestPayment.totalAmount.toString(),
            );
            await showCupertinoModalPopup(
              context: context,
              builder: (context) => PopupQrCreate(
                urlLink: requestPayment.urlLink,
                onSave: () {
                  NavigatorUtils.navigatePage(
                      context, PopupBankShare(dto: dto, type: TypeImage.SAVE),
                      routeName: PopupBankShare.routeName);
                },
                onShare: () {
                  NavigatorUtils.navigatePage(
                      context, PopupBankShare(dto: dto, type: TypeImage.SAVE),
                      routeName: PopupBankShare.routeName);
                },
                invoiceName: requestPayment.invoiceName,
                totalAmount: requestPayment.totalAmountAfterVat.toString(),
                billNumber: requestPayment.invoiceNumber,
                qr: requestPayment.qrCode,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        return Consumer<InvoiceProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                forceMaterialTransparency: true,
                backgroundColor: AppColor.WHITE,
                leadingWidth: 100,
                leading: InkWell(
                  onTap: () {
                    provider.reset();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.black,
                          size: 25,
                        ),
                        SizedBox(width: 2),
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
              body: Column(
                children: [
                  const SizedBox(height: 30),
                  _invoiceSection(provider, state),
                  const SizedBox(height: 15),
                  _buildListInvoice(state, provider),
                  ValueListenableBuilder<bool>(
                    valueListenable: paymentNotifier,
                    builder: (context, isPayment, child) {
                      return BottomPayment(
                        onPayment: () {
                          if (!isPayment) {
                            paymentNotifier.value = true;
                            _bloc.add(RequestMultiInvoicePaymentEvent(
                                invoiceIds: getListId()));
                          }
                        },
                        provider: provider,
                        selectd: getListId().length,
                        amount: getListId().isNotEmpty
                            ? listInvoice
                                .where((element) => element.isSelect)
                                .map((e) => e.totalAmount)
                                .reduce((a, b) => a + b)
                            : 0,
                      );
                    },
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
              const Text(
                'Danh sách hoá đơn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // const SizedBox(height: 20),
              // Text(
              //   provider.selectedStatus == 0
              //       ? 'chưa thanh toán'
              //       : 'đã thanh toán',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      if (scrollController.hasClients) {
                        scrollController.jumpTo(0.0);
                      }
                      provider.changeStatus(0);

                      _bloc.add(GetInvoiceList(
                          status: 0,
                          bankId: selectBankId ?? '',
                          // time: _provider.invoiceTime,
                          filterBy: 1,
                          page: 1));
                    },
                    child: Container(
                      width: 120,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: provider.selectedStatus == 0
                                ? AppColor.TRANSPARENT
                                : AppColor.GREY_DADADA),
                        color: provider.selectedStatus == 0
                            ? AppColor.BLUE_TEXT.withOpacity(0.2)
                            : AppColor.WHITE,
                        // border: Border.all(color: AppColor.BLUE_TEXT),
                      ),
                      child: Center(
                        child: Text(
                          'Chưa thanh toán',
                          style: TextStyle(
                              fontSize: 12,
                              color: provider.selectedStatus == 0
                                  ? AppColor.BLUE_TEXT
                                  : AppColor.BLACK_TEXT),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      if (scrollController.hasClients) {
                        scrollController.jumpTo(0.0);
                      }
                      provider.changeStatus(1);
                      _bloc.add(GetInvoiceList(
                          status: 1,
                          bankId: selectBankId ?? '',
                          // time: _provider.invoiceTime,
                          filterBy: 1,
                          page: 1));
                    },
                    child: Container(
                      width: 120,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: provider.selectedStatus == 1
                                ? AppColor.TRANSPARENT
                                : AppColor.GREY_DADADA),
                        color: provider.selectedStatus == 1
                            ? AppColor.BLUE_TEXT.withOpacity(0.2)
                            : AppColor.WHITE,
                      ),
                      child: Center(
                        child: Text(
                          'Đã thanh toán',
                          style: TextStyle(
                              fontSize: 12,
                              color: provider.selectedStatus == 1
                                  ? AppColor.BLUE_TEXT
                                  : AppColor.BLACK_TEXT),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              provider.invoiceMonth != null
                  ? Text(
                      'Tháng ${provider.invoiceMonth?.month}/${provider.invoiceMonth?.year}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  : const SizedBox.shrink(),
              provider.selectBank != null
                  ? Text(
                      'TK ${provider.selectBank?.bankShortName} - ${provider.selectBank?.bankAccount}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
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
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (state.status == BlocStatus.ERROR)
            const SizedBox.shrink()
          else if (state.status == BlocStatus.LOADING)
            ...List.generate(4, (index) => _buildLoading())
          else if (listInvoice.isEmpty)
            Container(
              padding: const EdgeInsets.only(top: 250),
              // height: MediaQuery.of(context).size.height,
              child: const Center(
                child: Text('Chưa có hóa đơn nào'),
              ),
            )
          else
            ...invoiceGroups
                .asMap()
                .map(
                  (index, i) => MapEntry(
                      i,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Hóa đơn tháng ${i.monthYear}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              if (provider.selectedStatus == 0)
                                Row(
                                  children: [
                                    const Text(
                                      'Tất cả',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Checkbox(
                                      value: i.invoices
                                          .every((element) => element.isSelect),
                                      onChanged: (value) {
                                        if (value != null) {
                                          List<InvoiceFeeDTO> list = [];
                                          for (var item in i.invoices) {
                                            InvoiceFeeDTO dto = item;
                                            dto.selected(value);
                                            list.add(dto);
                                          }
                                          setState(() {
                                            invoiceGroups[index] = InvoiceGroup(
                                                monthYear: i.monthYear,
                                                invoices: list);
                                          });
                                        }
                                      },
                                    )
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...i.invoices.map(
                            (e) => InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    Routes.INVOICE_DETAIL,
                                    arguments: {'id': e.invoiceId});
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: AppColor.GREY_DADADA,
                                        width: 0.5)),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 15, 0, 15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 260,
                                                  child: Text(
                                                    e.invoiceName,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  '${e.bankShortName} - ${e.bankAccount}',
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                if (e.fileAttachmentId != '')
                                                  GestureDetector(
                                                    onTap: () =>
                                                        _openUrl(e.invoiceId),
                                                    child: const Text(
                                                      'Xem tệp',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            AppColor.BLUE_TEXT,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            AppColor.BLUE_TEXT,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          if (provider.selectedStatus == 0)
                                            Checkbox(
                                              value: e.isSelect,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  int index = listInvoice
                                                      .indexWhere((element) =>
                                                          element.invoiceId ==
                                                          e.invoiceId);
                                                  InvoiceFeeDTO invoice = e;
                                                  invoice.selected(value);

                                                  setState(() {
                                                    listInvoice[index] =
                                                        invoice;
                                                  });
                                                }
                                              },
                                            )
                                          else
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15, top: 20),
                                              child: Image.asset(
                                                'assets/images/ic-arrow-right-blue.png',
                                                width: 15,
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                    const MySeparator(
                                        color: AppColor.GREY_DADADA),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${CurrencyUtils.instance.getCurrencyFormatted(e.totalAmount.toString())} VND',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      provider.selectedStatus ==
                                                              0
                                                          ? AppColor.ORANGE_DARK
                                                          : AppColor.GREEN),
                                            ),
                                            provider.selectedStatus == 0
                                                ? GestureDetector(
                                                    onTap: () {
                                                      _onQrCreate(e);
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10, 4, 10, 4),
                                                      decoration: BoxDecoration(
                                                        color: AppColor
                                                            .BLUE_TEXT
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/ic-tb-qr-blue.png',
                                                            width: 15,
                                                            height: 15,
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          const Text(
                                                            'QR thanh toán',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: AppColor
                                                                    .BLUE_TEXT),
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
                            ),
                          ),
                        ],
                      )),
                )
                .values,
          loadMoreIcon(state)
        ],
      ),
    );
  }

  Widget loadMoreIcon(InvoiceStates state) {
    if (state.status == BlocStatus.LOAD_MORE) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLoading() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBlock(
                  width: 200,
                  height: 35,
                ),
                SizedBox(height: 10),
                ShimmerBlock(
                  width: 160,
                  height: 20,
                ),
              ],
            ),
          ),
          const MySeparator(color: AppColor.GREY_DADADA),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: const Row(
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
  }
}

class InvoiceGroup {
  String monthYear;
  List<InvoiceFeeDTO> invoices;
  // bool i

  InvoiceGroup({required this.monthYear, required this.invoices});
}
