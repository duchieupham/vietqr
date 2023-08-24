import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/file_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/ambient_avatar_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/account/blocs/account_bloc.dart';
import 'package:vierqr/features/account/events/account_event.dart';
import 'package:vierqr/features/account/states/account_state.dart';
import 'package:vierqr/features/account/views/dialog_my_qr.dart';
import 'package:vierqr/features/account/widget/my_QR_bottom_sheet.dart';
import 'package:vierqr/features/personal/views/introduce_bottom_sheet.dart';
import 'package:vierqr/services/providers/auth_provider.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class IconData {
  final String url;
  final String name;

  IconData({required this.url, required this.name});
}

List<IconData> listIcon = [
  IconData(
    url: 'assets/images/ic-my-qr-setting.png',
    name: 'My QR',
  ),
  IconData(
    url: 'assets/images/ic-edit-personal-setting.png',
    name: 'Cá nhân',
  ),
  IconData(
    url: 'assets/images/ic-edit-avatar-setting.png',
    name: 'Ảnh đại diện',
  ),
  IconData(
    url: 'assets/images/ic-edit-password-setting.png',
    name: 'Mật khẩu',
  ),
];

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (BuildContext context) => AccountBloc(context),
      child: _AccountScreen(),
    );
  }
}

class _AccountScreen extends StatefulWidget {
  @override
  State<_AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<_AccountScreen>
    with AutomaticKeepAliveClientMixin {
  late AccountBloc _accountBloc;

  @override
  void initState() {
    super.initState();
    _accountBloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  Future<void> _onRefresh() async {
    eventBus.fire(ReloadWallet());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state.status == BlocStatus.UNLOADING) {
          Navigator.pop(context);
        }
        if (state.request == AccountType.LOG_OUT) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          Navigator.of(context).pushReplacementNamed(Routes.LOGIN);
          eventBus.fire(ChangeBottomBarEvent(0));
        }

        if (state.status == BlocStatus.ERROR) {
          if (!mounted) return;
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể đăng xuất',
            msg: 'Vui lòng thử lại sau.',
          );
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _BannerWidget(),
                _FeatureWidget(),
                const SizedBox(height: 30),
                _IntroduceWidget(),
                const SizedBox(height: 30),
                _SettingWidget(),
                const SizedBox(height: 30),
                _SupportWidget(),
                const SizedBox(height: 30),
                _buildLogOutWidget(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogOutWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        _accountBloc.add(LogoutEventSubmit());
      },
      child: Column(
        children: [
          Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return Text(
                  'Phiên bản ứng dụng: ${provider.packageInfo?.version ?? ''}');
            },
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).cardColor,
            ),
            child: const Text(
              'Đăng xuất',
              style: TextStyle(
                color: AppColor.RED_TEXT,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _BannerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          _buildAvatarWidget(context),
          const SizedBox(height: 16),
          Text(
            UserInformationHelper.instance.getUserFullname(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.BLACK,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            StringUtils.instance.formatPhoneNumberVN(
                UserInformationHelper.instance.getPhoneNo()),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.BLACK,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWidget(BuildContext context) {
    double size = 80;
    String imgId = UserInformationHelper.instance.getAccountInformation().imgId;
    return Consumer<UserEditProvider>(
      builder: (context, provider, child) {
        return (provider.imageFile != null)
            ? AmbientAvatarWidget(
                imgId: imgId,
                size: size,
                imageFile: provider.imageFile,
              )
            : (imgId.isEmpty)
                ? ClipOval(
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: Image.asset('assets/images/ic-avatar.png'),
                    ),
                  )
                : AmbientAvatarWidget(imgId: imgId, size: size);
      },
    );
  }
}

class _FeatureWidget extends StatelessWidget {
  final ImagePicker imagePicker = ImagePicker();

  void onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        DialogWidget.instance.showModelBottomSheet(
          context: context,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          radius: 15,
          bgrColor: AppColor.TRANSPARENT,
          isDismissible: true,
          widget: MyQRBottomSheet(),
        );
        break;
      case 1:
        onNaviAccount(context);
        break;
      case 2:
        onChangeAvatar(context);
        break;
      case 3:
        onNaviPassword(context);
        break;
      default:
        () {
          Navigator.of(context).pushNamed(Routes.USER_EDIT);
        };
    }
  }

  void onMyQr(
    BuildContext context, {
    required String code,
    required String userName,
    GestureTapCallback? onTapShare,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return DialogMyQR(
          code: code,
          userName: userName,
        );
      },
    );
  }

  void onNaviAccount(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.USER_EDIT);
  }

  void onNaviPassword(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.UPDATE_PASSWORD);
  }

  void onChangeAvatar(BuildContext context) async {
    await Permission.mediaLibrary.request();
    await imagePicker.pickImage(source: ImageSource.gallery).then(
      (pickedFile) async {
        if (pickedFile != null) {
          File? file = File(pickedFile.path);
          File? compressedFile = FileUtils.instance.compressImage(file);
          // Provider.of<AddBusinessProvider>(context, listen: false)
          //     .setImage(compressedFile);
          await Future.delayed(const Duration(milliseconds: 200), () {
            String userId = UserInformationHelper.instance.getUserId();
            String imgId =
                UserInformationHelper.instance.getAccountInformation().imgId;
            context.read<AccountBloc>().add(UpdateAvatarEvent(
                userId: userId, imgId: imgId, image: compressedFile));
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(listIcon.length, (index) {
        return GestureDetector(
          onTap: () {
            onTap(context, index);
          },
          child: _buildItem(listIcon.elementAt(index)),
        );
      }).toList(),
    );
  }

  Widget _buildItem(IconData data) {
    return Column(
      children: [
        Container(
          width: 45,
          height: 45,
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: AppColor.WHITE,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: Image.asset(data.url),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data.name,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _IntroduceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                    provider.introduceDTO?.point ?? '0',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Image.asset(
                    'assets/images/ic_point.png',
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
              const Divider(),
              GestureDetector(
                onTap: () async {
                  await DialogWidget.instance.showModelBottomSheet(
                    context: context,
                    padding: EdgeInsets.zero,
                    widget: IntroduceBottomSheet(
                        introduceDTO: provider.introduceDTO),
                    height: height * 0.6,
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ic_share_code.png',
                      width: 30,
                      height: 30,
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
      },
    );
  }
}

class _SupportWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Hỗ trợ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, Routes.REPORT_SCREEN);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic-report.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Báo cáo vấn đề',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, Routes.CONTACT_US_SCREEN);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic-introduce.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Liên hệ với chúng tôi',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Cài đặt',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, Routes.SETTING_BDSD);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic-setting-bdsd.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Cài đặt nhận biến động số dư',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                GestureDetector(
                  onTap: () async {
                    if (PlatformUtils.instance.isPhysicalDevice()) {
                      if (PlatformUtils.instance.isAndroidApp()) {
                        await Permission.bluetooth.request();
                        await Permission.bluetoothScan.request();
                        await Permission.bluetoothConnect.request();
                      }
                      await Permission.bluetooth.request().then((value) =>
                          Navigator.pushNamed(context, Routes.PRINTER_SETTING));
                    } else {
                      Navigator.pushNamed(context, Routes.PRINTER_SETTING);
                    }
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic-printer-setting.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Cài đặt máy in',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pushNamed(Routes.UI_SETTING);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic-theme-setting.png',
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Thay đổi giao diện',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
