import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/contact/blocs/contact_bloc.dart';
import 'package:vierqr/features/contact/events/contact_event.dart';
import 'package:vierqr/features/contact/states/contact_state.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/contact_detail_dto.dart';

// ignore: must_be_immutable
class ContactEditView extends StatefulWidget {
  final Function(Map<String, dynamic>)? onCallBack;
  final ContactDetailDTO contactDetailDTO;

  const ContactEditView(
      {super.key, this.onCallBack, required this.contactDetailDTO});

  @override
  State<ContactEditView> createState() => _ContactEditViewState();
}

class _ContactEditViewState extends State<ContactEditView> {
  final nickNameController = TextEditingController();
  final suggestController = TextEditingController();
  int typeColorCard = 0;
  List<CardQrColor> listCardColor = [
    CardQrColor(type: 0, pathImage: 'assets/images/color-type-0.png'),
    CardQrColor(type: 1, pathImage: 'assets/images/color-type-1.png'),
    CardQrColor(type: 2, pathImage: 'assets/images/color-type-2.png'),
    CardQrColor(type: 3, pathImage: 'assets/images/color-type-3.png'),
    CardQrColor(type: 4, pathImage: 'assets/images/color-type-4.png'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nickNameController.text = widget.contactDetailDTO.nickName ?? '';
      suggestController.text = widget.contactDetailDTO.additionalData ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactBloc>(
      create: (context) => ContactBloc(context),
      child: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state.status == BlocStatus.LOADING) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            Navigator.of(context).pop();
          }

          if (state.type == ContactType.UPDATE) {
            Fluttertoast.showToast(
              msg: 'Cập nhật thông tin thành công',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const MAppBar(title: 'Cập nhật thẻ QR', actions: []),
            body: SafeArea(
              child: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          children: [
                            _buildTypeQr(widget.contactDetailDTO),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 16, top: 8),
                              child: _buildTypeNameQr(widget.contactDetailDTO),
                            ),
                            TextFieldCustom(
                              isObscureText: false,
                              maxLines: 1,
                              fillColor: AppColor.WHITE,
                              controller: nickNameController,
                              textFieldType: TextfieldType.LABEL,
                              title: 'Tên',
                              hintText: '',
                              isRequired: true,
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.next,
                              onChange: (value) {},
                            ),
                            const SizedBox(height: 16),
                            TextFieldCustom(
                              isObscureText: false,
                              maxLines: 4,
                              fillColor: AppColor.WHITE,
                              textFieldType: TextfieldType.LABEL,
                              title: 'Mô tả QR',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              controller: suggestController,
                              hintText: 'Nhập mô tả cho mã QR của bạn',
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.next,
                              onChange: (value) {},
                            ),
                          ],
                        ),
                      ),
                      if (widget.contactDetailDTO.type == 1 ||
                          widget.contactDetailDTO.type == 3)
                        _buildChooseColor((colorType) {
                          setState(() {
                            typeColorCard = colorType;
                          });
                        }),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            DialogWidget.instance.openMsgDialog(
                              title: 'Xoá thẻ QR',
                              msg: 'Bạn có chắc chắn muốn xoá thẻ này?',
                              isSecondBT: true,
                              functionConfirm: () {
                                Navigator.of(context).pop();
                                BlocProvider.of<ContactBloc>(context).add(
                                    RemoveContactEvent(
                                        id: widget.contactDetailDTO.id ?? ''));
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: AppColor.RED_TEXT,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Xoá thẻ QR',
                                  style: TextStyle(
                                    color: AppColor.RED_TEXT,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 120,
                      )
                    ],
                  ),
                  Positioned(
                      bottom: 12,
                      right: 20,
                      left: 20,
                      child: Row(
                        children: [
                          Expanded(
                            child: MButtonWidget(
                              title: 'Huỷ',
                              isEnable: true,
                              colorEnableBgr: AppColor.WHITE,
                              colorEnableText: AppColor.BLACK,
                              margin: EdgeInsets.zero,
                              onTap: () async {
                                Navigator.of(context).pop();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: MButtonWidget(
                              title: 'Cập nhật thông tin',
                              isEnable: true,
                              margin: EdgeInsets.zero,
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (!mounted) return;
                                Map<String, dynamic> data = {
                                  "id": widget.contactDetailDTO.id ?? '',
                                  "nickName": nickNameController.text,
                                  "type":
                                      widget.contactDetailDTO.type.toString(),
                                  "additionalData": suggestController.text,
                                  "colorType": typeColorCard.toString(),
                                };

                                context
                                    .read<ContactBloc>()
                                    .add(UpdateContactEvent(data));
                              },
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChooseColor(Function(int) colorType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Màu sắc thẻ QR',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: listCardColor.map((e) {
              return GestureDetector(
                onTap: () {
                  colorType(e.type);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: e.type == typeColorCard
                              ? AppColor.BLUE_TEXT
                              : Colors.transparent)),
                  child: Image.asset(
                    e.pathImage,
                    height: 35,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeQr(ContactDetailDTO dto) {
    if (dto.type == 2) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColor.WHITE,
                image: DecorationImage(
                    image:
                        ImageUtils.instance.getImageNetWork(dto.imgId ?? '')),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.bankShortName ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    dto.bankAccount ?? '',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (dto.type == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColor.WHITE,
                image: DecorationImage(
                    image:
                        ImageUtils.instance.getImageNetWork(dto.imgId ?? '')),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              dto.nickName ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
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

  Widget _buildTypeNameQr(ContactDetailDTO dto) {
    if (dto.type == 2) {
      return TextFieldCustom(
        isObscureText: false,
        maxLines: 1,
        fillColor: AppColor.GREY_TEXT.withOpacity(0.1),
        controller: TextEditingController(text: dto.bankName ?? ''),
        textFieldType: TextfieldType.LABEL,
        title: 'Loại QR',
        hintText: '',
        readOnly: true,
        inputType: TextInputType.text,
        keyboardAction: TextInputAction.next,
        onChange: (value) {},
      );
    } else if (dto.type == 1) {
      return TextFieldCustom(
        isObscureText: false,
        maxLines: 1,
        fillColor: AppColor.GREY_TEXT.withOpacity(0.1),
        controller: TextEditingController(text: 'VietQR ID'),
        textFieldType: TextfieldType.LABEL,
        title: 'Loại QR',
        hintText: '',
        readOnly: true,
        inputType: TextInputType.text,
        keyboardAction: TextInputAction.next,
        onChange: (value) {},
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

class CardQrColor {
  final int type;
  final String pathImage;
  CardQrColor({required this.type, required this.pathImage});
}
