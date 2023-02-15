import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/ambient_avatar_widget.dart';
import 'package:vierqr/commons/widgets/button_text_widget.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/login/events/login_event.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/services/providers/register_provider.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';
import 'package:vierqr/services/shared_references/event_bloc_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserSetting();
}

class _UserSetting extends State<UserSetting> {
  static late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Alignment buttonTextAlignment = Alignment.centerLeft;
    return Padding(
      padding: const EdgeInsets.only(top: 70),
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
                ButtonTextWidget(
                  width: width,
                  alignment: buttonTextAlignment,
                  text: 'Quản lý tài khoản ngân hàng',
                  textColor: DefaultTheme.GREEN,
                  function: () {
                    Navigator.of(context).pushNamed(Routes.BANK_MANAGE);
                  },
                ),
                const Divider(
                  color: DefaultTheme.GREY_LIGHT,
                  height: 1,
                ),
                ButtonTextWidget(
                  width: width,
                  alignment: buttonTextAlignment,
                  text: 'Đăng nhập bằng mã QR',
                  textColor: DefaultTheme.GREEN,
                  function: () {
                    Navigator.of(context)
                        .pushNamed(Routes.QR_SCAN)
                        .then((code) {
                      if (code != null) {
                        if (code.toString().isNotEmpty) {
                          _loginBloc.add(
                            LoginEventUpdateCode(
                              code: code.toString(),
                              userId:
                                  UserInformationHelper.instance.getUserId(),
                            ),
                          );
                        }
                      }
                    });
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
                    await resetAll(context).then((_) {
                      Navigator.of(context).pushReplacementNamed(Routes.LOGIN);
                    });
                  },
                ),
              ],
            ),
          )
        ],
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

  Future<void> resetAll(BuildContext context) async {
    Provider.of<CreateQRProvider>(context, listen: false).reset();
    Provider.of<CreateQRPageSelectProvider>(context, listen: false).reset();
    Provider.of<BankAccountProvider>(context, listen: false).reset();
    Provider.of<UserEditProvider>(context, listen: false).reset();
    Provider.of<RegisterProvider>(context, listen: false).reset();
    Provider.of<SuggestionWidgetProvider>(context, listen: false).reset();
    await EventBlocHelper.instance.updateLogoutBefore(true);
    await UserInformationHelper.instance.initialUserInformationHelper();
    await AccountHelper.instance.setBankToken('');
    await AccountHelper.instance.setToken('');
  }
}
