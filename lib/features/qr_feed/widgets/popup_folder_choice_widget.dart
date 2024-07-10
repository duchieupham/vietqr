import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';
import 'package:vierqr/features/qr_feed/views/create_folder_screen.dart';
import 'package:vierqr/features/qr_feed/views/folder_detail_screen.dart';
import 'package:vierqr/features/qr_feed/widgets/delete_dialog_widget.dart';
import 'package:vierqr/features/qr_feed/widgets/popup_folder_detail_folder.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/qr_feed_folder_dto.dart';
import 'package:vierqr/models/qr_folder_detail_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class PopupFolderChoiceWidget extends StatefulWidget {
  final QrFeedFolderDTO dto;

  const PopupFolderChoiceWidget({super.key, required this.dto});

  @override
  State<PopupFolderChoiceWidget> createState() =>
      _PopupFolderChoiceWidgetState();
}

class _PopupFolderChoiceWidgetState extends State<PopupFolderChoiceWidget> {
  final QrFeedBloc _bloc = getIt.get<QrFeedBloc>();

  String get userId => SharePrefUtils.getProfile().userId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrFeedBloc, QrFeedState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == QrFeed.GET_UPDATE_FOLDER_DETAIL &&
            state.status == BlocStatus.SUCCESS) {
          List<QrData> qrList = [];
          if (state.folderDetailDTO != null) {
            qrList = state.folderDetailDTO!.qrData;
          }

          final listUser = state.listAllUserFolder;
          NavigationService.push(Routes.CREATE_QR_FOLDER_SCREEN, arguments: {
            'page': 2,
            'action': ActionType.UPDATE_USER,
            'id': widget.dto.id,
            'listQrPrivate': qrList,
            'listUserFolder': listUser,
          });
        }
      },
      builder: (context, state) {
        return Container(
          height: widget.dto.userId != userId ? 160 : 360,
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                                colors: [Color(0xFFF5CEC7), Color(0xFFFFD7BF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight)),
                        child: const XImage(
                            imagePath: 'assets/images/ic-folder.png'),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.dto.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.clear,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  DialogWidget.instance.showModelBottomSheet(
                    borderRadius: BorderRadius.circular(20),
                    widget: PopupDetailFolder(
                      dto: widget.dto,
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                  );
                },
                child: const _buildItem(
                    img: 'assets/images/ic-i-black.png',
                    title: 'Chi tiết thư mục'),
              ),
              if (widget.dto.userId == userId) ...[
                const MySeparator(color: AppColor.GREY_DADADA),
                InkWell(
                  onTap: () {
                    _bloc.add(GetUpdateFolderDetailEvent(
                        type: ActionType.UPDATE_USER, folderId: widget.dto.id));
                  },
                  child: const _buildItem(
                      img: 'assets/images/ic-add-person-black.png',
                      title: 'Thêm người truy cập'),
                ),
                const MySeparator(color: AppColor.GREY_DADADA),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();

                    NavigationService.push(Routes.CREATE_QR_FOLDER_SCREEN,
                        arguments: {
                          'page': 1,
                          'action': ActionType.UPDATE_QR,
                          'id': widget.dto.id,
                        });
                  },
                  child: const _buildItem(
                      img: 'assets/images/ic-add-qr-black.png',
                      title: 'Tùy chỉnh mã QR vào thư mục'),
                ),
                const MySeparator(color: AppColor.GREY_DADADA),
                // InkWell(
                //   onTap: () {},
                //   child: const _buildItem(
                //       img: 'assets/images/ic-delete-black.png',
                //       title: 'Xóa mã QR vào thư mục'),
                // ),
                // const MySeparator(color: AppColor.GREY_DADADA),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    DialogWidget.instance.openWidgetDialog(
                        heightPopup: MediaQuery.of(context).size.height * 0.5,
                        padding: const EdgeInsets.all(0),
                        radius: 10,
                        child: DeleteDialogWidget(
                          folderId: widget.dto.id,
                        ));
                  },
                  child: const _buildItem(
                      img: 'assets/images/ic-remove-black.png',
                      title: 'Xoá thư mục'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _buildItem extends StatelessWidget {
  final String img;
  final String title;

  const _buildItem({
    super.key,
    required this.img,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
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
            child: XImage(imagePath: img),
          ),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}
