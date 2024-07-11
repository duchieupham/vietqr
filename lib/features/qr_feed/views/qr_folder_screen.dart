import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';
import 'package:vierqr/features/qr_feed/views/create_folder_screen.dart';
import 'package:vierqr/features/qr_feed/views/folder_detail_screen.dart';
import 'package:vierqr/features/qr_feed/widgets/popup_folder_choice_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/qr_feed_folder_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class QrFolderScreen extends StatefulWidget {
  const QrFolderScreen({super.key});

  @override
  State<QrFolderScreen> createState() => _QrFolderScreenState();
}

class _QrFolderScreenState extends State<QrFolderScreen> {
  final ScrollController _scrollController = ScrollController();
  String get userId => SharePrefUtils.getProfile().userId;

  final QrFeedBloc _bloc = getIt.get<QrFeedBloc>();

  List<QrFeedFolderDTO> list = [];

  MetaDataDTO? metadata;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _scrollController.addListener(
          () {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              if (metadata != null) {
                int total = (metadata!.total! / 20).ceil();
                if (total > metadata!.page!) {
                  _bloc.add(GetMoreQrFeedFolderEvent(
                      value: '', type: 1, page: metadata!.page, size: 10));
                }
              }
            }
          },
        );
        _bloc.add(const GetQrFeedFolderEvent(value: '', type: 1));
      },
    );
  }

  Future<void> onRefresh() async {
    _bloc.add(const GetQrFeedFolderEvent(value: '', type: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrFeedBloc, QrFeedState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == QrFeed.GET_QR_FEED_FOLDER &&
            state.status == BlocStatus.SUCCESS) {
          list = [...state.listQrFeedFolder!];
          metadata = state.folderMetadata;
          updateState();
        }
        if (state.request == QrFeed.GET_MORE_FOLDER &&
            state.status == BlocStatus.SUCCESS) {
          list = [...list, ...state.listQrFeedFolder!];
          metadata = state.folderMetadata;
          updateState();
        }
        if (state.request == QrFeed.DELETE_FOLDER &&
            state.status == BlocStatus.SUCCESS) {
          Navigator.of(context).pop();
          _bloc.add(const GetQrFeedFolderEvent(value: '', type: 1));
          // _bloc.add(const GetQrFeedEvent(isLoading: true, type: 0));
          updateState();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.WHITE,
          appBar: _buildAppBar(),
          body: RefreshIndicator(
            onRefresh: onRefresh,
            child: _body(state),
          ),
        );
      },
    );
  }

  Widget _body(QrFeedState state) {
    double height = 80.0 * list.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: ListView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const Text(
            'Danh sách thư mục QR',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          if (state.status == BlocStatus.LOADING)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                6,
                (index) => const BuidlLoading(),
              ),
            )
          else if ((state.request == QrFeed.GET_QR_FEED_FOLDER &&
                  state.status == BlocStatus.SUCCESS) ||
              list.isNotEmpty)
            ...list
                .asMap()
                .map(
                  (index, e) => MapEntry(index, _buildItem(e, index)),
                )
                .values,
          if (state.request == QrFeed.GET_MORE_FOLDER &&
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
        ],
      ),
    );
  }

  Widget _buildItem(QrFeedFolderDTO dto, int index) {
    return InkWell(
      onTap: () {
        NavigationService.push(Routes.QR_FOLDER_DETAIL_SCREEN, arguments: {
          'userId': dto.userId,
          'id': dto.id,
          'folderName': dto.title,
          'countUsers': dto.countUsers,
          'countQrs': dto.countQrs,
          'tab': FolderEnum.QR,
          'isEdit': dto.isEdit,
        }).then(
          (value) {
            _bloc.add(const GetQrFeedFolderEvent(value: '', type: 1));
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: const TextStyle(
                              color: AppColor.BLACK,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          text: dto.title,
                          children: [
                            const WidgetSpan(
                              child: SizedBox(
                                  width: 10), // Space between text spans
                            ),
                            TextSpan(
                                text: dto.description,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal))
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text(
                              '${dto.countQrs} mục',
                              style: const TextStyle(
                                  fontSize: 12, color: AppColor.GREY_TEXT),
                            ),
                          ),
                          const SizedBox(
                              height: 15,
                              child: VerticalDivider(
                                width: 1,
                                color: AppColor.GREY_TEXT,
                              )),
                          const SizedBox(width: 8),
                          Text(
                            '${dto.countUsers} người truy cập',
                            style: const TextStyle(
                                fontSize: 12, color: AppColor.GREY_TEXT),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    DialogWidget.instance
                        .showModelBottomSheet(
                      borderRadius: BorderRadius.circular(20),
                      widget: PopupFolderChoiceWidget(
                        dto: dto,
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                    )
                        .then(
                      (value) {
                        _bloc.add(
                            const GetQrFeedFolderEvent(value: '', type: 1));
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.only(right: 10),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: const LinearGradient(
                            colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)),
                    child: const XImage(
                        imagePath: 'assets/images/ic-option-black.png'),
                  ),
                ),
              ],
            ),
            if (index + 1 < list.length) ...[
              const SizedBox(height: 20),
              const MySeparator(color: AppColor.GREY_DADADA)
            ]
          ],
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      backgroundColor: AppColor.WHITE,
      leadingWidth: 90,
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.only(left: 8),
          child: const Row(
            children: [
              Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 25,
              ),
              SizedBox(width: 2),
              Text(
                "Trở về",
                style: TextStyle(color: Colors.black, fontSize: 14),
              )
            ],
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            NavigationService.push(Routes.CREATE_QR_FOLDER_SCREEN, arguments: {
              'page': 0,
              'action': ActionType.CREATE,
              'id': '',
              'title': '',
              'description': '',
            });
          },
          onTapDown: (TapDownDetails details) {},
          child: Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(right: 10),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: const LinearGradient(
                    colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)),
            child: const XImage(imagePath: 'assets/images/ic-add-folder.png'),
          ),
        ),
      ],
    );
  }

  void updateState() {
    setState(() {});
  }
}

class BuidlLoading extends StatelessWidget {
  const BuidlLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 20),
      width: double.infinity,
      child: const Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBlock(
            height: 40,
            width: 40,
            borderRadius: 10,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerBlock(
                  height: 12,
                  width: double.infinity,
                  borderRadius: 50,
                ),
                SizedBox(height: 3),
                ShimmerBlock(
                  height: 12,
                  width: 200,
                  borderRadius: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
