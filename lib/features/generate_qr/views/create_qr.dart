import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/generate_qr/blocs/qr_blocs.dart';
import 'package:vierqr/features/generate_qr/states/qr_state.dart';
import 'package:vierqr/features/generate_qr/widgets/input_content_widget.dart';
import 'package:vierqr/features/generate_qr/widgets/input_ta_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/services/providers/search_clear_provider.dart';

class CreateQRScreen extends StatelessWidget {
  final BankAccountDTO bankAccountDTO;

  const CreateQRScreen({super.key, required this.bankAccountDTO});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QRBloc>(
      create: (BuildContext context) => QRBloc(),
      child: CreateQR(bankAccountDTO: bankAccountDTO),
    );
  }
}

class CreateQR extends StatefulWidget {
  final BankAccountDTO bankAccountDTO;

  const CreateQR({
    Key? key,
    required this.bankAccountDTO,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateQR();
}

class _CreateQR extends State<CreateQR> {
  late PageController _pageController;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    Provider.of<CreateQRProvider>(context, listen: false).reset();
    Provider.of<CreateQRPageSelectProvider>(context, listen: false).reset();
    _pageController = PageController(initialPage: 0, keepPage: true);
    _pages.addAll([
      InputTAWidget(
        key: const PageStorageKey('INPUT_TA_PAGE'),
        onNext: () {
          Provider.of<SearchProvider>(context, listen: false).reset();
          onNext(context);
        },
      ),
      InputContentWidget(
        key: const PageStorageKey('INPUT_CONTENT_PAGE'),
        bankAccountDTO: widget.bankAccountDTO,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateBack(context);
        return false;
      },
      child: Scaffold(
        appBar: const MAppBar(title: 'Tạo QR giao dịch'),
        body: Column(
          children: [
            BlocConsumer<QRBloc, QRState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Expanded(
                  child: PageView(
                    key: const PageStorageKey('PAGE_CREATE_QR_VIEW'),
                    allowImplicitScrolling: true,
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      Provider.of<CreateQRPageSelectProvider>(context,
                              listen: false)
                          .updateIndex(index);
                    },
                    children: _pages,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //navigate to page
  void _animatedToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutQuart,
    );
  }

  void _navigateBack(BuildContext context) {
    int index = Provider.of<CreateQRPageSelectProvider>(context, listen: false)
        .indexSelected;
    if (index == 0) {
      Provider.of<CreateQRProvider>(context, listen: false).reset();
      Provider.of<CreateQRPageSelectProvider>(context, listen: false).reset();
      Navigator.pop(context);
    } else {
      _animatedToPage(index - 1);
    }
  }

  void onNext(BuildContext context) {
    if (Provider.of<CreateQRProvider>(context, listen: false)
        .transactionAmount
        .toString()
        .isEmpty) {
      // Provider.of<CreateQRProvider>(context, listen: false)
      //     .updateTransactionAmount('0');
    }
    if (Provider.of<CreateQRProvider>(context, listen: false)
            .transactionAmount
            .isEmpty ||
        Provider.of<CreateQRProvider>(context, listen: false)
                .transactionAmount ==
            '0') {
      DialogWidget.instance.openMsgDialog(
        title: 'Số tiền không hợp lệ',
        msg: 'Số tiền phải lớn hơn 0 VND.',
      );
    } else {
      _animatedToPage(1);
    }
  }
}
