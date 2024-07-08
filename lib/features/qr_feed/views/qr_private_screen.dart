import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/scroll_indicator.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';
import 'package:vierqr/features/qr_feed/views/create_folder_screen.dart';
import 'package:vierqr/features/qr_feed/views/folder_detail_screen.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/qr_feed_folder_dto.dart';
import 'package:vierqr/models/qr_feed_private_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';

class QrPrivateScreen extends StatefulWidget {
  final List<List<Color>> listGradient;
  const QrPrivateScreen({
    super.key,
    required this.listGradient,
  });

  @override
  State<QrPrivateScreen> createState() => _QrPrivateScreenState();
}

class _QrPrivateScreenState extends State<QrPrivateScreen> {
  final ScrollController _scrollHorizontal = ScrollController();
  final QrFeedBloc _bloc = getIt.get<QrFeedBloc>();

  List<QrFeedPrivateDTO> listQrPrivate = [];
  List<QrFeedFolderDTO> listQrFolder = [];

  @override
  void initState() {
    super.initState();

    initData();
  }

  void initData() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _scrollHorizontal.jumpTo(0.0);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrFeedBloc, QrFeedState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == QrFeed.GET_QR_FEED_PRIVATE &&
            state.status == BlocStatus.SUCCESS) {
          if (!mounted) return;
          listQrPrivate = [...state.listQrFeedPrivate!];
          listQrFolder = [...state.listQrFeedFolder!];
          updateState();
        }
        if (state.request == QrFeed.GET_MORE_QR &&
            state.status == BlocStatus.SUCCESS) {
          if (!mounted) return;
          listQrPrivate = [...listQrPrivate, ...state.listQrFeedPrivate!];
          updateState();
        }
      },
      builder: (context, state) {
        Map<String, List<QrFeedPrivateDTO>> groupsAlphabet = {};
        if (listQrPrivate.isNotEmpty) {
          for (var item in listQrPrivate) {
            String firstChar = item.title[0].toUpperCase();
            if (!groupsAlphabet.containsKey(firstChar)) {
              groupsAlphabet[firstChar] = [];
            }
            groupsAlphabet[firstChar]!.add(item);
          }
        }
        return SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            color: AppColor.WHITE,
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (state.isFolderLoading == true)
                      const ShimmerBlock(
                          height: 15, width: 120, borderRadius: 50)
                    else
                      const Text(
                        'Thư mục QR',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    Row(
                      children: [
                        if (state.status == BlocStatus.LOADING &&
                            state.isFolderLoading)
                          const SizedBox.shrink()
                        else
                          InkWell(
                            onTap: () {
                              NavigationService.push(
                                  Routes.CREATE_QR_FOLDER_SCREEN,
                                  arguments: {
                                    'page': 0,
                                    'action': ActionType.CREATE,
                                    'id': '',
                                  }).then(
                                (value) {},
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: LinearGradient(
                                      colors: widget.listGradient[0],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight)),
                              child: const XImage(
                                  imagePath: 'assets/images/ic-add-folder.png'),
                            ),
                          ),
                        if (state.status == BlocStatus.LOADING &&
                            state.isFolderLoading)
                          const SizedBox.shrink()
                        else if (listQrFolder.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.QR_FOLDER_SCREEN);
                            },
                            child: Container(
                              height: 35,
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: LinearGradient(
                                      colors: widget.listGradient[0],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight)),
                              child: const Text(
                                'Xem thêm',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollHorizontal,
                  // physics: const ScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.isFolderLoading) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(2, (index) {
                            return _buildItemWidget(isLoading: true);
                          }),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(2, (index) {
                            return _buildItemWidget(isLoading: true);
                          }),
                        ),
                      ] else ...[
                        if (listQrFolder.isNotEmpty) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                (listQrFolder.length / 2).ceil(), (index) {
                              if (index * 2 < listQrFolder.length) {
                                return InkWell(
                                  onTap: () {
                                    NavigationService.push(
                                        Routes.QR_FOLDER_DETAIL_SCREEN,
                                        arguments: {
                                          'id': listQrFolder[index].id,
                                          'folderName':
                                              listQrFolder[index].title,
                                          'tab': FolderEnum.QR
                                        });
                                  },
                                  child: _buildItemWidget(
                                      dto: listQrFolder[index * 2],
                                      isLoading: false),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                (listQrFolder.length / 2).floor(), (index) {
                              if (index * 2 + 1 < listQrFolder.length) {
                                return InkWell(
                                  onTap: () {
                                    NavigationService.push(
                                        Routes.QR_FOLDER_DETAIL_SCREEN,
                                        arguments: {
                                          'id': listQrFolder[index].id,
                                          'folderName':
                                              listQrFolder[index].title,
                                          'tab': FolderEnum.QR
                                        });
                                  },
                                  child: _buildItemWidget(
                                      dto: listQrFolder[index * 2],
                                      isLoading: false),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                          ),
                        ] else
                          const Text(
                            'Thư mục rỗng...',
                            style: TextStyle(fontSize: 12),
                          )
                      ]
                    ],
                  ),
                ),
                // const SizedBox(height: 10),
                if (listQrFolder.isNotEmpty && !state.isFolderLoading)
                  ScrollIndicator(
                    alignment: Alignment.centerLeft,
                    scrollController: _scrollHorizontal,
                    width: 80,
                    height: 5,
                    indicatorWidth: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.BLUE_BGR,
                    ),
                    indicatorDecoration: BoxDecoration(
                        color: AppColor.BLUE_TEXT,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                const SizedBox(height: 30),
                if (state.request == QrFeed.GET_QR_FEED_PRIVATE &&
                    state.status == BlocStatus.LOADING)
                  const ShimmerBlock(height: 15, width: 120, borderRadius: 50)
                else
                  const Text(
                    'Danh sách mã QR',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 20),
                if (state.request == QrFeed.GET_QR_FEED_PRIVATE &&
                    state.status == BlocStatus.LOADING)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        4, (index) => _buildRowQrPrivate(isLoading: true)),
                  )
                else if (listQrPrivate.isNotEmpty)
                  ...groupsAlphabet.entries.map(
                    (e) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            // padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: LinearGradient(
                                    colors: widget.listGradient[0],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight)),
                            child: Center(
                              child: Text(
                                e.key,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ...e.value.map(
                            (item) {
                              return _buildRowQrPrivate(dto: item);
                            },
                          )
                        ],
                      );
                    },
                  )
                else
                  const Text(
                    'Danh sách rỗng...',
                    style: TextStyle(fontSize: 12),
                  ),
                if (state.request == QrFeed.GET_MORE_QR &&
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
                const SizedBox(height: 80),
                // ...listQrPrivate.map(
                //   (e) {
                //     return _buildRowQrPrivate(
                //       dto: e,
                //     );
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _buildQrListLoading(){
  //   return
  // }

  Widget _buildRowQrPrivate({QrFeedPrivateDTO? dto, bool isLoading = false}) {
    return Column(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              if (!isLoading)
                Container(
                  padding: const EdgeInsets.all(4),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(
                          colors: dto!.qrType == '0'
                              ? widget.listGradient[9]
                              : dto.qrType == '1'
                                  ? widget.listGradient[3]
                                  : dto.qrType == '2'
                                      ? widget.listGradient[1]
                                      : widget.listGradient[10],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child: XImage(
                      imagePath: dto.qrType == '0'
                          ? 'assets/images/ic-linked-bank-blue.png'
                          : dto.qrType == '1'
                              ? 'assets/images/ic-file-violet.png'
                              : dto.qrType == '2'
                                  ? 'assets/images/ic-vcard1.png'
                                  : 'assets/images/ic-vietqr-trans.png'),
                )
              else
                const ShimmerBlock(
                  height: 40,
                  width: 40,
                  borderRadius: 100,
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isLoading) ...[
                      Text(
                        dto!.title,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        dto.data,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else ...[
                      const ShimmerBlock(
                        height: 12,
                        width: 300,
                      ),
                      const SizedBox(height: 4.0),
                      const ShimmerBlock(
                        height: 12,
                        width: 200,
                      ),
                    ]
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (!isLoading)
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(Routes.QR_SAVE_SHARE_SCREEN, arguments: {
                          'type': TypeImage.SAVE,
                          'title': dto!.title,
                          'data': dto.data,
                          'value': dto.value,
                          'fileAttachmentId': dto.fileAttachmentId,
                          'qrType': dto.qrType,
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                                colors: widget.listGradient[0],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight)),
                        child: const XImage(
                            imagePath: 'assets/images/ic-dowload.png'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(Routes.QR_SAVE_SHARE_SCREEN, arguments: {
                          'type': TypeImage.SHARE,
                          'title': dto!.title,
                          'data': dto.data,
                          'value': dto.value,
                          'fileAttachmentId': dto.fileAttachmentId,
                          'qrType': dto.qrType,
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                                colors: widget.listGradient[0],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight)),
                        child: const XImage(
                            imagePath: 'assets/images/ic-share-black.png'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const MySeparator(
          color: AppColor.GREY_DADADA,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildItemWidget({QrFeedFolderDTO? dto, bool isLoading = false}) {
    return Container(
      width: 200,
      height: 40,
      margin: const EdgeInsets.fromLTRB(0, 8, 20, 20),
      child: Row(
        children: [
          if (!isLoading)
            Container(
              padding: const EdgeInsets.all(4),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                      colors: [Color(0xFFF5CEC7), Color(0xFFFFD7BF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight)),
              child: const XImage(imagePath: 'assets/images/ic-folder.png'),
            )
          else
            const ShimmerBlock(
              height: 40,
              width: 40,
              borderRadius: 10,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isLoading) ...[
                  Text(
                    dto!.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                    softWrap: false,
                  ),
                  Text(
                    dto.description,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                    softWrap: false,
                  ),
                ] else ...[
                  const ShimmerBlock(
                    height: 15,
                    width: double.infinity,
                    borderRadius: 10,
                  ),
                  const ShimmerBlock(
                    height: 15,
                    width: 100,
                    borderRadius: 10,
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateState() {
    setState(() {});
  }
}
