import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

import '../../commons/constants/configurations/app_images.dart';
import '../../commons/utils/currency_utils.dart';
import '../../services/providers/invoice_provider.dart';
import 'blocs/invoice_bloc.dart';
import 'events/invoice_events.dart';
import 'package:shimmer/shimmer.dart';

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

  initData({bool isRefresh = false}) {
    if (isRefresh) {}
    _bloc.add(GetInvoiceList(
        status: _provider.invoiceStatus.id,
        bankId: selectBankId ?? '',
        filterBy: _provider.invoiceTime.id,
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
  }

  void onFilter() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => PopupFilterWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvoiceBloc, InvoiceStates>(
      listener: (context, state) {},
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
                      _buildListInvoice(state),
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
                provider.invoiceStatus.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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

  Widget _buildListInvoice(InvoiceStates state) {
    if (state.status == BlocStatus.LOADING) {
      return _buildLoading();
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: MediaQuery.of(context).size.height,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
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
                            Text(
                              'Hoá đơn phí giao dịch tháng \n04/2024',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'MBBank - 1123355589',
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
                            '${CurrencyUtils.instance.getCurrencyFormatted('7200000')} VND',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColor.ORANGE_DARK),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            decoration: BoxDecoration(
                              color: AppColor.BLUE_TEXT.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                      fontSize: 12, color: AppColor.BLUE_TEXT),
                                ),
                              ],
                            ),
                          ),
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

  Widget _buildLoading() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: MediaQuery.of(context).size.height,
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColor.GREY_DADADA.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColor.GREY_DADADA, width: 0.5)),
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
