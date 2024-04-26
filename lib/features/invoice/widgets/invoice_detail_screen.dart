import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/features/invoice/blocs/invoice_bloc.dart';
import 'package:vierqr/features/invoice/events/invoice_events.dart';
import 'package:vierqr/models/invoice_detail_dto.dart';

import '../../../commons/constants/configurations/app_images.dart';
import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/widgets/separator_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<InvoiceBloc, InvoiceStates>(
      listener: (context, state) {
        if (state is GetInvoiceDetailSuccess) {
          setState(() {
            _data = state.data;
            debugPrint('state ==> ${state.data}');
          });
        }
   
      },
      listenWhen: (context, state) {
        return state is GetInvoiceDetailLoading || state is GetInvoiceDetailSuccess;
      },
      child: _buildBody(),
    );
  }

  Widget _buildBody(){
    return Scaffold(
          backgroundColor: AppColor.WHITE,
          bottomNavigationBar: _bottom(context),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
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
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 26, left: 0),
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
                          Container(
                            margin: EdgeInsets.only(bottom: 48),
                            child: Text(
                              _data?.totalAmount.toString() ?? '',
                              style: TextStyle(
                                color: AppColor.GREEN,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                                      'Đã thanh toán',
                                      style: TextStyle(
                                        color: AppColor.GREEN,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          MySeparator(),
                          _buildItem(
                              'Mã hoá đơn', 'VAFXXXXXXXX', FontWeight.normal),
                          MySeparator(),
                          _buildItem('Tài khoản', 'MBBank - 111111111111',
                              FontWeight.normal),
                          MySeparator(),
                          _buildItem('Tổng tiền hàng', '6,500,000 VND',
                              FontWeight.bold),
                          MySeparator(),
                          _buildItem('Tiền thuế GTGT (VAT)', '8% - 520,000 VND',
                              FontWeight.bold),
                          MySeparator(),
                          _buildItem('Tổng tiền thanh toán', '7,020,000 VND',
                              FontWeight.bold),
                          MySeparator(),
                          _buildItem('Thời gian TT', '25/04/2024 12:23',
                              FontWeight.normal),
                          MySeparator(),
                          Container(
                            margin: EdgeInsets.only(bottom: 50, top: 30),
                            child: Text(
                              'Danh mục hàng hoá, dịch vụ',
                              style: TextStyle(
                                color: AppColor.BLACK,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildItemBottom('Phí tích hợp dịch vụ', '1',
                              '6,350,000', '6,350,000')
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
  }

  Widget _buildItemBottom(String invoiceItemName, String quantity,
      String itemAmount, String totalItemAmount) {
    return Column(
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
                    '$itemAmount VND',
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
                    '$totalItemAmount VND',
                    style: TextStyle(color: AppColor.BLACK, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
        MySeparator(),
      ],
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
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
      child: InkWell(
        onTap: () {},
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
