import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
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
    if (Provider.of<AddBankProvider>(context, listen: false).index == 0) {
      Provider.of<AddBankProvider>(context, listen: false).reset();
      Navigator.of(context).pop();
    } else {
      Provider.of<AddBankProvider>(context, listen: false).updateIndex(0);
      _animatedToPage(0);
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
}
