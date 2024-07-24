import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/custom_date_range_picker.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/bank_detail_new/blocs/transaction_bloc.dart';
import 'package:vierqr/features/bank_detail_new/views/transaction_detail_screen.dart';
import 'package:vierqr/features/bank_detail_new/widgets/filter_time_widget.dart';
import 'package:vierqr/features/bank_detail_new/widgets/loading_item.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/trans_list_dto.dart';

import '../events/transaction_event.dart';
import '../states/transaction_state.dart';
import '../widgets/index.dart';
import '../widgets/trans_info_widget.dart';

class BankTransactionsScreen extends StatefulWidget {
  final ValueNotifier<bool> isScrollNotifier;
  final ScrollController scrollController;
  final String bankId;

  const BankTransactionsScreen({
    super.key,
    required this.isScrollNotifier,
    required this.scrollController,
    required this.bankId,
  });

  @override
  State<BankTransactionsScreen> createState() => _BankTransactionsScreenState();
}

class _BankTransactionsScreenState extends State<BankTransactionsScreen> {
  final TextEditingController _textController = TextEditingController();
  final NewTransactionBloc _bloc = getIt.get<NewTransactionBloc>();

  void initData() async {
    _bloc.add(SetTransType(type: selectFilterTransType.type));
    _bloc.add(SetTransTimeType(filter: selectFilterTime));
    _bloc.add(SetTransValue(value: ''));
    _bloc.add(GetTransListEvent(bankId: widget.bankId, offset: 0, type: 9));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        initData();
      },
    );
  }

  Future<void> onRefresh() async {
    _bloc.add(GetTransListEvent(bankId: widget.bankId, offset: 0, type: 9));
  }

  DateTime? _startDate;
  DateTime? _endDate;

  FilterTrans selectFilterTime = FilterTrans(
      title: '7 ngày gần đây',
      type: 0,
      fromDate:
          '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 7)))} 00:00:00',
      toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59');

  FilterTrans selectFilterTransType =
      FilterTrans(title: 'Tất cả giao dịch', type: 9);

  List<TransactionItemDTO> listTrans = [];
  Map<String, List<TransactionItemDTO>> groupsAlphabet = {};

  @override
  void dispose() {
    super.dispose();
    // widget.scrollController.dispose();
  }

  Future<FilterTrans> getFilterTransType() async {
    FilterTrans filterType = await DialogWidget.instance.showModelBottomSheet(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        bgrColor: AppColor.TRANSPARENT,
        padding: EdgeInsets.zero,
        widget: FilterTransWidget(
          isFilerTime: false,
          filter: selectFilterTransType,
        ));

    setState(() {
      selectFilterTransType = filterType;
    });
    _bloc.add(SetTransType(type: filterType.type));

    return filterType;
  }

  Future<void> getFilterTime() async {
    final filterType = await DialogWidget.instance.showModelBottomSheet(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        bgrColor: AppColor.TRANSPARENT,
        padding: EdgeInsets.zero,
        widget: FilterTransWidget(
          onDateRangeSelect: _showCustomDateRangePicker,
          isFilerTime: true,
          filter: selectFilterTime,
        ));
    if (filterType != null) {
      setState(() {
        selectFilterTime = filterType;
      });
      if (selectFilterTime.type != 3) {
        _startDate = null;
        _endDate = null;
        _bloc.add(SetTransTimeType(filter: filterType));
      } else {
        _showCustomDateRangePicker();
      }
    }
    // return selectFilterTime;
  }

  Future<void> _showCustomDateRangePicker() async {
    final selectedRange = await DialogWidget.instance.showModelBottomSheet(
        borderRadius: BorderRadius.circular(0),
        width: MediaQuery.of(context).size.width,
        height: 680,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        widget: CustomDateRangePicker(
          initialStartDate: _startDate,
          initialEndDate: _endDate,
        ));

    if (selectedRange != null) {
      setState(() {
        _startDate = selectedRange.start;
        _endDate = selectedRange.end;
      });
      String title =
          '${DateFormat('dd/MM/yyyy').format(selectedRange.start).toString()}\nĐến ${DateFormat('dd/MM/yyyy').format(selectedRange.end).toString()}';
      _bloc.add(SetTransTimeType(
        filter: FilterTrans(
            title: title,
            type: selectFilterTime.type,
            fromDate:
                '${DateFormat('yyyy-MM-dd').format(_startDate!)} 00:00:00',
            toDate: '${DateFormat('yyyy-MM-dd').format(_endDate!)} 23:59:59'),
      ));
      _bloc.add(GetTransListEvent(
          bankId: widget.bankId, offset: 0, type: selectFilterTransType.type));
    } else {
      getFilterTime();
      // setState(() {
      //   selectFilterTime = FilterTrans(title: '7 ngày gần đây', type: 0);
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    String timeFilter = '';
    if (selectFilterTime.type == 3 && _endDate != null) {
      timeFilter =
          '${DateFormat('dd/MM/yyyy').format(_startDate!).toString()} - ${DateFormat('dd/MM/yyyy').format(_endDate!).toString()}';
    } else {
      timeFilter = selectFilterTime.title;
    }

    String transType = '';
    switch (selectFilterTransType.type) {
      case 9:
        transType = 'Tất cả GD';
        break;
      case 0:
        transType = 'GD đến';
        break;
      case 1:
        transType = 'GD đi';
        break;
      default:
    }

    return BlocConsumer<NewTransactionBloc, TransactionState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == NewTranstype.GET_TRANS_LIST &&
            state.status == BlocStatus.SUCCESS) {
          listTrans = [...state.transItem!];
          groupsAlphabet = {};
          for (var item in listTrans) {
            String firstChar = DateFormat('dd/MM/yyyy')
                .format(DateTime.fromMillisecondsSinceEpoch(item.time * 1000));

            if (!groupsAlphabet.containsKey(firstChar)) {
              groupsAlphabet[firstChar] = [];
            }
            groupsAlphabet[firstChar]!.add(item);
          }
        }
        if (state.request == NewTranstype.GET_MORE &&
            state.status == BlocStatus.SUCCESS) {
          listTrans = [...listTrans, ...state.transItem!];
          for (var item in listTrans) {
            String firstChar = DateFormat('dd/MM/yyyy')
                .format(DateTime.fromMillisecondsSinceEpoch(item.time * 1000));

            if (!groupsAlphabet.containsKey(firstChar)) {
              groupsAlphabet[firstChar] = [];
            }
            bool exists = groupsAlphabet[firstChar]!
                .any((element) => element.transactionId == item.transactionId);
            if (!exists) {
              groupsAlphabet[firstChar]!.add(item);
            }
          }
        }
      },
      builder: (context, state) {
        return Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              return await onRefresh().then(
                (value) {
                  if (widget.scrollController.hasClients) {
                    widget.scrollController.jumpTo(0.0);
                  }
                },
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                color: AppColor.WHITE,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE1EFFF),
                    Color(0xFFE5F9FF),
                  ],
                  end: Alignment.centerRight,
                  begin: Alignment.centerLeft,
                ),
              ),
              child: Column(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: widget.isScrollNotifier,
                    builder: (context, value, child) {
                      return Container(
                        width: double.infinity,
                        height: 140,
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                        decoration: BoxDecoration(
                          color: AppColor.WHITE,
                          gradient: value
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFFE1EFFF),
                                    Color(0xFFE5F9FF),
                                  ],
                                  end: Alignment.centerRight,
                                  begin: Alignment.centerLeft,
                                )
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: MTextFieldCustom(
                                      controller: _textController,
                                      fillColor: AppColor.TRANSPARENT,
                                      contentPadding: EdgeInsets.zero,
                                      enable: true,
                                      focusBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColor.BLUE_TEXT)),
                                      hintText: 'Tìm kiếm giao dịch',
                                      keyboardAction: TextInputAction.next,
                                      onSubmitted: (value) {
                                        _bloc.add(GetTransListEvent(
                                            bankId: widget.bankId,
                                            offset: 0,
                                            type: selectFilterTransType.type,
                                            value: _textController.text));
                                      },
                                      onChange: (value) {
                                        _bloc.add(SetTransValue(value: value));
                                      },
                                      inputType: TextInputType.text,
                                      isObscureText: false),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    _bloc.add(GetTransListEvent(
                                        bankId: widget.bankId,
                                        offset: 0,
                                        type: selectFilterTransType.type,
                                        value: _textController.text));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFE1EFFF),
                                            Color(0xFFE5F9FF)
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight),
                                    ),
                                    child: const XImage(
                                        imagePath:
                                            'assets/images/ic-search-black.png'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    DialogWidget.instance.showModelBottomSheet(
                                        borderRadius: BorderRadius.circular(20),
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 20),
                                        height: 440,
                                        widget: const TransInfoWidget());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFE1EFFF),
                                              Color(0xFFE5F9FF)
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                AppColor.BLACK.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                            offset: const Offset(1, 0),
                                          )
                                        ]),
                                    child: const XImage(
                                        imagePath:
                                            'assets/images/ic-i-black.png'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    getFilterTransType().then(
                                      (value) {
                                        _bloc.add(GetTransListEvent(
                                            bankId: widget.bankId,
                                            offset: 0,
                                            type: value.type));
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 4),
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: AppColor.WHITE,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                AppColor.BLACK.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 1),
                                          )
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          transType,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColor.BLACK),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          size: 16,
                                          color: AppColor.BLACK,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    getFilterTime().then(
                                      (value) {
                                        _bloc.add(GetTransListEvent(
                                            bankId: widget.bankId,
                                            offset: 0,
                                            type: selectFilterTransType.type));
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 4),
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: AppColor.WHITE,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                AppColor.BLACK.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 1),
                                          )
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          timeFilter,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColor.BLACK),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          size: 16,
                                          color: AppColor.BLACK,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: widget.isScrollNotifier,
                          builder: (context, value, child) {
                            return Container(
                              width: double.infinity,
                              height: constraints.maxHeight,
                              padding: EdgeInsets.fromLTRB(
                                  20, !value ? 0 : 20, 20, 0),
                              decoration: BoxDecoration(
                                borderRadius: !value
                                    ? BorderRadius.circular(0)
                                    : const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                color: AppColor.WHITE.withOpacity(0.6),
                              ),
                              child: (state.status == BlocStatus.SUCCESS &&
                                          state.request ==
                                              NewTranstype.GET_TRANS_LIST) ||
                                      ((state.status == BlocStatus.SUCCESS ||
                                              state.status ==
                                                  BlocStatus.LOAD_MORE) &&
                                          state.request ==
                                              NewTranstype.GET_MORE)
                                  ? ListView(
                                      padding: EdgeInsets.zero,
                                      controller: widget.scrollController,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        ...groupsAlphabet.entries.map(
                                          (e) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                Text(
                                                  e.key,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 10),
                                                ...e.value.map(
                                                  (item) {
                                                    return _buildItem(item);
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                        if (state.request ==
                                                NewTranstype.GET_MORE &&
                                            state.status ==
                                                BlocStatus.LOAD_MORE)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 20),
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        const SizedBox(height: 150)
                                      ],
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          state.status == BlocStatus.LOADING
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          state.status == BlocStatus.LOADING
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.center,
                                      children: [
                                        if (state.request ==
                                                NewTranstype.GET_TRANS_LIST &&
                                            state.status == BlocStatus.LOADING)
                                          const BuildLoading()
                                        else if (state.request ==
                                                NewTranstype.GET_TRANS_LIST &&
                                            state.status ==
                                                BlocStatus.NONE) ...[
                                          XImage(
                                            imagePath: _textController
                                                    .text.isEmpty
                                                ? 'assets/images/ic-empty-transaction.png'
                                                : "assets/images/ic-trans-purple.png",
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            _textController.text.isEmpty
                                                ? 'Không tìm thấy thông tin giao dịch.\nVui lòng kiểm tra lại thông tin tìm kiếm của bạn.'
                                                : 'Bạn chưa có giao dịch nào gần đây.',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                color: AppColor.GREY_TEXT),
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3),
                                        ]
                                      ],
                                    ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem(TransactionItemDTO item) {
    Color color = AppColor.GREEN;
    String text = '';
    bool isPayment =
        (item.transType == 'C' && (item.status == 2 || item.status == 0));

    switch (item.transType) {
      case "C":
        switch (item.status) {
          case 0:
            // - Giao dịch chờ thanh toán
            color = AppColor.ORANGE_TRANS;
            text = 'Chờ thanh toán';
            break;
          case 1:
            switch (item.type) {
              case 2:
                // - Giao dịch đến (+) không đối soát
                color = AppColor.BLUE_TEXT;
                text = item.referenceNumber;
                break;
              default:
                // - Giao dịch đến (+) có đối soát
                color = AppColor.GREEN;
                text = item.referenceNumber;
                break;
            }
            break;
          case 2:
            // Giao dịch hết hạn thanh toán;
            color = AppColor.GREY_TEXT;
            text = 'Đã hủy';
            break;
        }
        break;
      case "D":
        // - Giao dịch đi (-)
        color = AppColor.RED_TEXT;
        text = item.referenceNumber;
        break;
    }

    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TransactionDetailScreen(
              id: item.transactionId,
            ),
            settings: const RouteSettings(
              name: Routes.TRANSACTION_DETAIL_VIEW,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const XImage(
              imagePath: 'assets/images/ic-trans-type.png',
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                    text: item.amount.contains('*')
                        ? '${item.amount} '
                        : '${item.transType == 'D' ? '-' : '+'} ${item.amount} ',
                    style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.bold),
                    children: const [
                      TextSpan(
                        text: 'VND',
                        style: TextStyle(
                            fontSize: 10,
                            color: AppColor.GREY_TEXT,
                            fontWeight: FontWeight.normal),
                        children: [],
                      )
                    ],
                  )),
                  const SizedBox(height: 2),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 10, color: AppColor.BLACK),
                  )
                ],
              ),
            ),
            if (!isPayment)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('HH:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            item.timePaid * 1000)),
                    style: const TextStyle(fontSize: 10, color: AppColor.BLACK),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('dd/MM/yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            item.timePaid * 1000)),
                    style: const TextStyle(fontSize: 10, color: AppColor.BLACK),
                  )
                ],
              )
            else
              VietQRButton.solid(
                onPressed: () {},
                borderRadius: 100,
                child: XImage(imagePath: 'assets/images/ic-qr-black.png'),
                isDisabled: false,
                size: VietQRButtonSize.medium,
              )
          ],
        ),
      ),
    );
  }
}
