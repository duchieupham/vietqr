import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/ambient_avatar_widget.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/features/personal/blocs/user_edit_bloc.dart';
import 'package:vierqr/features/personal/events/user_edit_event.dart';
import 'package:vierqr/features/personal/states/user_edit_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/account_information_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class NationalInformationView extends StatelessWidget {
  static late UserEditBloc userEditBloc;

  const NationalInformationView({super.key});

  void initialServices(BuildContext context) {
    userEditBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    NationalScannerDTO dto = arg['dto'];
    bool isPop = arg['isPop'] ?? false;
    initialServices(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 50,
              child: _buildAvatarWidget(context),
            ),
            BoxLayout(
              width: width - 40,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildElement(
                    width: width - 40,
                    context: context,
                    title: 'CCCD',
                    content: dto.nationalId,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: DividerWidget(width: width - 40),
                  ),
                  _buildElement(
                    width: width - 40,
                    context: context,
                    title: 'CMND',
                    content: dto.oldNationalId,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: DividerWidget(width: width - 40),
                  ),
                  _buildElement(
                    width: width - 40,
                    context: context,
                    title: 'Họ tên',
                    content: dto.fullname,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: DividerWidget(width: width - 40),
                  ),
                  _buildElement(
                    width: width - 40,
                    context: context,
                    title: 'Ngày sinh',
                    content: dto.getBirth,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: DividerWidget(width: width - 40),
                  ),
                  _buildElement(
                    width: width - 40,
                    context: context,
                    title: 'Địa chỉ',
                    content: dto.address,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: DividerWidget(width: width - 40),
                  ),
                  _buildElement(
                    width: width - 40,
                    context: context,
                    title: 'Ngày cấp',
                    content: dto.getDateValid,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              child: SizedBox(
                width: width - 40,
                child: Row(
                  children: [
                    BlocListener<UserEditBloc, UserEditState>(
                      listener: (context, state) {
                        if (state is UserEditLoadingState) {
                          DialogWidget.instance.openLoadingDialog();
                        }
                        if (state is UserEditFailedState) {
                          //pop loading dialog
                          Navigator.pop(context);
                          //
                          DialogWidget.instance.openMsgDialog(
                              title: 'Không thể cập nhật thông tin',
                              msg: state.msg);
                        }
                        if (state is UserEditSuccessfulState) {
                          //pop loading dialog
                          if (!isPop) {
                            Navigator.of(context).pop();
                          }
                          Provider.of<SuggestionWidgetProvider>(context,
                                  listen: false)
                              .updateUserUpdating(false);
                          Fluttertoast.showToast(
                            msg: 'Cập nhật thông tin thành công',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Theme.of(context).cardColor,
                            textColor: Theme.of(context).hintColor,
                            fontSize: 15,
                            webBgColor: 'rgba(255, 255, 255)',
                            webPosition: 'center',
                          );
                          if (!isPop) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: ButtonIconWidget(
                        width: width * 0.8 - 25,
                        height: 40,
                        icon: Icons.person_outline_rounded,
                        title: 'Cập nhật thông tin cá nhân',
                        function: () {
                          int gender = (dto.gender.trim() == 'Nam') ? 0 : 1;
                          List<String> namePaths =
                              StringUtils.instance.splitFullName(dto.fullname);
                          AccountInformationDTO accountInformationDTO =
                              AccountInformationDTO(
                            userId: UserInformationHelper.instance.getUserId(),
                            firstName: namePaths[0].trim(),
                            middleName: namePaths[1].trim(),
                            lastName: namePaths[2].trim(),
                            birthDate: dto.getBirth,
                            gender: gender,
                            address: dto.address,
                            email: UserInformationHelper.instance
                                .getAccountInformation()
                                .email,
                            imgId: UserInformationHelper.instance
                                .getAccountInformation()
                                .imgId,
                          );
                          userEditBloc.add(
                            UserEditInformationEvent(
                              dto: accountInformationDTO,
                            ),
                          );
                        },
                        bgColor: AppColor.GREEN,
                        textColor: AppColor.WHITE,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    ButtonIconWidget(
                      width: width * 0.2 - 25,
                      height: 40,
                      icon: Icons.home_outlined,
                      title: '',
                      function: () {
                        Navigator.pop(context);
                      },
                      bgColor: Theme.of(context).cardColor,
                      textColor: AppColor.GREEN,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElement({
    required double width,
    required BuildContext context,
    required String title,
    required String content,
    Color? color,
    bool? isBold,
  }) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColor.GREY_TEXT,
              ),
            ),
          ),
          Expanded(
            child: Text(
              content,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: (color != null) ? color : Theme.of(context).hintColor,
                fontWeight: (isBold != null && isBold)
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
            ),
          ),
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
}
