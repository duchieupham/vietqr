import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/file_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/ambient_avatar_widget.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/checkbox_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/home/home.dart';
import 'package:vierqr/features/personal/blocs/user_edit_bloc.dart';
import 'package:vierqr/features/personal/events/user_edit_event.dart';
import 'package:vierqr/features/personal/frames/user_edit_frame.dart';
import 'package:vierqr/features/personal/states/user_edit_state.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_information_dto.dart';
import 'package:vierqr/services/providers/add_business_provider.dart';
import 'package:vierqr/services/providers/avatar_provider.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/shared_references/qr_scanner_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class UserEditView extends StatelessWidget {
  static final TextEditingController _lastNameController =
      TextEditingController();
  static final TextEditingController _middleNameController =
      TextEditingController();
  static final TextEditingController _firstNameController =
      TextEditingController();
  static final TextEditingController _addressController =
      TextEditingController();
  static final TextEditingController _emailController = TextEditingController();
  static String _birthDate = '';
  static late UserEditBloc _userEditBloc;
  static final _formKey = GlobalKey<FormState>();
  static final ImagePicker imagePicker = ImagePicker();
  const UserEditView({super.key});

  void initialServices(BuildContext context) {
    _userEditBloc = BlocProvider.of(context);
    // final AccountInformationDTO accountInformationDTO =
    //     UserInformationHelper.instance.getUserInformation();
    final AccountInformationDTO accountInformationDTO =
        UserInformationHelper.instance.getAccountInformation();
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
    _birthDate = accountInformationDTO.birthDate;
    if (accountInformationDTO.address.isNotEmpty &&
        _addressController.text.isEmpty) {
      _addressController.value = _addressController.value
          .copyWith(text: accountInformationDTO.address);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    initialServices(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          SubHeader(
              title: 'Thông tin cá nhân',
              function: () {
                backToPreviousPage(context);
              }),
          Expanded(
            child: BlocListener<UserEditBloc, UserEditState>(
              listener: ((context, state) {
                if (state is UserEditLoadingState) {
                  DialogWidget.instance.openLoadingDialog();
                }
                if (state is UserDeactiveSuccessState) {
                  Navigator.pop(context);
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                  Navigator.of(context).pushReplacementNamed(Routes.LOGIN);
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
                  Provider.of<AvatarProvider>(context, listen: false)
                      .rebuildAvatar();
                  Provider.of<SuggestionWidgetProvider>(context, listen: false)
                      .updateUserUpdating(false);
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
                  //
                  if (_firstNameController.text != 'Undefined') {
                    Provider.of<SuggestionWidgetProvider>(context,
                            listen: false)
                        .updateUserUpdating(false);
                  }
                  Provider.of<UserEditProvider>(context, listen: false).reset();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
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
              }),
              child: Consumer<UserEditProvider>(
                builder: (context, provider, child) {
                  return UserEditFrame(
                    width: width,
                    height: height,
                    mobileChildren: Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          BoxLayout(
                            width: width,
                            bgColor: DefaultTheme.TRANSPARENT,
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Row(
                              children: [
                                _buildAvatarWidget(context),
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        UserInformationHelper.instance
                                            .getUserFullname(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        UserInformationHelper.instance
                                            .getPhoneNo(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: DefaultTheme.GREY_TEXT,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          ButtonWidget(
                            width: width - 40,
                            text: 'Cập nhật ảnh đại diện',
                            textColor: DefaultTheme.GREEN,
                            bgColor: Theme.of(context).cardColor,
                            function: () async {
                              await Permission.mediaLibrary.request();
                              await imagePicker
                                  .pickImage(source: ImageSource.gallery)
                                  .then(
                                (pickedFile) async {
                                  if (pickedFile != null) {
                                    File? file = File(pickedFile.path);
                                    File? compressedFile =
                                        FileUtils.instance.compressImage(file);
                                    Provider.of<AddBusinessProvider>(context,
                                            listen: false)
                                        .setImage(compressedFile);
                                    await Future.delayed(
                                        const Duration(milliseconds: 200), () {
                                      String userId = UserInformationHelper
                                          .instance
                                          .getUserId();
                                      String imgId = UserInformationHelper
                                          .instance
                                          .getAccountInformation()
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
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          ButtonWidget(
                            width: width - 40,
                            text: 'Đổi mật khẩu',
                            textColor: DefaultTheme.GREEN,
                            bgColor: Theme.of(context).cardColor,
                            function: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.UPDATE_PASSWORD);
                            },
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          ButtonWidget(
                            width: width - 40,
                            text: 'Cập nhật thông tin qua CCCD',
                            textColor: DefaultTheme.GREEN,
                            bgColor: Theme.of(context).cardColor,
                            function: () {
                              Navigator.pop(context);
                              if (QRScannerHelper.instance.getQrIntro()) {
                                Navigator.pushNamed(
                                    context, Routes.SCAN_QR_VIEW);
                              } else {
                                DialogWidget.instance
                                    .showFullModalBottomContent(
                                  widget: const QRScanWidget(),
                                  color: DefaultTheme.BLACK,
                                );
                              }
                            },
                          ),
                          // const Padding(padding: EdgeInsets.only(top: 10)),
                          // ButtonWidget(
                          //   width: width - 40,
                          //   text: 'Xoá tài khoản',
                          //   textColor: DefaultTheme.RED_TEXT,
                          //   bgColor: Theme.of(context).cardColor,
                          //   function: () {
                          //     //
                          //   },
                          // ),
                          const Padding(padding: EdgeInsets.only(top: 30)),
                          BoxLayout(
                            width: width,
                            child: Column(
                              children: [
                                TextFieldWidget(
                                  width: width,
                                  textfieldType: TextfieldType.LABEL,
                                  isObscureText: false,
                                  title: 'Họ',
                                  hintText: '',
                                  controller: _lastNameController,
                                  inputType: TextInputType.text,
                                  keyboardAction: TextInputAction.next,
                                  onChange: (vavlue) {
                                    provider.setAvailableUpdate(true);
                                  },
                                ),
                                DividerWidget(width: width),
                                TextFieldWidget(
                                  width: width,
                                  textfieldType: TextfieldType.LABEL,
                                  isObscureText: false,
                                  title: 'Tên đệm',
                                  hintText: '',
                                  controller: _middleNameController,
                                  inputType: TextInputType.text,
                                  keyboardAction: TextInputAction.next,
                                  onChange: (vavlue) {
                                    provider.setAvailableUpdate(true);
                                  },
                                ),
                                DividerWidget(width: width),
                                TextFieldWidget(
                                  width: width,
                                  textfieldType: TextfieldType.LABEL,
                                  isObscureText: false,
                                  title: 'Tên',
                                  hintText: '',
                                  controller: _firstNameController,
                                  inputType: TextInputType.text,
                                  keyboardAction: TextInputAction.next,
                                  onChange: (vavlue) {
                                    provider.setAvailableUpdate(true);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: provider.firstNameErr,
                            child: const Padding(
                              padding: EdgeInsets.only(top: 5, left: 5),
                              child: Text(
                                'Tên không được bỏ trống.',
                                style: TextStyle(
                                  color: DefaultTheme.RED_TEXT,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          BoxLayout(
                            width: width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 80,
                                  child: Text(
                                    'Ngày sinh',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 150,
                                    child: CupertinoTheme(
                                      data: CupertinoThemeData(
                                        textTheme: CupertinoTextThemeData(
                                          dateTimePickerTextStyle: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ),
                                      child: CupertinoDatePicker(
                                        initialDateTime: TimeUtils.instance
                                            .getDateFromString(_birthDate),
                                        maximumDate: DateTime.now(),
                                        mode: CupertinoDatePickerMode.date,
                                        onDateTimeChanged: ((time) {
                                          provider.setAvailableUpdate(true);
                                          _birthDate = TimeUtils.instance
                                              .formatDate(time.toString());
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          BoxLayout(
                            width: width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Row(
                              children: [
                                const Text(
                                  'Giới tính',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                const Text(
                                  'Nam',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 5)),
                                CheckBoxWidget(
                                  check: (provider.gender == 0),
                                  size: 20,
                                  function: () {
                                    provider.setAvailableUpdate(true);
                                    provider.updateGender(0);
                                  },
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                const Text(
                                  'Nữ',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 5)),
                                CheckBoxWidget(
                                  check: (provider.gender != 0),
                                  size: 20,
                                  function: () {
                                    provider.setAvailableUpdate(true);
                                    provider.updateGender(1);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          BoxLayout(
                            width: width,
                            // height: 55,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: TextFieldWidget(
                              width: width,
                              textfieldType: TextfieldType.LABEL,
                              isObscureText: false,
                              title: 'Email',
                              hintText: 'user@gmail.com',
                              controller: _emailController,
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {
                                provider.setAvailableUpdate(true);
                              },
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          BoxLayout(
                            width: width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 90,
                                  child: Text(
                                    'Địa chỉ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 100,
                                    child: TextField(
                                      maxLines: 10,
                                      controller: _addressController,
                                      textInputAction: TextInputAction.done,
                                      maxLength: 1000,
                                      decoration:
                                          const InputDecoration.collapsed(
                                        hintText: 'Nhập địa chỉ thường trú',
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: DefaultTheme.GREY_TEXT,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        provider.setAvailableUpdate(true);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 30)),
                          DividerWidget(width: width),
                          ButtonIconWidget(
                            width: width,
                            height: 40,
                            icon: Icons.remove_circle_outline_rounded,
                            title: 'Xoá tài khoản',
                            function: () {
                              DialogWidget.instance.openBoxWebConfirm(
                                title: 'Xác nhận xoá tài khoản',
                                confirmText: 'Đồng ý',
                                imageAsset: 'assets/images/ic-warning.png',
                                description:
                                    'Tài khoản của bạn sẽ bị vô hiệu hoá và không thể đăng nhập lại vào hệ thống',
                                confirmFunction: () {
                                  Navigator.pop(context);
                                  String userId = UserInformationHelper.instance
                                      .getUserId();
                                  _userEditBloc
                                      .add(UserDeactiveEvent(userId: userId));
                                },
                                confirmColor: DefaultTheme.RED_TEXT,
                              );
                            },
                            bgColor: DefaultTheme.TRANSPARENT,
                            textColor: DefaultTheme.RED_TEXT,
                          ),
                          DividerWidget(width: width),
                          const Padding(padding: EdgeInsets.only(top: 30)),
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
                          textColor: DefaultTheme.WHITE,
                          bgColor: DefaultTheme.GREEN,
                          function: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            provider.updateErrors(
                                _firstNameController.text.isEmpty);
                            if (provider.isValidUpdate()) {
                              AccountInformationDTO accountInformationDTO =
                                  AccountInformationDTO(
                                userId:
                                    UserInformationHelper.instance.getUserId(),
                                firstName: _firstNameController.text,
                                middleName: _middleNameController.text,
                                lastName: _lastNameController.text,
                                birthDate: _birthDate,
                                gender: provider.gender,
                                address: _addressController.text,
                                email: _emailController.text,
                                imgId: UserInformationHelper.instance
                                    .getAccountInformation()
                                    .imgId,
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
    );
  }

  Widget _buildAvatarWidget(BuildContext context) {
    double size = 60;
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

  // Future<void> _openDatePicker() async {
  //   await showDatePicker(
  //     context: NavigationService.navigatorKey.currentContext!,
  //     initialDate: TimeUtils.instance.getDateFromString(_birthDate),
  //     firstDate: TimeUtils.instance.getDateFromString('01/01/1900'),
  //     lastDate: DateTime.now(),
  //     helpText: 'Ngày sinh',
  //     cancelText: 'Đóng',
  //     confirmText: 'Chọn',
  //   ).then((pickedDate) {
  //     if (pickedDate != null) {
  //       Provider.of<UserEditProvider>(
  //               NavigationService.navigatorKey.currentContext!,
  //               listen: false)
  //           .setAvailableUpdate(true);
  //       _birthDate = TimeUtils.instance.formatDate(pickedDate.toString());
  //     }
  //   });
  // }

  void backToPreviousPage(BuildContext context) {
    _lastNameController.clear();
    _middleNameController.clear();
    _firstNameController.clear();
    _addressController.clear();
    _birthDate = '';
    Provider.of<UserEditProvider>(context, listen: false).reset();
    Provider.of<UserEditProvider>(context, listen: false).resetPasswordErr();
    Navigator.pop(context);
  }

  void backToHome(BuildContext context) {
    Provider.of<UserEditProvider>(context, listen: false).reset();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false);
  }
}
