import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/contact/blocs/contact_bloc.dart';
import 'package:vierqr/features/contact/events/contact_event.dart';
import 'package:vierqr/features/contact/states/contact_state.dart';

import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/contact_detail_dto.dart';
import 'package:vierqr/models/contact_dto.dart';

import 'contact_edit_view.dart';

// ignore: must_be_immutable
class ContactDetailScreen extends StatefulWidget {
  final ContactDTO dto;

  const ContactDetailScreen({super.key, required this.dto});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactBloc>(
      create: (context) =>
          ContactBloc(context)..add(ContactEventGetDetail(id: widget.dto.id)),
      child: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state.status == BlocStatus.UNLOADING) {
            // Navigator.pop(context);
          }

          if (state.type == ContactType.REMOVE) {
            Navigator.of(context).pop();
            Fluttertoast.showToast(
              msg: 'Xoá thành công',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
          }

          if (state.type == ContactType.UPDATE) {}

          if (state.type == ContactType.GET_LIST) {}
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
                        builder: (_) => ContactEditView(
                            contactDetailDTO: state.contactDetailDTO),
                        // settings: RouteSettings(name: ContactEditView.routeName),
                      ),
                    );

                    if (!mounted) return;
                    if (data is bool) {
                      context
                          .read<ContactBloc>()
                          .add(ContactEventGetDetail(id: widget.dto.id));
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
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30, right: 30, top: 50, bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColor.WHITE,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .shadowColor
                                    .withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(1, 2),
                              ),
                            ],
                          ),
                          child: QrImage(
                            data: state.contactDetailDTO.value ?? '',
                            version: QrVersions.auto,
                            embeddedImage: const AssetImage(
                                'assets/images/ic-viet-qr-small.png'),
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: const Size(30, 30),
                            ),
                          ),
                        ),
                        Text(
                          state.contactDetailDTO.nickName ?? '',
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
                            _buildTypeQr(state.contactDetailDTO)
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
                          child:
                              Text(state.contactDetailDTO.additionalData ?? ''),
                        ),
                        const SizedBox(
                          height: 80,
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: MButtonWidget(
                          onTap: () {
                            DialogWidget.instance.openMsgDialog(
                              title: 'Xoá liên hệ',
                              msg: 'Bạn có chắc chắn muốn xoá liên hệ này?',
                              isSecondBT: true,
                              functionConfirm: () {
                                Navigator.of(context).pop();
                                BlocProvider.of<ContactBloc>(context)
                                    .add(RemoveContactEvent(id: widget.dto.id));
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
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeQr(ContactDetailDTO dto) {
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
