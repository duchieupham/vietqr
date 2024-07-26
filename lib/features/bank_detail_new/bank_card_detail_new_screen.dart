import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/scroll_to_top_button.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/page/statistical_page.dart';
import 'package:vierqr/features/bank_detail/states/bank_card_state.dart';
import 'package:vierqr/features/bank_detail_new/blocs/transaction_bloc.dart';
import 'package:vierqr/features/bank_detail_new/events/transaction_event.dart';
import 'package:vierqr/features/bank_detail_new/views/detail_bank_card_screen.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/account_bank_detail_provider.dart';

import 'views/bank_transactions_screen.dart';
import 'widgets/index.dart';

class BankCardDetailNewScreen extends StatefulWidget {
  final String bankId;
  final bool isLoading;
  final BankAccountDTO dto;
  static String routeName = '/bank_card_detail_screen';

  const BankCardDetailNewScreen({
    super.key,
    required this.bankId,
    required this.dto,
    this.isLoading = true,
  });

  @override
  State<BankCardDetailNewScreen> createState() =>
      _BankCardDetailNewStateState();
}

class _BankCardDetailNewStateState extends State<BankCardDetailNewScreen> {
  ValueNotifier<bool> isScrollNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> scrollToTopNotifier = ValueNotifier<bool>(false);
  late ScrollController scrollController;
  late BankCardBloc bankCardBloc;
  late AccountBankDetailDTO dto = AccountBankDetailDTO();

  final PageController _pageController = PageController();
  String get userId => SharePrefUtils.getProfile().userId;

  int _selectedIndex = 0;
  final GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    bankCardBloc = getIt.get<BankCardBloc>(
        param1: widget.bankId, param2: widget.isLoading);
    scrollController = ScrollController()
      ..addListener(
        () {
          scrollToTopNotifier.value =
              scrollController.hasClients && scrollController.offset > 200;
          isScrollNotifier.value = scrollController.offset <= 0.0;
          if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
            getIt.get<NewTransactionBloc>().add(GetTransListEvent(
                  isLoadMore: true,
                  bankId: widget.bankId,
                ));
          }
        },
      );
  }

  Future<void> getStatistic() async {
    bankCardBloc.add(GetMerchantEvent());
    bankCardBloc
        .add(const BankCardGetDetailEvent(isLoading: true, isInit: true));
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context) => AccountBankDetailProvider(),
      child: Scaffold(
        floatingActionButton: ScrollToTopButton(
          onPressed: () {
            scrollController.animateTo(0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          notifier: scrollToTopNotifier,
          bottom: 70,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                BankDetailAppbar(
                  isScroll: isScrollNotifier,
                  onSelect: (index) async {
                    if (index == 2) {
                      await getStatistic();
                    }
                    isScrollNotifier.value = true;
                    if (scrollController.hasClients) {
                      scrollController.jumpTo(0.0);
                    }
                    // setState(() {
                    //   _selectedIndex = index;
                    // });
                    _pageController.jumpToPage(index);
                  },
                  selected: _selectedIndex,
                ),
                Expanded(
                  child: SizedBox(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (value) {
                        setState(() {
                          _selectedIndex = value;
                        });
                      },
                      children: [
                        DetailBankCardScreen(
                          bankCardBloc: bankCardBloc,
                          dto: widget.dto,
                          selectedIndex: _selectedIndex,
                          onScroll: (boolValue) {
                            isScrollNotifier.value = boolValue;
                          },
                          onSelectTab: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          bankId: widget.bankId,
                          isLoading: widget.isLoading,
                          globalKey: globalKey,
                        ),
                        BankTransactionsScreen(
                          dto: widget.dto,
                          bankId: widget.bankId,
                          scrollController: scrollController,
                          isScrollNotifier: isScrollNotifier,
                        ),
                        BlocConsumer<BankCardBloc, BankCardState>(
                          bloc: bankCardBloc,
                          listener: (context, state) {
                            if (state.request == BankDetailType.SUCCESS) {
                              if (state.bankDetailDTO != null) {
                                dto = state.bankDetailDTO!;
                              }
                            }
                          },
                          builder: (context, state) {
                            return StatisticalScreen(
                              bankId: widget.bankId,
                              terminalDto: state.terminalDto,
                              bankDetailDTO: dto,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            BottomBarWidget(
              dto: widget.dto,
              width: width,
              selectTab: _selectedIndex,
              onSave: () => onSaveImage(context),
              onShare: () => share(),
            ),
          ],
        ),
      ),
    );
  }

  void onSaveImage(BuildContext context) async {
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await ShareUtils.instance.saveImageToGallery(globalKey).then(
          (value) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
          },
        );
      },
    );
  }

  void share() async {
    await ShareUtils.instance
        .shareImage(key: globalKey, textSharing: '')
        .then((value) {
      // Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'Đã hoàn thành',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).hintColor,
        fontSize: 15,
      );
      // Navigator.pop(context);
    });
  }
}
