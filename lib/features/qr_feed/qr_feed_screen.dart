import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/extensions/string_extension.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/account/account_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';
import 'package:vierqr/features/qr_feed/widgets/app_bar_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/qr_feed_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:rive/rive.dart' as rive;

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

  rive.StateMachineController? _riveController;
  late rive.SMITrigger _action;

  final QrFeedBloc _bloc = getIt.get<QrFeedBloc>();

  MetaDataDTO? metadata;

  double height = 0.0;

  List<QrFeedDTO> list = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    initData();
  }

  void initData() {
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (metadata != null) {
            int total = (metadata!.total! / 5).ceil();
            if (total > metadata!.page!) {
              // await getMoreOrders();
              _bloc.add(
                  GetMoreQrFeedEvent(type: tab == TabView.COMMUNITY ? 0 : 1));
            }
          }
        }

        updateState();
      },
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _bloc.add(GetQrFeedEvent(
            isLoading: true, type: tab == TabView.COMMUNITY ? 0 : 1));
        _scrollController.animateTo(_scrollController.position.minScrollExtent,
            duration: const Duration(microseconds: 10), curve: Curves.easeOut);
      },
    );
  }

  List<Widget> listLoading = [
    const _buildLoading(),
    const _buildLoading(),
    const _buildLoading(),
  ];

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> onRefresh() async {
    _bloc.add(GetQrFeedEvent(
        isLoading: false, type: tab == TabView.COMMUNITY ? 0 : 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrFeedBloc, QrFeedState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == QrFeed.GET_QR_FEED_LIST &&
            state.status == BlocStatus.SUCCESS) {
          list = [...state.listQrFeed!];
          metadata = state.metadata;
        }

        if (state.request == QrFeed.GET_MORE &&
            state.status == BlocStatus.SUCCESS) {
          list = [...list, ...state.listQrFeed!];
          metadata = state.metadata;
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            floatingActionButton: _isShowScrollToTop
                ? _scrollToTopWidget()
                : const SizedBox.shrink(),
            backgroundColor: AppColor.BLUE_BGR,
            body: CustomScrollView(
              shrinkWrap: true,
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: AppColor.WHITE,
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
                  ),
                  pinned: true,
                  floating: true,
                ),
                CupertinoSliverRefreshControl(
                  builder: (context, refreshState, pulledExtent,
                      refreshTriggerPullDistance, refreshIndicatorExtent) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      height: 30,
                      width: 30,
                      child: rive.RiveAnimation.asset(
                        'assets/rives/loading_ani',
                        fit: BoxFit.contain,
                        antialiasing: false,
                        animations: const [Stringify.SUCCESS_ANI_INITIAL_STATE],
                        onInit: _onRiveInit,
                      ),
                    );
                  },
                  onRefresh: () => onRefresh(),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: AppColor.BLUE_BGR,
                    // padding: const EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        if (tab == TabView.COMMUNITY) ...[
                          if (state.request == QrFeed.GET_QR_FEED_LIST &&
                              state.status == BlocStatus.LOADING_PAGE)
                            ...listLoading
                          else
                            ...list.map(
                              (e) => _buildQRFeed(dto: e),
                            ),
                          if (state.request == QrFeed.GET_MORE &&
                              state.status == BlocStatus.LOAD_MORE)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: SizedBox(
                                height: 25,
                                width: 25,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 90,
                          ),
                        ]
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
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
                width: MediaQuery.of(context).size.width * 0.64,
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

  Widget _scrollToTopWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: 50,
      height: 50,
      margin: const EdgeInsets.only(bottom: 80, right: 5),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 4,
        onPressed: () {
          _scrollToTop();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          // side: BorderSide(color: Colors.red),
        ),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.GREY_DADADA,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            Icons.arrow_upward_outlined,
            color: AppColor.BLACK,
            size: 15,
          ),
        ),
      ),
    );
  }

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (100 - kToolbarHeight);
  }

  bool get _isShowScrollToTop {
    return _scrollController.hasClients && _scrollController.offset > 200;
  }

  _onRiveInit(rive.Artboard artboard) {
    _riveController = rive.StateMachineController.fromArtboard(
        artboard, Stringify.SUCCESS_ANI_STATE_MACHINE)!;
    artboard.addController(_riveController!);
    _doInitAnimation();
  }

  void _doInitAnimation() {
    _action =
        _riveController!.findInput<bool>(Stringify.SUCCESS_ANI_ACTION_DO_INIT)
            as rive.SMITrigger;
    _action.fire();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  void updateState() {
    setState(() {});
  }
}

// ignore: camel_case_types
class _buildLoading extends StatelessWidget {
  const _buildLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.WHITE,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBlock(
            borderRadius: 100,
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerBlock(height: 15, width: 150, borderRadius: 10),
                  ShimmerBlock(height: 15, width: 20, borderRadius: 10),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.only(right: 100),
                padding: const EdgeInsets.all(10),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBlock(
                      width: 80,
                      height: 80,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerBlock(
                                    width: double.infinity,
                                    height: 12,
                                    borderRadius: 10),
                                SizedBox(height: 2),
                                ShimmerBlock(
                                    width: 100, height: 12, borderRadius: 10),
                              ],
                            ),
                            ShimmerBlock(
                                width: 50, height: 10, borderRadius: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class _buildQRFeed extends StatelessWidget {
  final QrFeedDTO dto;
  const _buildQRFeed({
    required this.dto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.WHITE,
      width: double.infinity,
      // margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          XImage(
            borderRadius: BorderRadius.circular(100),
            imagePath: ImageConstant.icAvatar,
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trương Hiệp Hưng',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          XImage(
                            imagePath: 'assets/images/ic-global.png',
                            width: 15,
                            height: 15,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '3 giờ',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: AppColor.GREY_TEXT),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(right: 25),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: dto.content,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: AppColor.BLACK,
                          ),
                          children: <TextSpan>[
                            // TextSpan(
                            //     text: 'Xem Thêm',
                            //     style: const TextStyle(
                            //         color: AppColor.BLUE_TEXT,
                            //         fontSize: 12,
                            //         decoration: TextDecoration.underline,
                            //         decorationColor: AppColor.BLUE_TEXT),
                            //     recognizer: TapGestureRecognizer()
                            //       ..onTap = () {})
                          ],
                        ),
                      ]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.only(right: 100),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: VietQRTheme.gradientColor.vcard,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QrImageView(
                          data: '',
                          size: 80,
                          backgroundColor: AppColor.WHITE,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: SizedBox(
                            height: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'https://github.com/vanvixi/flutter-momo-sliver-appbar/blob/main/lib/main.dart',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Text(
                                  'VCard',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColor.GREY_TEXT,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const XImage(
                            imagePath: 'assets/images/ic-heart-red.png',
                            height: 15,
                            fit: BoxFit.fitHeight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '156',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppColor.GREY_TEXT,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const SizedBox(width: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const XImage(
                            imagePath: 'assets/images/ic-comment.png',
                            height: 15,
                            fit: BoxFit.fitHeight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '20',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppColor.GREY_TEXT,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const SizedBox(width: 18),
                      const XImage(
                        imagePath: 'assets/images/ic-share.png',
                        height: 15,
                        width: 15,
                        fit: BoxFit.fitWidth,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
