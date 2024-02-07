import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/trans_history/views/terminal_time_view.dart';
import 'package:vierqr/features/transaction/repositories/transaction_repository.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/models/transaction_input_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class TransProvider with ChangeNotifier {
  final controller = TextEditingController();

  List<FilterTransaction> listFilter = [
    const FilterTransaction(id: 9, title: 'Tất cả'),
    const FilterTransaction(id: 5, title: 'Trạng thái giao dịch'),
    const FilterTransaction(id: 1, title: 'Mã giao dịch'),
    const FilterTransaction(id: 2, title: 'Mã đơn hàng (Order ID)'),
    const FilterTransaction(id: 4, title: 'Mã điểm bán'),
    const FilterTransaction(id: 3, title: 'Nội dung'),
  ];

  List<FilterTransaction> listFilterNotOwner = [
    const FilterTransaction(id: 9, title: 'Tất cả'),
    const FilterTransaction(id: 5, title: 'Trạng thái giao dịch'),
    const FilterTransaction(id: 1, title: 'Mã giao dịch'),
    const FilterTransaction(id: 2, title: 'Mã đơn hàng (Order ID)'),
    const FilterTransaction(id: 3, title: 'Nội dung'),
  ];

  List<FilterTransaction> listFilterTerminal = [
    const FilterTransaction(id: 0, title: 'Tất cả'),
    const FilterTransaction(id: 1, title: 'Nhóm/Chi nhánh'),
  ];
  FilterTransaction _valueFilterTerminal =
      const FilterTransaction(id: 0, title: 'Tất cả');
  FilterTransaction get valueFilterTerminal => _valueFilterTerminal;

  final List<FilterStatusTransaction> listStatus = [
    const FilterStatusTransaction(title: 'Chờ thanh toán', id: 0),
    const FilterStatusTransaction(title: 'Thành công', id: 1),
    const FilterStatusTransaction(title: 'Đã huỷ', id: 2),
  ];

  List<FilterTimeTransaction> listTimeFilter = [
    const FilterTimeTransaction(id: 5, title: 'Khoảng thời gian'),
    const FilterTimeTransaction(id: 4, title: '3 tháng gần đây'),
    const FilterTimeTransaction(id: 3, title: '1 tháng gần đây'),
    const FilterTimeTransaction(id: 2, title: '7 ngày gần đây (mặc định)'),
  ];

  FilterStatusTransaction statusValue =
      const FilterStatusTransaction(title: 'Chờ thanh toán', id: 0);

  FilterTransaction _valueFilter =
      const FilterTransaction(id: 9, title: 'Tất cả');

  FilterTransaction get valueFilter => _valueFilter;

  FilterTimeTransaction _valueTimeFilter =
      const FilterTimeTransaction(id: 2, title: '7 ngày gần đây (mặc định)');

  FilterTimeTransaction get valueTimeFilter => _valueTimeFilter;
  DateTime? _toDate;

  DateTime? get toDate => _toDate;

  DateTime _formDate = DateTime.now();

  DateTime get fromDate => _formDate;

  String _keywordSearch = '';
  String bankId = '';

  String get keywordSearch => _keywordSearch;

  int offset = 0;
  bool isCalling = true;
  final merchantRepository = const TransactionRepository();
  final scrollControllerList = ScrollController();
  int _currentPage = 0;

  int get currentPage => _currentPage;
  List<BankAccountDTO> bankAccounts = [];

  TerminalResponseDTO _terminalResponseDTO = TerminalResponseDTO(banks: []);
  TerminalResponseDTO get terminalResponseDTO => _terminalResponseDTO;

  List<TerminalResponseDTO> terminals = [];

  void updateTerminals(
    List<TerminalResponseDTO> value,
    String bankID,
    DateTime formDate,
    DateTime toDate,
    FilterTimeTransaction timeFilter,
    String keyword,
    FilterTransaction filterTransaction,
    FilterStatusTransaction valueStatus,
    FilterTransaction filterTerminal,
    bool isOwner,
  ) {
    print('------------_keywordSearch--------------- $_keywordSearch');
    terminals = value;
    bankId = bankID;
    _formDate = formDate;
    _toDate = toDate;
    _valueTimeFilter = timeFilter;
    _terminalResponseDTO = terminals.first;
    _keywordSearch = keyword;
    controller.text = keyword;
    _valueFilter = filterTransaction;
    statusValue = valueStatus;
    _valueFilterTerminal = filterTerminal;

    if (isOwner) {
      _valueFilterTerminal = filterTerminal;
    } else {
      _valueFilterTerminal =
          const FilterTransaction(id: 1, title: 'Nhóm/Chi nhánh');
    }
  }

  void updateTerminalResponseDTO(TerminalResponseDTO value) {
    _terminalResponseDTO = value;
    notifyListeners();
  }

  void updateFilterTerminal(FilterTransaction value) {
    _valueFilterTerminal = value;
    if (value.id == 0) {
      _terminalResponseDTO = TerminalResponseDTO(banks: []);
    } else {
      _terminalResponseDTO = terminals.first;
    }

    notifyListeners();
  }

  void updateDataFilter(
      FilterTransaction filterTerminal,
      FilterTransaction? filterTransaction,
      FilterStatusTransaction? statusFilter,
      String keyword,
      FilterTimeTransaction? filterTime) {
    _valueFilterTerminal = filterTerminal;
    // if (_valueFilterTerminal.id == 0) {
    //   _terminalResponseDTO = TerminalResponseDTO(banks: []);
    // } else {
    //   _terminalResponseDTO = terminals.first;
    // }
    if (filterTransaction != null) {
      controller.clear();
      updateKeyword('');
      _valueFilter = filterTransaction;
      if (_valueFilter.id.typeTrans == TypeFilter.ALL) {
        // _valueTimeFilter = const FilterTimeTransaction(
        //     id: 2, title: '7 ngày gần đây (mặc định)');
      } else if (_valueFilter.id.typeTrans == TypeFilter.STATUS_TRANS) {}
    }
    changeTimeDataFilter(filterTime);

    if (statusFilter != null) {
      controller.clear();
      updateKeyword('');
      statusValue = statusFilter;
    }

    String text = keyword.trim();
    if (text.isNotEmpty) {
      if (text.contains('')) {
        _keywordSearch = text.replaceAll(' ', '-');
      } else {
        _keywordSearch = text;
      }
    }
  }

  String get hintText {
    if (valueFilter.id == 4) {
      return 'Nhập mã điểm bán';
    } else if (valueFilter.id == 1) {
      return 'Nhập mã giao dịch';
    } else if (valueFilter.id == 2) {
      return 'Nhập OrderID';
    } else if (valueFilter.id == 3) {
      return 'Nhập nội dung';
    }
    return '';
  }

  bool enableDropList = false;
  bool enableDropTime = false;

  init(Function(TransactionInputDTO) onInitTrans,
      Function(TransactionInputDTO) onSearchTrans) {
    DateTime now = DateTime.now();
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    DateTime endDate = fromDate.subtract(const Duration(days: 7));

    fromDate = fromDate
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
    updateFromDate(endDate);
    updateToDate(fromDate);
    TransactionInputDTO dto = TransactionInputDTO(
      type: 9,
      bankId: bankId,
      offset: 0,
      value: '',
      terminalCode: _terminalResponseDTO.id,
      userId: UserHelper.instance.getUserId(),
      status: 0,
      from: TimeUtils.instance.getCurrentDate(endDate),
      to: TimeUtils.instance.getCurrentDate(fromDate),
    );
    onInitTrans(dto);
    scrollControllerList.addListener(() {
      if (isCalling) {
        if (scrollControllerList.offset ==
            scrollControllerList.position.maxScrollExtent) {
          offset = offset + 20;

          TransactionInputDTO param = TransactionInputDTO(
            type: valueFilter.id,
            bankId: bankId,
            offset: offset,
            value: keywordSearch,
            terminalCode: _terminalResponseDTO.id,
            userId: UserHelper.instance.getUserId(),
            status: statusValue.id,
          );
          // if (valueTimeFilter.id == TypeTimeFilter.ALL.id ||
          //     (valueFilter.id.typeTrans != TypeFilter.ALL &&
          //         valueFilter.id.typeTrans != TypeFilter.CODE_SALE)) {
          //   param.from = '0';
          //   param.to = '0';
          // } else {
          //   param.from = TimeUtils.instance.getCurrentDate(_formDate);
          //   param.to = TimeUtils.instance.getCurrentDate(_toDate);
          // }
          param.from = TimeUtils.instance.getCurrentDate(_formDate);
          param.to = TimeUtils.instance.getCurrentDate(_toDate);
          onSearchTrans(param);
          isCalling = false;
        }
      }
    });
  }

  onChangedStatus(int index, Function(TransactionInputDTO) callBack) {
    enableDropList = !enableDropList;
    if (statusValue != listStatus[index]) {
      statusValue = listStatus[index];
    }
    onSearch(callBack);
    notifyListeners();
  }

  onChangeDropTime(bool value) {
    enableDropTime = value;
    // if (!value) {
    //   updateFromDate(DateTime.now());
    //   updateToDate(null);
    //   _valueTimeFilter =
    //       const FilterTimeTransaction(id: 2, title: '7 ngày gần nhất');
    // }
    notifyListeners();
  }

  resetFilterTime(Function(TransactionInputDTO) callBack) {
    enableDropTime = false;
    _valueTimeFilter =
        const FilterTimeTransaction(id: 2, title: '7 ngày gần đây (mặc định)');
    onSearch(callBack);
    notifyListeners();
  }

  onHandleTap() {
    enableDropList = !enableDropList;
    notifyListeners();
  }

  updateCallLoadMore(bool value) {
    isCalling = value;
  }

  resetFilter(Function(TransactionInputDTO) callBack, bool isOwner) {
    _valueFilter = const FilterTransaction(id: 9, title: 'Tất cả');
    _valueTimeFilter =
        const FilterTimeTransaction(id: 2, title: '7 ngày gần đây (mặc định)');
    statusValue = const FilterStatusTransaction(title: 'Chờ thanh toán', id: 0);

    if (isOwner) {
      _valueFilterTerminal = const FilterTransaction(id: 0, title: 'Tất cả');
    } else {
      _valueFilterTerminal =
          const FilterTransaction(id: 1, title: 'Nhóm/Chi nhánh');
    }

    _keywordSearch = '';
    controller.clear();
    onSearch(callBack);
    notifyListeners();
  }

  void changeFilter(
      FilterTransaction? value, Function(TransactionInputDTO) callBack) {
    if (value != null) {
      controller.clear();
      updateKeyword('');
      _valueFilter = value;
      if (value.id == 4) {
        _keywordSearch = _terminalResponseDTO.id;
      } else {
        updateKeyword('');
      }

      if (_valueFilter.id.typeTrans == TypeFilter.ALL) {
        // _valueTimeFilter = const FilterTimeTransaction(
        //     id: 2, title: '7 ngày gần đây (mặc định)');
        onSearch(callBack);
      } else if (_valueFilter.id.typeTrans == TypeFilter.STATUS_TRANS) {
        onSearch(callBack);
      }
    }

    notifyListeners();
  }

  void changeStatusFilter(
      FilterStatusTransaction? value, Function(TransactionInputDTO) callBack) {
    if (value != null) {
      controller.clear();
      updateKeyword('');
      statusValue = value;
    }

    notifyListeners();
  }

  void changeTimeFilter(FilterTimeTransaction? value, BuildContext context,
      Function(TransactionInputDTO) callBack) async {
    if (value != null) {
      DateTime now = DateTime.now();
      DateTime fromDate = DateTime(now.year, now.month, now.day);
      if (value.id == TypeTimeFilter.PERIOD.id) {
        final data = await DialogWidget.instance.showModelBottomSheet(
          context: context,
          padding: EdgeInsets.zero,
          bgrColor: AppColor.TRANSPARENT,
          widget: TerminalTimeView(
            toDate: null,
            fromDate: fromDate,
          ),
        );
        if (data is List) {
          updateFromDate(data[0]);
          updateToDate(data[1]);
          onChangeDropTime(true);
          _valueTimeFilter = value;
          onSearch(callBack);
        } else {
          updateFromDate(fromDate);
          // _valueTimeFilter =
          //     const FilterTimeTransaction(id: 0, title: 'Tất cả');
        }
      } else if (value.id == TypeTimeFilter.TODAY.id) {
        DateTime endDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(fromDate);
        updateToDate(endDate);
        _valueTimeFilter = value;
        onSearch(callBack);
      } else if (value.id == TypeTimeFilter.SEVEN_LAST_DAY.id) {
        DateTime endDate = fromDate.subtract(const Duration(days: 7));

        fromDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(endDate);
        updateToDate(fromDate);
        _valueTimeFilter = value;
        onSearch(callBack);
      } else if (value.id == TypeTimeFilter.THIRTY_LAST_DAY.id) {
        DateTime endDate = fromDate.subtract(const Duration(days: 30));

        fromDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(endDate);
        updateToDate(fromDate);
        _valueTimeFilter = value;
        onSearch(callBack);
      } else if (value.id == TypeTimeFilter.THREE_MONTH_LAST_DAY.id) {
        DateTime endDate = Jiffy(fromDate).subtract(months: 3).dateTime;
        fromDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(endDate);
        updateToDate(fromDate);
        _valueTimeFilter = value;
        onSearch(callBack);
      }
    }

    notifyListeners();
  }

  void changeTimeDataFilter(FilterTimeTransaction? value) async {
    if (value != null) {
      DateTime now = DateTime.now();
      DateTime fromDate = DateTime(now.year, now.month, now.day);
      if (value.id == TypeTimeFilter.TODAY.id) {
        DateTime endDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(fromDate);
        updateToDate(endDate);
        _valueTimeFilter = value;
      } else if (value.id == TypeTimeFilter.SEVEN_LAST_DAY.id) {
        DateTime endDate = fromDate.subtract(const Duration(days: 7));

        fromDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(endDate);
        updateToDate(fromDate);
        _valueTimeFilter = value;
      } else if (value.id == TypeTimeFilter.THIRTY_LAST_DAY.id) {
        DateTime endDate = fromDate.subtract(const Duration(days: 30));

        fromDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(endDate);
        updateToDate(fromDate);
        _valueTimeFilter = value;
      } else if (value.id == TypeTimeFilter.THREE_MONTH_LAST_DAY.id) {
        DateTime endDate = Jiffy(fromDate).subtract(months: 3).dateTime;
        fromDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(endDate);
        updateToDate(fromDate);
        _valueTimeFilter = value;
      }
    }
  }

  updateKeyword(String value) {
    String text = value.trim();
    if (text.contains('')) {
      _keywordSearch = text.replaceAll(' ', '-');
    } else {
      _keywordSearch = text;
    }
  }

  void updateFromDate(DateTime value) {
    _formDate = value;
    notifyListeners();
  }

  void updateToDate(DateTime? value) {
    _toDate = value;
    notifyListeners();
  }

  void onMenuStateChange(bool isOpen) {
    if (enableDropList) {
      enableDropList = false;
      notifyListeners();
    }
  }

  updateOffset(int value) {
    offset = value;
    notifyListeners();
  }

  void onSearch(Function(TransactionInputDTO) onSearchTrans) {
    if (_toDate == null) {
      _toDate = DateTime.now();
    }

    if (_formDate.millisecondsSinceEpoch <= _toDate!.millisecondsSinceEpoch) {
      updateOffset(0);

      TransactionInputDTO param = TransactionInputDTO(
        type: valueFilter.id,
        bankId: bankId,
        offset: offset,
        value: keywordSearch,
        terminalCode: _terminalResponseDTO.id,
        userId: UserHelper.instance.getUserId(),
        status: statusValue.id,
      );
      if (valueTimeFilter.id == TypeTimeFilter.ALL.id) {
        param.from = '0';
        param.to = '0';
      } else {
        param.from = TimeUtils.instance.getCurrentDate(_formDate);
        param.to = TimeUtils.instance.getCurrentDate(_toDate);
      }
      // else {
      //   param.from = TimeUtils.instance.getCurrentDate(_formDate);
      //   param.to = TimeUtils.instance.getCurrentDate(_toDate);
      // }

      onSearchTrans(param);
    } else {
      DialogWidget.instance.openMsgDialog(
          title: 'Không hợp lệ',
          msg: 'Ngày bắt đầu không được lớn hơn ngày kết thúc');
    }
  }

  setBankId(String value) {
    bankId = value;
    notifyListeners();
  }

  void openBottomTime(
      BuildContext context, Function(TransactionInputDTO) callBack) async {
    final data = await DialogWidget.instance.showModelBottomSheet(
      context: context,
      padding: EdgeInsets.zero,
      bgrColor: AppColor.TRANSPARENT,
      widget: TerminalTimeView(
        toDate: _toDate,
        fromDate: fromDate,
      ),
    );

    if (data is List) {
      updateFromDate(data[0]);
      updateToDate(data[1]);
      onChangeDropTime(true);
      onSearch(callBack);
    }
  }
}

class FilterTransaction {
  final String title;
  final int id;

  const FilterTransaction({required this.id, required this.title});
}

class FilterStatusTransaction {
  final String title;
  final int id;

  const FilterStatusTransaction({required this.id, required this.title});
}

class FilterTimeTransaction {
  final String title;
  final int id;

  const FilterTimeTransaction({required this.id, required this.title});
}
