import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';
import 'package:vierqr/features/qr_feed/widgets/default_appbar_widget.dart';
import 'package:vierqr/features/qr_feed/widgets/pop_up_qr_detail_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/qr_create_type_dto.dart';
import 'package:vierqr/models/qr_feed_detail_dto.dart';
import 'package:vierqr/models/qr_feed_popup_detail_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class QrDetailScreen extends StatefulWidget {
  final String id;
  const QrDetailScreen({
    super.key,
    required this.id,
  });

  @override
  State<QrDetailScreen> createState() => _QrDetailScreenState();
}

class _QrDetailScreenState extends State<QrDetailScreen> {
  String get userId => SharePrefUtils.getProfile().userId;

  final QrFeedBloc _bloc = getIt.get<QrFeedBloc>();

  final _cmtController = TextEditingController();
  final scrollController = ScrollController();

  FocusNode focusNode = FocusNode();

  MetaDataDTO? metadata;
  List<Comment> list = [];
  QrInteract qrInteract = QrInteract();

  bool isLoading = true;

  Timer? _timer;
  double _inputHeight = 40;
  bool isExpand = false;
  String qrType = '';
  QrFeedPopupDetailDTO? qrFeedPopupDetailDTO;
  final globalKey = GlobalKey();

  // void share() async {
  //   await ShareUtils.instance
  //       .shareImage(
  //           key: globalKey,
  //           textSharing: ShareUtils.instance.getTextSharing())
  //       .then((value) {
  //     Navigator.pop(context);
  //   });
  // }

  void onSaveImage(BuildContext context) async {
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await ShareUtils.instance.saveImageToGallery(globalKey).then(
          (value) {
            // Navigator.pop(context);
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        focusNode.addListener(
          () {
            if (focusNode.hasFocus) {
              scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut);
              isExpand = true;
            } else {
              isExpand = false;
            }
            updateState();
          },
        );
        scrollController.addListener(
          () {
            if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent) {
              if (metadata != null) {
                int total = (metadata!.total! / 10).ceil();
                if (total > metadata!.page!) {
                  _bloc.add(LoadConmmentEvent(
                      id: widget.id,
                      isLoadMore: true,
                      isLoading: false,
                      page: metadata?.page));
                }
              }
            }

            updateState();
          },
        );
        _cmtController.addListener(_checkInputHeight);
        _timer = Timer.periodic(
          const Duration(seconds: 20),
          (timer) {
            _bloc.add(LoadConmmentEvent(
                id: widget.id,
                isLoadMore: false,
                isLoading: false,
                size: list.length));
          },
        );
        _bloc.add(GetQrFeedPopupDetailEvent(qrWalletId: widget.id));
      },
    );

    // focusNode.addListener(
    //   () {
    //     if (!focusNode.hasFocus) {
    //       setState(() {
    //         _inputHeight = 40;
    //       });
    //     }
    //   },
    // );
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading = false;
    updateState();
  }

  Future<void> onRefresh() async {
    _bloc.add(
        LoadConmmentEvent(id: widget.id, isLoadMore: false, isLoading: true));
  }

  @override
  void dispose() {
    _timer?.cancel();
    focusNode.dispose();
    _cmtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrFeedBloc, QrFeedState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == QrFeed.ADD_CMT &&
            state.status == BlocStatus.SUCCESS) {
          focusNode.unfocus();
          _cmtController.clear();
          updateState();
          onRefresh();
        }
        if (state.request == QrFeed.GET_QR_FEED_POPUP_DETAIL &&
            state.status == BlocStatus.SUCCESS) {
          qrFeedPopupDetailDTO = state.qrFeedPopupDetail;
          updateState();
        }
        if (state.request == QrFeed.LOAD_CMT &&
            state.status == BlocStatus.SUCCESS) {
          metadata = state.detailMetadata;
          final detail = state.loadCmt;

          if (detail != null) {
            qrInteract = QrInteract(
              likes: detail.likeCount,
              cmt: detail.commentCount,
              hasLike: detail.hasLiked == 1 ? true : false,
              timeCreate: detail.timeCreated,
            );
            list = [...detail.comments.data];
          }
          updateState();
        }
        if (state.request == QrFeed.LOAD_CMT &&
            state.status == BlocStatus.LOAD_MORE) {
          metadata = state.detailMetadata;
          final detail = state.loadCmt;

          if (detail != null) {
            qrInteract = QrInteract(
              likes: detail.likeCount,
              cmt: detail.commentCount,
              hasLike: detail.hasLiked == 1 ? true : false,
              timeCreate: detail.timeCreated,
            );
            list = [...list, ...detail.comments.data];
          }
          updateState();
        }

        if (state.request == QrFeed.INTERACT_WITH_QR &&
            state.status == BlocStatus.SUCCESS) {
          final result = state.qrFeed;
          if (result != null) {
            qrInteract = QrInteract(
              likes: result.likeCount,
              cmt: result.commentCount,
              timeCreate: result.timeCreated,
              hasLike: result.hasLiked,
            );
          }
          updateState();
        }
      },
      builder: (context, state) {
        if (state.request == QrFeed.GET_DETAIL_QR &&
            state.status == BlocStatus.SUCCESS) {
          metadata = state.detailMetadata;
          final detail = state.detailQr;

          if (detail != null) {
            qrInteract = QrInteract(
              likes: detail.likeCount,
              cmt: detail.commentCount,
              hasLike: detail.hasLiked == 1 ? true : false,
              timeCreate: detail.timeCreated,
            );
            list = [...detail.comments.data];
            qrType = detail.qrType;
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: _buildAppBar(state.detailQr!),
          bottomNavigationBar: _bottom(state.detailQr!, interact: qrInteract),
          body: RefreshIndicator(
            displacement: 0,
            edgeOffset: 0,
            onRefresh: () => onRefresh(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  child: _buildBody(state.detailQr!,
                      state: state, interact: qrInteract)),
            ),
          ),
          // body: CustomScrollView(
          //   physics: const NeverScrollableScrollPhysics(),
          //   slivers: [
          //     _buildAppBar(state.detailQr!),
          //     SliverToBoxAdapter(
          //       child: Container(
          //         padding: const EdgeInsets.symmetric(vertical: 20),
          //         width: MediaQuery.of(context).size.width,
          //         // height: MediaQuery.of(context).size.height,
          //         child: _buildBody(state.detailQr!),
          //       ),
          //     )
          //   ],
          // ),
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
  ];

  Widget _buildBody(QrFeedDetailDTO e,
      {required QrFeedState state, required QrInteract interact}) {
    String qrType = '';
    switch (e.qrType) {
      case '0':
        qrType = 'QR đường dẫn';
        break;
      case '1':
        qrType = 'QR khác';
        break;
      case '2':
        qrType = 'VCard';
        break;
      case '3':
        qrType = 'VietQR';

        break;
      default:
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RepaintBoundaryWidget(
          globalKey: globalKey,
          builder: (key) {
            return Container(
              height: 420,
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                    colors: _gradients[0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
              ),
              child: Container(
                // height: 450,
                margin: const EdgeInsets.fromLTRB(30, 25, 30, 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColor.WHITE,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColor.TRANSPARENT,
                            ),
                          ),
                          isLoading == false
                              ? Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        e.title,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        e.data,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                )
                              : const ShimmerBlock(
                                  height: 20,
                                  width: 150,
                                  borderRadius: 50,
                                ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColor.GREY_F0F4FA,
                              ),
                              child: const XImage(
                                imagePath: 'assets/images/ic-save-blue.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: isLoading == false
                          ? Container(
                              height: 250,
                              width: 250,
                              margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                              child: QrImageView(
                                padding: EdgeInsets.zero,
                                data: e.value,
                                size: 80,
                                backgroundColor: AppColor.WHITE,
                                embeddedImage: ImageUtils.instance
                                    .getImageNetworkCache(e.fileAttachmentId),
                                embeddedImageStyle: const QrEmbeddedImageStyle(
                                  size: Size(50, 50),
                                ),
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.all(25),
                              child: const ShimmerBlock(
                                width: 250,
                                height: 250,
                              ),
                            ),
                    ),
                    isLoading == false
                        ? Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              '$qrType   |   By VIETQR.VN',
                              style: const TextStyle(
                                  fontSize: 10, color: AppColor.GREY_TEXT),
                            ),
                          )
                        : const ShimmerBlock(
                            height: 10,
                            width: 100,
                            borderRadius: 50,
                          ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 25),
        if (isLoading == false)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              e.description,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 12),
            ),
          )
        else ...[
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBlock(
                  height: 12,
                  width: MediaQuery.of(context).size.width - 200,
                  borderRadius: 50,
                ),
                const SizedBox(height: 8),
                ShimmerBlock(
                  height: 12,
                  width: MediaQuery.of(context).size.width - 300,
                  borderRadius: 50,
                ),
                const SizedBox(height: 8),
              ],
            ),
          )
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 20, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _bloc.add(InteractWithQrEvent(
                          qrWalletId: e.id,
                          interactionType: qrInteract.hasLike ? '0' : '1'));
                    },
                    child: XImage(
                      imagePath: interact.hasLike
                          ? 'assets/images/ic-heart-red.png'
                          : 'assets/images/ic-heart-grey.png',
                      height: 35,
                      width: 35,
                      fit: BoxFit.cover,
                    ),
                    // child: XImage(
                    //   imagePath: dto.hasLiked
                    //       ? 'assets/images/ic-heart-red.png'
                    //       : 'assets/images/ic-heart-grey.png',
                    //   height: 50,
                    //   fit: BoxFit.fitHeight,
                    // ),
                  ),
                  Text(
                    interact.likes.toString(),
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.GREY_TEXT,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              const SizedBox(width: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const XImage(
                    imagePath: 'assets/images/ic-comment-grey.png',
                    height: 35,
                    width: 35,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    interact.cmt.toString(),
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.GREY_TEXT,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              const Spacer(),
              if (interact.timeCreate != 0 && isLoading == false)
                Row(
                  children: [
                    const XImage(
                      imagePath: 'assets/images/ic-global.png',
                      width: 15,
                      height: 15,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      // TimeUtils.instance.formatTimeNotification(dto.timeCreated),
                      TimeUtils.instance
                          .formatTimeNotification(interact.timeCreate),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: AppColor.GREY_TEXT),
                    )
                  ],
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
        const MySeparator(
          color: AppColor.GREY_DADADA,
        ),
        if (isLoading ||
            (state.request == QrFeed.LOAD_CMT &&
                state.status == BlocStatus.LOADING_PAGE)) ...[
          _loadingCmt(),
          _loadingCmt(),
          _loadingCmt(),
        ] else if (list.isNotEmpty && isLoading == false)
          ...list.map(
            (e) => _buildCommend(e),
          ),
        if (state.request == QrFeed.LOAD_CMT &&
            state.status == BlocStatus.LOADING)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _loadingCmt() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBlock(
            width: 30,
            height: 30,
            borderRadius: 100,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBlock(
                  height: 12,
                  width: 300,
                  borderRadius: 50,
                ),
                SizedBox(height: 4),
                ShimmerBlock(
                  height: 12,
                  width: 200,
                  borderRadius: 50,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCommend(Comment commend) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.bounceInOut,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          XImage(
            borderRadius: BorderRadius.circular(100),
            imagePath: commend.imageId.isNotEmpty
                ? commend.imageId
                : ImageConstant.icAvatar,
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commend.id == userId ? 'Tôi' : commend.fullName,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                // const SizedBox(height: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 80, // Giới hạn chiều cao của bình luận
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      commend.message,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          if (isLoading == false)
            Text(
              TimeUtils.instance.formatTimeNotification(commend.timeCreated),
              style: const TextStyle(
                fontSize: 12,
                color: AppColor.GREY_TEXT,
              ),
            ),
        ],
      ),
    );
  }

  Widget _bottom(QrFeedDetailDTO e, {required QrInteract interact}) {
    return Container(
      // height: 70 +
      //     (MediaQuery.of(context).viewInsets.bottom > 0.0
      //         ? MediaQuery.of(context).viewInsets.bottom - 7
      //         : 0),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(
          20,
          MediaQuery.of(context).viewInsets.bottom > 0.0 ? 8 : 10,
          20,
          MediaQuery.of(context).viewInsets.bottom > 0.0
              ? MediaQuery.of(context).viewInsets.bottom + 8
              : 20),
      decoration: BoxDecoration(color: AppColor.WHITE, boxShadow: [
        BoxShadow(
          color: AppColor.BLACK.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, -1),
        ),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: () {
              _bloc.add(InteractWithQrEvent(
                  qrWalletId: widget.id,
                  interactionType: interact.hasLike ? '0' : '1'));
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                      colors: _gradients[0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight)),
              child: XImage(
                  imagePath: interact.hasLike
                      ? 'assets/images/ic-heart-red.png'
                      : 'assets/images/ic-heart-black.png'),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: !isExpand
                ? MediaQuery.of(context).size.width - 190
                : MediaQuery.of(context).size.width - 140,
            height: _inputHeight,
            decoration: BoxDecoration(
              borderRadius: _inputHeight != 40
                  ? BorderRadius.circular(5)
                  : BorderRadius.circular(50),
              color: AppColor.WHITE,
              border: Border.all(color: AppColor.GREY_DADADA),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 15),
                if (!focusNode.hasFocus && _inputHeight == 40) ...[
                  const XImage(
                    imagePath: 'assets/images/ic-comment-grey.png',
                    width: 25,
                    height: 25,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    controller: _cmtController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      suffixIconConstraints:
                          const BoxConstraints(maxWidth: 30, minWidth: 0),
                      suffixIcon: _cmtController.text.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.only(bottom: 4),
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: () {
                                  _bloc.add(AddCommendEvent(
                                      qrWalletId: e.id,
                                      message: _cmtController.text));
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: AppColor.BLUE_TEXT,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_upward_outlined,
                                      size: 15,
                                      color: AppColor.WHITE,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(
                          0, 12, 10, focusNode.hasFocus ? 8 : 10),
                      hintText: 'Bình luận',
                      hintStyle:
                          const TextStyle(fontSize: 12, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
              ],
            ),
          ),
          if (!isExpand) ...[
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                onSaveImage(context);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: LinearGradient(
                        colors: _gradients[0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: const XImage(imagePath: 'assets/images/ic-dowload.png'),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(4),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: LinearGradient(
                        colors: _gradients[0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child:
                    const XImage(imagePath: 'assets/images/ic-share-black.png'),
              ),
            ),
          ] else ...[
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                isExpand = false;
                updateState();
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: LinearGradient(
                        colors: _gradients[0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  size: 25,
                  weight: 1,
                  color: AppColor.BLACK,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  _buildAppBar(QrFeedDetailDTO e) {
    return AppBar(
      forceMaterialTransparency: true,
      backgroundColor: AppColor.WHITE,
      leadingWidth: double.infinity,
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 25,
              ),
              const SizedBox(width: 2),
              if (isLoading == false) ...[
                XImage(
                  borderRadius: BorderRadius.circular(100),
                  imagePath:
                      e.imageId.isNotEmpty ? e.imageId : ImageConstant.icAvatar,
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  e.fullName,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ] else ...[
                const ShimmerBlock(
                  width: 30,
                  height: 30,
                  borderRadius: 100,
                ),
                const SizedBox(width: 10),
                const ShimmerBlock(
                  height: 12,
                  width: 200,
                  borderRadius: 50,
                )
              ]
            ],
          ),
        ),
      ),
      actions: [
        Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                if (e.userId == userId)
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          details.globalPosition.dx,
                          details.globalPosition.dy + 20,
                          details.globalPosition.dx,
                          details.globalPosition.dy + 20,
                        ),
                        items: <PopupMenuEntry<int>>[
                          const PopupMenuItem<int>(
                            value: 0,
                            child: ListTile(
                              title: Text(
                                'Cập nhật nội dung mã QR',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.blue),
                              ),
                            ),
                          ),
                          const PopupMenuItem<int>(
                            value: 1,
                            child: ListTile(
                              title: Text(
                                'Tuỳ chỉnh giao diện mã QR',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.blue),
                              ),
                            ),
                          ),
                          const PopupMenuItem<int>(
                            value: 2,
                            child: ListTile(
                              title: Text(
                                'Xoá QR',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ).then((int? result) {
                        if (result != null) {
                          switch (result) {
                            case 0:
                              Navigator.of(context)
                                  .pushNamed(Routes.QR_UPDATE_SCREEN);
                              // Handle "Cập nhật nội dung mã QR"
                              break;
                            case 1:
                              // Handle "Tuỳ chỉnh giao diện mã QR"
                              break;
                            case 2:
                              // Handle "Xoá QR"
                              break;
                          }
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          colors: _gradients[0],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: const Image(
                        image: AssetImage('assets/images/ic-effect.png'),
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    // _bloc.add(GetQrFeedPopupDetailEvent(qrWalletId: widget.id));
                    DialogWidget.instance.showModelBottomSheet(
                      borderRadius: BorderRadius.circular(16),
                      widget: PopUpQrDetail(
                        qrType: qrType,
                        dto: qrFeedPopupDetailDTO!,
                      ),
                      // height: MediaQuery.of(context).size.height * 0.6,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                            colors: _gradients[0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)),
                    child:
                        const XImage(imagePath: 'assets/images/ic-i-black.png'),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  void _checkInputHeight() async {
    int count = _cmtController.text.split('\n').length;
    isExpand = true;
    if (count == 0 && _inputHeight == 40.0) {
      return;
    }
    if (count > 1) {
      // use a maximum height of 6 rows
      // height values can be adapted based on the font size
      var newHeight = count == 1 ? 40.0 : 28.0 + (count * 18.0);
      _inputHeight = newHeight;
    } else {
      _inputHeight = 40;
    }
    updateState();
  }

  void updateState() {
    setState(() {});
  }
}

class QrInteract {
  int likes;
  int cmt;
  bool hasLike;
  int timeCreate;

  QrInteract({
    this.likes = 0,
    this.cmt = 0,
    this.hasLike = false,
    this.timeCreate = 0,
  });

  QrInteract copyWith({
    int? likes,
    int? cmt,
    bool? hasLike,
    int? timeCreate,
  }) {
    return QrInteract(
      likes: likes ?? this.likes,
      cmt: cmt ?? this.cmt,
      hasLike: hasLike ?? this.hasLike,
      timeCreate: timeCreate ?? this.timeCreate,
    );
  }
}
