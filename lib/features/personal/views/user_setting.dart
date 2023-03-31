import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/ambient_avatar_widget.dart';
import 'package:vierqr/commons/widgets/button_text_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/logout/blocs/log_out_bloc.dart';
import 'package:vierqr/features/logout/events/log_out_event.dart';
import 'package:vierqr/features/logout/states/log_out_state.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserSetting();
}

class _UserSetting extends State<UserSetting> {
  static late LoginBloc _loginBloc;
  static late LogoutBloc _logoutBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of(context);
    _logoutBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Alignment buttonTextAlignment = Alignment.centerLeft;
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: BlocListener<LogoutBloc, LogoutState>(
        listener: (context, state) {
          if (state is LogoutLoadingState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is LogoutSuccessfulState) {
            Navigator.pop(context);
            Navigator.of(context).pushReplacementNamed(Routes.LOGIN);
          }
          if (state is LogoutFailedState) {
            Navigator.pop(context);
            DialogWidget.instance.openMsgDialog(
              title: 'Không thể đăng xuất',
              msg: 'Vui lòng thử lại sau.',
            );
          }
        },
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 20)),
            _buildAvatarWidget(context),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 30,
              ),
              child: Text(
                UserInformationHelper.instance.getUserFullname(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: width - 40,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ButtonTextWidget(
                    width: width,
                    alignment: buttonTextAlignment,
                    text: 'Chỉnh sửa thông tin cá nhân',
                    textColor: DefaultTheme.GREEN,
                    function: () {
                      Navigator.of(context).pushNamed(Routes.USER_EDIT);
                    },
                  ),
                  const Divider(
                    color: DefaultTheme.GREY_LIGHT,
                    height: 1,
                  ),
                  // ButtonTextWidget(
                  //   width: width,
                  //   alignment: buttonTextAlignment,
                  //   text: 'Quản lý tài khoản ngân hàng',
                  //   textColor: DefaultTheme.GREEN,
                  //   function: () {
                  //     // Navigator.of(context).pushNamed(Routes.BANK_MANAGE);
                  //   },
                  // ),
                  // const Divider(
                  //   color: DefaultTheme.GREY_LIGHT,
                  //   height: 1,
                  // ),
                  ButtonTextWidget(
                    width: width,
                    alignment: buttonTextAlignment,
                    text: 'Đăng nhập bằng mã QR',
                    textColor: DefaultTheme.GREEN,
                    function: () {
                      DialogWidget.instance.openMsgDialog(
                        title: 'Tính năng bảo trì',
                        msg:
                            'Tính năng hiện đang bảo trì, vui lòng thử lại sau.',
                      );
                      // Navigator.of(context)
                      //     .pushNamed(Routes.QR_SCAN)
                      //     .then((code) {
                      //   if (code != null) {
                      //     if (code.toString().isNotEmpty) {
                      //       _loginBloc.add(
                      //         LoginEventUpdateCode(
                      //           code: code.toString(),
                      //           userId:
                      //               UserInformationHelper.instance.getUserId(),
                      //         ),
                      //       );
                      //     }
                      //   }
                      // });
                    },
                  ),
                  const Divider(
                    color: DefaultTheme.GREY_LIGHT,
                    height: 1,
                  ),
                  // ButtonTextWidget(
                  //   width: width,
                  //   alignment: buttonTextAlignment,
                  //   text: 'Kết nối với Telegram',
                  //   textColor: DefaultTheme.GREEN,
                  //   function: () {},
                  // ),
                  // const Divider(
                  //   color: DefaultTheme.GREY_LIGHT,
                  //   height: 1,
                  // ),
                  ButtonTextWidget(
                    width: width,
                    alignment: buttonTextAlignment,
                    text: 'Thay đổi giao diện',
                    textColor: DefaultTheme.GREEN,
                    function: () {
                      Navigator.of(context).pushNamed(Routes.UI_SETTING);
                    },
                  ),
                  const Divider(
                    color: DefaultTheme.GREY_LIGHT,
                    height: 1,
                  ),
                  ButtonTextWidget(
                    width: width,
                    alignment: buttonTextAlignment,
                    text: 'Đăng xuất',
                    textColor: DefaultTheme.RED_TEXT,
                    function: () async {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      _logoutBloc.add(const LogoutEventSubmit());
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWidget(BuildContext context) {
    double size = 100;
    String imgId = UserInformationHelper.instance.getAccountInformation().imgId;
    return (imgId.isEmpty)
        ? ClipOval(
            child: SizedBox(
              width: size,
              height: size,
              child: Image.asset('assets/images/ic-avatar.png'),
            ),
          )
        : AmbientAvatarWidget(imgId: imgId, size: size);
  }
}
