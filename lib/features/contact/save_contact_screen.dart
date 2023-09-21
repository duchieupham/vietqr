import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/file_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/contact/blocs/contact_bloc.dart';
import 'package:vierqr/features/contact/blocs/contact_provider.dart';
import 'package:vierqr/features/contact/events/contact_event.dart';
import 'package:vierqr/features/contact/models/data_model.dart';
import 'package:vierqr/features/contact/states/contact_state.dart';
import 'package:vierqr/features/create_qr/views/bottom_sheet_image.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/add_contact_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/vietqr_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class SaveContactScreen extends StatelessWidget {
  final String code;
  final TypeContact typeQR;
  final dynamic dto;

  const SaveContactScreen(
      {super.key, required this.code, required this.typeQR, this.dto});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ContactBloc(context, qrCode: code, typeQR: typeQR, dto: dto)
            ..add(InitDataEvent()),
      child: ChangeNotifierProvider<ContactProvider>(
        create: (context) => ContactProvider(),
        child: _BodyWidget(typeQR),
      ),
    );
  }
}

class _BodyWidget extends StatefulWidget {
  final TypeContact typeQR;

  const _BodyWidget(this.typeQR);

  @override
  State<_BodyWidget> createState() => _SaveContactScreenState();
}

class _SaveContactScreenState extends State<_BodyWidget> {
  late ContactBloc _bloc;
  final nameController = TextEditingController();
  final suggestController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(GetNickNameContactEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).viewPadding.top;
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) async {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state.status == BlocStatus.UNLOADING) {
          Navigator.pop(context);
        }

        if (state.type == ContactType.SAVE) {
          Navigator.of(context).pop(true);
        }
        if (state.type == ContactType.NICK_NAME) {
          nameController.value =
              nameController.value.copyWith(text: state.nickName ?? '');
          Provider.of<ContactProvider>(context, listen: false)
              .onChangeName(state.nickName ?? '');
          if (state.dto is VietQRDTO) {
            VietQRDTO data = state.dto;
            Provider.of<ContactProvider>(context, listen: false)
                .updateColorType(data.colorType.toString());
          }
        }

        if (state.type == ContactType.SCAN) {
          nameController.value = nameController.value
              .copyWith(text: state.dto?.userBankName ?? '');
          Provider.of<ContactProvider>(context, listen: false)
              .onChangeName(state.dto?.userBankName ?? '');
        }

        if (state.type == ContactType.ERROR) {
          await DialogWidget.instance.openMsgDialog(
              title: 'Không thể lưu danh bạ', msg: state.msg ?? '');
        }
      },
      builder: (context, state) {
        return Consumer<ContactProvider>(
          builder: (context, provider, child) {
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                appBar: const MAppBar(title: 'Thêm thẻ QR'),
                body: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              if (state.typeQR == TypeContact.VietQR_ID)
                                _buildVietQRID(
                                  type: state.typeQR,
                                  nameController: nameController,
                                  suggestController: suggestController,
                                  onChange: provider.onChangeName,
                                  onChangeColor: provider.updateColorType,
                                  listColor: provider.listColor,
                                  typeColor: provider.colorType,
                                  imgId: state.imgId ?? '',
                                  height: height,
                                  onChangeQRT: provider.updateQRT,
                                  model: provider.model,
                                )
                              else if (state.typeQR == TypeContact.Bank)
                                _buildBankView(
                                  type: state.typeQR,
                                  nameController: nameController,
                                  suggestController: suggestController,
                                  onChange: provider.onChangeName,
                                  onChangeColor: provider.updateColorType,
                                  listColor: provider.listColor,
                                  typeColor: provider.colorType,
                                  imgId: state.imgId ?? '',
                                  dto: state.dto,
                                  bankTypeDto: state.bankTypeDTO,
                                )
                              else
                                _buildOtherView(
                                  type: state.typeQR,
                                  nameController: nameController,
                                  suggestController: suggestController,
                                  onChange: provider.onChangeName,
                                  onChangeColor: provider.updateColorType,
                                  listColor: provider.listColor,
                                  typeColor: provider.colorType,
                                  imgId: provider.file,
                                  onChangeLogo: provider.updateFile,
                                  onChangeQRT: provider.updateQRT,
                                  height: height,
                                  model: provider.model,
                                ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MButtonWidget(
                              title: 'Hủy',
                              isEnable: provider.isEnableBTSave,
                              margin: EdgeInsets.only(left: 20, bottom: 20),
                              colorEnableBgr:
                                  AppColor.BLUE_TEXT.withOpacity(0.4),
                              colorEnableText: AppColor.BLUE_TEXT,
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();

                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: MButtonWidget(
                              title: 'Lưu',
                              isEnable: provider.isEnableBTSave,
                              margin: EdgeInsets.only(right: 20, bottom: 20),
                              colorEnableText: provider.isEnableBTSave
                                  ? AppColor.WHITE
                                  : AppColor.GREY_TEXT,
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();

                                AddContactDTO dto = AddContactDTO(
                                  additionalData: suggestController.text,
                                  nickName: nameController.text,
                                  type: state.typeQR.value.toString(),
                                  value: state.qrCode,
                                  userId: UserInformationHelper.instance
                                      .getUserId(),
                                  bankTypeId: state.bankTypeDTO?.id ?? '',
                                  bankAccount: state.bankAccount ?? '',
                                  colorType: provider.colorType,
                                  image: provider.file,
                                  relation: provider.model.type,
                                );

                                _bloc.add(SaveContactEvent(dto: dto));
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _buildVietQRID extends StatefulWidget {
  final TypeContact type;
  final TextEditingController nameController;
  final TextEditingController suggestController;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onChangeColor;
  final ValueChanged<ContactDataModel>? onChangeQRT;
  final List<String> listColor;
  final String typeColor;
  final String imgId;
  final double height;
  final ContactDataModel model;

  const _buildVietQRID({
    required this.type,
    required this.nameController,
    required this.suggestController,
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
  State<_buildVietQRID> createState() => _buildVietQRIDState();
}

class _buildVietQRIDState extends State<_buildVietQRID> {
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
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
                        SizedBox(
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
                                    '${widget.model.url}',
                                    color: AppColor.BLACK,
                                    width: 28,
                                  ),
                                  Text(
                                    '${widget.model.title}',
                                    style: TextStyle(fontSize: 14),
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
              maxLines: 5,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                Text(
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
                            padding: EdgeInsets.all(2),
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

class _buildBankView extends StatelessWidget {
  final TypeContact type;
  final TextEditingController nameController;
  final TextEditingController suggestController;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onChangeColor;
  final List<String> listColor;
  final String typeColor;
  final String imgId;
  final QRGeneratedDTO? dto;
  final BankTypeDTO? bankTypeDto;

  const _buildBankView({
    required this.type,
    required this.nameController,
    required this.suggestController,
    this.onChange,
    this.onChangeColor,
    required this.listColor,
    this.typeColor = '',
    this.imgId = '',
    this.dto,
    this.bankTypeDto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              if (bankTypeDto != null)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColor.WHITE,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: ImageUtils.instance
                          .getImageNetWork(bankTypeDto!.imageId),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bankTypeDto?.bankCode ?? '',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dto?.bankAccount ?? '',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextFieldCustom(
            isObscureText: false,
            maxLines: 1,
            fillColor: AppColor.gray.withOpacity(0.3),
            isRequired: false,
            enable: false,
            title: 'Loại QR',
            textFieldType: TextfieldType.LABEL,
            hintText: bankTypeDto?.bankName ?? '',
            hintColor: AppColor.BLACK,
            inputType: TextInputType.text,
            keyboardAction: TextInputAction.next,
          ),
          const SizedBox(height: 24),
          TextFieldCustom(
            isObscureText: false,
            maxLines: 1,
            fillColor: AppColor.WHITE,
            controller: nameController,
            isRequired: true,
            title: 'Tên',
            textFieldType: TextfieldType.LABEL,
            hintText: 'Nhập tên',
            inputType: TextInputType.text,
            keyboardAction: TextInputAction.next,
            onChange: onChange,
          ),
          const SizedBox(height: 24),
          TextFieldCustom(
            isObscureText: false,
            maxLines: 5,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            fillColor: AppColor.WHITE,
            controller: suggestController,
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
              Text(
                'Màu sắc thẻ QR',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              if (listColor.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(listColor.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          onChangeColor!(index.toString());
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(2),
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            border: int.parse(typeColor.trim()) == index
                                ? Border.all(color: AppColor.BLUE_TEXT)
                                : Border.all(color: AppColor.TRANSPARENT),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset(listColor[index]),
                        ),
                      );
                    }).toList(),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}

class _buildOtherView extends StatefulWidget {
  final TypeContact type;
  final TextEditingController nameController;
  final TextEditingController suggestController;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onChangeColor;
  final ValueChanged<File>? onChangeLogo;
  final ValueChanged<ContactDataModel>? onChangeQRT;
  final List<String> listColor;
  final String typeColor;
  final File? imgId;
  final double height;
  final ContactDataModel model;

  _buildOtherView({
    required this.type,
    required this.nameController,
    required this.suggestController,
    this.onChange,
    this.onChangeColor,
    this.onChangeLogo,
    this.onChangeQRT,
    required this.listColor,
    this.typeColor = '',
    this.imgId,
    required this.height,
    required this.model,
  });

  @override
  State<_buildOtherView> createState() => _buildOtherViewState();
}

class _buildOtherViewState extends State<_buildOtherView> {
  final ImagePicker imagePicker = ImagePicker();

  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: widget.imgId != null
                              ? Image.file(widget.imgId!)
                              : Image.asset('assets/images/ic-avatar.png')),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Logo QR giúp bạn tìm thẻ nhanh hơn',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        MButtonWidget(
                          title: 'Đổi logo QR',
                          isEnable: true,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.zero,
                          colorEnableText: AppColor.BLUE_TEXT,
                          colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.4),
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            final data = await DialogWidget.instance
                                .showModelBottomSheet(
                              context: context,
                              padding: EdgeInsets.zero,
                              isDismissible: true,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              widget: BottomSheetImage(),
                            );

                            if (data is XFile) {
                              File? file = File(data.path);
                              File? compressedFile =
                                  FileUtils.instance.compressImage(file);
                              await Future.delayed(
                                  const Duration(milliseconds: 200), () {
                                if (compressedFile != null) {
                                  widget.onChangeLogo!(compressedFile);
                                }
                              });
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
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
                          SizedBox(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      '${widget.model.url}',
                                      color: AppColor.BLACK,
                                      width: 28,
                                    ),
                                    Text(
                                      '${widget.model.title}',
                                      style: TextStyle(fontSize: 14),
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
                maxLines: 5,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                  Text(
                    'Màu sắc thẻ QR',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  if (widget.listColor.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            List.generate(widget.listColor.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              widget.onChangeColor!(index.toString());
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              padding: EdgeInsets.all(2),
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                border: int.parse(widget.typeColor.trim()) ==
                                        index
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
              ),
            ],
          ),
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

class BuildDropDownWidget extends StatefulWidget {
  final Function(ContactDataModel) onChange;

  BuildDropDownWidget({required this.onChange});

  @override
  State<BuildDropDownWidget> createState() => _BuildDropDownWidgetState();
}

class _BuildDropDownWidgetState extends State<BuildDropDownWidget> {
  final List<ContactDataModel> list = [
    ContactDataModel(
        title: 'Cá nhân', type: 0, url: 'assets/images/personal-relation.png'),
    ContactDataModel(
        title: 'Cộng đồng', type: 1, url: 'assets/images/gl-white.png'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSearchList(context);
  }

  Widget _buildSearchList(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(
                  parent: NeverScrollableScrollPhysics()),
              itemCount: list.length,
              itemBuilder: (context, position) {
                return InkWell(
                  onTap: () {
                    widget.onChange(list[position]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      border: position != (list.length - 1)
                          ? Border(
                              bottom: BorderSide(
                                  color: AppColor.GREY_TEXT.withOpacity(0.3),
                                  width: 0.5))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          '${list[position].url}',
                          color: AppColor.BLACK,
                          width: 28,
                        ),
                        Expanded(
                          child: Text(
                            list[position].title,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        if (position == 0)
                          const Icon(
                            Icons.expand_less,
                            color: AppColor.BLACK,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
}
