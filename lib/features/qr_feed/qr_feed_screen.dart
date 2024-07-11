import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/extensions/string_extension.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/scroll_indicator.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/account/account_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';
import 'package:vierqr/features/qr_feed/views/qr_detail_screen.dart';
import 'package:vierqr/features/qr_feed/views/qr_private_screen.dart';
import 'package:vierqr/features/qr_feed/views/qr_style.dart';
import 'package:vierqr/features/qr_feed/widgets/app_bar_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/qr_feed_dto.dart';
import 'package:vierqr/models/qr_feed_folder_dto.dart';
import 'package:vierqr/models/qr_feed_private_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';
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
  late TextEditingController _searchController;
  late ScrollController _scrollController;

  TabView tab = TabView.COMMUNITY;

  FocusNode focusNode = FocusNode();
  // bool isClear = false;

  rive.StateMachineController? _riveController;
  late rive.SMITrigger _action;

  final QrFeedBloc _bloc = getIt.get<QrFeedBloc>();

  MetaDataDTO? metadata;
  MetaDataDTO? privateMetadata;

  double height = 0.0;

  List<QrFeedDTO> list = [];

  QrFeedDTO? qrFeedAction;
  String selectedQrId = '';

  final ValueNotifier<bool> _notifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isClearNotifier = ValueNotifier<bool>(false);

  QRTypeDTO _qrTypeDTO = const QRTypeDTO(
    type: 9,
    name: 'Tất cả',
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _searchController = TextEditingController();
    initData();
  }

  void initData() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _scrollController.addListener(
          () {
            _notifier.value = _isShowScrollToTop;
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              if (tab == TabView.COMMUNITY) {
                if (metadata != null) {
                  int total = (metadata!.total! / 10).ceil();
                  if (total > metadata!.page!) {
                    // await getMoreOrders();
                    _bloc.add(GetMoreQrFeedEvent(
                      type: tab == TabView.COMMUNITY ? 0 : 1,
                    ));
                  }
                }
              } else {
                if (privateMetadata != null) {
                  int total = (privateMetadata!.total! / 20).ceil();
                  if (total > privateMetadata!.page!) {
                    // await getMoreOrders();
                    _bloc.add(GetMoreQrPrivateEvent(
                        type: tab == TabView.COMMUNITY ? 0 : 1,
                        value: _searchController.text,
                        page: privateMetadata!.page! + 1));
                  }
                }
              }
            }

            // updateState();
          },
        );
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        if (tab == TabView.COMMUNITY) {
          _bloc.add(GetQrFeedEvent(
              isLoading: true, type: tab == TabView.COMMUNITY ? 0 : 1));
        } else {
          _bloc.add(GetQrFeedPrivateEvent(
              type: _qrTypeDTO.type,
              isGetFolder: true,
              isFolderLoading: true,
              value: ''));
          // _bloc.add(GetQrFeedFolderEvent());
        }

        // _searchController.addListener(
        //   () {
        //     if (_searchController.text.isNotEmpty) {
        //       isClear = true;
        //     } else {
        //       isClear = false;
        //     }
        //     // updateState();
        //   },
        // );
      },
    );
  }

  List<Widget> listLoading = [
    const _buildLoading(),
    const _buildLoading(),
    const _buildLoading(),
    const _buildLoading(),
  ];

  @override
  void dispose() {
    super.dispose();
    // tab = TabView.COMMUNITY;
    _scrollController.dispose();
    _searchController.dispose();
  }

  Future<void> onRefresh() async {
    if (tab == TabView.COMMUNITY) {
      _bloc.add(GetQrFeedEvent(
          isLoading: true, type: tab == TabView.COMMUNITY ? 0 : 1));
    } else {
      _bloc.add(GetQrFeedPrivateEvent(
          type: _qrTypeDTO.type,
          isGetFolder: true,
          isFolderLoading: true,
          value: ''));
      // _bloc.add(GetQrFeedFolderEvent());
    }
  }

  void startBarcodeScanStream() async {
    final data = await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
    if (data is Map<String, dynamic>) {
      if (!mounted) return;
      // QRScannerUtils.instance.onScanNavi(data, context);
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrFeedBloc, QrFeedState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == QrFeed.CREATE_QR &&
            state.status == BlocStatus.SUCCESS) {
          _bloc.add(GetQrFeedEvent(
            isLoading: true,
            type: tab == TabView.COMMUNITY ? 0 : 1,
          ));
        }

        if (state.request == QrFeed.GET_DETAIL_QR &&
            state.status == BlocStatus.SUCCESS) {
          Navigator.of(context).pushNamed(Routes.QR_DETAIL_SCREEN, arguments: {
            'id': state.qrId,
            'isPublic': true,
            'folderId': state.folderId
          }).then(
            (value) {
              final folderId = value as String;
              if (folderId.isNotEmpty) {
                _bloc.add(GetFolderDetailEvent(
                    value: '', type: 9, folderId: folderId));
              }
            },
          );
        }
      },
      builder: (context, state) {
        if (state.request == QrFeed.GET_QR_FEED_LIST &&
            state.status == BlocStatus.SUCCESS) {
          list = [...state.listQrFeed!];
          metadata = state.metadata;
          // updateState();
        }
        if (state.request == QrFeed.GET_QR_FEED_PRIVATE &&
            state.status == BlocStatus.SUCCESS) {
          privateMetadata = state.privateMetadata;
          // updateState();
        }

        if (state.request == QrFeed.GET_QR_FEED_LIST &&
            state.status == BlocStatus.NONE) {
          list = [];
          metadata = state.metadata;
          // updateState();
        }

        if (state.request == QrFeed.GET_MORE &&
            state.status == BlocStatus.SUCCESS) {
          list = [...list, ...state.listQrFeed!];
          metadata = state.metadata;
          // updateState();
        }
        if (state.request == QrFeed.GET_MORE_QR &&
            state.status == BlocStatus.SUCCESS) {
          privateMetadata = state.privateMetadata;
          // updateState();
        }

        if (state.request == QrFeed.INTERACT_WITH_QR &&
            state.status == BlocStatus.SUCCESS) {
          qrFeedAction = state.qrFeed;
          final indexOfQr = list.indexWhere((e) => e.id == state.qrFeed?.id);
          list[indexOfQr] = state.qrFeed!;
          // updateState();
        }
        return SafeArea(
          child: Scaffold(
            floatingActionButton: _scrollToTopWidget(),
            backgroundColor: AppColor.WHITE,
            body: CustomScrollView(
              shrinkWrap: true,
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
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
                    expandedHeight: tab == TabView.COMMUNITY ? 112 : 162,
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
                if (tab == TabView.COMMUNITY)
                  SliverToBoxAdapter(
                    child: Container(
                      color: AppColor.WHITE,
                      width: MediaQuery.of(context).size.width,
                      // height: (list.isEmpty || list.length < 4)
                      //     ? MediaQuery.of(context).size.height - 150
                      //     : null,
                      child: Column(
                        children: [
                          if (state.request == QrFeed.GET_QR_FEED_LIST &&
                              state.status == BlocStatus.LOADING_PAGE)
                            ...listLoading
                          else
                            ...list.map(
                              (e) => _buildQRFeed(
                                onTap: (id) {
                                  selectedQrId = id;
                                  updateState();
                                },
                                dto: e,
                              ),
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
                        ],
                      ),
                    ),
                  )
                else
                  QrPrivateScreen(
                    listGradient: _gradients,
                    onDetail: (qrId) {
                      _bloc
                          .add(GetQrFeedDetailEvent(id: qrId, isLoading: true));
                      setState(() {
                        selectedQrId = qrId;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  final List<List<Color>> _gradients = [
    [const Color(0xFFE1EFFF), const Color(0xFFE5F9FF)],
    [const Color(0xFFBAFFBF), const Color(0xFFCFF4D2)],
    [const Color(0xFFFFC889), const Color(0xFFFFDCA2)],
    [const Color(0xFFA6C5FF), const Color(0xFFC5CDFF)],
    [const Color(0xFFCDB3D4), const Color(0xFFF7C1D4)],
    [const Color(0xFFF5CEC7), const Color(0xFFFFD7BF)],
    [const Color(0xFFBFF6FF), const Color(0xFFFFDBE7)],
    [const Color(0xFFF1C9FF), const Color(0xFFFFB5AC)],
    [const Color(0xFFB4FFEE), const Color(0xFFEDFF96)],
    [const Color(0xFF91E2FF), const Color(0xFF91FFFF)],
    [const Color(0xFFFFFFFF), const Color(0xFFF0F4FA)],
  ];

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
                _bloc.add(const GetQrFeedEvent(isLoading: true, type: 0));

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
                _bloc.add(GetQrFeedPrivateEvent(
                    type: _qrTypeDTO.type,
                    isGetFolder: true,
                    isFolderLoading: true,
                    value: _searchController.text));
                // _bloc.add(GetQrFeedFolderEvent());
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
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (tab == TabView.COMMUNITY)
              Expanded(
                child: InkWell(
                  onTap: () {
                    NavigationService.push(Routes.QR_CREATE_SCREEN);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    height: 42,
                    // width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.circular(40),
                      border: Border(
                          bottom: BorderSide(color: AppColor.GREY_DADADA)),
                      // color: AppColor.GREY_F0F4FA,
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      'Chào ${SharePrefUtils.getProfile().firstName}, bạn đang nghĩ gì?',
                      style: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                  ),
                ),
              ),
            if (tab == TabView.INDIVIDUAL)
              ValueListenableBuilder<bool>(
                valueListenable: _isClearNotifier,
                builder: (context, isClear, child) {
                  return Expanded(
                    child: MTextFieldCustom(
                        focusNode: focusNode,
                        controller: _searchController,
                        prefixIcon: const XImage(
                          imagePath: 'assets/images/ic-search-grey.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                        suffixIcon: isClear
                            ? InkWell(
                                onTap: () {
                                  _searchController.clear();
                                  updateState();
                                },
                                child: const Icon(
                                  Icons.clear,
                                  size: 20,
                                  color: AppColor.GREY_DADADA,
                                ),
                              )
                            : const SizedBox.shrink(),
                        enable: true,
                        focusBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor.GREY_DADADA)),
                        contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        hintText: 'Tìm kiếm mã QR theo tên',
                        keyboardAction: TextInputAction.next,
                        onSubmitted: (t) {
                          _bloc.add(GetQrFeedPrivateEvent(
                              type: _qrTypeDTO.type,
                              isGetFolder: false,
                              isFolderLoading: false,
                              value: _searchController.text));
                        },
                        onChange: (value) {
                          if (value.isNotEmpty) {
                            isClear = true;
                          } else {
                            isClear = false;
                          }
                        },
                        inputType: TextInputType.text,
                        isObscureText: false),
                  );
                },
              ),
            const SizedBox(width: 10),
            if (tab == TabView.INDIVIDUAL)
              InkWell(
                onTap: () {
                  NavigationService.push(Routes.QR_CREATE_SCREEN).then(
                    (value) {},
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColor.BLUE_TEXT.withOpacity(0.2),
                  ),
                  child: const XImage(
                    fit: BoxFit.cover,
                    width: 42,
                    height: 42,
                    imagePath: 'assets/images/ic-plus-black.png',
                    // svgIconColor: ColorFilter.mode(
                    //     AppColor.RED_TEXT, BlendMode.),
                  ),
                ),
              ),
            const SizedBox(width: 10),

            InkWell(
              onTap: startBarcodeScanStream,
              child: Container(
                padding: const EdgeInsets.all(4),
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColor.BLUE_TEXT.withOpacity(0.2),
                ),
                child: const XImage(
                    imagePath: 'assets/images/ic-scan-content-black.png'),
              ),
            ),
            // InkWell(
            //   onTap: () {},
            //   child: Container(
            //     padding: const EdgeInsets.all(13),
            //     height: 42,
            //     width: 42,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(100),
            //       color: AppColor.GREEN.withOpacity(0.2),
            //     ),
            //     child: const XImage(
            //       fit: BoxFit.fitWidth,
            //       width: 42,
            //       height: 42,
            //       imagePath: 'assets/images/ic-img-picker.png',
            //       // svgIconColor: ColorFilter.mode(
            //       //     AppColor.RED_TEXT, BlendMode.),
            //     ),
            //   ),
            // )
          ],
        ),
        if (tab == TabView.INDIVIDUAL)
          Container(
            padding: const EdgeInsets.only(bottom: 0, top: 15),
            width: double.infinity,
            height: 50,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      _qrTypeDTO = _qrTypeList[index];
                      _bloc.add(GetQrFeedPrivateEvent(
                          type: _qrTypeDTO.type,
                          isGetFolder: true,
                          isFolderLoading: false,
                          value: _searchController.text));
                      updateState();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: _qrTypeDTO == _qrTypeList[index]
                            ? AppColor.BLUE_TEXT.withOpacity(0.2)
                            : AppColor.WHITE,
                      ),
                      child: Center(
                        child: Text(
                          _qrTypeList[index].name,
                          style: TextStyle(
                              fontSize: 10,
                              color: _qrTypeDTO == _qrTypeList[index]
                                  ? AppColor.BLACK
                                  : AppColor.GREY_TEXT),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: _qrTypeList.length),
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
    return ValueListenableBuilder<bool>(
      valueListenable: _notifier,
      builder: (context, value, child) {
        if (value == false) {
          return const SizedBox.shrink();
        }
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
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.arrow_upward_outlined,
                color: AppColor.BLACK,
                size: 15,
              ),
            ),
          ),
        );
      },
    );
  }

  final List<QRTypeDTO> _qrTypeList = const [
    QRTypeDTO(type: 9, name: 'Tất cả'),
    QRTypeDTO(type: 3, name: 'VietQR'),
    QRTypeDTO(type: 2, name: 'VCard'),
    QRTypeDTO(type: 0, name: 'QR Link'),
    QRTypeDTO(type: 1, name: 'Khác'),
  ];

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
                  // ShimmerBlock(height: 15, width: 20, borderRadius: 10),
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
  final Function(String) onTap;
  const _buildQRFeed({
    required this.dto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<List<Color>> _gradients = [
      [const Color(0xFFE1EFFF), const Color(0xFFE5F9FF)],
      [const Color(0xFFBAFFBF), const Color(0xFFCFF4D2)],
      [const Color(0xFFFFC889), const Color(0xFFFFDCA2)],
      [const Color(0xFFA6C5FF), const Color(0xFFC5CDFF)],
      [const Color(0xFFCDB3D4), const Color(0xFFF7C1D4)],
      [const Color(0xFFF5CEC7), const Color(0xFFFFD7BF)],
      [const Color(0xFFBFF6FF), const Color(0xFFFFDBE7)],
      [const Color(0xFFF1C9FF), const Color(0xFFFFB5AC)],
      [const Color(0xFFB4FFEE), const Color(0xFFEDFF96)],
      [const Color(0xFF91E2FF), const Color(0xFF91FFFF)],
    ];

    String qrType = '';
    switch (dto.qrType) {
      case '0':
        qrType = 'Mã QR link';
        break;
      case '1':
        qrType = 'Mã QR khác';
        break;
      case '2':
        qrType = 'Mã QR VCard';
        break;
      case '3':
        qrType = 'Mã VietQR';

        break;
      default:
    }
    return Container(
      color: AppColor.WHITE,
      width: double.infinity,
      // margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              XImage(
                borderRadius: BorderRadius.circular(100),
                imagePath: dto.imageId.isNotEmpty
                    ? dto.imageId
                    : ImageConstant.icAvatar,
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 7),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.fullName.isNotEmpty ? dto.fullName : 'Undefined',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 3),
                  Row(
                    children: [
                      const XImage(
                        imagePath: 'assets/images/ic-global.png',
                        width: 12,
                        height: 12,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        TimeUtils.instance
                            .formatTimeNotification(dto.timeCreated),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: AppColor.GREY_TEXT),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ReadMoreText(
            dto.description,
            trimLines: 2,
            trimCollapsedText: 'Xem thêm',
            trimExpandedText: '\nĐóng',
            trimMode: TrimMode.Line,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          // AutoSizeText.rich(
          //   TextSpan(
          //     text: dto.description,
          //     style: const TextStyle(
          //       fontSize: 12,
          //       fontWeight: FontWeight.normal,
          //       color: AppColor.BLACK,
          //     ),
          //     children: <TextSpan>[
          //       // TextSpan(
          //       //     text: 'Xem Thêm',
          //       //     style: const TextStyle(
          //       //         color: AppColor.BLUE_TEXT,
          //       //         fontSize: 12,
          //       //         decoration: TextDecoration.underline,
          //       //         decorationColor: AppColor.BLUE_TEXT),
          //       //     recognizer: TapGestureRecognizer()..onTap = () {})
          //     ],
          //   ),
          //   minFontSize: 12,
          //   maxLines: 2,
          //   overflow: TextOverflow.ellipsis,
          // ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              getIt
                  .get<QrFeedBloc>()
                  .add(GetQrFeedDetailEvent(id: dto.id, isLoading: true));
              onTap(dto.id);
            },
            child: Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  colors: _gradients[int.parse(dto.theme) - 1],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    color: AppColor.WHITE,
                    // padding: EdgeInsets.all(dto.qrType == '2' ? 0 : 0),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: QrImageView(
                        // gapless: dto.qrType != '2' ? true : true,
                        padding: dto.qrType == '2'
                            ? const EdgeInsets.all(10)
                            : EdgeInsets.zero,
                        data: dto.value,
                        size: dto.qrType == '2' ? 100 : 90,
                        backgroundColor: AppColor.WHITE,
                        embeddedImage: ImageUtils.instance
                            .getImageNetworkCache(dto.fileAttachmentId),

                        embeddedImageStyle: const QrEmbeddedImageStyle(
                          size: Size(20, 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dto.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            dto.data,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Text(
                              qrType,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColor.GREY_TEXT,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,

                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      getIt.get<QrFeedBloc>().add(
                                          InteractWithQrEvent(
                                              qrWalletId: dto.id,
                                              interactionType:
                                                  dto.hasLiked ? '0' : '1'));
                                    },
                                    child: XImage(
                                      imagePath: dto.hasLiked
                                          ? 'assets/images/ic-heart-red.png'
                                          : 'assets/images/ic-heart-black.png',
                                      height: 25,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Text(
                                    dto.likeCount.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColor.GREY_TEXT,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              InkWell(
                                onTap: () {
                                  getIt.get<QrFeedBloc>().add(
                                      GetQrFeedDetailEvent(
                                          id: dto.id, isLoading: true));
                                  onTap(dto.id);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const XImage(
                                      imagePath: 'assets/images/ic-comment.png',
                                      height: 25,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    Text(
                                      dto.commentCount.toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColor.GREY_TEXT,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      Routes.QR_SAVE_SHARE_SCREEN,
                                      arguments: {
                                        'type': TypeImage.SHARE,
                                        'title': dto.title,
                                        'data': dto.data,
                                        'value': dto.value,
                                        'fileAttachmentId':
                                            dto.fileAttachmentId,
                                        'qrType': dto.qrType,
                                        'theme': dto.theme,
                                      });
                                },
                                child: const XImage(
                                  imagePath: 'assets/images/ic-share-black.png',
                                  width: 25,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QRTypeDTO {
  final int type;
  final String name;

  const QRTypeDTO({
    this.type = 9,
    this.name = 'Tất cả',
  });
}
