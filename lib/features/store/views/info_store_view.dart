import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/bank_detail/widget/detail_group.dart';
import 'package:vierqr/models/store/store_dto.dart';
import 'package:vierqr/models/store/total_store_dto.dart';

class InfoStoreView extends StatefulWidget {
  final TotalStoreDTO? totalStoreDTO;
  final List<StoreDTO> stores;
  final RefreshCallback onRefresh;
  final ScrollController controller;

  const InfoStoreView({
    super.key,
    this.totalStoreDTO,
    required this.stores,
    required this.controller,
    required this.onRefresh,
  });

  @override
  State<InfoStoreView> createState() => _InfoStoreViewState();
}

class _InfoStoreViewState extends State<InfoStoreView> {
  DateTime get _now => DateTime.now();

  String get stringDate => '${_now.day} tháng ${_now.month}, ${_now.year}';

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        physics: const AlwaysScrollableScrollPhysics(),
        controller: widget.controller,
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Kết quả bán hàng hôm nay',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      stringDate,
                      style: TextStyle(color: AppColor.GREY_TEXT),
                    ),
                    Image.asset('assets/images/ic-navigate-next-blue.png',
                        width: 32),
                  ],
                ),
                const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildItemTotal(
                              title:
                                  '${widget.totalStoreDTO?.totalTrans ?? 0} giao dịch',
                              content: CurrencyUtils.instance
                                  .getCurrencyFormatted(
                                      (widget.totalStoreDTO?.totalAmount ?? 0)
                                          .toString()),
                              des: 'Doanh thu',
                              image: 'assets/images/ic-money-white.png',
                            ),
                            const SizedBox(height: 12),
                            _buildItemTotal(
                              content:
                                  '${(widget.totalStoreDTO?.ratePreviousDate ?? 0).toString().replaceAll('-', '')}%',
                              des: 'So với hôm qua',
                              image: (widget.totalStoreDTO?.ratePreviousDate ??
                                          0) >=
                                      0
                                  ? 'assets/images/ic-uptrend-white.png'
                                  : 'assets/images/ic-downtrend-white.png',
                              contentColor:
                                  (widget.totalStoreDTO?.ratePreviousDate ??
                                              0) >=
                                          0
                                      ? AppColor.GREEN
                                      : AppColor.RED_EC1010,
                              iconColor:
                                  (widget.totalStoreDTO?.ratePreviousDate ??
                                              0) >=
                                          0
                                      ? AppColor.GREEN
                                      : AppColor.RED_CALENDAR,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const VerticalDivider(color: AppColor.GREY_TEXT),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildItemTotal(
                              title:
                                  '${widget.totalStoreDTO?.totalTerminal ?? 0} cửa hàng',
                              content: '',
                              des: '',
                              iconColor: AppColor.ORANGE_DARK,
                              contentColor: AppColor.BLACK,
                              image: 'assets/images/ic-store-new_white.png',
                            ),
                            const SizedBox(height: 12),
                            _buildItemTotal(
                              content:
                                  '${widget.totalStoreDTO?.ratePreviousMonth ?? 0}%',
                              des: 'So với cùng kỳ tháng trước',
                              image: (widget.totalStoreDTO?.ratePreviousMonth ??
                                          0) >=
                                      0
                                  ? 'assets/images/ic-uptrend-white.png'
                                  : 'assets/images/ic-downtrend-white.png',
                              contentColor:
                                  (widget.totalStoreDTO?.ratePreviousMonth ??
                                              0) >=
                                          0
                                      ? AppColor.GREEN
                                      : AppColor.RED_EC1010,
                              iconColor:
                                  (widget.totalStoreDTO?.ratePreviousMonth ??
                                              0) >=
                                          0
                                      ? AppColor.GREEN
                                      : AppColor.RED_CALENDAR,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Danh sách cửa hàng',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.totalStoreDTO?.totalTerminal ?? 0} cửa hàng',
                      style: TextStyle(color: AppColor.GREY_TEXT),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: widget.stores.length,
                  itemBuilder: (context, index) {
                    var dto = widget.stores[index];
                    return GestureDetector(
                      onTap: () async {
                        await NavigatorUtils.navigatePage(context,
                            DetailGroupScreen(groupId: dto.terminalId ?? ''),
                            routeName: DetailGroupScreen.routeName);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColor.GREY_BORDER, width: 0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dto.terminalName ?? '',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Image.asset(
                                    'assets/images/ic-navigate-next-blue.png',
                                    width: 32),
                              ],
                            ),
                            const SizedBox(height: 16),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 11),
                                children: [
                                  TextSpan(
                                    text: '${dto.totalTrans ?? 0} giao dịch\n',
                                  ),
                                  TextSpan(
                                    text: CurrencyUtils.instance
                                        .getCurrencyFormatted(
                                            (dto.totalAmount ?? 0).toString()),
                                    style: TextStyle(
                                        color: AppColor.BLUE_TEXT,
                                        fontSize: 14),
                                  ),
                                  TextSpan(
                                    text: ' VND\n',
                                    style: TextStyle(color: AppColor.GREY_TEXT),
                                  ),
                                  TextSpan(
                                    text: 'Doanh thu',
                                    style: TextStyle(
                                        color: AppColor.GREY_TEXT,
                                        fontSize: 11),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 11),
                                children: [
                                  TextSpan(
                                    text: (dto.ratePreviousDate ?? 0) >= 0
                                        ? '+${dto.ratePreviousDate ?? 0} %\n'
                                        : '${dto.ratePreviousDate ?? 0} %\n',
                                    style: TextStyle(
                                        color: (dto.ratePreviousDate ?? 0) >= 0
                                            ? AppColor.GREEN
                                            : AppColor.RED_EC1010,
                                        fontSize: 14),
                                  ),
                                  TextSpan(
                                    text: 'So với hôm qua',
                                    style: TextStyle(
                                        color: AppColor.GREY_TEXT,
                                        fontSize: 11),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemTotal({
    String? title,
    required String content,
    required String des,
    required String image,
    Color? contentColor,
    Color? iconColor,
  }) {
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: iconColor ?? AppColor.BLUE_TEXT,
            ),
            child: Image.asset(image, width: 32),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title,
                    style: TextStyle(fontSize: 12),
                  ),
                Wrap(
                  children: [
                    if (content.isNotEmpty)
                      Text(
                        content,
                        style: TextStyle(
                            color: contentColor ?? AppColor.BLUE_TEXT,
                            fontSize: 12),
                      ),
                    if (contentColor == null)
                      Text(
                        ' VND',
                        style:
                            TextStyle(color: AppColor.GREY_TEXT, fontSize: 12),
                      ),
                  ],
                ),
                if (des.isNotEmpty)
                  Text(
                    des,
                    maxLines: 2,
                    style: TextStyle(color: AppColor.GREY_TEXT, fontSize: 10),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
