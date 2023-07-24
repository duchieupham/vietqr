import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/phone_book/blocs/phone_book_bloc.dart';
import 'package:vierqr/features/phone_book/events/phone_book_event.dart';
import 'package:vierqr/features/phone_book/states/phone_book_state.dart';
import 'package:vierqr/layouts/button_widget.dart';

import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/phone_book_detail_dto.dart';

// ignore: must_be_immutable
class PhoneBookEditView extends StatefulWidget {
  final Function(Map<String, dynamic>)? onCallBack;
  final PhoneBookDetailDTO phoneBookDetailDTO;

  const PhoneBookEditView(
      {super.key, this.onCallBack, required this.phoneBookDetailDTO});

  @override
  State<PhoneBookEditView> createState() => _PhoneBookEditViewState();
}

class _PhoneBookEditViewState extends State<PhoneBookEditView> {
  final nickNameController = TextEditingController();
  final suggestController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nickNameController.text = widget.phoneBookDetailDTO.nickName ?? '';
      suggestController.text = widget.phoneBookDetailDTO.additionalData ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhoneBookBloc>(
      create: (context) => PhoneBookBloc(context),
      child: BlocConsumer<PhoneBookBloc, PhoneBookState>(
        listener: (context, state) {
          if (state.status == BlocStatus.LOADING) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            Navigator.of(context).pop();
          }

          if (state.type == PhoneBookType.UPDATE) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const MAppBar(title: 'Cập nhật danh bạ', actions: []),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  TextFieldCustom(
                    isObscureText: false,
                    maxLines: 1,
                    fillColor: AppColor.WHITE,
                    controller: nickNameController,
                    textFieldType: TextfieldType.LABEL,
                    title: 'Biệt danh',
                    hintText: '',
                    inputType: TextInputType.text,
                    keyboardAction: TextInputAction.next,
                    onChange: (value) {},
                  ),
                  const SizedBox(height: 30),
                  TextFieldCustom(
                    isObscureText: false,
                    maxLines: 1,
                    fillColor: AppColor.WHITE,
                    textFieldType: TextfieldType.LABEL,
                    title: 'Ghi chú',
                    controller: suggestController,
                    hintText: '',
                    inputType: TextInputType.text,
                    keyboardAction: TextInputAction.next,
                    onChange: (value) {},
                  ),
                ],
              ),
            ),
            bottomSheet: MButtonWidget(
              title: 'Cập nhật thông tin',
              isEnable: true,
              onTap: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                if (!mounted) return;
                Map<String, dynamic> data = {
                  "id": widget.phoneBookDetailDTO.id ?? '',
                  "nickName": nickNameController.text,
                  "type": widget.phoneBookDetailDTO.type ?? 0,
                  "additionalData": suggestController.text,
                };

                context.read<PhoneBookBloc>().add(UpdatePhoneBookEvent(data));
              },
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
