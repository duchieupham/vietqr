import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/features/transaction/blocs/transaction_bloc.dart';
import 'package:vierqr/features/transaction/events/transaction_event.dart';
import 'package:vierqr/features/transaction/states/transaction_state.dart';
import 'package:vierqr/models/related_transaction_receive_dto.dart';
import 'package:vierqr/models/transaction_input_dto.dart';

class TransactionHistoryView extends StatelessWidget {
  static late TransactionBloc transactionBloc;
  static ScrollController scrollController = ScrollController();
  static final List<RelatedTransactionReceiveDTO> transactions = [];
  static String bankId = '';
  static int offset = 0;
  static bool isEnded = false;

  const TransactionHistoryView({
    super.key,
  });

  void initialServices(BuildContext context, String bankId) {
    isEnded = false;
    offset = 0;
    transactions.clear();
    transactionBloc = BlocProvider.of(context);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // ListView đã cuộn đến cuối
        // Xử lý tại đây
        offset += 1;
        TransactionInputDTO transactionInputDTO = TransactionInputDTO(
          bankId: bankId,
          offset: offset * 20,
        );
        transactionBloc.add(TransactionEventFetch(dto: transactionInputDTO));
      }
    });
    TransactionInputDTO transactionInputDTO = TransactionInputDTO(
      bankId: bankId,
      offset: 0,
    );
    transactionBloc.add(TransactionEventGetList(dto: transactionInputDTO));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    bankId = arg['bankId'] ?? '';
    initialServices(context, bankId);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          SubHeader(
            title: 'Lịch sử giao dịch',
            callBackHome: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          Expanded(
            child: BlocConsumer<TransactionBloc, TransactionState>(
              listener: (context, state) {
                if (state is TransactionGetListSuccessState) {
                  transactions.clear();
                  if (state.list.isEmpty || state.list.length < 20) {
                    isEnded = true;
                  }
                  if (transactions.isEmpty) {
                    transactions.addAll(state.list);
                  }
                }
                if (state is TransactionFetchSuccessState) {
                  if (state.list.isEmpty || state.list.length < 20) {
                    isEnded = true;
                  }
                  transactions.addAll(state.list);
                }
              },
              builder: (context, state) {
                return (transactions.isEmpty)
                    ? const SizedBox()
                    : ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: transactions.length + 1,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (context, index) {
                          return (index == transactions.length && !isEnded)
                              ? const UnconstrainedBox(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      color: AppColor.GREEN,
                                    ),
                                  ),
                                )
                              : (index == transactions.length && isEnded)
                                  ? const SizedBox()
                                  : _buildElement(
                                      context: context,
                                      dto: transactions[index],
                                    );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElement({
    required BuildContext context,
    required RelatedTransactionReceiveDTO dto,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.TRANSACTION_DETAIL,
          arguments: {
            'transactionId': dto.transactionId,
            'transactionBloc': transactionBloc,
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
                  dto.status,
                  dto.transType,
                ),
                color: TransactionUtils.instance.getColorStatus(
                  dto.status,
                  dto.type,
                  dto.transType,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${TransactionUtils.instance.getTransType(dto.transType)} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: TransactionUtils.instance.getColorStatus(
                        dto.status,
                        dto.type,
                        dto.transType,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    dto.content,
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
              TimeUtils.instance.formatDateFromInt(dto.time, true),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
