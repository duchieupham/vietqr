import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/ambient_avatar_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/checkbox_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/commons/widgets/web_widgets/header_mweb_widget_old.dart';
import 'package:vierqr/commons/widgets/web_widgets/header_web_widget_old.dart';
import 'package:vierqr/features/home/home.dart';
import 'package:vierqr/features/personal/blocs/user_edit_bloc.dart';
import 'package:vierqr/features/personal/events/user_edit_event.dart';
import 'package:vierqr/features/personal/frames/user_edit_frame.dart';
import 'package:vierqr/features/personal/states/user_edit_state.dart';
import 'package:vierqr/features/personal/views/qr_scanner.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_information_dto.dart';
import 'package:vierqr/models/user_information_dto.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
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
                            function: () {},
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
                              Navigator.of(context)
                                  .pushNamed(Routes.QR_SCAN)
                                  .then((code) {
                                if (code != '' &&
                                    code.toString().split('|').length == 7) {
                                  List<String> informations =
                                      code.toString().split('|');
                                  String fullName = informations[2];
                                  String firstName = fullName.split(' ').last;
                                  String lastName = fullName.split(' ').first;
                                  String middleName = '';
                                  for (int i = 0;
                                      i < fullName.split(' ').length;
                                      i++) {
                                    if (i != 0 &&
                                        i != fullName.split(' ').length - 1) {
                                      middleName +=
                                          ' ${fullName.split(' ')[i]}'.trim();
                                    }
                                  }
                                  String birthdate = informations[3];
                                  String bdDay = birthdate.substring(0, 2);
                                  String bdMonth = birthdate.substring(2, 4);
                                  String bdYear = birthdate.substring(4, 8);
                                  int gender =
                                      (informations[4] == 'Nam') ? 1 : 0;
                                  String address = informations[5];
                                  //
                                  _lastNameController.value =
                                      _lastNameController.value
                                          .copyWith(text: lastName);
                                  _middleNameController.value =
                                      _middleNameController.value
                                          .copyWith(text: middleName);
                                  _firstNameController.value =
                                      _firstNameController.value
                                          .copyWith(text: firstName);
                                  _birthDate = '$bdDay/$bdMonth/$bdYear';

                                  _addressController.value = _addressController
                                      .value
                                      .copyWith(text: address);
                                  provider.updateGender(gender);
                                  provider.setAvailableUpdate(true);
                                } else {
                                  // DialogWidget.instance.openMsgDialog(
                                  //
                                  //   title: 'Không thể cập nhật',
                                  //   msg:
                                  //       'Mã QR không đúng định dạng, vui lòng thử lại.',
                                  // );
                                }
                              });
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
                              hintText: '',
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
                                  width: 120,
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
                                        hintText: 'Địa chỉ tối đa 1000 ký tự.',
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
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
                        ],
                      ),
                    ),
                    widget1: SizedBox(
                      width: 200,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.asset(
                              'assets/images/ic-avatar.png',
                              width: 80,
                              height: 80,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              UserInformationHelper.instance.getUserFullname(),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              UserInformationHelper.instance.getPhoneNo(),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          ButtonWidget(
                            width: 200,
                            height: 30,
                            borderRadius: 5,
                            text: 'Cập nhật ảnh đại diện',
                            textColor: DefaultTheme.GREEN,
                            bgColor: Theme.of(context).cardColor,
                            function: () {},
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          ButtonWidget(
                            width: 200,
                            height: 30,
                            borderRadius: 5,
                            text: 'Đổi mật khẩu',
                            textColor: DefaultTheme.GREEN,
                            bgColor: Theme.of(context).cardColor,
                            function: () {
                              _openChangePIN(context);
                            },
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          ButtonWidget(
                            width: 200,
                            height: 30,
                            borderRadius: 5,
                            text: 'Cập nhật thông tin qua CCCD',
                            textColor: DefaultTheme.GREEN,
                            bgColor: Theme.of(context).cardColor,
                            function: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) => QRScanner(),
                                ),
                              )
                                  .then((code) {
                                if (code != '' &&
                                    code.toString().split('|').length == 7) {
                                  List<String> informations =
                                      code.toString().split('|');
                                  String fullName = informations[2];
                                  String firstName = fullName.split(' ').last;
                                  String lastName = fullName.split(' ').first;
                                  String middleName = '';
                                  for (int i = 0;
                                      i < fullName.split(' ').length;
                                      i++) {
                                    if (i != 0 &&
                                        i != fullName.split(' ').length - 1) {
                                      middleName +=
                                          ' ${fullName.split(' ')[i]}'.trim();
                                    }
                                  }
                                  String birthdate = informations[3];
                                  String bdDay = birthdate.substring(0, 2);
                                  String bdMonth = birthdate.substring(2, 4);
                                  String bdYear = birthdate.substring(4, 8);
                                  int gender =
                                      (informations[4] == 'Nam') ? 1 : 0;
                                  String address = informations[5];
                                  //
                                  _lastNameController.value =
                                      _lastNameController.value
                                          .copyWith(text: lastName);
                                  _middleNameController.value =
                                      _middleNameController.value
                                          .copyWith(text: middleName);
                                  _firstNameController.value =
                                      _firstNameController.value
                                          .copyWith(text: firstName);
                                  _birthDate = '$bdDay/$bdMonth/$bdYear';

                                  _addressController.value = _addressController
                                      .value
                                      .copyWith(text: address);
                                  provider.updateGender(gender);
                                  provider.setAvailableUpdate(true);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    widget2: BoxLayout(
                      width: 500,
                      borderRadius: 0,
                      child: Column(
                        children: [
                          _buildTitle('Họ'),
                          BorderLayout(
                            width: 500,
                            isError: false,
                            child: TextFieldWidget(
                              width: width,
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
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          _buildTitle('Tên đệm'),
                          BorderLayout(
                            width: 500,
                            isError: false,
                            child: TextFieldWidget(
                              width: width,
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
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          _buildTitle('Tên'),
                          BorderLayout(
                            width: 500,
                            isError: false,
                            child: TextFieldWidget(
                              width: width,
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
                          ),
                          Visibility(
                            visible: provider.firstNameErr,
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
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
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          _buildTitle('Giới tính'),
                          BorderLayout(
                            width: 500,
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            isError: false,
                            child: Row(
                              children: [
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
                          _buildTitle('Ngày sinh'),
                          BorderLayout(
                            width: 500,
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            isError: false,
                            child: InkWell(
                              onTap: () async {
                                await _openDatePicker();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    _birthDate,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.calendar_month_rounded,
                                    size: 15,
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          _buildTitle('Địa chỉ'),
                          BorderLayout(
                            width: 500,
                            height: 150,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            isError: false,
                            child: TextField(
                              maxLines: 10,
                              controller: _addressController,
                              textInputAction: TextInputAction.done,
                              maxLength: 1000,
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Địa chỉ tối đa 1000 ký tự.',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              onChanged: (value) {
                                provider.setAvailableUpdate(true);
                              },
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Consumer<UserEditProvider>(
                            builder: (context, provider, child) {
                              return Visibility(
                                visible: provider.availableUpdate,
                                child: ButtonWidget(
                                  width: 500,
                                  text: 'Cập nhật',
                                  textColor: DefaultTheme.WHITE,
                                  bgColor: DefaultTheme.GREEN,
                                  function: () {
                                    provider.updateErrors(
                                        _firstNameController.text.isEmpty);
                                    if (provider.isValidUpdate()) {
                                      AccountInformationDTO
                                          accountInformationDTO =
                                          AccountInformationDTO(
                                        userId: UserInformationHelper.instance
                                            .getUserId(),
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
                                              dto: accountInformationDTO));
                                    }
                                  },
                                ),
                              );
                            },
                          ),
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

  Future<void> _openDatePicker() async {
    await showDatePicker(
      context: NavigationService.navigatorKey.currentContext!,
      initialDate: TimeUtils.instance.getDateFromString(_birthDate),
      firstDate: TimeUtils.instance.getDateFromString('01/01/1900'),
      lastDate: DateTime.now(),
      helpText: 'Ngày sinh',
      cancelText: 'Đóng',
      confirmText: 'Chọn',
    ).then((pickedDate) {
      if (pickedDate != null) {
        Provider.of<UserEditProvider>(
                NavigationService.navigatorKey.currentContext!,
                listen: false)
            .setAvailableUpdate(true);
        _birthDate = TimeUtils.instance.formatDate(pickedDate.toString());
      }
    });
  }

  _openChangePIN(BuildContext context) {
    final TextEditingController _oldPasswordController =
        TextEditingController();
    final TextEditingController _newPasswordController =
        TextEditingController();
    final TextEditingController _confirmPassController =
        TextEditingController();
    double width = 500;
    return DialogWidget.instance.openContentDialog(
      () {
        Provider.of<UserEditProvider>(context, listen: false)
            .resetPasswordErr();
        Navigator.pop(context);
      },
      Consumer<UserEditProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Đổi mật khẩu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Padding(padding: EdgeInsets.only(top: 30)),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTitle('Mật khẩu cũ'),
                      BorderLayout(
                        width: width,
                        isError: provider.oldPassErr,
                        child: TextFieldWidget(
                          width: width,
                          isObscureText: true,
                          title: 'Mật khẩu cũ',
                          titleWidth: 120,
                          hintText: 'Mật khẩu hiện tại',
                          controller: _oldPasswordController,
                          inputType: TextInputType.number,
                          keyboardAction: TextInputAction.next,
                          onChange: (vavlue) {},
                        ),
                      ),
                      Visibility(
                        visible: provider.oldPassErr,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 5, right: 30),
                            child: Text(
                              'Mật khẩu cũ không đúng định dạng.',
                              style: TextStyle(
                                  color: DefaultTheme.RED_TEXT, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      _buildTitle('Mật khẩu mới'),
                      BorderLayout(
                        width: width,
                        isError: provider.newPassErr,
                        child: TextFieldWidget(
                          width: width,
                          isObscureText: true,
                          title: 'Mật khẩu mới',
                          titleWidth: 120,
                          hintText: 'Bao gồm 6 số',
                          controller: _newPasswordController,
                          inputType: TextInputType.number,
                          keyboardAction: TextInputAction.next,
                          onChange: (vavlue) {},
                        ),
                      ),
                      Visibility(
                        visible: provider.newPassErr,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 5, right: 30),
                            child: Text(
                              'Mật khẩu mới bao gồm 6 số.',
                              style: TextStyle(
                                  color: DefaultTheme.RED_TEXT, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      _buildTitle('Xác nhận lại'),
                      BorderLayout(
                        width: width,
                        isError: provider.confirmPassErr,
                        child: TextFieldWidget(
                          width: width,
                          isObscureText: true,
                          title: 'Xác nhận lại',
                          titleWidth: 120,
                          hintText: 'Xác nhận lại Mật khẩu mới',
                          controller: _confirmPassController,
                          inputType: TextInputType.number,
                          keyboardAction: TextInputAction.next,
                          onChange: (vavlue) {},
                        ),
                      ),
                      Visibility(
                        visible: provider.confirmPassErr,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 5, right: 30),
                            child: Text(
                              'Xác nhận Mật khẩu không trùng khớp.',
                              style: TextStyle(
                                  color: DefaultTheme.RED_TEXT, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                    ],
                  ),
                ),
              ),
              ButtonWidget(
                width: width - 40,
                text: 'Cập nhật',
                textColor: DefaultTheme.WHITE,
                bgColor: DefaultTheme.GREEN,
                function: () {
                  Provider.of<UserEditProvider>(context, listen: false)
                      .updatePasswordErrs(
                    (_oldPasswordController.text.isEmpty ||
                        _oldPasswordController.text.length != 6),
                    (_newPasswordController.text.isEmpty ||
                        _newPasswordController.text.length != 6),
                    (_confirmPassController.text !=
                        _newPasswordController.text),
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
            ],
          );
        },
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: 500,
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

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
