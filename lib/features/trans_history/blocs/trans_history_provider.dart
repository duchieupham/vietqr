import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/trans_history/views/terminal_time_view.dart';
import 'package:vierqr/features/transaction/repositories/transaction_repository.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/transaction_input_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class TransProvider with ChangeNotifier {
  final controller = TextEditingController();

  List<FilterTransaction> listFilter = [
    const FilterTransaction(id: 9, title: 'Tất cả'),
    const FilterTransaction(id: 5, title: 'Trạng thái giao dịch'),
    const FilterTransaction(id: 1, title: 'Mã giao dịch'),
    const FilterTransaction(id: 2, title: 'Order ID'),
    const FilterTransaction(id: 4, title: 'Mã điểm bán'),
    const FilterTransaction(id: 3, title: 'Nội dung'),
  ];

  final List<FilterTransaction> listStatus = [
    FilterTransaction(title: 'Tất cả', id: 9),
    FilterTransaction(title: 'Chờ thanh toán', id: 0),
    FilterTransaction(title: 'Thành công', id: 1),
    FilterTransaction(title: 'Đã huỷ', id: 2),
  ];

  List<FilterTimeTransaction> listTimeFilter = [
    const FilterTimeTransaction(id: 0, title: 'Tất cả'),
    const FilterTimeTransaction(id: 1, title: 'Hôm nay'),
    const FilterTimeTransaction(id: 2, title: '7 ngày gần nhất'),
    const FilterTimeTransaction(id: 3, title: '30 ngày gần nhất'),
    const FilterTimeTransaction(id: 4, title: '3 tháng gần nhất'),
    const FilterTimeTransaction(id: 5, title: 'Khoảng thời gian'),
  ];

  FilterTransaction statusValue =
      const FilterTransaction(id: 9, title: 'Tất cả');

  FilterTransaction _valueFilter =
      const FilterTransaction(id: 9, title: 'Tất cả');

  FilterTransaction get valueFilter => _valueFilter;

  FilterTimeTransaction _valueTimeFilter =
      const FilterTimeTransaction(id: 0, title: 'Tất cả');

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

  String get hintText {
    if (valueFilter.id == 4) {
      return 'Nhập mã điểm bán tại đây';
    } else if (valueFilter.id == 1) {
      return 'Nhập mã giao dịch tại đây';
    } else if (valueFilter.id == 2) {
      return 'Nhập OrderID tại đây';
    } else if (valueFilter.id == 3) {
      return 'Nhập nội dung tại đây';
    }
    return '';
  }

  bool enableDropList = false;
  bool enableDropTime = false;

  init(Function(TransactionInputDTO) onInitTrans,
      Function(TransactionInputDTO) onSearchTrans) {
    TransactionInputDTO dto = TransactionInputDTO(
      type: 9,
      bankId: bankId,
      offset: 0,
      value: '',
      userId: UserInformationHelper.instance.getUserId(),
      status: 0,
      from: '0',
      to: '0',
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
            userId: UserInformationHelper.instance.getUserId(),
            status: statusValue.id,
          );
          if (valueTimeFilter.id == TypeTimeFilter.ALL.id ||
              (valueFilter.id.typeTrans != TypeFilter.ALL &&
                  valueFilter.id.typeTrans != TypeFilter.CODE_SALE)) {
            param.from = '0';
            param.to = '0';
          } else {
            param.from = TimeUtils.instance.getCurrentDate(_formDate);
            param.to = TimeUtils.instance.getCurrentDate(_toDate);
          }
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
    if (!value) {}
    notifyListeners();
  }

  onHandleTap() {
    enableDropList = !enableDropList;
    notifyListeners();
  }

  updateCallLoadMore(bool value) {
    isCalling = value;
  }

  resetFilter(Function(TransactionInputDTO) callBack) {
    _valueFilter = const FilterTransaction(id: 9, title: 'Tất cả');
    _valueTimeFilter = const FilterTimeTransaction(id: 0, title: 'Tất cả');
    onSearch(callBack);
    notifyListeners();
  }

  void changeFilter(
      FilterTransaction? value, Function(TransactionInputDTO) callBack) {
    if (value != null) {
      controller.clear();
      updateKeyword('');
      _valueFilter = value;
      if (_valueFilter.id.typeTrans == TypeFilter.ALL) {
        _valueTimeFilter = const FilterTimeTransaction(id: 0, title: 'Tất cả');
        onSearch(callBack);
      } else if (_valueFilter.id.typeTrans == TypeFilter.STATUS_TRANS) {
        onSearch(callBack);
      }
    }

    notifyListeners();
  }

  void changeTimeFilter(
      FilterTimeTransaction? value, BuildContext context) async {
    if (value != null) {
      _valueTimeFilter = value;
      DateTime now = DateTime.now();
      DateTime fromDate = DateTime(now.year, now.month, now.day);
      if (value.id == TypeTimeFilter.PERIOD.id) {
        // DateTime endDate = fromDate
        //     .add(const Duration(days: 1))
        //     .subtract(const Duration(seconds: 1));
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
        } else {
          updateFromDate(fromDate);
        }
      } else if (value.id == TypeTimeFilter.TODAY.id) {
        DateTime endDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(fromDate);
        updateToDate(endDate);
      } else if (value.id == TypeTimeFilter.SEVEN_LAST_DAY.id) {
        DateTime endDate = fromDate.subtract(const Duration(days: 7));

        fromDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(endDate);
        updateToDate(fromDate);
      } else if (value.id == TypeTimeFilter.THIRTY_LAST_DAY.id) {
        DateTime endDate = fromDate.subtract(const Duration(days: 30));

        fromDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(endDate);
        updateToDate(fromDate);
      } else if (value.id == TypeTimeFilter.THREE_MONTH_LAST_DAY.id) {
        DateTime endDate = Jiffy(fromDate).subtract(months: 3).dateTime;
        fromDate = fromDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        updateFromDate(endDate);
        updateToDate(fromDate);
      }
    }

    notifyListeners();
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

  void updateToDate(DateTime value) {
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
        userId: UserInformationHelper.instance.getUserId(),
        status: statusValue.id,
      );
      if (valueTimeFilter.id == TypeTimeFilter.ALL.id ||
          (valueFilter.id.typeTrans != TypeFilter.ALL &&
              valueFilter.id.typeTrans != TypeFilter.CODE_SALE)) {
        param.from = '0';
        param.to = '0';
      } else {
        param.from = TimeUtils.instance.getCurrentDate(_formDate);
        param.to = TimeUtils.instance.getCurrentDate(_toDate);
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
}

class FilterTransaction {
  final String title;
  final int id;

  const FilterTransaction({required this.id, required this.title});
}

class FilterTimeTransaction {
  final String title;
  final int id;

  const FilterTimeTransaction({required this.id, required this.title});
}
