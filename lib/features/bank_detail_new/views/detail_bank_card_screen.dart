import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/measure_size.dart';
import 'package:vierqr/features/bank_detail_new/widgets/animation_graph_widget.dart';
import 'package:vierqr/features/bank_detail_new/widgets/bank_detail_appbar.dart';
import 'package:vierqr/features/bank_detail_new/widgets/bottom_bank_detail_widget.dart';
import 'package:vierqr/features/bank_detail_new/widgets/qr_widget.dart';
import 'package:vierqr/features/bank_detail_new/widgets/suggestion_widget.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class DetailBankCardScreen extends StatefulWidget {
  QRGeneratedDTO qrGeneratedDTO;
  DetailBankCardScreen({super.key, required this.qrGeneratedDTO});

  @override
  State<DetailBankCardScreen> createState() => _DetailBankCardScreenState();
}

class _DetailBankCardScreenState extends State<DetailBankCardScreen> {
  ValueNotifier<double> heightNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<bool> isScrollNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> isScrollToChart = ValueNotifier<bool>(false);
  int _selectedIndex = 0;
  ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0);
  final GlobalKey _animatedBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          children: [
            BankDetailAppbar(
              isScroll: isScrollNotifier,
              onSelect: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selected: _selectedIndex,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                // height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFE1EFFF),
                      Color(0xFFE5F9FF),
                    ],
                    end: Alignment.centerRight,
                    begin: Alignment.centerLeft,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Stack(
                        children: [
                          _buildExpandedWidget(),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                QrWidget(
                                  dto: widget.qrGeneratedDTO,
                                ),
                                MeasureSize(
                                  onChange: (size) {
                                    final widgetHeight = size.height;

                                    double itemheight =
                                        constraints.maxHeight - 400;

                                    if (itemheight > widgetHeight) {
                                      heightNotifier.value =
                                          constraints.maxHeight - 200;
                                    } else if (itemheight <= widgetHeight) {
                                      heightNotifier.value =
                                          (constraints.maxHeight - 200) +
                                              (widgetHeight - itemheight);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xFFE1EFFF),
                                                      Color(0xFFE5F9FF),
                                                    ],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image(
                                                      height: 30,
                                                      image: AssetImage(
                                                          'assets/images/ic-add-money-content.png'),
                                                    ),
                                                    Text(
                                                      'Thêm số tiền và nội dung',
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFFE1EFFF),
                                                    Color(0xFFE5F9FF),
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                              ),
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/images/ic-effect.png'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const SuggestionWidget(),
                                      const SizedBox(height: 20),
                                      AnimationGraphWidget(
                                        scrollNotifer: isScrollToChart,
                                        key: _animatedBarKey,
                                      ),
                                      const SizedBox(height: 120),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        BottomBarWidget(width: width),
      ],
    );
  }

  Widget _buildExpandedWidget() {
    return ValueListenableBuilder<double>(
      valueListenable: heightNotifier,
      builder: (context, value, child) {
        return Column(
          children: [
            const SizedBox(height: 200),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE1EFFF),
                    Color(0xFFE5F9FF),
                  ],
                  end: Alignment.centerRight,
                  begin: Alignment.centerLeft,
                ),
              ),
              child: Container(
                width: double.infinity,
                height: value + 10,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: AppColor.WHITE.withOpacity(0.6),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
