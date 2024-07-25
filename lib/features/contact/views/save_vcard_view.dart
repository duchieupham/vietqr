import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/contact/models/data_model.dart';
import 'package:vierqr/features/contact/save_contact_screen.dart';

class BuildVCardView extends StatefulWidget {
  final TypeContact type;
  final TextEditingController nameController;
  final TextEditingController suggestController;
  final TextEditingController addressController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController webController;
  final TextEditingController companyController;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onChangeColor;
  final ValueChanged<ContactDataModel>? onChangeQRT;
  final List<String> listColor;
  final String typeColor;
  final String imgId;
  final double height;
  final ContactDataModel model;

  const BuildVCardView({super.key, 
    required this.type,
    required this.nameController,
    required this.suggestController,
    required this.addressController,
    required this.emailController,
    required this.phoneController,
    required this.webController,
    required this.companyController,
    this.onChange,
    this.onChangeColor,
    required this.listColor,
    this.typeColor = '',
    this.imgId = '',
    required this.height,
    this.onChangeQRT,
    required this.model,
  });

  @override
  State<BuildVCardView> createState() => _buildVietQRIDState();
}

class _buildVietQRIDState extends State<BuildVCardView> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              children: [
                if (widget.imgId.isNotEmpty)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            ImageUtils.instance.getImageNetWork(widget.imgId),
                      ),
                    ),
                  )
                else
                  ClipOval(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset('assets/images/ic-avatar.png'),
                    ),
                  ),
                const SizedBox(width: 10),
                Text(
                  widget.nameController.text,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFieldCustom(
              isObscureText: false,
              maxLines: 1,
              fillColor: AppColor.WHITE,
              controller: widget.nameController,
              isRequired: true,
              title: 'Tên',
              textFieldType: TextfieldType.LABEL,
              hintText: 'Nhập tên',
              inputType: TextInputType.text,
              keyboardAction: TextInputAction.next,
              onChange: widget.onChange,
            ),
            const SizedBox(height: 24),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TextFieldCustom(
                      isObscureText: false,
                      maxLines: 1,
                      fillColor: AppColor.gray.withOpacity(0.3),
                      isRequired: false,
                      enable: false,
                      title: 'Loại QR',
                      textFieldType: TextfieldType.LABEL,
                      hintText: widget.type.typeName,
                      hintColor: AppColor.BLACK,
                      inputType: TextInputType.text,
                      keyboardAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    widget.model.url,
                                    color: AppColor.BLACK,
                                    width: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.model.title,
                                    style: const TextStyle(fontSize: 14),
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
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFieldCustom(
              isObscureText: false,
              fillColor: AppColor.WHITE,
              textFieldType: TextfieldType.LABEL,
              title: 'Số điện thoại',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              controller: widget.phoneController,
              hintText: 'Nhập số điện thoại cho mã QR của bạn',
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
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              controller: widget.emailController,
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
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              controller: widget.addressController,
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
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              controller: widget.webController,
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
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              controller: widget.companyController,
              hintText: 'Nhập tên công ty cho mã QR của bạn',
              inputType: TextInputType.text,
              keyboardAction: TextInputAction.next,
              onChange: (value) {},
            ),
            const SizedBox(height: 24),
            TextFieldCustom(
              isObscureText: false,
              maxLines: 5,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              fillColor: AppColor.WHITE,
              controller: widget.suggestController,
              isRequired: false,
              title: 'Mô tả QR',
              textFieldType: TextfieldType.LABEL,
              hintText: 'Nhập mô tả cho mã QR của bạn',
              inputType: TextInputType.text,
              keyboardAction: TextInputAction.next,
              // onChange: provider.onChangeName,
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Màu sắc thẻ QR',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                if (widget.listColor.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(widget.listColor.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            widget.onChangeColor!(index.toString());
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(2),
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              border:
                                  int.parse(widget.typeColor.trim()) == index
                                      ? Border.all(color: AppColor.BLUE_TEXT)
                                      : Border.all(color: AppColor.TRANSPARENT),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Image.asset(widget.listColor[index]),
                          ),
                        );
                      }).toList(),
                    ),
                  )
              ],
            )
          ],
        ),
        if (_offset != null)
          if (enableList)
            Positioned(
              top: (_offset!.dy - widget.height - 110),
              left: _offset!.dx - 20,
              right: 0,
              child: Row(
                children: [
                  Expanded(
                    child: BuildDropDownWidget(
                      onChange: (model) {
                        widget.onChangeQRT!(model);
                        setState(() {
                          enableList = !enableList;
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
      ],
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
}
