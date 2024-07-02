part of '../bank_screen.dart';

class BottomSection extends StatefulWidget {
  const BottomSection({super.key});

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColor.WHITE, boxShadow: [
        BoxShadow(
          color: AppColor.BLACK.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, -2),
        )
      ]),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 90),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildSection(
                context,
                pathIcon: ImageConstant.icCopyQr,
                radiusRight: 0,
                onTap: () async {
                  if (SharePrefUtils.getQrIntro()) {
                    startBarcodeScanStream();
                  } else {
                    await DialogWidget.instance.showFullModalBottomContent(
                      widget: const QRScanWidget(),
                      color: AppColor.BLACK,
                    );
                    if (!mounted) return;
                    startBarcodeScanStream();
                  }
                },
                title: 'Copy QR',
              ),
            ),
            SizedBox(
              height: context.isSmall ? 40 : 60,
              child: VerticalDashedLine(),
            ),
            Expanded(
              child: _buildSection(
                context,
                pathIcon: ImageConstant.icAddBank,
                radiusRight: 0,
                radiusLeft: 0,
                onTap: () async {
                  await NavigatorUtils.navigatePage(
                      context, const AddBankScreen(),
                      routeName: AddBankScreen.routeName);
                },
                title: 'Thêm Tài khoản',
              ),
            ),
            SizedBox(
              height: context.isSmall ? 40 : 60,
              child: VerticalDashedLine(),
            ),
            Expanded(
              child: _buildSection(
                context,
                pathIcon: ImageConstant.icShareBDSD,
                radiusLeft: 0,
                onTap: () async {
                  NavigatorUtils.navigatePage(
                    context,
                    const ShareBDSDScreen(),
                    routeName: 'share_bdsd_screen',
                  );
                },
                title: 'Chia sẻ BĐSD',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String pathIcon,
    required GestureTapCallback? onTap,
    String title = '',
    double? radiusLeft,
    double? radiusRight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: context.isSmall ? 6 : 8,
            horizontal: context.isSmall ? 6 : 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(radiusLeft ?? 8),
            right: Radius.circular(radiusRight ?? 8),
          ),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          children: [
            XImage(
              imagePath: pathIcon,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startBarcodeScanStream() async {
    final data = await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
    if (data is Map<String, dynamic>) {
      if (!mounted) return;
      QRScannerUtils.instance.onScanNavi(data, context);
    }
  }
}
