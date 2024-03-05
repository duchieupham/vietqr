import 'package:flutter/cupertino.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/models/merchant_dto.dart';

class TabInfoMerchant extends StatelessWidget {
  final MerchantDTO? merchantDTO;
  final VoidCallback onCreateOder;
  final VoidCallback onUnRegister;

  const TabInfoMerchant({
    super.key,
    required this.merchantDTO,
    required this.onCreateOder,
    required this.onUnRegister,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...[
            _buildItem('Đại lý:', merchantDTO?.merchantName ?? ''),
            _buildItem('Mã đại lý:', merchantDTO?.merchantId ?? ''),
            _buildItem('Tài khoản ngân hàng:', merchantDTO?.accountBank ?? ''),
            _buildItem('CCCD/MST:', merchantDTO?.nationalId ?? ''),
            _buildItem('Số điện thoại xác thực:',
                merchantDTO?.phoneAuthenticated ?? '',
                isUnBorder: true),
            const SizedBox(height: 24),
          ],
          _buildItemFeature(
            'Dịch vụ',
            des1: 'Tạo hoá đơn thanh toán',
            des2: 'Hoá đơn có thể thanh toán từ các kênh giao dịch của BIDV.',
            path: 'assets/images/ic-invoice-blue.png',
            onTap: onCreateOder,
          ),
          const SizedBox(height: 16),
          _buildItemFeature(
            'Cài đặt',
            des1: 'Huỷ đăng ký đại lý',
            des2: 'Ngừng sử dụng dịch vụ đại lý và quản lý hoá đơn.',
            path: 'assets/images/ic-remove-account.png',
            colorIcon: AppColor.RED_EC1010,
            onTap: onUnRegister,
          ),
        ],
      ),
    );
  }

  Widget _buildItemFeature(String title,
      {required String des1,
      required String des2,
      String path = '',
      Color? colorIcon,
      GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.WHITE,
            ),
            child: Row(
              children: [
                Image.asset(path, width: 30, color: colorIcon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(des1,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text(des2,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 12, color: AppColor.GREY_TEXT)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String content, {bool isUnBorder = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: isUnBorder
            ? null
            : Border(
                bottom: BorderSide(
                    color: AppColor.grey979797.withOpacity(0.3), width: 2),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, maxLines: 1),
          const SizedBox(height: 4),
          Text(
            content,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
