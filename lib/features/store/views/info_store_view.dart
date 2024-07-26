import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/create_store/create_store_screen.dart';
import 'package:vierqr/features/detail_store/detail_store_screen.dart';
import 'package:vierqr/models/store/merchant_dto.dart';
import 'package:vierqr/models/store/store_dto.dart';
import 'package:vierqr/models/store/total_store_dto.dart';

class InfoStoreView extends StatefulWidget {
  final TotalStoreDTO? totalStoreDTO;
  final List<MerchantDTO> merchants;
  final MerchantDTO dto;
  final List<StoreDTO> stores;
  final RefreshCallback onRefresh;
  final ScrollController controller;
  final Function(MerchantDTO?) callBack;

  const InfoStoreView({
    super.key,
    this.totalStoreDTO,
    required this.stores,
    required this.controller,
    required this.onRefresh,
    required this.merchants,
    required this.dto,
    required this.callBack,
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
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            physics: const AlwaysScrollableScrollPhysics(),
            controller: widget.controller,
            children: [
              const SizedBox(height: 16),
              _buildDropListTerminal(),
              const SizedBox(height: 16),
              _buildResultSaleToday(),
              _buildListStore(),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 16,
            child: GestureDetector(
              onTap: _onCreateStore,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColor.BLUE_TEXT,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ic-store-white.png',
                      height: 26,
                      color: Colors.white,
                    ),
                    const Text(
                      'Thêm cửa hàng',
                      style: TextStyle(fontSize: 12, color: AppColor.WHITE),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropListTerminal() {
    return SizedBox(
      height: 44,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<MerchantDTO>(
          isExpanded: true,
          selectedItemBuilder: (context) {
            return widget.merchants
                .map(
                  (item) => DropdownMenuItem<MerchantDTO>(
                    value: item,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.name,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                )
                .toList();
          },
          items: widget.merchants.map((item) {
            return DropdownMenuItem<MerchantDTO>(
              value: item,
              child: Text(
                item.name,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
          value: widget.dto,
          onChanged: widget.callBack,
          iconStyleData: IconStyleData(
            icon: Container(
              decoration: BoxDecoration(
                color: AppColor.BLUE_TEXT.withOpacity(0.25),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset('assets/images/ic-select-merchant.png',
                  width: 34),
            ),
            iconEnabledColor: AppColor.BLACK,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.zero,
          ),
        ),
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
                    style: const TextStyle(fontSize: 12),
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
                      const Text(
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
                    style: const TextStyle(
                        color: AppColor.GREY_TEXT, fontSize: 10),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onCreateStore() async {
    await NavigatorUtils.navigatePage(context, const CreateStoreScreen(),
        routeName: CreateStoreScreen.routeName);
    widget.onRefresh();
  }

  void updateSubTerminal(MerchantDTO? value) {}

  Widget _buildResultSaleToday() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              spreadRadius: 2,
              color: AppColor.BLACK.withOpacity(0.1),
              offset: const Offset(0, 1),
            )
          ]),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Kết quả bán hàng hôm nay',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                stringDate,
                style: const TextStyle(color: AppColor.GREY_TEXT, fontSize: 12),
              ),
              Image.asset('assets/images/ic-navigate-next-blue.png', width: 26),
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
                        content: CurrencyUtils.instance.getCurrencyFormatted(
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
                        image:
                            (widget.totalStoreDTO?.ratePreviousDate ?? 0) >= 0
                                ? 'assets/images/ic-uptrend-white.png'
                                : 'assets/images/ic-downtrend-white.png',
                        contentColor:
                            (widget.totalStoreDTO?.ratePreviousDate ?? 0) >= 0
                                ? AppColor.GREEN
                                : AppColor.RED_EC1010,
                        iconColor:
                            (widget.totalStoreDTO?.ratePreviousDate ?? 0) >= 0
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
                        image:
                            (widget.totalStoreDTO?.ratePreviousMonth ?? 0) >= 0
                                ? 'assets/images/ic-uptrend-white.png'
                                : 'assets/images/ic-downtrend-white.png',
                        contentColor:
                            (widget.totalStoreDTO?.ratePreviousMonth ?? 0) >= 0
                                ? AppColor.GREEN
                                : AppColor.RED_EC1010,
                        iconColor:
                            (widget.totalStoreDTO?.ratePreviousMonth ?? 0) >= 0
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
    );
  }

  Widget _buildListStore() {
    if (widget.stores.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.only(top: 60),
          child: const Text(
            'Danh sách cửa hàng đang trống',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Danh sách cửa hàng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${widget.totalStoreDTO?.totalTerminal ?? 0} cửa hàng',
                style: const TextStyle(color: AppColor.GREY_TEXT),
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
                  await NavigatorUtils.navigatePage(
                      context,
                      DetailStoreScreen(
                        merchantId: widget.dto.id,
                        terminalId: dto.terminalId ?? '',
                        terminalCode: dto.terminalCode ?? '',
                        terminalName: dto.terminalName ?? '',
                      ),
                      routeName: DetailStoreScreen.routeName);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: BorderRadius.circular(8),
                      // border: Border.all(color: AppColor.GREY_BORDER, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1,
                          spreadRadius: 1,
                          color: AppColor.BLACK.withOpacity(0.1),
                          offset: const Offset(0, 1),
                        ),
                        BoxShadow(
                          blurRadius: 1,
                          spreadRadius: 1,
                          color: AppColor.BLACK.withOpacity(0.1),
                          offset: const Offset(0, -1),
                        ),
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              dto.terminalName ?? '',
                              maxLines: 2,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Image.asset('assets/images/ic-navigate-next-blue.png',
                              width: 32),
                        ],
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 11),
                          children: [
                            TextSpan(
                              text: '${dto.totalTrans ?? 0} giao dịch\n',
                            ),
                            TextSpan(
                              text: CurrencyUtils.instance.getCurrencyFormatted(
                                  (dto.totalAmount ?? 0).toString()),
                              style: const TextStyle(
                                  color: AppColor.BLUE_TEXT, fontSize: 14),
                            ),
                            const TextSpan(
                              text: ' VND\n',
                              style: TextStyle(color: AppColor.GREY_TEXT),
                            ),
                            const TextSpan(
                              text: 'Doanh thu',
                              style: TextStyle(
                                  color: AppColor.GREY_TEXT, fontSize: 11),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 11),
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
                            const TextSpan(
                              text: 'So với hôm qua',
                              style: TextStyle(
                                  color: AppColor.GREY_TEXT, fontSize: 11),
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
    );
  }
}
