import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/features/trans_history/blocs/trans_history_bloc.dart';
import 'package:vierqr/features/trans_history/events/trans_history_event.dart';
import 'package:vierqr/models/related_transaction_receive_dto.dart';

import 'states/trans_history_state.dart';

class TransHistoryScreen extends StatelessWidget {
  final String bankId;

  const TransHistoryScreen({super.key, required this.bankId});

  @override
  Widget build(BuildContext context) {
    // final arg = ModalRoute.of(context)!.settings.arguments as Map;
    // String bankId = arg['bankId'] ?? '';

    return BlocProvider(
      create: (context) => TransHistoryBloc(context, bankId),
      child: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatefulWidget {
  const _BodyWidget();

  @override
  State<_BodyWidget> createState() => _TransHistoryScreenState();
}

class _TransHistoryScreenState extends State<_BodyWidget> {
  late TransHistoryBloc _bloc;

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(context);
    });
  }

  _loadMore() async {
    final maxScroll = scrollController.position.maxScrollExtent;
    if (scrollController.offset >= maxScroll &&
        !scrollController.position.outOfRange) {
      _bloc.add(TransactionEventFetch());
    }
  }

  void initData(BuildContext context) {
    scrollController.addListener(_loadMore);
    _bloc.add(TransactionEventGetList());
  }

  Future<void> onRefresh() async {
    _bloc.add(TransactionEventGetList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MAppBar(title: 'Lịch sử giao dịch'),
      body: BlocConsumer<TransHistoryBloc, TransHistoryState>(
        listener: (context, state) {
          if (state.status == BlocStatus.LOADING) {
            // DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            // Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state.status == BlocStatus.LOADING) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.BLUE_TEXT,
              ),
            );
          }

          if ((state.list.isEmpty)) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: const Center(
                child: Text('Không có giao dịch nào'),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Column(
                      children: List.generate(
                        state.list.length,
                        (index) {
                          return _buildElement(
                            context: context,
                            dto: state.list[index],
                          );
                        },
                      ).toList(),
                    ),
                    if (!state.isLoadMore)
                      const UnconstrainedBox(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            color: AppColor.BLUE_TEXT,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          }
        },
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
            // 'bankId': bankId,
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
