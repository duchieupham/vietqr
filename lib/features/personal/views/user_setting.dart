import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/widgets/ambient_avatar_widget.dart';
import 'package:vierqr/commons/widgets/button_text_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/logout/blocs/log_out_bloc.dart';
import 'package:vierqr/features/logout/events/log_out_event.dart';
import 'package:vierqr/features/logout/states/log_out_state.dart';
import 'package:vierqr/services/providers/avatar_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

import 'introduce_bottom_sheet.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({Key? key, this.voidCallback}) : super(key: key);

  final VoidCallback? voidCallback;

  @override
  State<StatefulWidget> createState() => _UserSetting();
}

class _UserSetting extends State<UserSetting>
    with AutomaticKeepAliveClientMixin {
  static late LogoutBloc _logoutBloc;

  @override
  void initState() {
    super.initState();
    _logoutBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    Alignment buttonTextAlignment = Alignment.centerLeft;
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutLoadingState) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state is LogoutSuccessfulState) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          Navigator.of(context).pushReplacementNamed(Routes.LOGIN);
          widget.voidCallback!();
        }
        if (state is LogoutFailedState) {
          if (!mounted) return;
          Navigator.pop(context);
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể đăng xuất',
            msg: 'Vui lòng thử lại sau.',
          );
        }
      },
      child: ClipRRect(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 50)),
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
                    text: 'Cập nhật thông tin cá nhân',
                    textColor: AppColor.GREEN,
                    function: () {
                      Navigator.of(context).pushNamed(Routes.USER_EDIT);
                    },
                  ),
                  const Divider(
                    color: AppColor.GREY_LIGHT,
                    height: 1,
                  ),
                  ButtonTextWidget(
                    width: width,
                    alignment: buttonTextAlignment,
                    text: 'Cài đặt máy in',
                    textColor: AppColor.GREEN,
                    function: () async {
                      if (PlatformUtils.instance.isPhysicalDevice()) {
                        if (PlatformUtils.instance.isAndroidApp()) {
                          await Permission.bluetooth.request();
                          await Permission.bluetoothScan.request();
                          await Permission.bluetoothConnect.request();
                        }
                        await Permission.bluetooth.request().then((value) =>
                            Navigator.pushNamed(
                                context, Routes.PRINTER_SETTING));
                      } else {
                        Navigator.pushNamed(context, Routes.PRINTER_SETTING);
                      }
                    },
                  ),
                  const Divider(
                    color: AppColor.GREY_LIGHT,
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
                    textColor: AppColor.GREEN,
                    function: () {
                      Navigator.of(context).pushNamed(Routes.UI_SETTING);
                    },
                  ),
                  const Divider(
                    color: AppColor.GREY_LIGHT,
                    height: 1,
                  ),
                  ButtonTextWidget(
                    width: width,
                    alignment: buttonTextAlignment,
                    text: 'Đăng xuất',
                    textColor: AppColor.RED_TEXT,
                    function: () async {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      _logoutBloc.add(const LogoutEventSubmit());
                    },
                  ),
                ],
              ),
            ),
            // _IntroduceWidget(
            //   onTap: () async {
            //     final data = await DialogWidget.instance.showModelBottomSheet(
            //       context: context,
            //       padding: EdgeInsets.zero,
            //       widget: const IntroduceBottomSheet(),
            //       height: height * 0.6,
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWidget(BuildContext context) {
    double size = 100;
    String imgId = UserInformationHelper.instance.getAccountInformation().imgId;
    return Consumer<AvatarProvider>(
      builder: (context, provider, child) => (imgId.isEmpty)
          ? ClipOval(
              child: SizedBox(
                width: size,
                height: size,
                child: Image.asset('assets/images/ic-avatar.png'),
              ),
            )
          : AmbientAvatarWidget(imgId: imgId, size: size),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class _IntroduceWidget extends StatelessWidget {
  final String? point;
  final GestureTapCallback? onTap;

  const _IntroduceWidget({super.key, this.point, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Điểm thưởng : ',
                style: TextStyle(
                  color: AppColor.GREY_TEXT,
                  fontSize: 14,
                ),
              ),
              Text(
                point ?? '0',
                style: const TextStyle(fontSize: 18),
              ),
              Image.asset(
                'assets/images/ic_point.png',
                width: 36,
                height: 36,
              ),
            ],
          ),
          const Divider(),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/ic_share_code.png',
                  width: 36,
                  height: 36,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Giới thiệu VietQR VN',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: AppColor.GREY_BG,
                  ),
                  child: const Icon(Icons.arrow_forward_ios, size: 12),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
