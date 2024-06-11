import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/transaction_detail/repositories/transaction_repository.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/models/transaction_input_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class TransProvider with ChangeNotifier {
  final controller = TextEditingController();

  final bool isOwner;
  final List<TerminalAccountDTO> terminalList;

  TransProvider(this.isOwner, this.terminalList);

  List<FilterTransaction> listFilter = [
    const FilterTransaction(id: 9, title: 'Tất cả (mặc định)'),
    const FilterTransaction(id: 5, title: 'Trạng thái giao dịch'),
    const FilterTransaction(id: 1, title: 'Mã giao dịch'),
    const FilterTransaction(id: 2, title: 'Mã đơn hàng (Order ID)'),
    const FilterTransaction(id: 4, title: 'Mã điểm bán'),
    const FilterTransaction(id: 3, title: 'Nội dung'),
  ];

  List<FilterTransaction> listFilterNotOwner = [
    const FilterTransaction(id: 9, title: 'Tất cả (mặc định)'),
    const FilterTransaction(id: 5, title: 'Trạng thái giao dịch'),
    const FilterTransaction(id: 1, title: 'Mã giao dịch'),
    const FilterTransaction(id: 2, title: 'Mã đơn hàng (Order ID)'),
    const FilterTransaction(id: 3, title: 'Nội dung'),
  ];

  List<FilterTransaction> listFilterTerminal = [
    const FilterTransaction(id: 0, title: 'Tất cả (mặc định)'),
    const FilterTransaction(id: 1, title: 'Cửa hàng'),
  ];
  FilterTransaction _valueFilterTerminal =
      const FilterTransaction(id: 0, title: 'Tất cả (mặc định)');

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
    const FilterTimeTransaction(id: 2, title: '7 ngày gần nhất'),
    const FilterTimeTransaction(id: 1, title: 'Hôm nay (mặc định)'),
  ];

  FilterStatusTransaction statusValue =
      const FilterStatusTransaction(title: 'Chờ thanh toán', id: 0);

  FilterTransaction _valueFilter =
      const FilterTransaction(id: 9, title: 'Tất cả (mặc định)');

  FilterTransaction get valueFilter => _valueFilter;

  FilterTimeTransaction _valueTimeFilter =
      const FilterTimeTransaction(id: 1, title: 'Hôm nay (mặc định)');

  FilterTimeTransaction get valueTimeFilter => _valueTimeFilter;
  DateTime? _toDate;

  DateTime? get toDate => _toDate;

  DateTime _formDate = DateTime.now();

  DateTime get fromDate => _formDate;

  DateFormat dateFormat = DateFormat('HH:mm dd-MM-yyyy');

  String _keywordSearch = '';
  String codeTerminal = '';
  String bankId = '';

  String get keywordSearch => _keywordSearch;

  int offset = 0;
  bool isCalling = true;
  bool _isInput = false;
  bool get isInput => _isInput;
  final merchantRepository = getIt.get<TransactionRepository>();
  final scrollControllerList = ScrollController();
  int _currentPage = 0;

  int get currentPage => _currentPage;
  List<BankAccountDTO> bankAccounts = [];

  TerminalAccountDTO _terminalAccountDTO = TerminalAccountDTO();
  TerminalAccountDTO get terminalAccountDTO => _terminalAccountDTO;

  // TerminalResponseDTO _terminalResponseDTO = TerminalResponseDTO(banks: []);

  // TerminalResponseDTO get terminalResponseDTO => _terminalResponseDTO;

  String get fromDateText => dateFormat.format(fromDate);

  String get toDateText => dateFormat.format(toDate ?? DateTime.now());

  void updateTerminals(
    // List<TerminalResponseDTO> value,
    String bankID,
    DateTime formDate,
    DateTime toDate,
    FilterTimeTransaction timeFilter,
    String keyword,
    String codeTerminalParent,
    FilterTransaction filterTransaction,
    FilterStatusTransaction valueStatus,
    FilterTransaction filterTerminal, {
    // TerminalResponseDTO? terminalRes,
    List<TerminalAccountDTO>? listTerminal,
  }) {
    bankId = bankID;
    _formDate = formDate;
    _toDate = toDate;
    _valueTimeFilter = timeFilter;
    if (timeFilter.id == TypeTimeFilter.PERIOD.id) {
      onChangeDropTime(true);
    }

    if (listTerminal != null && listTerminal.isNotEmpty) {
      _terminalAccountDTO = terminalList.first;
    } else {
      _terminalAccountDTO = listTerminal![0];
    }

    _keywordSearch = keyword;
    codeTerminal = codeTerminalParent;
    controller.text = keyword;
    _valueFilter = filterTransaction;
    statusValue = valueStatus;
    _valueFilterTerminal = filterTerminal;

    if (isOwner) {
      _valueFilterTerminal = filterTerminal;
    } else {
      _valueFilterTerminal = const FilterTransaction(id: 1, title: 'Cửa hàng');
    }
  }

  void updateTerminalResponseDTO(TerminalAccountDTO? value) {
    _isInput = false;
    if (value == null) return;
    _terminalAccountDTO = value;
    if (isOwner) {
      _keywordSearch = value.terminalName!;
      codeTerminal = value.terminalCode!;
    }
    notifyListeners();
  }

  void updateDataFilter(
    FilterTransaction filterTerminal,
    FilterTransaction? filterTransaction,
    FilterStatusTransaction? statusFilter,
    String keyword,
    String codeParent,
    FilterTimeTransaction? filterTime,
    DateTime fromDate,
    DateTime? toDate,
    TerminalAccountDTO terminalAccount,
  ) {
    _valueFilterTerminal = filterTerminal;
    if (filterTransaction != null) {
      controller.clear();
      updateKeyword('');
      _valueFilter = filterTransaction;
    }

    changeTimeDataFilter(filterTime);

    updateFromDate(fromDate);
    updateToDate(toDate);

    _terminalAccountDTO = terminalAccount;

    if (statusFilter != null) {
      controller.clear();
      updateKeyword('');
      statusValue = statusFilter;
    }

    String text = keyword.trim();
    if (text.isNotEmpty) {
      _keywordSearch = text;
    }

    codeTerminal = codeParent;
  }

  String get hintText {
    if (valueFilter.id == 4) {
      return 'Nhập mã điểm bán';
    } else if (valueFilter.id == 1) {
      return 'Nhập mã giao dịch';
    } else if (valueFilter.id == 2) {
      return 'OrderID';
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
    DateTime endDate = fromDate.subtract(const Duration(days: 0));

    // _terminalAccountDTO = terminalList.first;
    _terminalAccountDTO = terminalList.first;

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
      // terminalCode: _terminalAccountDTO.terminalCode!,
      terminalCode: '',

      userId: SharePrefUtils.getProfile().userId,
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
            value: codeTerminal,
            terminalCode: _terminalAccountDTO.terminalCode == null
                ? (_terminalAccountDTO.terminalCode!
                        .contains('Tất cả (mặc định)')
                    ? ''
                    : _terminalAccountDTO.terminalCode!)
                : '',
            userId: SharePrefUtils.getProfile().userId,
            status: statusValue.id,
          );

          if (valueFilter.id == 5) {
            param.value = statusValue.id.toString();
          }
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
    _valueFilter = const FilterTransaction(id: 9, title: 'Tất cả (mặc định)');
    _valueTimeFilter =
        const FilterTimeTransaction(id: 1, title: 'Hôm nay (mặc định)');
    statusValue = const FilterStatusTransaction(title: 'Chờ thanh toán', id: 0);

    if (isOwner) {
      _valueFilterTerminal =
          const FilterTransaction(id: 0, title: 'Tất cả (mặc định)');
    } else {
      _valueFilterTerminal = const FilterTransaction(id: 1, title: 'Cửa hàng');
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
        _keywordSearch = _terminalAccountDTO.terminalCode!;
      } else {
        updateKeyword('');
      }

      _terminalAccountDTO = terminalList.first;

      if (_valueFilter.id.typeTrans == TypeFilter.ALL) {
        onSearch(callBack);
      } else if (_valueFilter.id.typeTrans == TypeFilter.STATUS_TRANS) {
        onSearch(callBack);
      }
    }

    notifyListeners();
  }

  void changeStatusFilter(FilterStatusTransaction? value) {
    if (value != null) {
      controller.clear();
      statusValue = value;
      updateKeyword('');
    }
    notifyListeners();
  }

  void changeTimeFilter(FilterTimeTransaction? value, BuildContext context,
      Function(TransactionInputDTO) callBack) async {
    if (value != null) {
      DateTime now = DateTime.now();
      DateTime fromDate = DateTime(now.year, now.month, now.day);
      if (value.id == TypeTimeFilter.PERIOD.id) {
        onChangeDropTime(true);
        _valueTimeFilter = value;
        updateFromDate(fromDate);
        updateToDate(null);
      } else if (value.id == TypeTimeFilter.TODAY.id) {
        onChangeDropTime(false);
        DateTime endDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(fromDate);
        updateToDate(endDate);
        _valueTimeFilter = value;
        onSearch(callBack);
      } else if (value.id == TypeTimeFilter.SEVEN_LAST_DAY.id) {
        onChangeDropTime(false);
        DateTime endDate = fromDate.subtract(const Duration(days: 7));

        fromDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(endDate);
        updateToDate(fromDate);
        _valueTimeFilter = value;
        onSearch(callBack);
      } else if (value.id == TypeTimeFilter.THIRTY_LAST_DAY.id) {
        onChangeDropTime(false);
        DateTime endDate = fromDate.subtract(const Duration(days: 30));

        fromDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(endDate);
        updateToDate(fromDate);
        _valueTimeFilter = value;
        onSearch(callBack);
      } else if (value.id == TypeTimeFilter.THREE_MONTH_LAST_DAY.id) {
        onChangeDropTime(false);
        DateTime endDate = Jiffy.parseFromDateTime(fromDate).subtract(months: 3).dateTime;
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
      if (value.id == TypeTimeFilter.PERIOD.id) {
        _valueTimeFilter = value;
      } else if (value.id == TypeTimeFilter.TODAY.id) {
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
        DateTime endDate = Jiffy.parseFromDateTime(fromDate).subtract(months: 3).dateTime;
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
    _isInput = true;
    String text = value.trim();
    _keywordSearch = text;
    codeTerminal = text;
    notifyListeners();
  }

  void updateFromDate(DateTime? value) {
    _formDate = value ?? DateTime.now();
    notifyListeners();
  }

  void updateToDate(DateTime? value) {
    _toDate = value;
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
        value: codeTerminal,
        terminalCode: _terminalAccountDTO.terminalCode!,
        userId: SharePrefUtils.getProfile().userId,
        status: statusValue.id,
      );
      if (valueTimeFilter.id == TypeTimeFilter.ALL.id) {
        param.from = '0';
        param.to = '0';
      } else {
        param.from = TimeUtils.instance.getCurrentDate(_formDate);
        param.to = TimeUtils.instance.getCurrentDate(_toDate);
      }

      if (codeTerminal == _terminalAccountDTO.terminalCode! &&
          _terminalAccountDTO.terminalId!.isEmpty) {
        param.terminalCode = '';
        param.value = '';
      }

      if (!isOwner && _terminalAccountDTO.terminalId == null) {
        param.terminalCode = '';
      }

      if (valueFilter.id == 5) {
        param.value = statusValue.id.toString();
      }

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

  updateOffset(int value) {
    offset = value;
    notifyListeners();
  }

  Future<void> onRefresh(Function(TransactionInputDTO dto) onCall) async {}
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
