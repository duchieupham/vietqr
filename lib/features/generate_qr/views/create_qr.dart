import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/additional_data.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/utils/viet_qr_utils.dart';
import 'package:vierqr/commons/widgets/bank_information_widget.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/features/generate_qr/frames/create_qr_frame.dart';
import 'package:vierqr/features/generate_qr/views/qr_generated.dart';
import 'package:vierqr/features/generate_qr/widgets/input_content_widget.dart';
import 'package:vierqr/features/generate_qr/widgets/input_ta_widget.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/viet_qr_generate_dto.dart';
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
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _msgFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey key = GlobalKey();

  bool isCreatedQRAgain = false;

  VietQRGenerateDTO _vietQRGenerateDTO = const VietQRGenerateDTO(
      cAIValue: '',
      transactionAmountValue: '',
      additionalDataFieldTemplateValue: '');

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
        msgController: msgController,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(toolbarHeight: 0),
      body: CreateQRFrame(
        width: width,
        height: height,
        scrollController: _scrollController,
        mobileChildren: [
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
        widget1: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Số tiền'),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Consumer<CreateQRProvider>(
                builder: (context, value, child) {
                  return BorderLayout(
                    width: width,
                    isError: value.amountErr,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFieldWidget(
                            width: width,
                            autoFocus: true,
                            focusNode: _amountFocusNode,
                            isObscureText: false,
                            hintText: '0',
                            controller: amountController,
                            inputType: TextInputType.number,
                            keyboardAction: TextInputAction.next,
                            onSubmitted: (_) {
                              if (msgController.text.isNotEmpty) {
                                msgController.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset:
                                        msgController.value.text.length);
                              }
                            },
                            onChange: (text) {
                              if (amountController.text.isEmpty) {
                                amountController.value =
                                    amountController.value.copyWith(text: '0');
                                amountController.selection =
                                    TextSelection.collapsed(
                                        offset: amountController.text.length);
                              }
                              CurrencyUtils.instance
                                  .formatCurrencyTextController(
                                      amountController);
                              value.updateErr(
                                !StringUtils.instance.isNumeric(
                                  amountController.text
                                      .trim()
                                      .replaceAll(',', ''),
                                ),
                              );
                            },
                          ),
                        ),
                        const Text(
                          'VND',
                          style: TextStyle(fontSize: 15),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                      ],
                    ),
                  );
                },
              ),
              Consumer<CreateQRProvider>(builder: (context, value, child) {
                return Visibility(
                  visible: value.amountErr,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Số tiền không đúng định dạng, vui lòng nhập lại.',
                      style: TextStyle(
                        color: DefaultTheme.RED_TEXT,
                      ),
                    ),
                  ),
                );
              }),
              const Padding(padding: EdgeInsets.only(top: 20)),
              _buildTitle('Nội dung'),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Container(
                width: width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: DefaultTheme.GREY_TOP_TAB_BAR, width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: msgController,
                  autofocus: false,
                  focusNode: _msgFocusNode,
                  maxLength: 99,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nội dung chứa tối đa 99 ký tự.',
                    hintStyle: TextStyle(
                      color: DefaultTheme.GREY_TEXT,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    onSubmitted(width);
                  },
                ),
              ),
              (PlatformUtils.instance.resizeWhen(width, 800))
                  ? const Spacer()
                  : const Padding(padding: EdgeInsets.only(top: 50)),
              ButtonWidget(
                width: width,
                text: 'Tạo mã QR',
                borderRadius: 5,
                textColor: DefaultTheme.WHITE,
                bgColor: DefaultTheme.GREEN,
                function: () {
                  onSubmitted(width);
                },
              ),
            ],
          ),
        ),
        widget2: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: BankInformationWidget(
            width: width,
            height: 80,
            bankAccountDTO: widget.bankAccountDTO,
          ),
        ),
        widget3: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('QR giao dịch'),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Expanded(
                child: Consumer<CreateQRProvider>(
                  builder: (context, value, child) {
                    return (value.qrGenerated)
                        ? Container(
                            width: width,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      DialogWidget.instance.openContentDialog(
                                        null,
                                        VietQRWidget(
                                          width: width,
                                          qrGeneratedDTO: const QRGeneratedDTO(
                                            bankCode: '',
                                            bankName: '',
                                            bankAccount: '',
                                            userBankName: '',
                                            amount: '',
                                            content: '',
                                            qrCode: '',
                                            imgId: '',
                                          ),
                                          content: msgController.text,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).canvasColor,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: const Icon(
                                        Icons.zoom_out_map_rounded,
                                        color: DefaultTheme.GREEN,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: VietQRWidget(
                                    width: width,
                                    qrGeneratedDTO: const QRGeneratedDTO(
                                      bankCode: '',
                                      bankName: '',
                                      bankAccount: '',
                                      userBankName: '',
                                      amount: '',
                                      content: '',
                                      qrCode: '',
                                      imgId: '',
                                    ),
                                    content: msgController.text,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ButtonIconWidget(
                                      width: 120,
                                      icon: Icons.download_rounded,
                                      alignment: Alignment.center,
                                      title: 'Lưu',
                                      function: () {},
                                      bgColor: DefaultTheme.GREEN,
                                      textColor: DefaultTheme.WHITE,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10)),
                                    ButtonIconWidget(
                                      width: 120,
                                      icon: Icons.print_rounded,
                                      alignment: Alignment.center,
                                      title: 'In',
                                      function: () {},
                                      bgColor: DefaultTheme.GREEN,
                                      textColor: DefaultTheme.WHITE,
                                    ),
                                  ],
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 10)),
                                ButtonIconWidget(
                                  width: 250,
                                  icon: Icons.refresh_rounded,
                                  alignment: Alignment.center,
                                  title: 'Tạo lại mã QR',
                                  function: () async {
                                    await _scrollController.animateTo(
                                      0.0,
                                      duration:
                                          const Duration(milliseconds: 800),
                                      curve: Curves.ease,
                                    );
                                    amountController.clear();
                                    _amountFocusNode.requestFocus();
                                  },
                                  bgColor: Theme.of(context).canvasColor,
                                  textColor: DefaultTheme.GREEN,
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: width,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: DefaultTheme.GREY_TEXT, width: 0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'QR chưa được tạo.',
                              style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
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

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDot(int index, int indexSelected) {
    return Container(
      width: 25,
      height: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: (index == indexSelected)
            ? DefaultTheme.WHITE
            : DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.6),
      ),
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
    _animatedToPage(1);
  }

  void onSubmitted(double width) {
    if (amountController.text.isNotEmpty &&
        !Provider.of<CreateQRProvider>(context, listen: false).amountErr) {
      String additionalDataFieldTemplateValue = '';
      if (msgController.text.isNotEmpty) {
        additionalDataFieldTemplateValue =
            AdditionalData.PURPOSE_OF_TRANSACTION_ID +
                VietQRUtils.instance.generateLengthOfValue(msgController.text) +
                msgController.text;
      }
      _vietQRGenerateDTO = VietQRGenerateDTO(
        cAIValue: VietQRUtils.instance.generateCAIValue(
            widget.bankAccountDTO.bankCode, widget.bankAccountDTO.bankAccount),
        transactionAmountValue:
            amountController.text.replaceAll(',', '').trim(),
        additionalDataFieldTemplateValue: additionalDataFieldTemplateValue,
      );
      Provider.of<CreateQRProvider>(context, listen: false)
          .updateQrGenerated(true);
    }
    if (PlatformUtils.instance.resizeWhen(width, 800)) {
      _amountFocusNode.requestFocus();
      amountController.clear();
    } else {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 800),
        curve: Curves.ease,
      );
    }
  }
}
