import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/create_store/create_store_screen.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

class SuggestCreateStoreView extends StatefulWidget {
  final RefreshCallback onRefresh;

  const SuggestCreateStoreView({super.key, required this.onRefresh});

  @override
  State<SuggestCreateStoreView> createState() => _SuggestCreateStoreViewState();
}

class _SuggestCreateStoreViewState extends State<SuggestCreateStoreView> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/banner-store-and-service-3D.png'),
                ),
              ),
            ),
            ...[
              Text(
                'Cửa hàng và dịch vụ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                'Nhận thanh toán và quản lý tiền bán hàng\ntiện lợi ngay trên ứng dụng',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              MButtonWidget(
                title: 'Tạo cửa hàng ngay',
                icon: Image.asset('assets/images/ic-store-bottom-bar-blue.png',
                    height: 40),
                colorEnableText: AppColor.BLUE_TEXT,
                isEnable: true,
                margin: const EdgeInsets.symmetric(vertical: 16),
                height: 50,
                colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.35),
                onTap: () => NavigatorUtils.navigatePage(
                    context, CreateStoreScreen(),
                    routeName: CreateStoreScreen.routeName),
              ),
              const SizedBox(height: 16),
            ],
            ...[
              Text(
                'Giới thiệu tính năng',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildListSuggest(),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListSuggest() {
    return Column(
      children: [
        _itemSuggest(
          title: 'Tạo mã VietQR theo điểm bán',
          content: 'Mỗi cửa hàng có một mã VietQR tương ứng.',
          path: 'assets/images/ic-store-bottom-bar-blue.png',
        ),
        const SizedBox(height: 16),
        _itemSuggest(
          title: 'Quản lý doanh thu cửa hàng',
          content:
              'Nhận biến động số dư theo mã điểm bán, truy vấn lịch sử giao dịch, thống kê từng cửa hàng.',
          path: 'assets/images/logo-store-income-3D.png',
        ),
        const SizedBox(height: 16),
        _itemSuggest(
          title: 'Chia sẻ BĐSD với nhân viên',
          content:
              'Các nhân viên cùng theo dõi thông tin biến động số dư của cửa hàng.',
          path: 'assets/images/logo-share-bdsd-member-3D.png',
        ),
      ],
    );
  }

  Widget _itemSuggest(
      {required String title, required String content, required String path}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.WHITE,
      ),
      height: 100,
      child: Row(
        children: [
          Image.asset(path, height: 60),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  maxLines: 2,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
