import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/invoice_overview_dto.dart';

class InvoiceOverviewWidget extends StatefulWidget {
  const InvoiceOverviewWidget({super.key});

  @override
  State<InvoiceOverviewWidget> createState() => _InvoiceOverviewWidgetState();
}

class _InvoiceOverviewWidgetState extends State<InvoiceOverviewWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    // isShow = SharePrefUtils.getInvoice();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<BankBloc, BankState>(
      bloc: getIt.get<BankBloc>(),
      builder: (context, state) {
        if (state.isClose) {
          return const SizedBox.shrink();
        }
        if (state.invoiceOverviewDTO == null ||
            state.invoiceOverviewDTO!.countInvoice == 0) {
          return const SizedBox.shrink();
        }
        return Container(
          margin: const EdgeInsets.only(top: 10),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xFFD8ECF8),
            Color(0xFFFFEAD9),
            Color(0xFFF5C9D1),
          ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const XImage(
                    imagePath: 'assets/images/ic-suggest.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text:
                                '${state.invoiceOverviewDTO!.countInvoice} hóa đơn',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColor.BLACK),
                            children: const [
                              TextSpan(
                                text: ' chưa thanh toán',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: AppColor.BLACK),
                              )
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: CurrencyUtils.instance.getCurrencyFormatted(
                                state.invoiceOverviewDTO!.amountUnpaid
                                    .toString()),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFFFF5C02)),
                            children: const [
                              TextSpan(
                                text: ' VND',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: AppColor.GREY_TEXT),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getIt
                          .get<BankBloc>()
                          .add(const CloseInvoiceOverviewEvent(isClose: true));
                    },
                    child: const XImage(
                      imagePath: 'assets/images/ic-close-black.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ...state.invoiceOverviewDTO!.invoices.map(
                (e) => _item(e),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _item(Invoice item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: VietQRTheme.gradientColor.lilyLinear,
            ),
            child: const Center(
              child: XImage(
                imagePath: 'assets/images/ic-invoice-overview.png',
                width: 30,
                height: 30,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 170,
            child: Text(
              item.invoiceName,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              text: CurrencyUtils.instance
                  .getCurrencyFormatted(item.totalAmount.toString()),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFFFF5C02)),
              children: const [
                TextSpan(
                  text: ' VND',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: AppColor.GREY_TEXT),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
