import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/file_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/ambient_avatar_widget.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/checkbox_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/account/widget/my_QR_bottom_sheet.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/home/home.dart';
import 'package:vierqr/features/personal/blocs/user_edit_bloc.dart';
import 'package:vierqr/features/personal/events/user_edit_event.dart';
import 'package:vierqr/features/personal/frames/user_edit_frame.dart';
import 'package:vierqr/features/personal/states/user_edit_state.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/features/verify_email/verify_email_screen.dart';
import 'package:vierqr/features/verify_email/views/key_active_free.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/user_profile.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';

class UserInfoView extends StatefulWidget {
  const UserInfoView({super.key});

  @override
  State<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends State<UserInfoView> {
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _nationalIdController = TextEditingController(text: '');
  final _oldNationalIdController = TextEditingController(text: '');
  String _birthDate = '';
  String _nationalDate = '';
  String _timeCreated = '';
  late UserEditBloc _userEditBloc;
  final _formKey = GlobalKey<FormState>();
  final imagePicker = ImagePicker();
  bool _isBalanceVisible = true;
  ScrollController controllerAppbar = ScrollController();
  ValueNotifier<bool> appbarNotifier = ValueNotifier<bool>(true);

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  void initialServices(BuildContext context) {
    final UserProfile accountInformationDTO = SharePrefUtils.getProfile();
    if (accountInformationDTO.lastName.isNotEmpty &&
        _lastNameController.text.isEmpty) {
      _lastNameController.value = _lastNameController.value
          .copyWith(text: accountInformationDTO.lastName);
    }
    if (accountInformationDTO.middleName.isNotEmpty &&
        _middleNameController.text.isEmpty) {
      _middleNameController.value = _middleNameController.value
          .copyWith(text: accountInformationDTO.middleName);
    }
    if (accountInformationDTO.firstName.isNotEmpty &&
        _firstNameController.text.isEmpty) {
      _firstNameController.value = _firstNameController.value
          .copyWith(text: accountInformationDTO.firstName);
    }
    if (accountInformationDTO.nationalId.isNotEmpty &&
        _nationalIdController.text.isEmpty) {
      _nationalIdController.value = _nationalIdController.value
          .copyWith(text: accountInformationDTO.nationalId);
    }
    if (accountInformationDTO.oldNationalId.isNotEmpty &&
        _oldNationalIdController.text.isEmpty) {
      _oldNationalIdController.value = _oldNationalIdController.value
          .copyWith(text: accountInformationDTO.oldNationalId);
    }
    _birthDate = accountInformationDTO.birthDate;
    _timeCreated = accountInformationDTO.timeCreated;
    if (accountInformationDTO.nationalDate.isEmpty) {
      _nationalDate = '01/01/1970';
    } else {
      _nationalDate = accountInformationDTO.nationalDate;
    }

    if (accountInformationDTO.email.isNotEmpty &&
        _emailController.text.isEmpty) {
      _emailController.value =
          _emailController.value.copyWith(text: accountInformationDTO.email);
    }

    if (accountInformationDTO.address.isNotEmpty &&
        _addressController.text.isEmpty) {
      _addressController.value = _addressController.value
          .copyWith(text: accountInformationDTO.address);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _userEditBloc = BlocProvider.of(context);
    initialServices(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllerAppbar.addListener(
        () {
          appbarNotifier.value = controllerAppbar.offset == 0;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //     final Map<String, String> userInfo = {
    //   'Email': _emailController.text,
    //   'CCCD': _nationalIdController.text,
    //   'Ngày cấp':    TimeUtils.instance.getDateFromString(_nationalDate).toString(),
    //   'CMT (cũ)': _oldNationalIdController.text,
    //   'Giới tính': provider.gender == 0 ? 'Nam' : 'Nữ',
    //   'Ngày sinh': ,
    //   'Địa chỉ': ,
    // };

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColor.WHITE,
        // appBar: MAppBar(
        //   title: 'Thông tin cá nhân',
        //   onPressed: () {
        //     backToPreviousPage(context);
        //   },
        //   callBackHome: () {
        //     backToPreviousPage(context);
        //   },
        // ),
        appBar: AppBar(
          leadingWidth: appbarNotifier.value ? 400 : 120,
          elevation: 0,
          backgroundColor: Colors.white,
          forceMaterialTransparency: true,
          leading: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: appbarNotifier,
                builder: (BuildContext context, value, Widget? child) {
                  return value
                      ? InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Trở về'))
                      : Container(
                          width: 200,
                          child: Row(
                            children: [
                              _buildAvatarWidget(context, 40),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  SharePrefUtils.getProfile().fullName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                DialogWidget.instance.showModelBottomSheet(
                  context: context,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  radius: 15,
                  bgrColor: AppColor.TRANSPARENT,
                  isDismissible: true,
                  widget: MyQRBottomSheet(),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                          colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      XImage(
                        imagePath: 'assets/images/ic-add-image-black.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'My QR',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocListener<UserEditBloc, UserEditState>(
                listener: (context, state) async {
                  if (state is UserEditLoadingState) {
                    DialogWidget.instance.openLoadingDialog();
                  }
                  if (state is UserDeactiveSuccessState) {
                    Navigator.pop(context);
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                    Navigator.of(context).pushReplacementNamed(Routes.LOGIN);
                    eventBus.fire(ChangeBottomBarEvent(0));
                  }
                  if (state is UserDeactiveFailedState) {
                    //pop loading dialog
                    Navigator.pop(context);
                    //
                    DialogWidget.instance.openMsgDialog(
                      title: 'Không thể xoá tài khoản',
                      msg: state.message,
                    );
                  }
                  if (state is UserEditAvatarSuccessState) {
                    //pop loading dialog
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                  if (state is UserEditAvatarFailedState) {
                    //pop loading dialog
                    Navigator.pop(context);
                    //
                    DialogWidget.instance.openMsgDialog(
                      title: 'Không thể cập nhật ảnh đại diện',
                      msg: state.message,
                    );
                  }
                  if (state is UserEditFailedState) {
                    //pop loading dialog
                    Navigator.pop(context);
                    //
                    DialogWidget.instance.openMsgDialog(
                        title: 'Không thể cập nhật thông tin', msg: state.msg);
                  }
                  if (state is UserEditSuccessfulState) {
                    //pop loading dialog
                    Navigator.of(context).pop();
                    Provider.of<UserEditProvider>(context, listen: false)
                        .reset();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const DashBoardScreen()),
                        (Route<dynamic> route) => false);
                  }
                  if (state is UserEditPasswordFailedState) {
                    if (PlatformUtils.instance.isWeb()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      //pop loading dialog
                      Navigator.of(context).pop();
                      //
                      DialogWidget.instance.openMsgDialog(
                        title: 'Không thể cập nhật Mật khẩu',
                        msg: state.msg,
                      );
                    }
                  }
                  if (state is UserEditPasswordSuccessfulState) {
                    if (PlatformUtils.instance.isWeb()) {
                      //pop loading dialog

                      Navigator.of(context).pop();
                      //
                      Provider.of<UserEditProvider>(context, listen: false)
                          .resetPasswordErr();
                      Navigator.pop(context);
                    }
                  }
                },
                child: Consumer<UserEditProvider>(
                  builder: (context, provider, child) {
                    return UserEditFrame(
                      width: width,
                      height: height,
                      mobileChildren: Form(
                        key: _formKey,
                        child: ListView(
                          controller: controllerAppbar,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            BoxLayout(
                              width: width,
                              bgColor: AppColor.TRANSPARENT,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                children: [
                                  Stack(children: [
                                    Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 5,
                                              blurRadius: 9,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: _buildAvatarWidget(context, 80)),
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: InkWell(
                                        onTap: () async {
                                          await Permission.mediaLibrary
                                              .request();
                                          await imagePicker
                                              .pickImage(
                                                  source: ImageSource.gallery)
                                              .then(
                                            (pickedFile) async {
                                              if (pickedFile != null) {
                                                File? file =
                                                    File(pickedFile.path);
                                                File? compressedFile = FileUtils
                                                    .instance
                                                    .compressImage(file);

                                                await Future.delayed(
                                                    const Duration(
                                                        milliseconds: 200), () {
                                                  String userId = SharePrefUtils
                                                          .getProfile()
                                                      .userId;
                                                  String imgId = SharePrefUtils
                                                          .getProfile()
                                                      .imgId;
                                                  _userEditBloc.add(
                                                    UserEditAvatarEvent(
                                                        userId: userId,
                                                        imgId: imgId,
                                                        image: compressedFile),
                                                  );
                                                });
                                              }
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: AppColor.GREY_F0F4FA,
                                          ),
                                          child: const XImage(
                                            imagePath:
                                                'assets/images/ic-add-image-black.png',
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 10)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        SharePrefUtils.getProfile().fullName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        SharePrefUtils.getPhone(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColor.GREY_TEXT,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // const Padding(padding: EdgeInsets.only(top: 10)),
                            // ButtonWidget(
                            //   width: width - 40,
                            //   text: 'Cập nhật ảnh đại diện',
                            //   textColor: AppColor.BLUE_TEXT,
                            //   bgColor: Theme.of(context).cardColor,
                            //   function: () async {
                            //     await Permission.mediaLibrary.request();
                            //     await imagePicker
                            //         .pickImage(source: ImageSource.gallery)
                            //         .then(
                            //       (pickedFile) async {
                            //         if (pickedFile != null) {
                            //           File? file = File(pickedFile.path);
                            //           File? compressedFile = FileUtils.instance
                            //               .compressImage(file);

                            //           await Future.delayed(
                            //               const Duration(milliseconds: 200),
                            //               () {
                            //             String userId =
                            //                 SharePrefUtils.getProfile().userId;
                            //             String imgId =
                            //                 SharePrefUtils.getProfile().imgId;
                            //             _userEditBloc.add(
                            //               UserEditAvatarEvent(
                            //                   userId: userId,
                            //                   imgId: imgId,
                            //                   image: compressedFile),
                            //             );
                            //           });
                            //         }
                            //       },
                            //     );
                            //   },
                            // ),
                            // const Padding(padding: EdgeInsets.only(top: 10)),
                            // ButtonWidget(
                            //   width: width - 40,
                            //   text: 'Đổi mật khẩu',
                            //   textColor: AppColor.BLUE_TEXT,
                            //   bgColor: Theme.of(context).cardColor,
                            //   function: () {
                            //     Navigator.of(context)
                            //         .pushNamed(Routes.UPDATE_PASSWORD);
                            //   },
                            // ),
                            // const Padding(padding: EdgeInsets.only(top: 10)),
                            // ButtonWidget(
                            //   width: width - 40,
                            //   text: 'Cập nhật thông tin qua CCCD',
                            //   textColor: AppColor.BLUE_TEXT,
                            //   bgColor: Theme.of(context).cardColor,
                            //   function: () async {
                            //     if (SharePrefUtils.getQrIntro()) {
                            //       startBarcodeScanStream(context);
                            //     } else {
                            //       await DialogWidget.instance
                            //           .showFullModalBottomContent(
                            //         widget: const QRScanWidget(),
                            //         color: AppColor.BLACK,
                            //       );
                            //       if (!mounted) return;
                            //       startBarcodeScanStream(context);
                            //     }
                            //   },
                            // ),
                            // const Padding(padding: EdgeInsets.only(top: 30)),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 80,
                                    color: Colors.white,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Số dư VQR',
                                            style: TextStyle(
                                                color: AppColor.GREY_TEXT,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            _isBalanceVisible
                                                ? CurrencyUtils.instance
                                                    .getCurrencyFormatted(
                                                        SharePrefUtils
                                                                .getProfile()
                                                            .balance
                                                            .toString())
                                                : '*****',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 2,
                                  color: AppColor.GREY_DADADA,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 80,
                                    color: Colors.white,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Điểm thưởng',
                                            style: TextStyle(
                                                color: AppColor.GREY_TEXT,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            CurrencyUtils.instance
                                                .getCurrencyFormatted(
                                                    SharePrefUtils.getProfile()
                                                        .score
                                                        .toString()),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: _toggleBalanceVisibility,
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFE1EFFF),
                                              Color(0xFFE5F9FF),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _isBalanceVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            size: 15,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            _isBalanceVisible
                                                ? 'Ẩn số dư'
                                                : 'Hiện số dư',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFE1EFFF),
                                              Color(0xFFE5F9FF),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        children: [
                                          XImage(
                                            imagePath:
                                                'assets/images/ic-viet-qr-small-trans.png',
                                            width: 20,
                                          ),
                                          SizedBox(width: 12),
                                          const Text(
                                            'Giới thiệu VietQR.VN',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SharePrefUtils.getProfile().verify == true
                                ? InkWell(
                                    onTap: () {
                                      NavigatorUtils.navigatePage(
                                          context, KeyActiveFreeScreen(),
                                          routeName:
                                              KeyActiveFreeScreen.routeName);
                                    },
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFE1EFFF),
                                                Color(0xFFE5F9FF),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Row(
                                          children: [
                                            const XImage(
                                              imagePath:
                                                  'assets/images/ic-infinity.png',
                                              width: 40,
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Nhận ngay ưu đãi sử dụng dịch vụ',
                                                  style:
                                                      TextStyle(fontSize: 11),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'không giới hạn của VietQR',
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                    ShaderMask(
                                                      shaderCallback: (bounds) =>
                                                          const LinearGradient(
                                                        colors: [
                                                          Color(0xFF00C6FF),
                                                          Color(0xFF0072FF),
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ).createShader(bounds),
                                                      child: Text(
                                                        ' miễn phí 01 tháng.',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          // decoration:
                                                          //     TextDecoration.underline,
                                                          // decorationColor:
                                                          //     Colors.transparent,
                                                          // decorationThickness: 2,
                                                          foreground: Paint()
                                                            ..shader =
                                                                const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                    0xFF00C6FF),
                                                                Color(
                                                                    0xFF0072FF),
                                                              ],
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                            ).createShader(
                                                                    const Rect
                                                                        .fromLTWH(
                                                                        0,
                                                                        0,
                                                                        200,
                                                                        30)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      NavigatorUtils.navigatePage(
                                          context, VerifyEmailScreen(),
                                          routeName:
                                              VerifyEmailScreen.routeName);
                                    },
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFE1EFFF),
                                                Color(0xFFE5F9FF),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Row(
                                          children: [
                                            const XImage(
                                              imagePath:
                                                  'assets/images/logo-email.png',
                                              width: 40,
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'Xác thực thông tin Email của bạn',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Icon(
                                                      Icons
                                                          .arrow_circle_right_outlined,
                                                      color: AppColor.BLUE_TEXT
                                                          .withOpacity(0.8),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  'Nhận ngay ưu đãi sử dụng dịch vụ',
                                                  style:
                                                      TextStyle(fontSize: 11),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'không giới hạn của VietQR',
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                    ShaderMask(
                                                      shaderCallback: (bounds) =>
                                                          const LinearGradient(
                                                        colors: [
                                                          Color(0xFF00C6FF),
                                                          Color(0xFF0072FF),
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ).createShader(bounds),
                                                      child: Text(
                                                        ' miễn phí 01 tháng.',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          foreground: Paint()
                                                            ..shader =
                                                                const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                    0xFF00C6FF),
                                                                Color(
                                                                    0xFF0072FF),
                                                              ],
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                            ).createShader(
                                                                    const Rect
                                                                        .fromLTWH(
                                                                        0,
                                                                        0,
                                                                        200,
                                                                        30)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                            const SizedBox(height: 12),
                            Column(
                              children: [
                                Container(
                                  height: 50,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: 80,
                                                child: Text('Email')),
                                            Text(_emailController.text),
                                          ],
                                        ),
                                        SharePrefUtils.getProfile().verify ==
                                                true
                                            ? ClipOval(
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  color: AppColor.GREEN
                                                      .withOpacity(0.3),
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 15,
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  'haha';
                                                },
                                                child: ClipOval(
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    color: AppColor.ORANGE
                                                        .withOpacity(0.3),
                                                    child: Center(
                                                        child: Text('?')),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                const MySeparator(
                                  color: AppColor.GREY_DADADA,
                                ),
                              ],
                            ),
                            _buildInfo('CCCD', _nationalIdController.text),
                            _buildInfo('Ngày cấp', _nationalDate),
                            _buildInfo(
                                'CMT (cũ)', _oldNationalIdController.text),
                            _buildInfo('Giới tính',
                                provider.gender == 0 ? 'Nam' : 'Nữ'),
                            _buildInfo('Ngày sinh', _birthDate),
                            _buildInfo('Địa chỉ', _addressController.text),

                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF6FF),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Tuỳ chọn',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          'Đã đăng ký ngày $_timeCreated',
                                          style: const TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    buildOptionRow(
                                      'Cập nhật ảnh đại diện',
                                      'assets/images/ic-add-image-black.png',
                                      () async {
                                        await Permission.mediaLibrary.request();
                                        await imagePicker
                                            .pickImage(
                                                source: ImageSource.gallery)
                                            .then(
                                          (pickedFile) async {
                                            if (pickedFile != null) {
                                              File? file =
                                                  File(pickedFile.path);
                                              File? compressedFile = FileUtils
                                                  .instance
                                                  .compressImage(file);

                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 200), () {
                                                String userId =
                                                    SharePrefUtils.getProfile()
                                                        .userId;
                                                String imgId =
                                                    SharePrefUtils.getProfile()
                                                        .imgId;
                                                _userEditBloc.add(
                                                  UserEditAvatarEvent(
                                                      userId: userId,
                                                      imgId: imgId,
                                                      image: compressedFile),
                                                );
                                              });
                                            }
                                          },
                                        );
                                      },
                                    ),
                                    const MySeparator(
                                      color: AppColor.GREY_DADADA,
                                    ),
                                    buildOptionRow(
                                      'Thay đổi mật khẩu',
                                      'assets/images/ic-lock-black.png',
                                      () {
                                        Navigator.of(context)
                                            .pushNamed(Routes.UPDATE_PASSWORD);
                                      },
                                    ),
                                    const MySeparator(
                                      color: AppColor.GREY_DADADA,
                                    ),
                                    buildOptionRow(
                                      'Cập nhật thông tin cá nhân',
                                      'assets/images/ic-info-person-black.png',
                                      () {
                                        Navigator.of(context)
                                            .pushNamed(Routes.USER_EDIT);
                                      },
                                    ),
                                    const MySeparator(
                                      color: AppColor.GREY_DADADA,
                                    ),
                                    buildOptionRow(
                                      'Xoá tài khoản VietQR',
                                      'assets/images/ic-remove-black.png',
                                      () {
                                        DialogWidget.instance.openBoxWebConfirm(
                                          title: 'Xác nhận xoá tài khoản',
                                          confirmText: 'Đồng ý',
                                          imageAsset:
                                              'assets/images/ic-warning.png',
                                          description:
                                              'Tài khoản của bạn sẽ bị vô hiệu hoá và không thể đăng nhập lại vào hệ thống',
                                          confirmFunction: () async {
                                            Navigator.pop(context);
                                            String userId =
                                                SharePrefUtils.getProfile()
                                                    .userId;
                                            _userEditBloc.add(UserDeactiveEvent(
                                                userId: userId));
                                          },
                                          confirmColor: AppColor.RED_TEXT,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // BoxLayout(
                            //   width: width,
                            //   child: Column(
                            //     children: [
                            //       TextFieldWidget(
                            //         width: width,
                            //         textfieldType: TextfieldType.LABEL,
                            //         isObscureText: false,
                            //         title: 'Họ',
                            //         hintText: '',
                            //         controller: _lastNameController,
                            //         inputType: TextInputType.text,
                            //         keyboardAction: TextInputAction.next,
                            //         onChange: (value) {
                            //           provider.setAvailableUpdate(true);
                            //         },
                            //       ),
                            //       DividerWidget(width: width),
                            //       TextFieldWidget(
                            //         width: width,
                            //         textfieldType: TextfieldType.LABEL,
                            //         isObscureText: false,
                            //         title: 'Tên đệm',
                            //         hintText: '',
                            //         controller: _middleNameController,
                            //         inputType: TextInputType.text,
                            //         keyboardAction: TextInputAction.next,
                            //         onChange: (value) {
                            //           provider.setAvailableUpdate(true);
                            //         },
                            //       ),
                            //       DividerWidget(width: width),
                            //       TextFieldWidget(
                            //         width: width,
                            //         textfieldType: TextfieldType.LABEL,
                            //         isObscureText: false,
                            //         title: 'Tên',
                            //         hintText: '',
                            //         controller: _firstNameController,
                            //         inputType: TextInputType.text,
                            //         keyboardAction: TextInputAction.next,
                            //         onChange: (value) {
                            //           provider.setAvailableUpdate(true);
                            //         },
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Visibility(
                            //   visible: provider.firstNameErr,
                            //   child: const Padding(
                            //     padding: EdgeInsets.only(top: 5, left: 5),
                            //     child: Text(
                            //       'Tên không được bỏ trống.',
                            //       style: TextStyle(
                            //         color: AppColor.RED_TEXT,
                            //         fontSize: 13,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // const Padding(padding: EdgeInsets.only(top: 10)),
                            // BoxLayout(
                            //   width: width,
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       const SizedBox(
                            //         width: 80,
                            //         child: Text(
                            //           'Ngày sinh',
                            //           style: TextStyle(
                            //             fontSize: 16,
                            //           ),
                            //         ),
                            //       ),
                            //       Expanded(
                            //         child: SizedBox(
                            //           height: 150,
                            //           child: CupertinoTheme(
                            //             data: CupertinoThemeData(
                            //               textTheme: CupertinoTextThemeData(
                            //                 dateTimePickerTextStyle: TextStyle(
                            //                   fontSize: 16,
                            //                   color:
                            //                       Theme.of(context).hintColor,
                            //                 ),
                            //               ),
                            //             ),
                            //             child: CupertinoDatePicker(
                            //               initialDateTime: TimeUtils.instance
                            //                   .getDateFromString(_birthDate),
                            //               maximumDate: DateTime.now(),
                            //               mode: CupertinoDatePickerMode.date,
                            //               onDateTimeChanged: ((time) {
                            //                 provider.setAvailableUpdate(true);
                            //                 _birthDate = TimeUtils.instance
                            //                     .formatDate(time.toString());
                            //               }),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // const Padding(padding: EdgeInsets.only(top: 10)),
                            // BoxLayout(
                            //   width: width,
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 20, vertical: 20),
                            //   child: Row(
                            //     children: [
                            //       const Text(
                            //         'Giới tính',
                            //         style: TextStyle(
                            //           fontSize: 16,
                            //         ),
                            //       ),
                            //       const Spacer(),
                            //       const Text(
                            //         'Nam',
                            //         style: TextStyle(
                            //           fontSize: 16,
                            //         ),
                            //       ),
                            //       const Padding(
                            //           padding: EdgeInsets.only(left: 5)),
                            //       CheckBoxWidget(
                            //         check: (provider.gender == 0),
                            //         size: 20,
                            //         function: () {
                            //           provider.setAvailableUpdate(true);
                            //           provider.updateGender(0);
                            //         },
                            //       ),
                            //       const Padding(
                            //           padding: EdgeInsets.only(left: 10)),
                            //       const Text(
                            //         'Nữ',
                            //         style: TextStyle(
                            //           fontSize: 16,
                            //         ),
                            //       ),
                            //       const Padding(
                            //           padding: EdgeInsets.only(left: 5)),
                            //       CheckBoxWidget(
                            //         check: (provider.gender != 0),
                            //         size: 20,
                            //         function: () {
                            //           provider.setAvailableUpdate(true);
                            //           provider.updateGender(1);
                            //         },
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // const Padding(padding: EdgeInsets.only(top: 10)),
                            // BoxLayout(
                            //   width: width,
                            //   // height: 55,
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 20, vertical: 0),
                            //   child: TextFieldWidget(
                            //     width: width,
                            //     textfieldType: TextfieldType.LABEL,
                            //     isObscureText: false,
                            //     title: 'Email',
                            //     hintText: 'user@gmail.com',
                            //     controller: _emailController,
                            //     inputType: TextInputType.text,
                            //     keyboardAction: TextInputAction.next,
                            //     onChange: (vavlue) {
                            //       provider.setAvailableUpdate(true);
                            //     },
                            //   ),
                            // ),
                            // const Padding(padding: EdgeInsets.only(top: 10)),
                            // BoxLayout(
                            //   width: width,
                            //   // height: 55,
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 20, vertical: 0),
                            //   child: TextFieldWidget(
                            //     width: width,
                            //     textfieldType: TextfieldType.LABEL,
                            //     isObscureText: false,
                            //     title: 'CCCD',
                            //     hintText: 'Nhập CCCD',
                            //     controller: _nationalIdController,
                            //     inputType: TextInputType.text,
                            //     keyboardAction: TextInputAction.next,
                            //     onChange: (vavlue) {
                            //       provider.setAvailableUpdate(true);
                            //     },
                            //   ),
                            // ),
                            // const Padding(padding: EdgeInsets.only(top: 10)),
                            // BoxLayout(
                            //   width: width,
                            //   // height: 55,
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 20, vertical: 0),
                            //   child: TextFieldWidget(
                            //     width: width,
                            //     textfieldType: TextfieldType.LABEL,
                            //     isObscureText: false,
                            //     title: 'CMND(cũ)',
                            //     hintText: 'Nhập cmnd',
                            //     controller: _oldNationalIdController,
                            //     inputType: TextInputType.text,
                            //     keyboardAction: TextInputAction.next,
                            //     onChange: (vavlue) {
                            //       provider.setAvailableUpdate(true);
                            //     },
                            //   ),
                            // ),
                            // const Padding(padding: EdgeInsets.only(top: 10)),
                            // BoxLayout(
                            //   width: width,
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       const SizedBox(
                            //         width: 80,
                            //         child: Text(
                            //           'Ngày cấp CCCD',
                            //           style: TextStyle(
                            //             fontSize: 16,
                            //           ),
                            //         ),
                            //       ),
                            //       Expanded(
                            //         child: SizedBox(
                            //           height: 150,
                            //           child: CupertinoTheme(
                            //             data: CupertinoThemeData(
                            //               textTheme: CupertinoTextThemeData(
                            //                 dateTimePickerTextStyle: TextStyle(
                            //                   fontSize: 16,
                            //                   color:
                            //                       Theme.of(context).hintColor,
                            //                 ),
                            //               ),
                            //             ),
                            //             child: CupertinoDatePicker(
                            // initialDateTime: TimeUtils.instance
                            //     .getDateFromString(_nationalDate),
                            //               maximumDate: DateTime.now(),
                            //               mode: CupertinoDatePickerMode.date,
                            //               onDateTimeChanged: ((time) {
                            //                 provider.setAvailableUpdate(true);
                            //                 _nationalDate = TimeUtils.instance
                            //                     .formatDate(time.toString());
                            //               }),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // const Padding(padding: EdgeInsets.only(top: 10)),
                            // BoxLayout(
                            //   width: width,
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 20, vertical: 20),
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       const SizedBox(
                            //         width: 90,
                            //         child: Text(
                            //           'Địa chỉ',
                            //           style: TextStyle(
                            //             fontSize: 16,
                            //           ),
                            //         ),
                            //       ),
                            //       Expanded(
                            //         child: SizedBox(
                            //           height: 100,
                            //           child: TextField(
                            //             maxLines: 10,
                            //             controller: _addressController,
                            //             textInputAction: TextInputAction.done,
                            //             maxLength: 1000,
                            //             decoration:
                            //                 const InputDecoration.collapsed(
                            //               hintText: 'Nhập địa chỉ thường trú',
                            //               hintStyle: TextStyle(
                            //                 fontSize: 16,
                            //                 color: AppColor.GREY_TEXT,
                            //               ),
                            //             ),
                            //             onChanged: (value) {
                            //               provider.setAvailableUpdate(true);
                            //             },
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // const Padding(padding: EdgeInsets.only(top: 30)),
                            // DividerWidget(width: width),
                            // ButtonIconWidget(
                            //   width: width,
                            //   height: 40,
                            //   icon: Icons.remove_circle_outline_rounded,
                            //   title: 'Xoá tài khoản',
                            //   function: () {
                            //     DialogWidget.instance.openBoxWebConfirm(
                            //       title: 'Xác nhận xoá tài khoản',
                            //       confirmText: 'Đồng ý',
                            //       imageAsset: 'assets/images/ic-warning.png',
                            //       description:
                            //           'Tài khoản của bạn sẽ bị vô hiệu hoá và không thể đăng nhập lại vào hệ thống',
                            //       confirmFunction: () async {
                            //         Navigator.pop(context);
                            //         String userId =
                            //             SharePrefUtils.getProfile().userId;
                            //         _userEditBloc
                            //             .add(UserDeactiveEvent(userId: userId));
                            //       },
                            //       confirmColor: AppColor.RED_TEXT,
                            //     );
                            //   },
                            //   bgColor: AppColor.TRANSPARENT,
                            //   textColor: AppColor.RED_TEXT,
                            // ),
                            // DividerWidget(width: width),
                            // const Padding(padding: EdgeInsets.only(top: 30)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            (PlatformUtils.instance.isWeb())
                ? const Padding(
                    padding: EdgeInsets.only(
                      bottom: 10,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                      top: 10,
                    ),
                    child: Consumer<UserEditProvider>(
                      builder: (context, provider, child) {
                        return Visibility(
                          visible: provider.availableUpdate,
                          child: ButtonWidget(
                            width: width - 40,
                            text: 'Cập nhật',
                            textColor: AppColor.WHITE,
                            borderRadius: 8,
                            bgColor: AppColor.BLUE_TEXT,
                            function: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              provider.updateErrors(
                                  _firstNameController.text.isEmpty);
                              if (provider.isValidUpdate()) {
                                UserProfile accountInformationDTO = UserProfile(
                                  userId: SharePrefUtils.getProfile().userId,
                                  firstName: _firstNameController.text,
                                  middleName: _middleNameController.text,
                                  lastName: _lastNameController.text,
                                  birthDate: _birthDate,
                                  gender: provider.gender,
                                  address: _addressController.text,
                                  email: _emailController.text,
                                  nationalDate: _nationalDate,
                                  nationalId: _nationalIdController.text,
                                  oldNationalId: _oldNationalIdController.text,
                                  imgId: SharePrefUtils.getProfile().imgId,
                                );

                                _userEditBloc.add(
                                  UserEditInformationEvent(
                                    dto: accountInformationDTO,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWidget(BuildContext context, double size) {
    // double size = size;
    String imgId = SharePrefUtils.getProfile().imgId;
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return (provider.avatarUser.path.isNotEmpty)
            ? AmbientAvatarWidget(
                imgId: imgId,
                size: size,
                imageFile: provider.avatarUser,
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

  // Future<void> _openDatePicker() async {
  Future<void> startBarcodeScanStream(BuildContext context) async {
    String data = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    if (data.isNotEmpty) {
      if (data == TypeQR.NEGATIVE_ONE.value) {
        return;
      } else if (data == TypeQR.NEGATIVE_TWO.value) {
        DialogWidget.instance.openMsgDialog(
          title: 'Không thể xác nhận mã QR',
          msg: 'Ảnh QR không đúng định dạng, vui lòng chọn ảnh khác.',
          function: () {
            Navigator.pop(context);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      } else {
        if (data.contains('|')) {
          NationalScannerDTO nationalScannerDTO =
              dashBoardRepository.getNationalInformation(data);
          if (!mounted) return;
          Navigator.pushNamed(
            context,
            Routes.NATIONAL_INFORMATION,
            arguments: {'dto': nationalScannerDTO, 'isPop': true},
          );
        }
      }
    }
  }

  backToPreviousPage(BuildContext context) async {
    _lastNameController.clear();
    _middleNameController.clear();
    _firstNameController.clear();
    _addressController.clear();
    _birthDate = '';
    Provider.of<UserEditProvider>(context, listen: false).reset();
    Provider.of<UserEditProvider>(context, listen: false).resetPasswordErr();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void backToHome(BuildContext context) {
    Provider.of<UserEditProvider>(context, listen: false).reset();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false);
  }

  Widget _buildInfo(String title, String data) {
    return Column(
      children: [
        Container(
          height: 50,
          child: Center(
            child: Row(
              children: [
                Row(
                  children: [
                    SizedBox(width: 80, child: Text(title)),
                    Text(data),
                  ],
                ),
              ],
            ),
          ),
        ),
        const MySeparator(
          color: AppColor.GREY_DADADA,
        ),
      ],
    );
  }

  Widget buildOptionRow(String title, String path, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        width: double.infinity, // Mở rộng chiều rộng của Container
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 12)),
            XImage(
              imagePath: path,
              width: 30,
            ),
          ],
        ),
      ),
    );
  }
}
