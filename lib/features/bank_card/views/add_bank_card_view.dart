import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/features/bank_card/views/choose_bank_plan_view.dart';
import 'package:vierqr/features/bank_card/views/input_information_bank_widget.dart';
import 'package:vierqr/features/bank_card/views/select_bank_type_widget.dart';
import 'package:vierqr/features/bank_type/blocs/bank_type_bloc.dart';
import 'package:vierqr/features/bank_type/events/bank_type_event.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';

class AddBankCardView extends StatelessWidget {
  static late BankTypeBloc bankTypeBloc;
  static final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  static final TextEditingController searchController = TextEditingController();
  static final TextEditingController bankAccountController =
      TextEditingController();
  static final TextEditingController nameController = TextEditingController();
  static final List<Widget> _pages = [];

  const AddBankCardView({super.key});

  void initialServices(BuildContext context) {
    if (!Provider.of<AddBankProvider>(context, listen: false).getBankTypes) {
      _pages.clear();
      _pages.addAll([
        ChooseBankPlanView(
          key: const PageStorageKey('SELECT_BANK_TYPE'),
          pageController: _pageController,
        ),
        SelectBankTypeWidget(
          key: const PageStorageKey('SELECT_BANK_TYPE'),
          pageController: _pageController,
          searchController: searchController,
        ),
        InputInformationBankWidget(
          key: const PageStorageKey('INPUT_INFORMATION_BANK'),
          bankAccountController: bankAccountController,
          nameController: nameController,
        ),
      ]);
      bankTypeBloc = BlocProvider.of(context);
      bankTypeBloc.add(const BankTypeEventGetList());
      Future.delayed(const Duration(milliseconds: 0), () {
        Provider.of<AddBankProvider>(context, listen: false)
            .updateGetBankType(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    initialServices(context);
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          SubHeader(
            title: 'Liên kết TK ngân hàng',
            function: () {
              _navigateBack(context);
            },
          ),
          _buildStepWidget(context, width),
          Expanded(
            child: PageView(
              key: const PageStorageKey('PAGE_CREATE_QR_VIEW'),
              allowImplicitScrolling: true,
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                Provider.of<AddBankProvider>(context, listen: false)
                    .updateIndex(index);
                searchController.clear();
                bankAccountController.clear();
                nameController.clear();
              },
              children: _pages,
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    searchController.clear();
    bankAccountController.clear();
    nameController.clear();
    int index = Provider.of<AddBankProvider>(context, listen: false).index;
    if (index == 0) {
      Provider.of<AddBankProvider>(context, listen: false).reset();
      Navigator.of(context).pop();
    } else {
      Provider.of<AddBankProvider>(context, listen: false).updateIndex(0);
      _animatedToPage(index - 1);
    }
  }

  //navigate to page
  void _animatedToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutQuart,
    );
  }

  Widget _buildStepWidget(BuildContext context, double width) {
    return SizedBox(
      width: width,
      child: Consumer<AddBankProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Positioned(
                top: 10,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.2),
                  width: width,
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.3,
                        height: 5,
                        color: (provider.index >= 1)
                            ? DefaultTheme.GREEN
                            : DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.3),
                      ),
                      Container(
                        width: width * 0.3,
                        height: 5,
                        color: (provider.index >= 2)
                            ? DefaultTheme.GREEN
                            : DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: (provider.index == 0)
                              ? Theme.of(context).cardColor
                              : DefaultTheme.GREEN,
                        ),
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: (provider.index == 0)
                                ? DefaultTheme.GREEN
                                : DefaultTheme.WHITE,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      SizedBox(
                        width: width * 0.3,
                        child: Text(
                          'Chọn loại TK',
                          style: TextStyle(
                            fontSize: 12,
                            color: (provider.index == 0)
                                ? DefaultTheme.GREEN
                                : Theme.of(context).hintColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  Column(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: (provider.index <= 1)
                              ? Theme.of(context).cardColor
                              : DefaultTheme.GREEN,
                        ),
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: (provider.index == 1)
                                ? DefaultTheme.GREEN
                                : (provider.index == 0)
                                    ? Theme.of(context).hintColor
                                    : DefaultTheme.WHITE,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      SizedBox(
                        width: width * 0.3,
                        child: Text(
                          'Chọn ngân hàng',
                          style: TextStyle(
                            fontSize: 12,
                            color: (provider.index == 1)
                                ? DefaultTheme.GREEN
                                : Theme.of(context).hintColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  Column(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Text(
                          '3',
                          style: TextStyle(
                            color: (provider.index == 2)
                                ? DefaultTheme.GREEN
                                : Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      SizedBox(
                        width: width * 0.3,
                        child: Text(
                          'Nhập thông tin TK',
                          style: TextStyle(
                            fontSize: 12,
                            color: (provider.index == 2)
                                ? DefaultTheme.GREEN
                                : Theme.of(context).hintColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
