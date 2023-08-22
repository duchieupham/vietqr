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
      _bloc.add(TransactionEventFetch(model.type));
    }
  }

  void initData(BuildContext context) {
    scrollController.addListener(_loadMore);
    _bloc.add(TransactionEventGetList(model.type));
  }

  Future<void> onRefresh() async {
    _bloc.add(TransactionEventGetList(model.type));
  }

  bool isEnableBT = false;
  DataModel model = DataModel(title: 'Tất cả', type: 9);

  final List<DataModel> list = [
    DataModel(title: 'Tất cả', type: 9),
    DataModel(title: 'Chờ thanh toán', type: 0),
    DataModel(title: 'Thành công', type: 1),
    DataModel(title: 'Đã huỷ', type: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.WHITE,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Trạng thái giao dịch',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: _onHandleTap,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${model.title}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.expand_more,
                                    color: AppColor.BLACK,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Danh sách giao dịch',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (state.status == BlocStatus.LOADING)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.BLUE_TEXT,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    if (state.list.isEmpty)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: const Center(
                            child: Text('Không có giao dịch nào'),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: RefreshIndicator(
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
                        ),
                      ),
                  ],
                ],
              ),
              enableList
                  ? Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'Trạng thái giao dịch',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColor.TRANSPARENT),
                          ),
                          const SizedBox(width: 30),
                          Expanded(child: _buildSearchList()),
                        ],
                      ),
                    )
                  : Container(),
            ],
          );
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

  bool enableList = false;

  _onChanged(int index) {
    setState(() {
      enableList = !enableList;
      if (model != list[index]) {
        model = list[index];
        _bloc.add(TransactionEventGetList(model.type));
      }
    });
  }

  _onHandleTap() {
    setState(() {
      enableList = !enableList;
    });
  }

  Widget _buildSearchList() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(
                  parent: NeverScrollableScrollPhysics()),
              itemCount: list.length,
              itemBuilder: (context, position) {
                return InkWell(
                  onTap: () {
                    _onChanged(position);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      border: position != (list.length - 1)
                          ? const Border(
                              bottom: BorderSide(
                                  color: AppColor.GREY_TEXT, width: 0.5))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(
                          list[position].title,
                          style: const TextStyle(color: Colors.black),
                        ),
                        if (position == 0)
                          const Icon(
                            Icons.expand_less,
                            color: AppColor.BLACK,
                            size: 16,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
}

class DataModel {
  final String title;
  final int type;

  DataModel({required this.title, required this.type});
}
