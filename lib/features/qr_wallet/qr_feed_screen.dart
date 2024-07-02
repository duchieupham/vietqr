import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/extensions/string_extension.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/account/account_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/qr_wallet/widgets/app_bar_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

// ignore: constant_identifier_names
enum TabView { COMMUNITY, INDIVIDUAL }

class QrFeedScreen extends StatefulWidget {
  const QrFeedScreen({super.key});

  @override
  State<QrFeedScreen> createState() => _QrFeedScreenState();
}

class _QrFeedScreenState extends State<QrFeedScreen> {
  late ScrollController _scrollController;
  TabView tab = TabView.COMMUNITY;

  double height = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollToTop();
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _scrollController.animateTo(_scrollController.position.minScrollExtent,
            duration: const Duration(microseconds: 10), curve: Curves.easeOut);
        _scrollController.addListener(
          () {
            if (_isAppBarExpanded) {
              height = 30;
              updateState();
            } else {
              height = 0;
              updateState();
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _scrollController.animateTo(_scrollController.position.minScrollExtent,
    //     duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    _scrollController.dispose();
  }

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (100 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.WHITE,
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: kToolbarHeight,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                title: Container(
                  color: AppColor.WHITE,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        AppImages.icLogoVietQr,
                        width: 95,
                        fit: BoxFit.fitWidth,
                      ),
                      _buildAvatar(),
                    ],
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: CustomSliverAppBarDelegate(
                  expandedHeight: 112,
                  widget: _pinnedAppbar(),
                  isExpanded: _isAppBarExpanded),
              pinned: true,
              floating: true,
            ),
            // SliverList(
            //     delegate: SliverChildListDelegate(<Widget>[
            //   SizedBox(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height,
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         // Container(),
            //         // productTitle(),

            //         // _buidProductRecomend(),
            //         // tabCompination()
            //       ],
            //     ),
            //   ),
            // ]))
            SliverToBoxAdapter(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _pinnedAppbar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                tab = TabView.COMMUNITY;
                updateState();
              },
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: tab == TabView.COMMUNITY
                          ? AppColor.TRANSPARENT
                          : AppColor.GREY_DADADA),
                  color: tab == TabView.COMMUNITY
                      ? AppColor.BLUE_TEXT.withOpacity(0.2)
                      : AppColor.WHITE,
                  // border: Border.all(color: AppColor.BLUE_TEXT),
                ),
                child: Center(
                  child: Text(
                    'Cộng đồng',
                    style: TextStyle(
                        fontSize: 12,
                        color: tab == TabView.COMMUNITY
                            ? AppColor.BLUE_TEXT
                            : AppColor.BLACK_TEXT),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                tab = TabView.INDIVIDUAL;
                updateState();
              },
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: tab == TabView.INDIVIDUAL
                          ? AppColor.TRANSPARENT
                          : AppColor.GREY_DADADA),
                  color: tab == TabView.INDIVIDUAL
                      ? AppColor.BLUE_TEXT.withOpacity(0.2)
                      : AppColor.WHITE,
                ),
                child: Center(
                  child: Text(
                    'Cá nhân',
                    style: TextStyle(
                        fontSize: 12,
                        color: tab == TabView.INDIVIDUAL
                            ? AppColor.BLUE_TEXT
                            : AppColor.BLACK_TEXT),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.QR_CREATE_SCREEN).then(
                      (value) {},
                    );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                height: 42,
                width: 290,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: AppColor.GREY_DADADA),
                  color: AppColor.GREY_F0F4FA,
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  'Chào ${SharePrefUtils.getProfile().firstName}, bạn đang nghĩ gì?',
                  style:
                      const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColor.BLUE_TEXT.withOpacity(0.2),
                    ),
                    child: const XImage(
                        imagePath: 'assets/images/ic-scan-content.png'),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColor.GREEN.withOpacity(0.2),
                    ),
                    child: const XImage(
                      fit: BoxFit.fitWidth,
                      width: 42,
                      height: 42,
                      imagePath: 'assets/images/ic-img-picker.png',
                      // svgIconColor: ColorFilter.mode(
                      //     AppColor.RED_TEXT, BlendMode.),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    String imgId = SharePrefUtils.getProfile().imgId;
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
            onTap: () => NavigatorUtils.navigatePage(
                context, const AccountScreen(),
                routeName: AccountScreen.routeName),
            child: SizedBox(
              width: 40,
              height: 40,
              child: XImage(
                borderRadius: BorderRadius.circular(100),
                imagePath: provider.avatarUser.path.isEmpty
                    ? imgId.isNotEmpty
                        ? imgId.getPathIMageNetwork
                        : ImageConstant.icAvatar
                    : provider.avatarUser.path,
                errorWidget: XImage(
                  borderRadius: BorderRadius.circular(100),
                  imagePath: ImageConstant.icAvatar,
                  width: 40,
                  height: 40,
                ),
              ),
            ));
      },
    );
  }

  void updateState() {
    setState(() {});
  }
}
