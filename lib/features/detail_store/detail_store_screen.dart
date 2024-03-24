import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/models/store/detail_store_dto.dart';

import 'detail_store.dart';

enum FlowTab { INFO, STORE, TRANS }

extension PageIndex on int {
  FlowTab get tab {
    switch (this) {
      case 1:
        return FlowTab.STORE;
      case 2:
        return FlowTab.TRANS;
      default:
        return FlowTab.INFO;
    }
  }
}

extension FlowTabExt on FlowTab {
  int get tabIndex {
    switch (this) {
      case FlowTab.STORE:
        return 1;
      case FlowTab.TRANS:
        return 2;
      default:
        return 0;
    }
  }
}

class DetailStoreScreen extends StatefulWidget {
  static String routeName = '/DetailStoreScreen';

  final String terminalId;
  final String terminalCode;
  final String terminalName;

  const DetailStoreScreen(
      {super.key,
      required this.terminalId,
      required this.terminalCode,
      required this.terminalName});

  @override
  State<DetailStoreScreen> createState() => _DetailStoreScreenState();
}

class _DetailStoreScreenState extends State<DetailStoreScreen> {
  FlowTab tab = FlowTab.INFO;
  late PageController _controller;

  DetailStoreDTO detailStoreDTO = DetailStoreDTO();

  List<TabData> _tabs = [
    TabData(title: 'Thông tin', type: FlowTab.INFO),
    TabData(title: 'VietQR cửa hàng', type: FlowTab.STORE),
    TabData(title: 'Giao dịch', type: FlowTab.TRANS),
  ];

  bool get isVietQRStore => tab == FlowTab.STORE;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0, keepPage: true);
    detailStoreDTO = DetailStoreDTO(
      terminalId: widget.terminalId,
      terminalCode: widget.terminalCode,
      terminalName: widget.terminalName,
    );
  }

  _handleBack(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          _buildAppBar(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 120),
                _buildTabBar(),
                const SizedBox(height: 24),
                Expanded(
                  child: PageView(
                    key: const PageStorageKey('PAGE_VIEW'),
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _controller,
                    onPageChanged: _onChangedPage,
                    children: [
                      DetailStoreView(
                        terminalId: widget.terminalId,
                        callBack: _onChangedPage,
                        updateStore: _updateStore,
                      ),
                      VietQRStoreView(
                        terminalId: widget.terminalId,
                      ),
                      TransStoreView(
                        detailStoreDTO: detailStoreDTO,
                      ),
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

  Widget _buildAppBar(BuildContext context) {
    double paddingTop = MediaQuery.of(context).viewPadding.top;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<AuthProvider>(
      builder: (context, page, child) {
        File file = page.bannerApp;
        return Container(
          height: isVietQRStore ? height : 230,
          width: width,
          padding: EdgeInsets.only(top: paddingTop + 12),
          alignment: Alignment.topCenter,
          decoration: isVietQRStore
              ? BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg-qr-vqr.png'),
                    fit: BoxFit.fitHeight,
                  ),
                )
              : BoxDecoration(
                  image: file.path.isNotEmpty
                      ? DecorationImage(
                          image: FileImage(file), fit: BoxFit.fitWidth)
                      : DecorationImage(
                          image: AssetImage('assets/images/bgr-header.png'),
                          fit: BoxFit.fitWidth)),
          child: Stack(
            children: [
              if (!isVietQRStore)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Theme.of(context).scaffoldBackgroundColor,
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(0.1),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          tileMode: TileMode.clamp),
                    ),
                  ),
                ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _handleBack(context),
                    padding: const EdgeInsets.only(left: 20),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: isVietQRStore ? Colors.white : Colors.black,
                      size: 18,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Cửa hàng',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isVietQRStore ? Colors.white : Colors.black,
                        height: 1.4,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .popUntil((route) => route.isFirst),
                    child: Container(
                      width: 50,
                      height: 40,
                      margin: const EdgeInsets.only(right: 20),
                      child: CachedNetworkImage(
                        imageUrl: page.settingDTO.logoUrl,
                        height: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isVietQRStore ? AppColor.WHITE : AppColor.BLUE_TEXT),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          TabData model = _tabs[index];
          return Expanded(
            child: _itemTab(model, index),
          );
        }),
      ),
    );
  }

  Widget _itemTab(TabData model, int index) {
    bool isSelected = tab == model.type;
    return GestureDetector(
      onTap: () => _onChangedPage(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isSelected
              ? isVietQRStore
                  ? AppColor.WHITE.withOpacity(0.3)
                  : AppColor.BLUE_TEXT.withOpacity(0.3)
              : AppColor.TRANSPARENT,
        ),
        child: Text(
          model.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? isVietQRStore
                    ? AppColor.WHITE
                    : AppColor.BLUE_TEXT
                : isVietQRStore
                    ? AppColor.WHITE
                    : AppColor.textBlack,
          ),
        ),
      ),
    );
  }

  void _onChangedPage(int page) {
    setState(() => tab = page.tab);
    try {
      _controller.jumpToPage(page);
    } catch (e) {
      _controller = PageController(
        initialPage: tab.tabIndex,
        keepPage: true,
      );
      _onChangedPage(page);
    }
  }

  _updateStore(DetailStoreDTO value) {
    detailStoreDTO = value;
    setState(() {});
  }
}

class TabData {
  final String title;
  final FlowTab type;

  TabData({required this.title, required this.type});
}
