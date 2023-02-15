import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/features/bank_card/repositories/bank_manage_repository.dart';
import 'package:vierqr/features/personal/widgets/transaction_bank_item.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/transaction_bank_dto.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TransactionHistory();
}

class _TransactionHistory extends State<TransactionHistory> {
  String _fromDate = DateTime.now().toString();
  String _toDate = DateTime.now().toString();
  BankManageRepository bankManageRepository = const BankManageRepository();
  List<TransactionBankDTO> transactions = [];
  bool _isSearch = false;

  Future<void> search(BankAccountDTO dto) async {
    await bankManageRepository.getBankToken();
    transactions = await bankManageRepository.getBankTransactions(
      dto.bankAccount,
      'ACCOUNT',
      TimeUtils.instance.formatBankTime(_fromDate),
      TimeUtils.instance.formatBankTime(_toDate),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    BankAccountDTO dto = arg['bankAccountDTO'];
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          SubHeader(title: 'Giao dịch'),
          Expanded(
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Truy vấn lịch sử giao dịch',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                UnconstrainedBox(
                  child: BoxLayout(
                    width: width - 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            DialogWidget.instance.openDateTimePickerDialog(
                                'Từ ngày', _changeFromDate);
                          },
                          child: SizedBox(
                            width: width,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Từ ngày',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const Spacer(),
                                Text(TimeUtils.instance
                                    .formatBankTimeView(_fromDate)),
                              ],
                            ),
                          ),
                        ),
                        DividerWidget(width: width),
                        InkWell(
                          onTap: () {
                            DialogWidget.instance.openDateTimePickerDialog(
                                'Đến ngày', _changeToDate);
                          },
                          child: SizedBox(
                            width: width,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Đến ngày',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const Spacer(),
                                Text(TimeUtils.instance
                                    .formatBankTimeView(_toDate)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                UnconstrainedBox(
                  child: ButtonIconWidget(
                    width: width - 40,
                    height: 40,
                    icon: Icons.search_rounded,
                    borderRadius: 10,
                    title: 'Tìm kiếm',
                    textColor: DefaultTheme.BLUE_TEXT,
                    bgColor: Theme.of(context).cardColor,
                    function: () async {
                      setState(() {
                        _isSearch = true;
                      });
                      await search(dto);
                    },
                  ),
                ),
                if (_isSearch) ...[
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 30, bottom: 10),
                    child: Text(
                      'Chi tiết giao dịch',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  (transactions.isEmpty)
                      ? SizedBox(
                          width: width,
                          height: 200,
                          child: const Center(
                            child: Text(
                                'Không có giao dịch nào trong khoảng thời gian này'),
                          ),
                        )
                      : ListView.builder(
                          itemCount: transactions.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return TransactionBankItem(
                                transactionDTO: transactions[index]);
                          },
                        ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _changeFromDate(value) {
    setState(() {
      _fromDate = value.toString();
    });
  }

  void _changeToDate(value) {
    setState(() {
      _toDate = value.toString();
    });
  }
}
