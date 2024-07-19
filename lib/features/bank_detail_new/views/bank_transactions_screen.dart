import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';

import '../widgets/index.dart';

class BankTransactionsScreen extends StatefulWidget {
  final ValueNotifier<bool> isScroll;
  final Function(bool) onScroll;

  const BankTransactionsScreen({
    super.key,
    required this.isScroll,
    required this.onScroll,
  });

  @override
  State<BankTransactionsScreen> createState() => _BankTransactionsScreenState();
}

class _BankTransactionsScreenState extends State<BankTransactionsScreen> {
  ValueNotifier<bool> isScrollNotifier = ValueNotifier<bool>(true);
  ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0);

  void initData(BuildContext context) async {
    scrollController.addListener(
      () {
        widget.onScroll(scrollController.offset == 0.0);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        initData(context);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColor.WHITE,
          gradient: LinearGradient(
            colors: [
              Color(0xFFE1EFFF),
              Color(0xFFE5F9FF),
            ],
            end: Alignment.centerRight,
            begin: Alignment.centerLeft,
          ),
        ),
        child: Column(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: widget.isScroll,
              builder: (context, value, child) {
                return Container(
                  width: double.infinity,
                  height: 140,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    gradient: value
                        ? const LinearGradient(
                            colors: [
                              Color(0xFFE1EFFF),
                              Color(0xFFE5F9FF),
                            ],
                            end: Alignment.centerRight,
                            begin: Alignment.centerLeft,
                          )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MTextFieldCustom(
                                fillColor: AppColor.TRANSPARENT,
                                contentPadding: EdgeInsets.zero,
                                enable: true,
                                focusBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColor.BLUE_TEXT)),

                                // suffixIcon: I,
                                hintText: 'Tìm kiếm giao dịch',
                                keyboardAction: TextInputAction.next,
                                onChange: (value) {},
                                inputType: TextInputType.text,
                                isObscureText: true),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE1EFFF),
                                      Color(0xFFE5F9FF)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight),
                              ),
                              child: const XImage(
                                  imagePath:
                                      'assets/images/ic-search-black.png'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFE1EFFF),
                                        Color(0xFFE5F9FF)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.BLACK.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      offset: const Offset(1, 0),
                                    )
                                  ]),
                              child: const XImage(
                                  imagePath: 'assets/images/ic-i-black.png'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColor.WHITE,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.BLACK.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 1),
                                    )
                                  ]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Tất cả GD',
                                    style: TextStyle(
                                        fontSize: 12, color: AppColor.BLACK),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    size: 16,
                                    color: AppColor.BLACK,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColor.WHITE,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.BLACK.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 1),
                                    )
                                  ]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '7 ngày gần đây',
                                    style: TextStyle(
                                        fontSize: 12, color: AppColor.BLACK),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    size: 16,
                                    color: AppColor.BLACK,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: widget.isScroll,
                    builder: (context, value, child) {
                      return Container(
                        width: double.infinity,
                        height: constraints.maxHeight,
                        padding:
                            EdgeInsets.fromLTRB(20, !value ? 0 : 20, 20, 0),
                        decoration: BoxDecoration(
                          borderRadius: !value
                              ? BorderRadius.circular(0)
                              : const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                          color: AppColor.WHITE.withOpacity(0.6),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            children: [],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
