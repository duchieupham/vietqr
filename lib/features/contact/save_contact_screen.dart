import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/contact/blocs/contact_bloc.dart';
import 'package:vierqr/features/contact/blocs/contact_provider.dart';
import 'package:vierqr/features/contact/events/contact_event.dart';
import 'package:vierqr/features/contact/states/contact_state.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/add_contact_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class SaveContactScreen extends StatelessWidget {
  final String code;
  final TypeContact typeQR;

  const SaveContactScreen(
      {super.key, required this.code, required this.typeQR});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactBloc(context, qrCode: code, typeQR: typeQR)
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
                                )
                              else if (state.typeQR == TypeContact.Bank)
                                _buildBankView()
                              else ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Loại QR',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColor.WHITE,
                                      ),
                                      child: Text(
                                        state.typeQR.typeName,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                TextFieldCustom(
                                  isObscureText: false,
                                  maxLines: 1,
                                  fillColor: AppColor.WHITE,
                                  controller: nameController,
                                  isRequired: true,
                                  title: 'Biệt danh',
                                  textFieldType: TextfieldType.LABEL,
                                  hintText: 'Nhập tên',
                                  inputType: TextInputType.text,
                                  keyboardAction: TextInputAction.next,
                                  onChange: provider.onChangeName,
                                ),
                                const SizedBox(height: 30),
                                TextFieldCustom(
                                  isObscureText: false,
                                  maxLines: 1,
                                  fillColor: AppColor.WHITE,
                                  controller: suggestController,
                                  title: 'Ghi chú',
                                  textFieldType: TextfieldType.LABEL,
                                  hintText:
                                      'Đoạn ghi chú cho thông tin danh bạ',
                                  inputType: TextInputType.text,
                                  keyboardAction: TextInputAction.next,
                                  onChange: provider.onChangeSuggest,
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                      MButtonWidget(
                        title: 'Lưu danh bạ',
                        isEnable: provider.isEnableBTSave,
                        colorEnableText: provider.isEnableBTSave
                            ? AppColor.WHITE
                            : AppColor.GREY_TEXT,
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();

                          AddContactDTO dto = AddContactDTO(
                            additionalData: suggestController.text,
                            nickName: nameController.text,
                            type: state.typeQR.value,
                            value: state.qrCode,
                            userId: UserInformationHelper.instance.getUserId(),
                            bankTypeId: state.bankTypeDTO?.id ?? '',
                            bankAccount: state.bankAccount ?? '',
                          );

                          _bloc.add(SaveContactEvent(dto: dto));
                        },
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

class _buildVietQRID extends StatelessWidget {
  final TypeContact type;
  final TextEditingController nameController;
  final TextEditingController suggestController;
  final ValueChanged<String>? onChange;

  const _buildVietQRID(
      {required this.type,
      required this.nameController,
      required this.suggestController,
      this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset('assets/images/ic-avatar.png'),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                nameController.text,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
            hintText: type.typeName,
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
          Text(
            'Màu sắc thẻ QR',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

        ],
      ),
    );
  }
}

class _buildBankView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset('assets/images/ic-avatar.png'),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'CAN QUANG TRIEU',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
            hintText: '',
            hintColor: AppColor.BLACK,
            inputType: TextInputType.text,
            keyboardAction: TextInputAction.next,
          ),
          const SizedBox(height: 24),
          TextFieldCustom(
            isObscureText: false,
            maxLines: 1,
            fillColor: AppColor.WHITE,
            // controller: nameController,
            isRequired: true,
            title: 'Tên',
            textFieldType: TextfieldType.LABEL,
            hintText: 'Nhập tên',
            inputType: TextInputType.text,
            keyboardAction: TextInputAction.next,
            // onChange: provider.onChangeName,
          ),
          const SizedBox(height: 24),
          TextFieldCustom(
            isObscureText: false,
            maxLines: 1,
            fillColor: AppColor.WHITE,
            // controller: nameController,
            isRequired: false,
            title: 'Mô tả QR',
            textFieldType: TextfieldType.LABEL,
            hintText: 'Nhập mô tả cho mã QR của bạn',
            inputType: TextInputType.text,
            keyboardAction: TextInputAction.next,
            // onChange: provider.onChangeName,
          ),
        ],
      ),
    );
  }
}
