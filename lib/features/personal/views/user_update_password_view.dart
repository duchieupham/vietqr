import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/personal/blocs/user_edit_bloc.dart';
import 'package:vierqr/features/personal/events/user_edit_event.dart';
import 'package:vierqr/features/personal/states/user_edit_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class UserUpdatePassword extends StatelessWidget {
  static final TextEditingController _oldPasswordController =
      TextEditingController();

  static final TextEditingController _newPasswordController =
      TextEditingController();

  static final TextEditingController _confirmPassController =
      TextEditingController();

  static late UserEditBloc _userEditBloc;
  static bool _isInit = false;

  const UserUpdatePassword({super.key});

  void initialServices(BuildContext context) {
    if (!_isInit) {
      _userEditBloc = BlocProvider.of(context);
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Scaffold(
      body: Column(
        children: [
          SubHeader(
              title: 'Đổi mật khẩu',
              function: () {
                backToPreviousPage(context);
              }),
          Expanded(
            child: BlocListener<UserEditBloc, UserEditState>(
              listener: ((context, state) {
                if (state is UserEditLoadingState) {
                  DialogWidget.instance.openLoadingDialog();
                }
                if (state is UserEditPasswordFailedState) {
                  //pop loading dialog
                  Navigator.pop(context);
                  FocusManager.instance.primaryFocus?.unfocus();
                  //
                  DialogWidget.instance.openMsgDialog(
                    title: 'Không thể cập nhật Mật khẩu',
                    msg: state.msg,
                  );
                }
                if (state is UserEditPasswordSuccessfulState) {
                  //pop loading dialog
                  Navigator.pop(context);
                  //
                  backToPreviousPage(context);
                }
              }),
              child: Consumer<UserEditProvider>(
                builder: (context, provider, child) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      BoxLayout(
                        width: width,
                        child: Column(
                          children: [
                            TextFieldWidget(
                              width: width,
                              isObscureText: true,
                              textfieldType: TextfieldType.LABEL,
                              title: 'Mật khẩu cũ',
                              titleWidth: 120,
                              hintText: 'Mật khẩu hiện tại',
                              controller: _oldPasswordController,
                              inputType: TextInputType.number,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {},
                            ),
                            const Divider(
                              height: 0.5,
                              color: AppColor.GREY_LIGHT,
                            ),
                            TextFieldWidget(
                              width: width,
                              isObscureText: true,
                              textfieldType: TextfieldType.LABEL,
                              title: 'Mật khẩu mới',
                              titleWidth: 120,
                              hintText: 'Bao gồm 6 số',
                              controller: _newPasswordController,
                              inputType: TextInputType.number,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {},
                            ),
                            const Divider(
                              height: 0.5,
                              color: AppColor.GREY_LIGHT,
                            ),
                            TextFieldWidget(
                              width: width,
                              isObscureText: true,
                              textfieldType: TextfieldType.LABEL,
                              title: 'Xác nhận lại',
                              titleWidth: 120,
                              hintText: 'Xác nhận lại Mật khẩu mới',
                              controller: _confirmPassController,
                              inputType: TextInputType.number,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {},
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: provider.oldPassErr,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10, top: 5, right: 30),
                          child: Text(
                            'Mật khẩu cũ không đúng định dạng.',
                            style: TextStyle(
                                color: AppColor.RED_TEXT, fontSize: 13),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: provider.newPassErr,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10, top: 5, right: 30),
                          child: Text(
                            'Mật khẩu mới bao gồm 6 số.',
                            style: TextStyle(
                                color: AppColor.RED_TEXT, fontSize: 13),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: provider.confirmPassErr,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10, top: 5, right: 30),
                          child: Text(
                            'Xác nhận Mật khẩu không trùng khớp.',
                            style: TextStyle(
                                color: AppColor.RED_TEXT, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: ButtonWidget(
              width: width - 40,
              text: 'Cập nhật',
              textColor: AppColor.WHITE,
              bgColor: AppColor.BLUE_TEXT,
              borderRadius: 8,
              function: () {
                Provider.of<UserEditProvider>(context, listen: false)
                    .updatePasswordErrs(
                  (_oldPasswordController.text.isEmpty ||
                      _oldPasswordController.text.length != 6),
                  (_newPasswordController.text.isEmpty ||
                      _newPasswordController.text.length != 6),
                  (_confirmPassController.text != _newPasswordController.text),
                );
                if (Provider.of<UserEditProvider>(context, listen: false)
                    .isValidUpdatePassword()) {
                  _userEditBloc.add(
                    UserEditPasswordEvent(
                      userId: UserInformationHelper.instance.getUserId(),
                      phoneNo: UserInformationHelper.instance.getPhoneNo(),
                      oldPassword: _oldPasswordController.text,
                      newPassword: _newPasswordController.text,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void backToPreviousPage(BuildContext context) {
    _isInit = false;
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPassController.clear();
    Provider.of<UserEditProvider>(context, listen: false).resetPasswordErr();
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context);
  }
}
