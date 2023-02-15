import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/personal/views/qr_scanner.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/services/providers/search_clear_provider.dart';

class InputContentWidget extends StatelessWidget {
  final TextEditingController msgController;
  static final _formKey = GlobalKey<FormState>();

  static final SearchClearProvider msgClearProvider =
      SearchClearProvider(false);

  const InputContentWidget({
    Key? key,
    required this.msgController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BoxLayout(
            width: width - 20,
            height: 40,
            borderRadius: 5,
            child: Row(
              children: [
                const Text('Số tiền giao dịch: '),
                const Spacer(),
                Text(
                  Provider.of<CreateQRProvider>(context).currencyFormatted,
                  style: const TextStyle(
                    color: DefaultTheme.GREEN,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(' VND'),
              ],
            )),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: ListView(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                UnconstrainedBox(
                  child: Image.asset(
                    'assets/images/ic-business-introduction.png',
                    width: 150,
                  ),
                ),
                UnconstrainedBox(
                  child: SizedBox(
                    width: width * 0.6,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(fontSize: 15),
                        children: [
                          const TextSpan(
                            text: 'Thêm thông tin doanh nghiệp',
                            style: TextStyle(
                              color: DefaultTheme.GREEN,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: ' để phân loại và quản lý các giao dịch.',
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20)),
        Container(
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: DefaultTheme.BLACK.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: width - 30,
                  child: Row(
                    children: [
                      const Text('Mẫu nội dung: '),
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: const Text(
                          'Thêm mới',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: DefaultTheme.GREEN,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                SizedBox(
                  width: width - 30,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildChoiceChip(
                        context,
                        'Thanh toán',
                        (text) {
                          print('----tap: $text');
                        },
                      ),
                      _buildChoiceChip(
                        context,
                        'Chuyển khoản',
                        (text) {
                          print('----tap: $text');
                        },
                      ),
                      _buildChoiceChip(
                        context,
                        'Chuyển tiền cho ABC',
                        (text) {
                          print('----tap: $text');
                        },
                      ),
                      _buildChoiceChip(
                        context,
                        'Thanh toán sản phẩm',
                        (text) {
                          print('----tap: $text');
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Container(
                      width: width - 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                          width: 0.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.text_format_rounded,
                            size: 15,
                            color: DefaultTheme.GREY_TEXT,
                          ),
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFieldWidget(
                                width: width,
                                hintText: 'Nội dung thanh toán',
                                controller: msgController,
                                maxLength: 50,
                                keyboardAction: TextInputAction.done,
                                onChange: (value) {
                                  if (msgController.text.isNotEmpty) {
                                    msgClearProvider.updateClearSearch(true);
                                  } else {
                                    msgClearProvider.updateClearSearch(false);
                                  }
                                },
                                inputType: TextInputType.text,
                                isObscureText: false,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.document_scanner_outlined,
                              color: DefaultTheme.GREEN,
                              size: 18,
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: msgClearProvider,
                            builder: (_, provider, child) {
                              return Visibility(
                                visible: provider == true,
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        msgController.clear();
                                        msgClearProvider
                                            .updateClearSearch(false);
                                      },
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 15,
                                        color: DefaultTheme.GREY_TEXT,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: DefaultTheme.GREEN,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.navigate_next_rounded,
                        color: DefaultTheme.WHITE,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                  ],
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildChoiceChip(
      BuildContext context, String text, ValueChanged<Object>? onTap) {
    return UnconstrainedBox(
      child: InkWell(
        onTap: () {
          return onTap!(text);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).canvasColor,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
