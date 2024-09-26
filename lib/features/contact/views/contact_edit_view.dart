import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/contact/blocs/contact_bloc.dart';
import 'package:vierqr/features/contact/events/contact_event.dart';
import 'package:vierqr/features/contact/models/data_model.dart';
import 'package:vierqr/features/contact/save_contact_screen.dart';
import 'package:vierqr/features/contact/states/contact_state.dart';
import 'package:vierqr/features/create_qr/widgets/bottom_sheet_image.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/contact_detail_dto.dart';

import '../../../commons/utils/file_utils.dart';

class ContactEditView extends StatelessWidget {
  final Function(Map<String, dynamic>)? onCallBack;
  final ContactDetailDTO contactDetailDTO;

  const ContactEditView(
      {super.key, this.onCallBack, required this.contactDetailDTO});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactBloc>(
      create: (context) => ContactBloc(context),
      child: _ContactEditView(
        onCallBack: onCallBack,
        contactDetailDTO: contactDetailDTO,
      ),
    );
  }
}

// ignore: must_be_immutable
class _ContactEditView extends StatefulWidget {
  final Function(Map<String, dynamic>)? onCallBack;
  final ContactDetailDTO contactDetailDTO;

  const _ContactEditView({this.onCallBack, required this.contactDetailDTO});

  @override
  State<_ContactEditView> createState() => _ContactEditViewState();
}

class _ContactEditViewState extends State<_ContactEditView> {
  final nickNameController = TextEditingController();
  final suggestController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final webController = TextEditingController();
  final companyController = TextEditingController();
  int typeColorCard = 0;
  String imageLogoId = '';
  File? logo;
  final _key = GlobalKey();

  late ContactBloc _bloc;

  final ImagePicker imagePicker = ImagePicker();
  List<CardQrColor> listCardColor = [
    CardQrColor(type: 0, pathImage: 'assets/images/color-type-0.png'),
    CardQrColor(type: 1, pathImage: 'assets/images/color-type-1.png'),
    CardQrColor(type: 2, pathImage: 'assets/images/color-type-2.png'),
    CardQrColor(type: 3, pathImage: 'assets/images/color-type-3.png'),
    CardQrColor(type: 4, pathImage: 'assets/images/color-type-4.png'),
  ];

  final List<ContactDataModel> list = [
    ContactDataModel(
        title: 'Cá nhân', type: 0, url: 'assets/images/personal-relation.png'),
    ContactDataModel(
        title: 'Cộng đồng', type: 1, url: 'assets/images/gl-white.png'),
  ];

  ContactDataModel? model;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);

    typeColorCard = widget.contactDetailDTO.colorType;
    imageLogoId = widget.contactDetailDTO.imgId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nickNameController.text = widget.contactDetailDTO.nickname;
      suggestController.text = widget.contactDetailDTO.additionalData;

      if (widget.contactDetailDTO.type == 4) {
        addressController.text = widget.contactDetailDTO.address;
        webController.text = widget.contactDetailDTO.website;
        companyController.text = widget.contactDetailDTO.company;
        emailController.text = widget.contactDetailDTO.email;
        phoneController.text = widget.contactDetailDTO.phoneNo;
      }

      if (widget.contactDetailDTO.type == 2) {
        model = list.first;
      } else {
        if (widget.contactDetailDTO.relation == 0) {
          model = list.first;
        } else {
          model = list.last;
        }
      }

      setState(() {});
    });
  }

  void onChangeLogo(BuildContext context) async {
    final data = await DialogWidget.instance.showModelBottomSheet(
      context: context,
      padding: EdgeInsets.zero,
      isDismissible: true,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      widget: BottomSheetImage(),
    );

    if (data is XFile) {
      File? file = File(data.path);
      File? compressedFile = FileUtils.instance.compressImage(file);
      await Future.delayed(const Duration(milliseconds: 200), () {
        if (compressedFile != null) {
          File? file = File(compressedFile.path);

          setState(() {
            logo = file;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).viewPadding.top;
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state.status == BlocStatus.UNLOADING) {
          Navigator.of(context).pop();
        }

        if (state.type == ContactType.REMOVE) {
          eventBus.fire(ReloadContact());
          NavigatorUtils.navigateToRoot(context);
        }

        if (state.type == ContactType.UPDATE) {
          Map<String, dynamic> query = {
            "id": widget.contactDetailDTO.id,
            "relation": model?.type ?? 0,
          };
          _bloc.add(UpdateContactRelationEvent(query));

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
          body: Column(
            children: [
              Expanded(
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
                              const SizedBox(height: 8),
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
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: _buildTypeNameQr(
                                          widget.contactDetailDTO),
                                    ),
                                    if (widget.contactDetailDTO.type != 2) ...[
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              child: Text(
                                                'Quyền riêng tư',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: _onHandleTap,
                                                child: Container(
                                                  key: _key,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      if (model?.url != null)
                                                        if (model!
                                                            .url.isNotEmpty)
                                                          Image.asset(
                                                              model?.url ?? '',
                                                              color: AppColor
                                                                  .BLACK,
                                                              width: 20),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        model?.title ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      const Spacer(),
                                                      const Icon(
                                                        Icons.expand_more,
                                                        color: AppColor.BLACK,
                                                        size: 24,
                                                      ),
                                                      const SizedBox(width: 8),
                                                    ],
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
                              ),
                              const SizedBox(height: 24),
                              if (widget.contactDetailDTO.type == 4) ...[
                                TextFieldCustom(
                                  isObscureText: false,
                                  fillColor: AppColor.WHITE,
                                  textFieldType: TextfieldType.LABEL,
                                  title: 'Số điện thoại',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  controller: phoneController,
                                  hintText:
                                      'Nhập số điện thoại cho mã QR của bạn',
                                  inputType: TextInputType.text,
                                  keyboardAction: TextInputAction.next,
                                  onChange: (value) {},
                                ),
                                const SizedBox(height: 24),
                                TextFieldCustom(
                                  isObscureText: false,
                                  fillColor: AppColor.WHITE,
                                  textFieldType: TextfieldType.LABEL,
                                  title: 'Email',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  controller: emailController,
                                  hintText: 'Nhập email cho mã QR của bạn',
                                  inputType: TextInputType.text,
                                  keyboardAction: TextInputAction.next,
                                  onChange: (value) {},
                                ),
                                const SizedBox(height: 24),
                                TextFieldCustom(
                                  isObscureText: false,
                                  fillColor: AppColor.WHITE,
                                  textFieldType: TextfieldType.LABEL,
                                  title: 'Địa chỉ',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  controller: addressController,
                                  hintText: 'Nhập địa chỉ cho mã QR của bạn',
                                  inputType: TextInputType.text,
                                  keyboardAction: TextInputAction.next,
                                  onChange: (value) {},
                                ),
                                const SizedBox(height: 24),
                                TextFieldCustom(
                                  isObscureText: false,
                                  fillColor: AppColor.WHITE,
                                  textFieldType: TextfieldType.LABEL,
                                  title: 'Website',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  controller: webController,
                                  hintText: 'Nhập website cho mã QR của bạn',
                                  inputType: TextInputType.text,
                                  keyboardAction: TextInputAction.next,
                                  onChange: (value) {},
                                ),
                                const SizedBox(height: 24),
                                TextFieldCustom(
                                  isObscureText: false,
                                  fillColor: AppColor.WHITE,
                                  textFieldType: TextfieldType.LABEL,
                                  title: 'Công ty',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  controller: companyController,
                                  hintText:
                                      'Nhập tên công ty cho mã QR của bạn',
                                  inputType: TextInputType.text,
                                  keyboardAction: TextInputAction.next,
                                  onChange: (value) {},
                                ),
                                const SizedBox(height: 24),
                              ],
                              TextFieldCustom(
                                isObscureText: false,
                                maxLines: 4,
                                fillColor: AppColor.WHITE,
                                textFieldType: TextfieldType.LABEL,
                                title: 'Mô tả QR',
                                contentPadding: const EdgeInsets.symmetric(
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
                            widget.contactDetailDTO.type == 3 ||
                            widget.contactDetailDTO.type == 4)
                          _buildChooseColor((colorType) {
                            setState(() {
                              typeColorCard = colorType;
                            });
                          }),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: GestureDetector(
                            onTap: () {
                              DialogWidget.instance.openMsgDialog(
                                title: 'Xoá thẻ QR',
                                msg: 'Bạn có chắc chắn muốn xoá thẻ này?',
                                isSecondBT: true,
                                functionConfirm: () {
                                  Navigator.of(context).pop();
                                  _bloc.add(RemoveContactEvent(
                                      id: widget.contactDetailDTO.id));
                                },
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColor.WHITE,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    color: AppColor.RED_TEXT,
                                    size: 18,
                                  ),
                                  SizedBox(
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
                    if (_offset != null)
                      if (enableList)
                        Positioned(
                          top: (_offset!.dy - height - 60),
                          left: _offset!.dx,
                          right: 20,
                          child: Row(
                            children: [
                              Expanded(
                                child: BuildDropDownWidget(
                                  onChange: (data) {
                                    if (model != data) {
                                      model = data;
                                    }
                                    enableList = !enableList;

                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
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
                        title: 'Cập nhật',
                        isEnable: true,
                        margin: EdgeInsets.zero,
                        onTap: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (!mounted) return;

                          //type vCard
                          if (widget.contactDetailDTO.type == 4) {
                            ContactDetailDTO dto = ContactDetailDTO(
                              id: widget.contactDetailDTO.id,
                              nickname: nickNameController.text,
                              additionalData: suggestController.text,
                              colorType: typeColorCard,
                              address: addressController.text,
                              company: companyController.text,
                              website: webController.text,
                              email: emailController.text,
                              phoneNo: phoneController.text,
                              imgId: widget.contactDetailDTO.imgId,
                            );

                            _bloc.add(
                                UpdateContactVCardEvent(dto.toJson(), logo));
                          } else {
                            Map<String, dynamic> data = {
                              "id": widget.contactDetailDTO.id,
                              "nickName": nickNameController.text,
                              "type": widget.contactDetailDTO.type.toString(),
                              "additionalData": suggestController.text,
                              "colorType": typeColorCard.toString(),
                              "imgId": widget.contactDetailDTO.type == 3
                                  ? imageLogoId
                                  : '',
                            };
                            _bloc.add(UpdateContactEvent(data, logo));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  bool enableList = false;

  bool isEnableBT = false;

  Offset? _offset;

  _onHandleTap() {
    RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position

    _offset = position;
    enableList = !enableList;

    setState(() {});
  }

  Widget _buildChooseColor(Function(int) colorType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
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
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(3),
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
    if (dto.type == 2 || dto.type == 1) {
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
                image: dto.imgId.isNotEmpty
                    ? DecorationImage(
                        image: ImageUtils.instance.getImageNetWork(dto.imgId),
                        fit: dto.type == 1 ? BoxFit.cover : BoxFit.contain,
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/images/ic-viet-qr-small.png'),
                        fit: BoxFit.contain),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            if (dto.type == 1)
              Text(dto.nickname,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16))
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dto.bankShortName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(dto.bankAccount),
                  ],
                ),
              ),
          ],
        ),
      );
    }
    return Row(
      children: [
        if (logo != null)
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColor.WHITE,
              image:
                  DecorationImage(image: FileImage(logo!), fit: BoxFit.cover),
            ),
          )
        else
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColor.WHITE,
              image: dto.imgId.isNotEmpty
                  ? DecorationImage(
                      image: ImageUtils.instance.getImageNetWork(dto.imgId),
                      fit: BoxFit.cover)
                  : const DecorationImage(
                      image: AssetImage('assets/images/ic-tb-qr.png'),
                      fit: BoxFit.contain),
            ),
          ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Logo QR giúp bạn tìm thẻ nhanh hơn',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColor.GREY_TEXT),
            ),
            const SizedBox(height: 4),
            MButtonWidget(
              width: 120,
              height: 30,
              title: 'Đổi logo QR',
              isEnable: true,
              colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.3),
              colorEnableText: AppColor.BLUE_TEXT,
              margin: EdgeInsets.zero,
              onTap: () async {
                onChangeLogo(context);
              },
            )
          ],
        ),
      ],
    );
  }

  Widget _buildTypeNameQr(ContactDetailDTO dto) {
    if (dto.type == 2) {
      return TextFieldCustom(
        isObscureText: false,
        maxLines: 1,
        fillColor: AppColor.GREY_TEXT.withOpacity(0.1),
        controller: TextEditingController(text: dto.bankName),
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
    } else if (dto.type == 4) {
      return TextFieldCustom(
        isObscureText: false,
        maxLines: 1,
        fillColor: AppColor.GREY_TEXT.withOpacity(0.1),
        controller: TextEditingController(text: 'VCard'),
        textFieldType: TextfieldType.LABEL,
        title: 'Loại QR',
        hintText: '',
        readOnly: true,
        inputType: TextInputType.text,
        keyboardAction: TextInputAction.next,
        onChange: (value) {},
      );
    }

    return TextFieldCustom(
      isObscureText: false,
      maxLines: 1,
      fillColor: AppColor.GREY_TEXT.withOpacity(0.1),
      controller: TextEditingController(text: 'Khác'),
      textFieldType: TextfieldType.LABEL,
      title: 'Loại QR',
      hintText: '',
      readOnly: true,
      inputType: TextInputType.text,
      keyboardAction: TextInputAction.next,
      onChange: (value) {},
    );
  }
}

class CardQrColor {
  final int type;
  final String pathImage;

  CardQrColor({required this.type, required this.pathImage});
}
