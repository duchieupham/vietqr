import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/qr_feed_screen.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';
import 'package:vierqr/features/qr_feed/views/create_folder_screen.dart';
import 'package:vierqr/features/qr_feed/views/qr_detail_screen.dart';
import 'package:vierqr/features/qr_feed/widgets/popup_folder_choice_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/qr_feed_folder_dto.dart';
import 'package:vierqr/models/qr_folder_detail_dto.dart';
import 'package:vierqr/models/user_folder_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

// ignore: constant_identifier_names
enum FolderEnum { QR, ACCESS }

class FolderDetailScreen extends StatefulWidget {
  final String folderId;
  final String userId;
  final int countQrs;
  final int countUsers;
  final int isEdit;

  final String folderName;
  final FolderEnum tab;

  const FolderDetailScreen(
      {super.key,
      required this.countQrs,
      required this.countUsers,
      required this.folderId,
      required this.isEdit,
      required this.userId,
      required this.folderName,
      required this.tab});

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String get userId => SharePrefUtils.getProfile().userId;

  final QrFeedBloc _bloc = getIt.get<QrFeedBloc>();

  FolderEnum tab = FolderEnum.QR;

  QRTypeDTO _qrTypeDTO = const QRTypeDTO(
    type: 9,
    name: 'Tất cả',
  );

  QrFolderDetailDTO? dto;

  List<UserFolder> listUser = [];

  MetaDataDTO? userMetadata;

  @override
  void initState() {
    super.initState();

    initData();
  }

  void initData() {
    tab = widget.tab;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _scrollController.addListener(
          () {
            if (tab == FolderEnum.ACCESS) {
              if (_scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent) {
                if (userMetadata != null) {
                  int total = (userMetadata!.total! / 20).ceil();
                  if (total > userMetadata!.page!) {
                    _bloc.add(
                      GetMoreUserFolderEvent(
                          value: '',
                          folderId: widget.folderId,
                          page: userMetadata!.page),
                    );
                  }
                }
              }
            }
          },
        );
        if (tab == FolderEnum.QR) {
          _bloc.add(GetFolderDetailEvent(
              value: '', type: 9, folderId: widget.folderId));
        } else {
          _bloc.add(GetUserFolderEvent(value: '', folderId: widget.folderId));
        }
      },
    );
    setState(() {});
  }

  Future<void> onRefresh() async {
    if (tab == FolderEnum.QR) {
      _bloc.add(GetFolderDetailEvent(
          value: '', type: _qrTypeDTO.type, folderId: widget.folderId));
    } else {
      _bloc.add(GetUserFolderEvent(
          value: '', folderId: widget.folderId, size: userMetadata?.size));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrFeedBloc, QrFeedState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == QrFeed.REMOVE_USER &&
            state.status == BlocStatus.SUCCESS) {
          _bloc.add(GetUserFolderEvent(
              value: '',
              folderId: widget.folderId,
              page: 1,
              size: userMetadata?.size));
        }
        if (state.request == QrFeed.UPDATE_USER_ROLE &&
            state.status == BlocStatus.SUCCESS) {
          _bloc.add(GetUserFolderEvent(
              value: '',
              folderId: widget.folderId,
              page: 1,
              size: userMetadata?.size));
        }
        // if (state.request == QrFeed.GET_UPDATE_FOLDER_DETAIL &&
        //     state.status == BlocStatus.SUCCESS) {
        //   List<QrData> qrList = [];
        //   if (state.folderDetailDTO != null) {
        //     qrList = state.folderDetailDTO!.qrData;
        //   }

        //   final listUser = state.listAllUserFolder;
        //   NavigationService.push(Routes.CREATE_QR_FOLDER_SCREEN, arguments: {
        //     'page': 2,
        //     'action': ActionType.UPDATE_USER,
        //     'id': widget.folderId,
        //     'listQrPrivate': qrList,
        //     'listUserFolder': listUser,
        //   }).then(
        //     (value) {
        //       _bloc.add(GetUserFolderEvent(
        //           value: '',
        //           folderId: widget.folderId,
        //           size: userMetadata?.size));
        //     },
        //   );
        // }
      },
      // buildWhen: (previous, current) =>
      //     (previous.request == QrFeed.GET_QR_FEED_FOLDER) !=
      //     (current.request == QrFeed.GET_FOLDER_DETAIL),
      builder: (context, state) {
        Map<String, List<QrData>> groupsAlphabet = {};
        if (state.request == QrFeed.GET_FOLDER_DETAIL &&
            state.status == BlocStatus.SUCCESS) {
          dto = state.folderDetailDTO;
          final listQr = dto != null ? dto!.qrData : [];
          if (listQr.isNotEmpty) {
            for (var item in listQr) {
              String firstChar = item.title[0].toUpperCase();
              if (!groupsAlphabet.containsKey(firstChar)) {
                groupsAlphabet[firstChar] = [];
              }
              groupsAlphabet[firstChar]!.add(item);
            }
          }
        }

        if (state.request == QrFeed.GET_USER_FOLDER &&
            state.status == BlocStatus.SUCCESS) {
          listUser = [...state.listUserFolder!];
          userMetadata = state.folderMetadata;
        }

        if (state.request == QrFeed.GET_MORE_USER_FOLDER &&
            state.status == BlocStatus.SUCCESS) {
          listUser = [...listUser, ...state.listUserFolder!];
          userMetadata = state.folderMetadata;
        }

        return Scaffold(
          backgroundColor: AppColor.WHITE,
          // appBar: _buildAppBar(),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                _pinnedAppbar(),
                const SizedBox(height: 4),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tab == FolderEnum.QR) ...[
                            const SizedBox(height: 30),
                            const Text(
                              'Danh sách mã QR',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 25),
                            if (state.request == QrFeed.GET_FOLDER_DETAIL &&
                                state.status == BlocStatus.LOADING)
                              ...List.generate(
                                4,
                                (index) => _buildRowQrPrivate(isLoading: true),
                              )
                            else if (dto != null && dto!.qrData.isNotEmpty)
                              ...groupsAlphabet.entries.map(
                                (e) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 35,
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            gradient: LinearGradient(
                                                colors: _gradients[0],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight)),
                                        child: Text(
                                          e.key,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
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
                              const Center(
                                child: Text(
                                  'Danh mục trống',
                                  style: TextStyle(
                                      fontSize: 15, color: AppColor.GREY_TEXT),
                                ),
                              ),
                          ] else ...[
                            const SizedBox(height: 30),
                            if (state.request == QrFeed.GET_USER_FOLDER &&
                                state.status == BlocStatus.LOADING)
                              ...List.generate(
                                  4, (index) => _userFolder(isLoading: true))
                            else if (listUser.isNotEmpty)
                              ...listUser.asMap().map(
                                (index, e) {
                                  return MapEntry(index,
                                      _userFolder(user: e, index: index));
                                },
                              ).values

                            // ListView.separated(
                            //     physics: const NeverScrollableScrollPhysics(),
                            //     itemBuilder: (context, index) {
                            //       final user = listUser[index];
                            //       return _userFolder(user);
                            //     },
                            //     separatorBuilder: (context, index) =>
                            //         const MySeparator(
                            //           color: AppColor.GREY_DADADA,
                            //         ),
                            //     itemCount: listUser.length)
                          ],
                          const SizedBox(height: 50)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _userFolder({UserFolder? user, bool isLoading = false, int? index}) {
    String role = '';
    if (user != null) {
      switch (user.role) {
        case 'ADMIN':
          role = 'Chủ sở hữu';
          break;
        case 'EDITOR':
          role = 'Quản lý';
          break;
        case 'MANAGER':
          role = 'Quản lý';
          break;
        case 'VIEWER':
          role = 'Người xem';
          break;
        default:
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              !isLoading
                  ? Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)),
                      child: XImage(
                        borderRadius: BorderRadius.circular(100),
                        imagePath: user!.imageId.isNotEmpty
                            ? user.imageId
                            : ImageConstant.icAvatar,
                        width: 40,
                        height: 40,
                      ),
                    )
                  : const ShimmerBlock(
                      width: 40,
                      height: 40,
                      borderRadius: 100,
                    ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !isLoading
                        ? Text(
                            user!.fullName,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          )
                        : const ShimmerBlock(
                            height: 12,
                            width: 150,
                            borderRadius: 50,
                          ),
                    const SizedBox(height: 4),
                    !isLoading
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  role,
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
                              const SizedBox(width: 16),
                              Text(
                                user!.phoneNo,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColor.GREY_TEXT),
                              )
                            ],
                          )
                        : const ShimmerBlock(
                            height: 12,
                            width: 250,
                            borderRadius: 50,
                          ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (!isLoading)
                if (!user!.role.toLowerCase().contains('admin') &&
                    widget.userId == userId)
                  GestureDetector(
                    onTapDown: (details) {
                      onTapDown(details, user);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: LinearGradient(
                              colors: _gradients[0],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight)),
                      child: const XImage(
                          imagePath: 'assets/images/ic-option-black.png'),
                    ),
                  ),
            ],
          ),
          const SizedBox(height: 15),
          const MySeparator(color: AppColor.GREY_DADADA),
        ],
      ),
    );
  }

  Widget _buildRowQrPrivate({QrData? dto, bool isLoading = false}) {
    return InkWell(
      onTap: () {
        setState(() {
          _qrTypeDTO = const QRTypeDTO(
            type: 9,
            name: 'Tất cả',
          );
        });
        getIt.get<QrFeedBloc>().add(GetQrFeedDetailEvent(
            id: dto!.id, isLoading: true, folderId: widget.folderId));
      },
      child: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
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
                              ? _gradients[9]
                              : dto.qrType == '1'
                                  ? _gradients[3]
                                  : dto.qrType == '2'
                                      ? _gradients[1]
                                      : _gradients[10],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                    ),
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
                          Navigator.of(context).pushNamed(
                              Routes.QR_SAVE_SHARE_SCREEN,
                              arguments: {
                                'type': TypeImage.SAVE,
                                'title': dto!.title,
                                'data': dto.data,
                                'value': dto.vlue,
                                'fileAttachmentId': dto.fileAttachmentId,
                                'qrType': dto.qrType,
                                'theme': dto.theme,
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: LinearGradient(
                                  colors: _gradients[0],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight)),
                          child: const XImage(
                              imagePath: 'assets/images/ic-dowload.png'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              Routes.QR_SAVE_SHARE_SCREEN,
                              arguments: {
                                'type': TypeImage.SHARE,
                                'title': dto!.title,
                                'data': dto.data,
                                'value': dto.vlue,
                                'fileAttachmentId': dto.fileAttachmentId,
                                'qrType': dto.qrType,
                                'theme': dto.theme,
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: LinearGradient(
                                  colors: _gradients[0],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight)),
                          child: const XImage(
                              imagePath: 'assets/images/ic-share-black.png'),
                        ),
                      )
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
      ),
    );
  }

  Widget _pinnedAppbar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 60, 0, 20),
          color: AppColor.WHITE,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.black,
                          size: 25,
                        ),
                        const SizedBox(width: 2),
                        Container(
                          padding: const EdgeInsets.all(4),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF5CEC7),
                                    Color(0xFFFFD7BF)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight)),
                          child: const XImage(
                              imagePath: 'assets/images/ic-folder.png'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.folderName,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (dto != null) {
                    QrFeedFolderDTO folderDTO = QrFeedFolderDTO(
                        isEdit: widget.isEdit,
                        id: dto!.folderId,
                        description: dto!.descriptionFolder,
                        userId: dto!.userId,
                        title: dto!.titleFolder,
                        countUsers: widget.countUsers,
                        countQrs: widget.countQrs,
                        timeCreated: 0);
                    DialogWidget.instance
                        .showModelBottomSheet(
                      borderRadius: BorderRadius.circular(20),
                      widget: PopupFolderChoiceWidget(
                        dto: folderDTO,
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                    )
                        .then(
                      (value) {
                        if (tab == FolderEnum.QR) {
                          _bloc.add(GetFolderDetailEvent(
                              value: '',
                              type: _qrTypeDTO.type,
                              folderId: widget.folderId));
                        } else {
                          _bloc.add(GetUserFolderEvent(
                              value: '', folderId: widget.folderId));
                        }
                      },
                    );
                  }
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
                  child: const XImage(
                      imagePath: 'assets/images/ic-option-black.png'),
                ),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                tab = FolderEnum.QR;
                _bloc.add(GetFolderDetailEvent(
                    value: _searchController.text,
                    type: _qrTypeDTO.type,
                    folderId: widget.folderId));
                updateState();
              },
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: tab == FolderEnum.QR
                          ? AppColor.TRANSPARENT
                          : AppColor.GREY_DADADA),
                  color: tab == FolderEnum.QR
                      ? AppColor.BLUE_TEXT.withOpacity(0.2)
                      : AppColor.WHITE,
                  // border: Border.all(color: AppColor.BLUE_TEXT),
                ),
                child: Center(
                  child: Text(
                    'Mã QR',
                    style: TextStyle(
                        fontSize: 12,
                        color: tab == FolderEnum.QR
                            ? AppColor.BLUE_TEXT
                            : AppColor.BLACK_TEXT),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                tab = FolderEnum.ACCESS;
                _searchController.clear();
                _bloc.add(
                    GetUserFolderEvent(value: '', folderId: widget.folderId));

                updateState();
              },
              child: Container(
                // width: 100,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: tab == FolderEnum.ACCESS
                          ? AppColor.TRANSPARENT
                          : AppColor.GREY_DADADA),
                  color: tab == FolderEnum.ACCESS
                      ? AppColor.BLUE_TEXT.withOpacity(0.2)
                      : AppColor.WHITE,
                ),
                child: Center(
                  child: Text(
                    'Quyền truy cập',
                    style: TextStyle(
                        fontSize: 12,
                        color: tab == FolderEnum.ACCESS
                            ? AppColor.BLUE_TEXT
                            : AppColor.BLACK_TEXT),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                  child: MTextFieldCustom(
                      // focusNode: focusNode,
                      controller: _searchController,
                      prefixIcon: const XImage(
                        imagePath: 'assets/images/ic-search-grey.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                      fillColor: AppColor.WHITE,
                      suffixIcon: InkWell(
                        onTap: () {
                          _searchController.clear();
                          if (tab == FolderEnum.QR) {
                            _bloc.add(GetFolderDetailEvent(
                                value: '',
                                type: _qrTypeDTO.type,
                                folderId: widget.folderId));
                          } else {
                            _bloc.add(GetUserFolderEvent(
                                value: '', folderId: widget.folderId));
                          }

                          updateState();
                        },
                        child: const Icon(
                          Icons.clear,
                          size: 20,
                          color: AppColor.GREY_DADADA,
                        ),
                      ),
                      enable: true,
                      focusBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.GREY_DADADA)),
                      contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      hintText: tab == FolderEnum.QR
                          ? 'Tìm kiếm mã QR theo tên'
                          : 'Tìm kiếm thành viên theo tên',
                      keyboardAction: TextInputAction.next,
                      onSubmitted: (value) {
                        if (tab == FolderEnum.QR) {
                          _bloc.add(GetFolderDetailEvent(
                              value: _searchController.text,
                              type: _qrTypeDTO.type,
                              folderId: widget.folderId));
                        } else {
                          _bloc.add(GetUserFolderEvent(
                              value: _searchController.text,
                              folderId: widget.folderId));
                        }
                      },
                      onChange: (value) {},
                      inputType: TextInputType.text,
                      isObscureText: false)),
              const SizedBox(width: 10),
              if (widget.userId == userId)
                InkWell(
                  onTap: tab == FolderEnum.QR
                      ? () {}
                      : () {
                          NavigationService.push(Routes.CREATE_QR_FOLDER_SCREEN,
                              arguments: {
                                'page': 2,
                                'action': ActionType.UPDATE_USER,
                                'id': widget.folderId,
                              }).then(
                            (value) {
                              if (tab == FolderEnum.QR) {
                                _bloc.add(GetFolderDetailEvent(
                                    value: '',
                                    type: _qrTypeDTO.type,
                                    folderId: widget.folderId));
                              } else {
                                _bloc.add(GetUserFolderEvent(
                                    value: '', folderId: widget.folderId));
                              }
                            },
                          );
                        },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                        gradient: LinearGradient(
                            colors: _gradients[0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)),
                    child: XImage(
                        imagePath: tab == FolderEnum.QR
                            ? 'assets/images/ic-scan-content-black.png'
                            : 'assets/images/ic-add-person-black.png'),
                  ),
                ),
            ],
          ),
        ),
        if (tab == FolderEnum.QR)
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
                      _bloc.add(GetFolderDetailEvent(
                          value: '',
                          type: _qrTypeDTO.type,
                          folderId: widget.folderId));
                      // _bloc.add(GetQrFeedPrivateEvent(
                      //     type: _qrTypeDTO.type,
                      //     isGetFolder: true,
                      //     isFolderLoading: false,
                      //     value: _searchController.text));
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

  void onTapDown(TapDownDetails details, UserFolder user) {
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
              'Sửa quyền truy cập',
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: ListTile(
            title: Text(
              'Xoá quyền truy cập',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
        ),
      ],
    ).then(
      (value) {
        if (value == 1) {
          _bloc.add(RemoveUserFolderEvent(
              folderId: widget.folderId, userFolderId: user.userId));
        }
        if (value == 0) {
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
                  value: 2,
                  child: ListTile(
                    title: Text(
                      'Quản lý',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: ListTile(
                    title: Text(
                      'Người xem',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ),
              ]).then(
            (value) {
              _bloc.add(UpdateUserRoleFolderEvent(
                  folderId: widget.folderId,
                  userFolderId: user.userId,
                  role: value == 2 ? 'MANAGER' : 'VIEWER'));
            },
          );
        }
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

  void updateState() {
    setState(() {});
  }
}
