import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/features/generate_qr/widgets/input_content_widget.dart';
import 'package:vierqr/features/generate_qr/widgets/input_ta_widget.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  static final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  final TextEditingController amountController = TextEditingController();
  final TextEditingController msgController = TextEditingController();

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      InputTAWidget(
        key: const PageStorageKey('INPUT_TA_PAGE'),
        onNext: () {
          onNext(context);
        },
      ),
      InputContentWidget(
        key: const PageStorageKey('INPUT_CONTENT_PAGE'),
        bankAccountDTO: widget.bankAccountDTO,
        msgController: msgController,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          Consumer<CreateQRPageSelectProvider>(
            builder: (context, page, child) {
              return SubHeader(
                title: 'Tạo QR giao dịch',
                function: () {
                  if (page.indexSelected == 0) {
                    Provider.of<CreateQRProvider>(context, listen: false)
                        .reset();
                    Provider.of<CreateQRPageSelectProvider>(context,
                            listen: false)
                        .reset();
                    Navigator.pop(context);
                  } else {
                    _animatedToPage(page.indexSelected - 1);
                  }
                },
              );
            },
          ),
          Expanded(
            child: PageView(
              key: const PageStorageKey('PAGE_CREATE_QR_VIEW'),
              allowImplicitScrolling: true,
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                Provider.of<CreateQRPageSelectProvider>(context, listen: false)
                    .updateIndex(index);
              },
              children: _pages,
            ),
          ),
        ],
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

  void onNext(BuildContext context) {
    if (Provider.of<CreateQRProvider>(context, listen: false)
        .transactionAmount
        .toString()
        .isEmpty) {
      Provider.of<CreateQRProvider>(context, listen: false)
          .updateTransactionAmount('0');
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
