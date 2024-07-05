import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/qr_feed/views/qr_screen.dart';
import 'package:vierqr/features/qr_feed/widgets/default_appbar_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';

// ignore: constant_identifier_names
enum ViewType { GRID, LIST }

class QrCreateScreen extends StatefulWidget {
  const QrCreateScreen({super.key});

  @override
  State<QrCreateScreen> createState() => _QrCreateScreenState();
}

class _QrCreateScreenState extends State<QrCreateScreen> {
  PageController _pageController = PageController(initialPage: 0);
  ViewType _viewType = ViewType.GRID;

  final List<QrType> _qrType = [
    QrType(
        type: 1,
        icon: 'assets/images/ic-vietqr-trans.png',
        gradient: VietQRTheme.gradientColor.viet_qr,
        name: 'Mã VietQR',
        separateWidget: const SizedBox.shrink(),
        description: 'Mã QR chứa thông tin chuyển khoản'),
    QrType(
        type: 2,
        icon: 'assets/images/ic-popup-bank-linked.png',
        gradient: VietQRTheme.gradientColor.qr_link,
        name: 'Đường dẫn',
        separateWidget: const MySeparator(color: AppColor.GREY_DADADA),
        description: 'Mã QR chứa thông tin URL đến trang web'),
    QrType(
        type: 3,
        icon: 'assets/images/ic-vcard-green.png',
        gradient: VietQRTheme.gradientColor.vcard,
        name: 'VCard',
        separateWidget: const MySeparator(color: AppColor.GREY_DADADA),
        description: 'Mã QR chứa thông tin danh bạ liên hệ'),
    QrType(
        type: 4,
        icon: 'assets/images/ic-other-qr.png',
        gradient: VietQRTheme.gradientColor.other_qr,
        name: 'Khác',
        separateWidget: const MySeparator(color: AppColor.GREY_DADADA),
        description: 'Mã QR chứa thông tin cấu hình tuỳ chọn'),
  ];

  final List<QrType> _importQr = [
    QrType(
        type: 5,
        icon: 'assets/images/ic-scan-content.png',
        gradient: VietQRTheme.gradientColor.scan_qr,
        name: 'Quét mã QR',
        separateWidget: const SizedBox.shrink(),
        description: 'Quét mã QR để thêm mới'),
    // QrType(
    //     type: 6,
    //     icon: 'assets/images/ic-img-picker.png',
    //     gradient: VietQRTheme.gradientColor.import_qr,
    //     name: 'Tải ảnh QR',
    //     separateWidget: const MySeparator(color: AppColor.GREY_DADADA),
    //     description: 'Chọn ảnh QR từ thư viện để thêm mới'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const DefaultAppbarWidget(),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: _buildBody(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Đầu tiên, chọn loại QR\nmà bạn muốn thêm mới',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 18),
        Container(
          // width: 100,
          // height: 40,
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: AppColor.GREY_DADADA),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  _viewType = ViewType.GRID;
                  updateState();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  width: 40,
                  height: 25,
                  decoration: BoxDecoration(
                    color: _viewType == ViewType.GRID
                        ? AppColor.BLUE_TEXT.withOpacity(0.2)
                        : AppColor.WHITE,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const XImage(
                      fit: BoxFit.fitHeight,
                      imagePath: 'assets/images/ic-grid.png'),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  _viewType = ViewType.LIST;
                  updateState();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  width: 40,
                  height: 25,
                  decoration: BoxDecoration(
                    color: _viewType == ViewType.LIST
                        ? AppColor.BLUE_TEXT.withOpacity(0.2)
                        : AppColor.WHITE,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const XImage(imagePath: 'assets/images/ic-list.png'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        if (_viewType == ViewType.LIST) ...[
          ..._qrType.map(
            (e) => _buildListItem(e),
          ),
          const SizedBox(height: 25),
          const Row(
            children: [
              Expanded(child: MySeparator(color: AppColor.GREY_DADADA)),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Text('Hoặc', style: TextStyle(fontSize: 13)),
              ),
              Expanded(child: MySeparator(color: AppColor.GREY_DADADA)),
            ],
          ),
          const SizedBox(height: 25),
          ..._importQr.map((e) => _buildListItem(e)),
        ] else ...[
          SizedBox(
            width: double.infinity,
            height: 310,
            child: GridView(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 150,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2),
                children: _qrType
                    .map(
                      (e) => _buildGridItem(e),
                    )
                    .toList()),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(child: MySeparator(color: AppColor.GREY_DADADA)),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Text('Hoặc', style: TextStyle(fontSize: 13)),
              ),
              Expanded(child: MySeparator(color: AppColor.GREY_DADADA)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 160,
            child: GridView(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 150,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2),
                children: _importQr
                    .map(
                      (e) => _buildGridItem(e),
                    )
                    .toList()),
          ),
        ],
      ],
    );
  }

  Widget _buildGridItem(
    QrType e,
  ) {
    return InkWell(
      onTap: () {
        onNavi(e);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: e.gradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            e.type == 6
                ? Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(12),
                    child: XImage(imagePath: e.icon),
                  )
                : XImage(
                    imagePath: e.icon,
                    width: 50,
                    height: 50,
                    fit: BoxFit.fitWidth,
                  ),
            const SizedBox(height: 8),
            Text(
              e.name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            // const SizedBox(height: 2),
            SizedBox(
              width: 120,
              child: Text(
                e.description,
                textAlign: TextAlign.left,
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(QrType e) {
    return Column(
      children: [
        e.separateWidget,
        InkWell(
          onTap: () {
            onNavi(e);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(e.type == 6 ? 12 : 4),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: e.gradient,
                  ),
                  child: XImage(
                    imagePath: e.icon,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.name,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(e.description,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                const XImage(
                  imagePath: 'assets/images/ic-navigate-next-blue.png',
                  width: 32,
                  // height: 12,
                  fit: BoxFit.fitWidth,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onNavi(QrType e) {
    switch (e.type) {
      case 1:
        NavigatorUtils.navigatePage(
            context, const QrLinkScreen(type: TypeQr.VIETQR),
            routeName: Routes.QR_SCREEN);
        break;
      case 2:
        NavigatorUtils.navigatePage(
            context, const QrLinkScreen(type: TypeQr.QR_LINK),
            routeName: Routes.QR_SCREEN);
        break;
      case 3:
        NavigatorUtils.navigatePage(
            context, const QrLinkScreen(type: TypeQr.VCARD),
            routeName: Routes.QR_SCREEN);
        break;
      case 4:
        NavigatorUtils.navigatePage(
            context, const QrLinkScreen(type: TypeQr.OTHER),
            routeName: Routes.QR_SCREEN);
        break;
      case 5:
        startBarcodeScanStream();
        break;
      case 6:
        break;
      default:
    }
  }

  void startBarcodeScanStream() async {
    final data = await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
    if (data is Map<String, dynamic>) {
      if (!mounted) return;
      QRScannerUtils.instance.onScanNavi(data, context);
      final type = data['type'];
      final typeQR = data['typeQR'] as TypeQR;
      final value = data['data'];
      final bankTypeDTO = data['bankTypeDTO'];
      switch (typeQR) {
        case TypeQR.QR_LINK:
          break;
        case TypeQR.QR_BANK:
          break;
        default:
      }
      print('QrDATA: -------------\n$data');
      // Navigator.of(context).pop();
    }
  }

  void updateState() {
    setState(() {});
  }
}

class QrType {
  final int type;
  final String icon;
  final LinearGradient gradient;
  final String name;
  final String description;
  final Widget separateWidget;

  QrType({
    required this.type,
    required this.icon,
    required this.gradient,
    required this.name,
    required this.description,
    required this.separateWidget,
  });
}
