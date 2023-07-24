import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/phone_book/blocs/phone_book_bloc.dart';
import 'package:vierqr/features/phone_book/events/phone_book_event.dart';
import 'package:vierqr/features/phone_book/states/phone_book_state.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/phone_book_detail_dto.dart';
import 'package:vierqr/models/phone_book_dto.dart';

import 'phone_book_edit_view.dart';

// ignore: must_be_immutable
class PhoneDetailScreen extends StatefulWidget {
  final PhoneBookDTO dto;

  const PhoneDetailScreen({super.key, required this.dto});

  @override
  State<PhoneDetailScreen> createState() => _PhoneDetailScreenState();
}

class _PhoneDetailScreenState extends State<PhoneDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhoneBookBloc>(
      create: (context) => PhoneBookBloc(context)
        ..add(PhoneBookEventGetDetail(id: widget.dto.id)),
      child: BlocConsumer<PhoneBookBloc, PhoneBookState>(
        listener: (context, state) {
          if (state.status == BlocStatus.LOADING) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            Navigator.pop(context);
          }

          if (state.type == PhoneBookType.REMOVE) {
            Navigator.of(context).pop();
            Fluttertoast.showToast(
              msg: 'Xoá thành công',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
          }

          if (state.type == PhoneBookType.UPDATE) {}

          if (state.type == PhoneBookType.GET_LIST) {}
        },
        builder: (context, state) {
          return Scaffold(
            appBar: MAppBar(
              title: widget.dto.nickname,
              actions: [
                GestureDetector(
                  onTap: () async {
                    final data = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PhoneBookEditView(
                            phoneBookDetailDTO: state.phoneBookDetailDTO),
                        // settings: RouteSettings(name: PhoneBookEditView.routeName),
                      ),
                    );

                    if (!mounted) return;
                    if (data is bool) {
                      context
                          .read<PhoneBookBloc>()
                          .add(PhoneBookEventGetDetail(id: widget.dto.id));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/ic-edit.png',
                    ),
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 30, right: 30, top: 50, bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(1, 2),
                        ),
                      ],
                    ),
                    child: QrImage(
                      data: state.phoneBookDetailDTO.value ?? '',
                      version: QrVersions.auto,
                      embeddedImage: const AssetImage(
                          'assets/images/ic-viet-qr-small.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: const Size(30, 30),
                      ),
                    ),
                  ),
                  Text(
                    state.phoneBookDetailDTO.nickName ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Loại QR",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      _buildTypeQr(state.phoneBookDetailDTO)
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ghi chú",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColor.WHITE,
                    ),
                    child: Text(state.phoneBookDetailDTO.additionalData ?? ''),
                  ),
                  const Spacer(),
                  MButtonWidget(
                      onTap: () {
                        DialogWidget.instance.openMsgDialog(
                          title: 'Xoá liên hệ',
                          msg: 'Bạn có chắc chắn muốn xoá liên hệ này?',
                          isSecondBT: true,
                          functionConfirm: () {
                            Navigator.of(context).pop();
                            BlocProvider.of<PhoneBookBloc>(context)
                                .add(RemovePhoneBookEvent(id: widget.dto.id));
                          },
                        );
                      },
                      height: 40,
                      width: double.infinity,
                      title: 'Xoá thông tin',
                      margin: EdgeInsets.zero,
                      isEnable: true,
                      colorEnableText: AppColor.RED_TEXT,
                      fontSize: 14,
                      colorEnableBgr: AppColor.WHITE),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeQr(PhoneBookDetailDTO dto) {
    if (dto.type == 2) {
      return Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColor.WHITE,
          image: DecorationImage(
              image: ImageUtils.instance.getImageNetWork(dto.imgId ?? '')),
        ),
      );
    }

    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.WHITE,
      ),
      child: const Text('VietQR ID'),
    );
  }
}
