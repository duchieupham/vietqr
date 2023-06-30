import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/features/bank_card/views/choose_bank_plan_view.dart';
import 'package:vierqr/features/bank_card/views/input_auth_information_view.dart';
import 'package:vierqr/features/bank_card/views/input_information_bank_widget.dart';
import 'package:vierqr/features/bank_card/views/policy_bank_view.dart';
import 'package:vierqr/features/bank_card/views/select_bank_type_widget.dart';
import 'package:vierqr/features/bank_type/blocs/bank_type_bloc.dart';
import 'package:vierqr/features/bank_type/events/bank_type_event.dart';
import 'package:vierqr/features/home/widgets/custom_app_bar_widget.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';

class AddBankCardView extends StatefulWidget {
  const AddBankCardView({super.key});

  @override
  State<AddBankCardView> createState() => _AddBankCardViewState();
}

class _AddBankCardViewState extends State<AddBankCardView> {
  late PageController _pageController;

  final bankAccountController = TextEditingController();
  final nationalController = TextEditingController();
  final phoneAuthController = TextEditingController();
  final nameController = TextEditingController();

  final List<Widget> _pages = [];

  int initialPage = 0;
  String bankAccount = '';
  String userBankName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initData(context);
  }

  void initData(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      initialPage = args['pageIndex'] ?? 0;
      bankAccount = args['bankAccount'] ?? '';
      userBankName = args['name'] ?? '';
    }

    if (bankAccount.isNotEmpty) {
      bankAccountController.value =
          bankAccountController.value.copyWith(text: bankAccount);
    }
    if (userBankName.isNotEmpty) {
      nameController.value = nameController.value.copyWith(text: userBankName);
    }
    _pageController = PageController(initialPage: initialPage);

    _pages.addAll(
      [
        ChooseBankPlanView(
          key: const PageStorageKey('SELECT_BANK_TYPE'),
          pageController: _pageController,
        ),
        SelectBankTypeWidget(
          key: const PageStorageKey('SELECT_BANK_TYPE'),
          callBack: (index) {
            _animatedToPage(index);
          },
        ),
        InputInformationBankWidget(
          key: const PageStorageKey('INPUT_INFORMATION_BANK'),
          bankAccountController: bankAccountController,
          nameController: nameController,
          callBack: (index) {
            _animatedToPage(index);
          },
        ),
        InputAuthInformationView(
          bankAccountController: bankAccountController,
          nameController: nameController,
          phoneAuthenController: phoneAuthController,
          nationalController: nationalController,
          callBack: (index) {
            _animatedToPage(index);
          },
        ),
        PolicyBankView(
          key: const PageStorageKey('POLICY_BANK'),
          bankAccountController: bankAccountController,
          nameController: nameController,
          nationalController: nationalController,
          phoneAuthenController: phoneAuthController,
          callBack: (index) {
            _animatedToPage(index);
            nationalController.clear();
            phoneAuthController.clear();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        _hideKeyboardBack(context);
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          child: Consumer<AddBankProvider>(
            builder: (context, provider, child) {
              return SubHeader(
                title: (provider.select == 0 || provider.select == 2)
                    ? 'Liên kết TK ngân hàng'
                    : (provider.select == 1)
                        ? 'Thêm TK ngân hàng'
                        : 'Mở TK MB Bank',
                function: () {
                  _hideKeyboardBack(context);
                },
                callBackHome: () {
                  _hideKeyboardBack(context);
                },
              );
            },
          ),
        ),
        body: Column(
          children: [
            // _buildStepWidget(context, width),
            Expanded(
              child: PageView(
                key: const PageStorageKey('PAGE_CREATE_QR_VIEW'),
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  Provider.of<AddBankProvider>(context, listen: false)
                      .updateIndex(index);
                },
                children: _pages,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
          ],
        ),
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    int index = Provider.of<AddBankProvider>(context, listen: false).index;
    if (index == 0 || index == 2) {
      bankAccountController.clear();
      nameController.clear();
      nationalController.clear();
      phoneAuthController.clear();
    } else if (index == 3) {
      nationalController.clear();
      phoneAuthController.clear();
    }

    if (index == 0) {
      Provider.of<AddBankProvider>(context, listen: false).reset();
      Navigator.of(context).pop();
    } else {
      if (index == 1) {
        Provider.of<AddBankProvider>(context, listen: false).updateSelect(0);
        Provider.of<AddBankProvider>(context, listen: false).reset();
        Navigator.of(context).pop();
      }
      Provider.of<AddBankProvider>(context, listen: false).updateIndex(0);
      _animatedToPage(index - 1);
    }
  }

  void _hideKeyboardBack(BuildContext context) {
    double bottom = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottom > 0.0) {
      FocusManager.instance.primaryFocus?.unfocus();
      Future.delayed(const Duration(milliseconds: 250), () {
        _navigateBack(context);
      });
    } else {
      _navigateBack(context);
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

  @override
  void dispose() {
    bankAccountController.clear();
    nationalController.clear();
    phoneAuthController.clear();
    nameController.clear();
    _pages.clear();
    _pageController.dispose();
    super.dispose();
  }
}
