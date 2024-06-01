import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/month_calculator.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/models/store/data_filter.dart';
import 'package:vierqr/models/store/detail_store_dto.dart';

import 'drop_filter_widget.dart';

class FilterTransStoreWidget extends StatefulWidget {
  final int typeFilter;
  final int typeTime;
  final int typeStatus;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String terminalName;
  final String subCode;
  final String searchKey;
  final List<SubTerminal> terminals;
  final Function(int, int, int, String, String, DateTime, DateTime) callBack;

  const FilterTransStoreWidget({
    super.key,
    required this.typeFilter,
    required this.typeTime,
    required this.callBack,
    this.fromDate,
    this.toDate,
    this.terminalName = '',
    required this.terminals,
    required this.subCode,
    required this.searchKey,
    required this.typeStatus,
  });

  @override
  State<FilterTransStoreWidget> createState() => _FilterTransStoreWidgetState();
}

class _FilterTransStoreWidgetState extends State<FilterTransStoreWidget> {
  MonthCalculator monthCalculator = MonthCalculator();

  List<DataFilter> listFilterBy = [
    const DataFilter(id: 9, name: 'Tất cả (mặc định)'),
    const DataFilter(id: 5, name: 'Trạng thái giao dịch'),
    const DataFilter(id: 1, name: 'Mã giao dịch'),
    // const DataFilter(id: 4, name: 'Mã điểm bán'),
    const DataFilter(id: 2, name: 'Mã đơn hàng (Order ID)'),
    const DataFilter(id: 3, name: 'Nội dung'),
  ];

  List<DataFilter> listFilterByStatus = [
    const DataFilter(id: 0, name: 'Chờ thanh toán'),
    const DataFilter(id: 1, name: 'Thành công'),
    const DataFilter(id: 2, name: 'Đã huỷ'),
  ];

  List<DataFilter> listFilterByTime = [
    const DataFilter(id: 1, name: 'Hôm nay (mặc định)'),
    const DataFilter(id: 2, name: '7 ngày gần nhất'),
    const DataFilter(id: 3, name: '1 tháng gần đây'),
    const DataFilter(id: 4, name: '3 tháng gần đây'),
    const DataFilter(id: 5, name: 'Khoảng thời gian'),
  ];

  DataFilter _filterBy = const DataFilter(id: 9, name: 'Tất cả (mặc định)');

  DataFilter _filterByStatus = const DataFilter(id: 0, name: 'Chờ thanh toán');
  DataFilter _filterByTime =
      const DataFilter(id: 1, name: 'Hôm nay (mặc định)');

  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();

  List<SubTerminal> terminals = [];
  SubTerminal subTerminal = SubTerminal();
  bool isOwner = true;
  String _searchKey = '';

  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  void loadData() {
    terminals = [...widget.terminals];
    updateToDate(widget.toDate ?? _toDate);
    updateFromDate(widget.fromDate ?? _fromDate);

    controller.text = widget.searchKey;
    _searchKey = widget.searchKey;

    /// Get Filter by Filter
    int indexFilter =
        listFilterBy.indexWhere((element) => element.id == widget.typeFilter);
    if (indexFilter != -1) _filterBy = listFilterBy[indexFilter];

    /// Get Filter by status
    int indexStatus = listFilterByStatus
        .indexWhere((element) => element.id == widget.typeStatus);
    if (indexStatus != -1) _filterByStatus = listFilterByStatus[indexStatus];

    /// Get Filter by time
    int indexTime =
        listFilterByTime.indexWhere((element) => element.id == widget.typeTime);
    if (indexTime != -1) {
      _filterByTime = listFilterByTime[indexTime];
      if (_filterByTime.id != 5) onChangeTimeFilter(_filterByTime);
    }

    /// Get SubTerminal
    int indexTerminal = terminals
        .indexWhere((element) => element.subTerminalCode == widget.subCode);
    if (indexTerminal != -1) {
      subTerminal = terminals[indexTerminal];
    } else {
      subTerminal = terminals.first;
    }

    updateState();
  }

  void onReset() {
    _filterBy = const DataFilter(id: 9, name: 'Tất cả (mặc định)');
    _filterByStatus = const DataFilter(id: 0, name: 'Chờ thanh toán');
    _filterByTime = const DataFilter(id: 1, name: 'Hôm nay (mặc định)');
    _searchKey = '';
    subTerminal = terminals.first;

    onChangeTimeFilter(_filterByTime);
  }

  void updateState() {
    setState(() {});
  }

  void _handleApply() {
    Navigator.pop(context);
    widget.callBack.call(_filterBy.id, _filterByTime.id, _filterByStatus.id,
        subTerminal.subTerminalCode, _searchKey, _fromDate, _toDate);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 4),
              child: Row(
                children: [
                  const Spacer(),
                  const SizedBox(
                    width: 48,
                  ),
                  Text(
                    'Bộ lọc giao dịch',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.clear,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (terminals.isNotEmpty) ...[
              Text(
                'Máy QR box',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              _buildDropListTerminal(),
              const SizedBox(height: 24),
            ],
            _buildFilterByWidget(),
            _buildFormSearch(),
            if (_filterBy.id == 5) _buildFilterByStatusWidget(),
            const SizedBox(height: 24),
            _buildFilterByTimeWidget(),
            if (_filterByTime.id == 5) ...[
              const SizedBox(height: 24),
              _buildRangeTimeWidget(),
            ],
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    text: 'Xoá bộ lọc',
                    textColor: AppColor.BLUE_TEXT,
                    bgColor: AppColor.BLUE_TEXT.withOpacity(0.25),
                    function: onReset,
                    borderRadius: 5,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ButtonWidget(
                    text: 'Áp dụng',
                    textColor: AppColor.WHITE,
                    bgColor: AppColor.BLUE_TEXT,
                    function: _handleApply,
                    borderRadius: 5,
                    height: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterByWidget() {
    return DropFilterWidget(
      title: 'Tìm kiếm theo',
      list: listFilterBy,
      filter: _filterBy,
      callBack: (value) {
        if (value == null) return;
        _filterBy = value;
        _searchKey = '';
        controller.clear();
        updateState();
      },
    );
  }

  Widget _buildFilterByStatusWidget() {
    return DropFilterWidget(
      list: listFilterByStatus,
      filter: _filterByStatus,
      callBack: (value) {
        if (value == null) return;
        _filterByStatus = value;
        updateState();
      },
    );
  }

  Widget _buildFilterByTimeWidget() {
    return DropFilterWidget(
      title: 'Thời gian',
      list: listFilterByTime,
      filter: _filterByTime,
      callBack: onChangeTimeFilter,
    );
  }

  Widget _buildRangeTimeWidget() {
    return Row(
      children: [
        Expanded(
            child: _itemPickTime(
                title: 'Từ ngày', date: _fromDate, onTap: _onPickToDate)),
        const SizedBox(width: 8),
        Expanded(child: _itemPickTime()),
      ],
    );
  }

  Widget _itemPickTime(
      {String? title, GestureTapCallback? onTap, DateTime? date}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? 'Đến ngày',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap ?? _onPickFromDate,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              border: Border.all(color: AppColor.GREY_BORDER),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 12,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    TimeUtils.instance.formatDateToString(date ?? _toDate),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onPickFromDate() async {
    DateTime? date = await showDateTimePicker(
      context: context,
      initialDate: _toDate,
      firstDate: DateTime(2021, 6),
      lastDate: DateTime.now(),
    );
    int numberOfMonths =
        monthCalculator.calculateMonths(_fromDate, date ?? DateTime.now());

    if (numberOfMonths > 3) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo',
          msg: 'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
    } else if ((date ?? DateTime.now()).isBefore(_fromDate)) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo', msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
    } else {
      updateToDate(date ?? DateTime.now());
    }
  }

  void _onPickToDate() async {
    DateTime? date = await showDateTimePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2021, 6),
      lastDate: DateTime.now(),
    );

    int numberOfMonths =
        monthCalculator.calculateMonths(date ?? DateTime.now(), _toDate);

    if (numberOfMonths > 3) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo',
          msg: 'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
    } else if ((date ?? DateTime.now()).isAfter(_toDate)) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo', msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
    } else {
      updateFromDate(date ?? DateTime.now());
    }
  }

  Widget _buildFormSearch() {
    if (_filterBy.id == 9 || _filterBy.id == 5) return const SizedBox();
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.only(top: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColor.GREY_BORDER),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextFieldCustom(
              isObscureText: false,
              fillColor: AppColor.WHITE,
              title: '',
              controller: controller,
              hintText: hintText,
              inputType: TextInputType.text,
              keyboardAction: TextInputAction.next,
              onChange: (value) {
                _searchKey = value;
                updateState();
              },
            ),
          ),
        ],
      ),
    );
  }

  String get hintText {
    if (_filterBy.id == 1) {
      return 'Nhập mã giao dịch';
    } else if (_filterBy.id == 2) {
      return 'OrderID';
    } else if (_filterBy.id == 3) {
      return 'Nhập nội dung';
    }
    return '';
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }

  void updateFromDate(DateTime dateTime) {
    _fromDate = dateTime;
    updateState();
  }

  void updateToDate(DateTime dateTime) {
    _toDate = dateTime;
    updateState();
  }

  void onChangeTimeFilter(DataFilter? value) {
    if (value == null) return;
    _filterByTime = value;
    updateState();
    DateTime now = DateTime.now();
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    if (_filterByTime.id == TypeTimeFilter.PERIOD.id) {
      DateTime endDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (_filterByTime.id == TypeTimeFilter.TODAY.id) {
      DateTime endDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (_filterByTime.id == TypeTimeFilter.SEVEN_LAST_DAY.id) {
      DateTime endDate = fromDate.subtract(const Duration(days: 7));

      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(endDate);
      updateToDate(fromDate);
    } else if (_filterByTime.id == TypeTimeFilter.THIRTY_LAST_DAY.id) {
      DateTime endDate = fromDate.subtract(const Duration(days: 30));

      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(endDate);
      updateToDate(fromDate);
    } else if (_filterByTime.id == TypeTimeFilter.THREE_MONTH_LAST_DAY.id) {
      DateTime endDate = Jiffy.parseFromDateTime(fromDate).subtract(months: 3).dateTime;
      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(endDate);
      updateToDate(fromDate);
    }
  }

  Widget _buildDropListTerminal() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      height: 44,
      decoration: BoxDecoration(
          color: AppColor.WHITE,
          border: Border.all(color: AppColor.GREY_BORDER),
          borderRadius: BorderRadius.circular(6)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<SubTerminal>(
          isExpanded: true,
          selectedItemBuilder: (context) {
            return terminals
                .map(
                  (item) => DropdownMenuItem<SubTerminal>(
                    value: item,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.subTerminalName,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                )
                .toList();
          },
          items: terminals.map((item) {
            return DropdownMenuItem<SubTerminal>(
              value: item,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            item.subTerminalName,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  if (terminals.length > 1) ...[
                    const Divider(),
                  ]
                ],
              ),
            );
          }).toList(),
          value: subTerminal,
          onChanged: updateSubTerminal,
          buttonStyleData: ButtonStyleData(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.WHITE,
            ),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.expand_more),
            iconSize: 18,
            iconEnabledColor: AppColor.BLACK,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      ),
    );
  }

  void updateSubTerminal(SubTerminal? value) {
    if (value == null) return;
    subTerminal = value;
    updateState();
  }
}
