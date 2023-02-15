import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/slider_header.dart';
import 'package:vierqr/features/log_sms/widgets/sms_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/features/bank_card/blocs/bank_manage_bloc.dart';
import 'package:vierqr/features/personal/events/bank_manage_event.dart';
import 'package:vierqr/features/bank_card/states/bank_manage_state.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/transaction_dto.dart';
import 'package:vierqr/services/providers/scroll_list_transaction_provider.dart';

class SmsDetailScreen extends StatelessWidget {
  final String address;
  final List<TransactionDTO> transactions;
  static final ScrollController scrollController = ScrollController();
  static late BankManageBloc bankManageBloc;
  final ScrollListTransactionProvider scrollListTransactionProvider =
      ScrollListTransactionProvider(false);
  late double maxScrollExtent;
  late double currentScroll;

  static BankAccountDTO bankAccountDTO = const BankAccountDTO(
    id: '',
    bankAccount: '',
    bankName: '',
    bankCode: '',
    userId: '',
    bankStatus: 0,
    role: 0,
    userBankName: '',
    imgId: '',
  );

  SmsDetailScreen({
    Key? key,
    required this.address,
    required this.transactions,
  }) : super(key: key);

  void initialServices(BuildContext context) {
    bankManageBloc = BlocProvider.of(context);
    bankManageBloc.add(BankManageEventGetDTO(
        userId: transactions.first.userId,
        bankAccount: transactions.first.bankAccount));
    scrollController.addListener(() {
      //show button back to top
      if (scrollController.position.pixels >= 150) {
        scrollListTransactionProvider.updateScroll(true);
      } else if (scrollController.position.pixels < 150) {
        scrollListTransactionProvider.updateScroll(false);
      }
      //pagging
    });
  }

  @override
  Widget build(BuildContext context) {
    initialServices(context);
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<BankManageBloc, BankManageState>(
              builder: (context, state) {
            if (state is BankManageGetDTOSuccessfulState) {
              bankAccountDTO = state.bankAccountDTO;
            }
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  collapsedHeight: MediaQuery.of(context).size.width * 0.3,
                  floating: false,
                  expandedHeight: MediaQuery.of(context).size.width * 0.7,
                  flexibleSpace: SliverHeader(
                    minHeight: MediaQuery.of(context).size.width * 0.3,
                    maxHeight: MediaQuery.of(context).size.width * 0.7,
                    title: 'Chi tiết giao dịch',
                    image: 'assets/images/bg-qr.png',
                    bankAccountDTO: bankAccountDTO,
                    accountBalance: transactions.first.accountBalance,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: 1,
                    (context, index) {
                      return _buidListTransaction();
                    },
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 60)),
              ],
            );
          }),
          Positioned(
            bottom: 30,
            right: 10,
            child: ValueListenableBuilder<bool>(
                valueListenable: scrollListTransactionProvider,
                builder: (_, scroll, child) {
                  return (scroll)
                      ? InkWell(
                          onTap: () {
                            _backToTop();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Theme.of(context).canvasColor,
                            ),
                            child: const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: DefaultTheme.GREY_TEXT,
                              size: 30,
                            ),
                          ),
                        )
                      : Container();
                }),
          ),
        ],
      ),
    );
  }

  Widget _buidListTransaction() {
    return Visibility(
      visible: transactions.isNotEmpty,
      child: ListView.builder(
        itemCount: transactions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return SmsDetailItem(transactionDTO: transactions[index]);
        }),
      ),
    );
  }

  _backToTop() {
    scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
