import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/phone_book/blocs/phone_book_bloc.dart';
import 'package:vierqr/features/phone_book/events/phone_book_event.dart';
import 'package:vierqr/features/phone_book/states/phone_book_state.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/phone_book_detail_dto.dart';
import 'package:vierqr/services/providers/update_phone_book_provider.dart';

class EditPhoneBookScreen extends StatelessWidget {
  final PhoneBookDetailDTO dto;
  EditPhoneBookScreen({super.key, required this.dto});
  late TextEditingController nickNameController = TextEditingController();
  late TextEditingController nickAdditionalData = TextEditingController();
  @override
  Widget build(BuildContext context) {
    nickNameController.text = dto.nickName!;
    nickAdditionalData.text = dto.additionalData!;
    return Scaffold(
        appBar: const MAppBar(
          title: 'Cập nhật danh bạ',
          actions: [],
        ),
        body: ChangeNotifierProvider(
          create: (context) => UpdatePhoneBookProvider(),
          child: BlocProvider<PhoneBookBloc>(
            create: (context) => PhoneBookBloc(),
            child: BlocConsumer<PhoneBookBloc, PhoneBookState>(
                listener: (context, state) {
              if (state.type == PhoneBookType.UPDATE) {
                if (state.status == BlocStatus.LOADING) {
                  DialogWidget.instance.openLoadingDialog();
                }
              }
              if (state.type == PhoneBookType.UPDATE) {
                if (state.status == BlocStatus.SUCCESS) {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: 'Đã cập nhật',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).cardColor,
                    textColor: Theme.of(context).hintColor,
                    fontSize: 15,
                    webBgColor: 'rgba(255, 255, 255)',
                    webPosition: 'center',
                  );
                  Navigator.pop(context);
                }
              }
            }, builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Consumer<UpdatePhoneBookProvider>(
                    builder: (context, provider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      MTextFieldCustom(
                        isObscureText: false,
                        maxLines: 1,
                        controller: nickNameController,
                        fillColor: AppColor.WHITE,
                        textFieldType: TextfieldType.LABEL,
                        title: 'Biệt danh',
                        hintText: 'Nhập biệt danh',
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.next,
                        onChange: (String value) {
                          provider.updateNickName(value);
                        },
                      ),
                      if (provider.errorNickName)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Biệt danh là bắt buộc',
                            style: TextStyle(
                                fontSize: 13, color: AppColor.RED_TEXT),
                          ),
                        ),
                      const SizedBox(
                        height: 12,
                      ),
                      MTextFieldCustom(
                        isObscureText: false,
                        maxLines: 1,
                        controller: nickAdditionalData,
                        fillColor: AppColor.WHITE,
                        textFieldType: TextfieldType.LABEL,
                        title: 'Ghi chú',
                        hintText: 'Nhập ghi chú',
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.done,
                        onChange: (String value) {
                          provider.updateAdditionalData(value);
                        },
                      ),
                      if (provider.errorAdditionalData)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Ghi chú là bắt buộc',
                            style: TextStyle(
                                fontSize: 13, color: AppColor.RED_TEXT),
                          ),
                        ),
                      const Spacer(),
                      MButtonWidget(
                          onTap: () {
                            if (!provider.errorAdditionalData &&
                                !provider.errorNickName) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Map<String, dynamic> data = {};
                              data['id'] = dto.id;
                              data['nickName'] = nickNameController.text;
                              data['type'] = dto.type;
                              data['additionalData'] = nickAdditionalData.text;
                              BlocProvider.of<PhoneBookBloc>(context)
                                  .add(PhoneBookEventUpdate(data: data));
                            }
                          },
                          height: 40,
                          width: double.infinity,
                          title: 'Cập nhật thôgn tin',
                          margin: EdgeInsets.zero,
                          isEnable: true,
                          colorEnableText: !provider.errorAdditionalData &&
                                  !provider.errorNickName
                              ? AppColor.WHITE
                              : AppColor.GREY_TEXT,
                          fontSize: 14,
                          colorEnableBgr: !provider.errorAdditionalData &&
                                  !provider.errorNickName
                              ? AppColor.BLUE_TEXT
                              : AppColor.GREY_BUTTON),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  );
                }),
              );
            }),
          ),
        ));
  }
}
