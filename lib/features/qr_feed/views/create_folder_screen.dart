import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/input_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/qr_feed_screen.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/create_folder_dto.dart';
import 'package:vierqr/models/qr_feed_private_dto.dart';
import 'package:vierqr/models/search_user_dto.dart';
import 'package:vierqr/models/user_folder_dto.dart';
import 'package:vierqr/models/user_profile.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

enum ActionType {
  CREATE,
  UPDATE,
}

class CreateFolderScreen extends StatefulWidget {
  final int pageView;
  final ActionType action;
  final String folderId;
  const CreateFolderScreen(
      {super.key,
      required this.pageView,
      required this.action,
      required this.folderId});

  @override
  State<CreateFolderScreen> createState() => _CreateFolderScreenState();
}

class _CreateFolderScreenState extends State<CreateFolderScreen> {
  PageController _pageController = PageController();
  final TextEditingController _folderNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  FocusNode focusNode = FocusNode();
  FocusNode focusNodeDes = FocusNode();
  FocusNode focusNodeSearch = FocusNode();

  final QrFeedBloc _bloc = getIt.get<QrFeedBloc>();

  // String get userId => SharePrefUtils.getProfile().userId.trim();
  UserProfile userProfile = SharePrefUtils.getProfile();

  int _currentPageIndex = 0;

  QRTypeDTO _qrTypeDTO = const QRTypeDTO(
    type: 9,
    name: 'Tất cả',
  );

  List<ListQrCheckBox> listQr = [];

  List<ListUserCheckBox> listUser = [];
  List<ListUserCheckBox> listSelectedUser = [];

  List<UserFolder> listUserUpdate = [];
  List<UserFolder> listUserUpdateSearch = [];

  List<ListUserCheckBox> mapUser(List<SearchUser> user) {
    return user
        .map((item) => ListUserCheckBox(
            role: 'VIEWER', title: 'Người xem', isValid: false, dto: item))
        .toList();
  }

  Map<String, List<ListQrCheckBox>> groupsAlphabet = {};

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (widget.action == ActionType.CREATE) {
          _bloc.add(GetUserQREvent(value: '', type: _qrTypeDTO.type));
        } else {
          _bloc.add(GetFolderDetailEvent(
              value: '', type: _qrTypeDTO.type, folderId: widget.folderId));
          _bloc.add(GetUserFolderEvent(value: '', folderId: widget.folderId));
        }

        setState(() {
          _currentPageIndex = widget.pageView;
          _pageController.jumpToPage(widget.pageView);
        });
      },
    );
  }

  Future<List<SearchUser>> getUser(String phoneNo) async {
    List<SearchUser> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}users/search/?phoneNo=$phoneNo';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data.map<SearchUser>((json) {
          return SearchUser.fromJson(json);
        }).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  List<ListQrCheckBox> mapQr(List<QrFeedPrivateDTO> qr) {
    return qr.map((item) => ListQrCheckBox(isValid: false, dto: item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrFeedBloc, QrFeedState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == QrFeed.GET_USER_QR &&
            state.status == BlocStatus.SUCCESS) {
          final list = state.listQrFeedPrivate;
          listQr = mapQr(list!);
          if (listQr.isNotEmpty) {
            for (var item in listQr) {
              String firstChar = item.dto!.title[0].toUpperCase();
              if (!groupsAlphabet.containsKey(firstChar)) {
                groupsAlphabet[firstChar] = [];
              }
              groupsAlphabet[firstChar]!.add(item);
            }
          }
          setState(() {});
        }

        if (state.request == QrFeed.CREATE_FOLDER &&
            state.status == BlocStatus.SUCCESS) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: 'Tạo thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }
      },
      builder: (context, state) {
        bool isEnable = false;

        if (_currentPageIndex == 0) {
          if (_folderNameController.text.isNotEmpty &&
              _descriptionController.text.isNotEmpty) {
            isEnable = true;
          } else {
            isEnable = false;
          }
        } else if (_currentPageIndex == 1) {
          isEnable = listQr.any((element) => element.isValid == true);
        } else if (_currentPageIndex == 2) {
          isEnable = true;
        }

        if (widget.action == ActionType.UPDATE) {
          listUserUpdate = [...state.listUserFolder!];
          // userMetadata = state.folderMetadata;
        }

        return GestureDetector(
          onTap: () {
            focusNode.unfocus();
            focusNodeDes.unfocus();
          },
          child: Scaffold(
            backgroundColor: AppColor.WHITE,
            bottomNavigationBar: _bottomButton(isEnable),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _appbar(),
                  Expanded(
                    child: PageView(
                      onPageChanged: (value) {
                        setState(() {
                          _currentPageIndex = value;
                        });
                      },
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _inputWidget(),
                        _selectQrWidget(groupsAlphabet),
                        if (widget.action == ActionType.CREATE)
                          _addUser()
                        else
                          _updateUser(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _selectQrWidget(Map<String, List<ListQrCheckBox>> groupsAlphabet) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            ...groupsAlphabet.entries.map(
              (e) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 35,
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
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
                    ...listQr.asMap().map(
                      (index, item) {
                        return MapEntry(
                            index, _buildRowQrPrivate(e: item, index: index));
                      },
                    ).values
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _updateUser() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          if (listUserUpdate.isNotEmpty)
            ...listUserUpdate.asMap().map(
              (index, e) {
                return MapEntry(
                    index,
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          XImage(
                            imagePath: e.imageId.isNotEmpty
                                ? e.imageId
                                : ImageConstant.icAvatar,
                            width: 40,
                            height: 40,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.fullName,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  e.phoneNo,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (e.role.toLowerCase().contains('admin'))
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                height: 40,
                                // width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                                    gradient: LinearGradient(
                                        colors: _gradients[0],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight)),
                                child: const Center(
                                  child: Text(
                                    'Admin',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ))
                          else
                            GestureDetector(
                              onTapDown: (details) {
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
                                            'Quản lý',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem<int>(
                                        value: 1,
                                        child: ListTile(
                                          title: Text(
                                            'Người xem',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ]).then(
                                  (value) {
                                    if (value == 0) {
                                      listUserUpdate[index].role = 'EDITOR';
                                      setState(() {});
                                    }
                                    if (value == 1) {
                                      listUserUpdate[index].role = 'VIEWER';
                                      setState(() {});
                                    }
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                                    gradient: LinearGradient(
                                        colors: _gradients[0],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight)),
                                child: Row(
                                  children: [
                                    Text(
                                      listUserUpdate[index].role,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColor.BLUE_TEXT),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 22,
                                      color: AppColor.BLUE_TEXT,
                                    )
                                  ],
                                ),
                                // width: 40,
                              ),
                            ),
                        ],
                      ),
                    ));
              },
            ).values,
          if (listUserUpdateSearch.isNotEmpty) ...[
            const SizedBox(height: 20),
            const MySeparator(color: AppColor.GREY_DADADA),
            const SizedBox(height: 20),
            ...listUserUpdateSearch.map(
              (e) {
                return Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      XImage(
                        imagePath: e.imageId.isNotEmpty
                            ? e.imageId
                            : ImageConstant.icAvatar,
                        width: 40,
                        height: 40,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.fullName,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              e.phoneNo,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          listUserUpdate.add(e);
                          listUserUpdateSearch.remove(e);
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                              gradient: LinearGradient(
                                  colors: _gradients[0],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight)),
                          child: const XImage(
                              imagePath:
                                  'assets/images/ic-add-person-black.png'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ]
        ],
      ),
    );
  }

  Widget _addUser() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                XImage(
                  imagePath: userProfile.imgId.isNotEmpty
                      ? userProfile.imgId
                      : ImageConstant.icAvatar,
                  width: 40,
                  height: 40,
                  borderRadius: BorderRadius.circular(100),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfile.fullName,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        SharePrefUtils.getPhone(),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  height: 40,
                  // width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                      gradient: LinearGradient(
                          colors: _gradients[0],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child: const Center(
                    child: Text(
                      'Admin',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          const MySeparator(color: AppColor.GREY_DADADA),
          const SizedBox(height: 10),
          if (listSelectedUser.isNotEmpty) ...[
            ...listSelectedUser.asMap().map(
              (index, e) {
                return MapEntry(
                    index,
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          XImage(
                            imagePath: e.dto!.imageId.isNotEmpty
                                ? e.dto!.imageId
                                : ImageConstant.icAvatar,
                            width: 40,
                            height: 40,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.dto!.fullName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  e.dto!.phoneNo,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              listSelectedUser.remove(e);
                              listUser.add(e);
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                                  gradient: LinearGradient(
                                      colors: _gradients[0],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight)),
                              child: const XImage(
                                  imagePath:
                                      'assets/images/ic-delete-black.png'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTapDown: (details) {
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
                                          'Quản lý',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    const PopupMenuItem<int>(
                                      value: 1,
                                      child: ListTile(
                                        title: Text(
                                          'Người xem',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ]).then(
                                (value) {
                                  if (value == 0) {
                                    listSelectedUser[index].role = 'MANAGER';
                                    listSelectedUser[index].title = 'Quản lý';

                                    setState(() {});
                                  }
                                  if (value == 1) {
                                    listSelectedUser[index].title = 'Người xem';
                                    listSelectedUser[index].role = 'VIEWER';

                                    setState(() {});
                                  }
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                                  gradient: LinearGradient(
                                      colors: _gradients[0],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight)),
                              child: Row(
                                children: [
                                  Text(
                                    listSelectedUser[index].title!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColor.BLUE_TEXT),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 22,
                                    color: AppColor.BLUE_TEXT,
                                  )
                                ],
                              ),
                              // width: 40,
                            ),
                          )
                        ],
                      ),
                    ));
              },
            ).values,
            const SizedBox(height: 10),
            const MySeparator(color: AppColor.GREY_DADADA),
          ],
          if (listUser.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...listUser.asMap().map(
              (index, e) {
                return MapEntry(
                    index,
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          XImage(
                            imagePath: e.dto!.imageId.isNotEmpty
                                ? e.dto!.imageId
                                : ImageConstant.icAvatar,
                            width: 40,
                            height: 40,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.dto!.fullName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  e.dto!.phoneNo,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              ListUserCheckBox item = ListUserCheckBox(
                                  isValid: true,
                                  role: "VIEWER",
                                  title: 'Người xem',
                                  dto: listUser[index].dto);
                              listUser.remove(e);
                              listSelectedUser.add(item);
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                                  gradient: LinearGradient(
                                      colors: _gradients[0],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight)),
                              child: XImage(
                                  imagePath:
                                      'assets/images/ic-add-person-black.png'),
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            ).values,
          ]
        ],
      ),
    );
  }

  Widget _buildRowQrPrivate(
      {required ListQrCheckBox e, bool isLoading = false, required int index}) {
    return Column(
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
                        colors: e.dto!.qrType == '0'
                            ? _gradients[9]
                            : e.dto!.qrType == '1'
                                ? _gradients[3]
                                : e.dto!.qrType == '2'
                                    ? _gradients[1]
                                    : _gradients[10],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),
                  ),
                  child: XImage(
                      imagePath: e.dto!.qrType == '0'
                          ? 'assets/images/ic-linked-bank-blue.png'
                          : e.dto!.qrType == '1'
                              ? 'assets/images/ic-file-violet.png'
                              : e.dto!.qrType == '2'
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
                        e.dto!.title,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        e.dto!.data,
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
              Checkbox(
                checkColor: AppColor.BLUE_TEXT,
                activeColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                side: MaterialStateBorderSide.resolveWith(
                  (states) => const BorderSide(
                    width: 1.0,
                    color: AppColor.GREY_DADADA,
                  ),
                ),
                value: e.isValid,
                onChanged: (value) {
                  setState(() {
                    listQr[index].isValid = value!;
                  });
                },
              )
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

  Widget _inputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Đầu tiên, nhập thông tin\nthư mục QR của bạn',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        const Text(
          'Tên thư mục*',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        MTextFieldCustom(
            focusNode: focusNode,
            controller: _folderNameController,
            contentPadding: const EdgeInsets.only(left: 0),
            focusBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.GREY_DADADA)),
            inputFormatter: [VietnameseNameInputFormatter()],
            suffixIcon: InkWell(
              onTap: () {
                _folderNameController.clear();
                setState(() {});
              },
              child: _folderNameController.text.isNotEmpty
                  ? const Icon(
                      Icons.clear,
                      size: 20,
                      color: AppColor.GREY_DADADA,
                    )
                  : const SizedBox.shrink(),
            ),
            enable: true,
            hintText: 'Nhập tên thư mục tại đây',
            keyboardAction: TextInputAction.next,
            onChange: (value) {
              setState(() {});
            },
            inputType: TextInputType.text,
            isObscureText: false),
        const SizedBox(height: 30),
        const Text(
          'Mô tả cho thư mục',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        MTextFieldCustom(
            focusNode: focusNodeDes,
            controller: _descriptionController,
            contentPadding: const EdgeInsets.only(left: 0),
            focusBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.GREY_DADADA)),
            suffixIcon: InkWell(
              onTap: () {
                _descriptionController.clear();
                setState(() {});
              },
              child: _descriptionController.text.isNotEmpty
                  ? const Icon(
                      Icons.clear,
                      size: 20,
                      color: AppColor.GREY_DADADA,
                    )
                  : const SizedBox.shrink(),
            ),
            enable: true,
            hintText: 'Nhập mô tả cho thư mục tại đây',
            keyboardAction: TextInputAction.next,
            onChange: (value) {
              setState(() {});
            },
            inputType: TextInputType.text,
            isObscureText: false),
      ],
    );
  }

  Widget _bottomButton(bool isEnable) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: InkWell(
        onTap: isEnable
            ? () async {
                if (widget.action == ActionType.CREATE) {
                  await onUnFocus();
                  switch (_currentPageIndex) {
                    case 0:
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                      break;
                    case 1:
                      _searchController.clear();
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                      break;
                    case 2:
                      List<UserRole> roles = [];

                      roles = listSelectedUser
                          .map(
                            (e) =>
                                UserRole(userId: e.dto!.userId, role: e.role!),
                          )
                          .toList();
                      List<String> qrIds = [];
                      qrIds = listQr
                          .where((element) => element.isValid == true)
                          .map(
                            (e) => e.dto!.id,
                          )
                          .toList();

                      CreateFolderDTO createDTO = CreateFolderDTO(
                          title: _folderNameController.text,
                          description: _descriptionController.text,
                          userId: userProfile.userId,
                          userRoles: roles,
                          qrIds: qrIds);
                      _bloc.add(CreateFolderEvent(dto: createDTO));
                      break;
                    default:
                      break;
                  }
                } else {}
              }
            : null,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: isEnable
                ? const LinearGradient(
                    colors: [
                      Color(0xFF00C6FF),
                      Color(0xFF0072FF),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: isEnable ? null : const Color(0xFFF0F4FA),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.action == ActionType.CREATE && _currentPageIndex != 2)
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: AppColor.TRANSPARENT,
                  ),
                ),
              Expanded(
                child: Center(
                  child: Text(
                    widget.action == ActionType.CREATE
                        ? _currentPageIndex == 2
                            ? 'Hoàn thành'
                            : 'Tiếp tục'
                        : 'Cập nhật',
                    style: TextStyle(
                      color: isEnable ? AppColor.WHITE : AppColor.BLACK,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              if (widget.action == ActionType.CREATE && _currentPageIndex != 2)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: isEnable ? AppColor.WHITE : AppColor.BLACK,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.fromLTRB(0, _currentPageIndex == 0 ? 40 : 60, 0, 8),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  // padding: const EdgeInsets.only(left: 8),
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
              if (_currentPageIndex == 0)
                Image.asset(
                  AppImages.icLogoVietQr,
                  width: 95,
                  fit: BoxFit.fitWidth,
                )
              else if (_currentPageIndex == 1) ...[
                Row(
                  children: [
                    const SizedBox(width: 5),
                    if (listQr.any((element) => element.isValid == true))
                      InkWell(
                        onTap: () {
                          for (var element in listQr) {
                            element.isValid = false;
                          }

                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                              gradient: LinearGradient(
                                  colors: _gradients[0],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight)),
                          child: const XImage(
                              imagePath:
                                  'assets/images/ic-remove-checkbox-black.png'),
                        ),
                      ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        for (var element in listQr) {
                          element.isValid = true;
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        height: 40,
                        // width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                            gradient: LinearGradient(
                                colors: _gradients[0],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight)),
                        child: const Center(
                          child: Text(
                            'Chọn tất cả',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ],
          ),
          if (_currentPageIndex == 1) ...[
            const SizedBox(height: 20),
            const Text(
              'Thêm mã QR vào\nthư mục của bạn',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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
                          suffixIcon: _searchController.text.isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {});
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          hintText: 'Tìm kiếm mã QR theo tên',
                          keyboardAction: TextInputAction.next,
                          onSubmitted: (value) {
                            _bloc.add(GetUserQREvent(
                                value: _searchController.text,
                                type: _qrTypeDTO.type));
                          },
                          onChange: (value) {
                            setState(() {});
                          },
                          inputType: TextInputType.text,
                          isObscureText: false)),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      _bloc.add(GetUserQREvent(
                          value: _searchController.text,
                          type: _qrTypeDTO.type));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      height: 40,
                      // width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                          gradient: LinearGradient(
                              colors: _gradients[0],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight)),
                      child: const Center(
                        child: Text(
                          'Tìm kiếm',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 0, top: 15),
              width: double.infinity,
              height: 50,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _qrTypeDTO = _qrTypeList[index];
                        });
                        _bloc.add(GetUserQREvent(
                            value: _searchController.text,
                            type: _qrTypeDTO.type));
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
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemCount: _qrTypeList.length),
            ),
          ] else if (_currentPageIndex == 2) ...[
            const SizedBox(height: 20),
            Text(
              widget.action == ActionType.CREATE
                  ? 'Tiếp theo, thêm thành viên\ntruy cập thư mục QR'
                  : 'Thêm thành viên\ntruy cập thư mục QR',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                      child: MTextFieldCustom(
                          focusNode: focusNodeSearch,
                          controller: _searchController,
                          prefixIcon: const XImage(
                            imagePath: 'assets/images/ic-search-grey.png',
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                          fillColor: AppColor.WHITE,
                          suffixIcon: _searchController.text.isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {});
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          hintText: 'Tìm kiếm người dùng qua SĐT',
                          keyboardAction: TextInputAction.next,
                          onSubmitted: (value) async {
                            if (_searchController.text.isNotEmpty &&
                                _searchController.text.length >= 5) {
                              await getUser(_searchController.text).then(
                                (value) {
                                  listUser = [...mapUser(value)];
                                },
                              );
                            } else {
                              listUser = [];
                            }
                            setState(() {});
                          },
                          onChange: (value) {
                            setState(() {});
                          },
                          inputType: TextInputType.text,
                          isObscureText: false)),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      focusNodeSearch.unfocus();
                      if (_searchController.text.isNotEmpty &&
                          _searchController.text.length >= 5) {
                        await getUser(_searchController.text).then(
                          (value) {
                            if (widget.action == ActionType.CREATE) {
                              listUser = [...mapUser(value)];
                            } else {
                              for (var element in value) {
                                UserFolder userFolder = UserFolder(
                                  fullName: element.fullName,
                                  role: 'VIEWER',
                                  userId: element.userId,
                                  phoneNo: element.phoneNo,
                                  imageId: element.imageId,
                                );
                                listUserUpdateSearch.add(userFolder);
                              }
                            }
                          },
                        );
                      } else {
                        listUserUpdateSearch = [];
                        listUser = [];
                      }
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      height: 40,
                      // width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                          gradient: LinearGradient(
                              colors: _gradients[0],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight)),
                      child: const Center(
                        child: Text(
                          'Tìm kiếm',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Future<void> onUnFocus() async {
    focusNodeDes.unfocus();
    focusNode.unfocus();
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
}

class ListQrCheckBox {
  bool? isValid;
  QrFeedPrivateDTO? dto;

  ListQrCheckBox({required this.isValid, required this.dto});
}

class ListUserCheckBox {
  String? role;
  String? title;

  bool? isValid;
  SearchUser? dto;

  ListUserCheckBox(
      {required this.isValid,
      required this.role,
      required this.title,
      required this.dto});
}
