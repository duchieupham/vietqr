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
            appBar: const MAppBar(title: 'Cập nhật danh bạ', actions: []),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
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
                  ),
                  MButtonWidget(
                    title: 'Cập nhật thông tin',
                    isEnable: true,
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (!mounted) return;
                      Map<String, dynamic> data = {
                        "id": widget.contactDetailDTO.id ?? '',
                        "nickName": nickNameController.text,
                        "type": widget.contactDetailDTO.type ?? 0,
                        "additionalData": suggestController.text,
                      };

                      context.read<ContactBloc>().add(UpdateContactEvent(data));
                    },
                  ),
                ],
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
