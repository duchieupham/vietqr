import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/detail_store/blocs/detail_store_bloc.dart';
import 'package:vierqr/features/detail_store/events/detail_store_event.dart';
import 'package:vierqr/features/detail_store/states/detail_store_state.dart';
import 'package:vierqr/features/detail_store/widgets/filter_trans_store_widget.dart';
import 'package:vierqr/features/transaction_detail/transaction_detail_screen.dart';
import 'package:vierqr/models/store/detail_store_dto.dart';
import 'package:vierqr/models/trans_dto.dart';

class TransStoreView extends StatefulWidget {
  final DetailStoreDTO detailStoreDTO;

  const TransStoreView({
    super.key,
    required this.detailStoreDTO,
  });

  @override
  State<TransStoreView> createState() => _TransStoreViewState();
}

class _TransStoreViewState extends State<TransStoreView>
    with AutomaticKeepAliveClientMixin {
  late DetailStoreBloc bloc;
  final _controller = ScrollController();

  int typeFilter = 9;
  int typeTime = 1;
  int typeStatus = 0;
  String _searchKey = '';
  String _subCode = '';

  bool get isOwner => true;

  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();

  DateFormat get _dateFormat => DateFormat('yyyy-MM-dd HH:mm:ss');

  DateFormat get _dateFormatShow => DateFormat('dd-MM-yyyy HH:mm:ss');

  DateTime get now => DateTime.now();

  DateTime _formatFromDate(DateTime now) {
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    return fromDate;
  }

  DateTime _endDate(DateTime now) {
    DateTime fromDate = _formatFromDate(now);
    return fromDate
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    bloc = DetailStoreBloc(context,
        terminalCode: widget.detailStoreDTO.terminalCode,
        terminalId: widget.detailStoreDTO.terminalId);
    _controller.addListener(_loadMore);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetTerminalStoreEvent());
      _loadData();
    });
  }

  void _scrollDown() {
    _controller.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _loadData() async {
    String fromDate = _dateFormat.format(_formatFromDate(DateTime.now()));
    String toDate = _dateFormat.format(_endDate(DateTime.now()));
    if (typeTime != 1) {
      fromDate = _dateFormat.format(_fromDate);
      toDate = _dateFormat.format(_toDate);
    }

    final event = GetTransStoreEvent(
      fromDate: fromDate,
      toDate: toDate,
      subTerminalCode: _subCode,
      value: _searchKey,
      type: typeFilter,
    );

    bloc.add(event);
  }

  Future<void> _onRefresh() async {
    _loadData();
  }

  void _loadMore() {
    String fromDate = _dateFormat.format(_formatFromDate(DateTime.now()));
    String toDate = _dateFormat.format(_endDate(DateTime.now()));
    if (typeTime != 1) {
      fromDate = _dateFormat.format(_fromDate);
      toDate = _dateFormat.format(_toDate);
    }
    final maxScroll = _controller.position.maxScrollExtent;
    if (_controller.offset >= maxScroll && !_controller.position.outOfRange) {
      final event = FetchTransStoreEvent(
        fromDate: fromDate,
        toDate: toDate,
        subTerminalCode: _subCode,
        value: _searchKey,
        type: 9,
      );
      bloc.add(event);
    }
  }

  void _onSearch() {
    final event = GetTransStoreEvent(
      fromDate: _dateFormat.format(_fromDate),
      toDate: _dateFormat.format(_toDate),
      subTerminalCode: _subCode,
      value: _searchKey,
      type: typeFilter,
    );

    bloc.add(event);
  }

  ///
  void _onFilter(List<SubTerminal> terminals) async {
    double height = MediaQuery.of(context).size.height;
    await DialogWidget.instance.showModelBottomSheet(
      isDismissible: true,
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      height: height * 0.8,
      borderRadius: BorderRadius.circular(16),
      widget: FilterTransStoreWidget(
        typeFilter: typeFilter,
        typeTime: typeTime,
        typeStatus: typeStatus,
        fromDate: _fromDate,
        toDate: _toDate,
        subCode: _subCode,
        searchKey: _searchKey,
        terminals: terminals,
        callBack: _onReceive,
      ),
    );
  }

  _onReceive(int type, int time, int status, String subCode, String searchKey,
      DateTime fromDate, DateTime toDate) {
    _scrollDown();

    /// 1: Thời gian hôm nay( mặc định)
    typeFilter = type;
    typeTime = time;
    typeStatus = status;
    _fromDate = fromDate;
    _toDate = toDate;
    _subCode = subCode;
    _searchKey = searchKey;
    if (typeFilter == 5) {
      _searchKey = '$typeStatus';
    }

    updateState();

    _onSearch();
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<DetailStoreBloc>(
      create: (context) => bloc,
      child: BlocConsumer<DetailStoreBloc, DetailStoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Danh sách giao dịch',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          if (isOwner)
                            const Text(
                              'Hiển thị các giao dịch thuộc cửa hàng của bạn.',
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.GREY_TEXT),
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onFilter(state.terminals),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColor.BLUE_TEXT.withOpacity(0.3)),
                        child: Image.asset(
                          'assets/images/ic-filter-blue.png',
                          height: 36,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Lọc theo:',
                      style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterWith(
                                'Cửa hàng: ${widget.detailStoreDTO.terminalName}'),
                            _buildFilterWith('Thời gian: $timeValue'),
                            if (typeFilter == 1)
                              _buildFilterWith('Mã giao dịch: $_searchKey'),
                            if (typeFilter == 3)
                              _buildFilterWith('Nội dung: $_searchKey'),
                            if (typeFilter == 5)
                              _buildFilterWith(
                                  'Trạng thái: $_filterByStatus'),
                            if (typeFilter == 2)
                              _buildFilterWith('Mã đơn hàng: $_searchKey'),
                            if (typeFilter == 4)
                              _buildFilterWith('Mã điểm bán: $_searchKey'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                if (state.status == BlocStatus.LOADING_PAGE)
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 100),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.BLUE_TEXT,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: SingleChildScrollView(
                        controller: _controller,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            if (state.isEmpty)
                              Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 200),
                                    child: const Center(
                                      child: Text('Không có giao dịch nào'),
                                    ),
                                  ),
                                ],
                              )
                            else
                              ...List.generate(
                                state.transDTO.items.length,
                                (index) {
                                  return _buildElement(
                                    context: context,
                                    dto: state.transDTO.items[index],
                                  );
                                },
                              ),
                            if (state.isLoadMore)
                              const UnconstrainedBox(
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
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
            ),
          );
        },
      ),
    );
  }

  String get timeValue {
    if (typeTime == 1) return 'Hôm nay (mặc định)';
    if (typeTime == 2) return '7 ngày gần nhất';
    if (typeTime == 3) return '1 tháng gần đây';
    if (typeTime == 4) return '3 tháng gần đây';
    return 'Từ ${_dateFormatShow.format(_fromDate)} - đến ${_dateFormatShow.format(_toDate)}';
  }

  String get _filterByStatus {
    if (typeStatus == 1) return 'Thành công';
    if (typeStatus == 2) return 'Đã huỷ';
    return 'Chờ thanh toán';
  }

  Widget _buildFilterWith(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.BLUE_TEXT.withOpacity(0.3),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
      ),
    );
  }

  Widget _buildElement({
    required BuildContext context,
    required TransDTO dto,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        NavigatorUtils.navigatePage(
            context, TransactionDetailScreen(transactionId: dto.transactionId),
            routeName: TransactionDetailScreen.routeName);
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColor.WHITE,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              '${TransactionUtils.instance.getTransType(dto.transType)} ${dto.amount.contains('*') ? dto.amount : CurrencyUtils.instance.getCurrencyFormatted(dto.amount)} VND',
              style: TextStyle(fontSize: 18, color: dto.getColorStatus),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (dto.isTimeCreate)
                        _buildItem(
                            'Thời gian tạo:',
                            TimeUtils.instance.formatDateFromInt(
                                dto.time, false,
                                isShowHHmmFirst: true)),
                      if (dto.isTimeTT)
                        _buildItem(
                            'Thời gian TT:',
                            TimeUtils.instance.formatDateFromInt(
                                dto.timePaid, false,
                                isShowHHmmFirst: true)),
                      _buildItem(
                        'Trạng thái:',
                        TransactionUtils.instance.getStatusString(dto.status),
                        style: TextStyle(
                          color: TransactionUtils.instance.getColorStatus(
                            dto.status,
                            dto.type,
                            dto.transType,
                          ),
                        ),
                      ),
                      _buildItem(
                        'Nội dung:',
                        dto.content,
                        style: const TextStyle(color: AppColor.GREY_TEXT),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title, String value,
      {TextStyle? style, int? maxLines}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(color: AppColor.GREY_TEXT),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Text(value, style: style, maxLines: maxLines),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
