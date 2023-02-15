import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/personal/blocs/member_manage_bloc.dart';
import 'package:vierqr/features/bank_card/events/member_manage_event.dart';
import 'package:vierqr/features/personal/states/member_manage_state.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/services/providers/memeber_manage_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class AddMembersCardWidget extends StatelessWidget {
  final double width;
  final String bankId;
  final String roleInsert;
  final bool? isModalBottom;
  final TextEditingController _textController = TextEditingController();

  bool _isInitial = false;
  static late MemberManageBloc memberManageBloc;

  AddMembersCardWidget({
    super.key,
    required this.width,
    required this.bankId,
    required this.roleInsert,
    this.isModalBottom,
  });

  _initialServices(BuildContext context) {
    if (!_isInitial) {
      memberManageBloc = BlocProvider.of(context);
      memberManageBloc.add(MemberManageEventGetList(bankId: bankId));
      _isInitial = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initialServices(context);
    return Consumer<MemeberManageProvider>(
      builder: ((context, provider, child) {
        return BlocConsumer<MemberManageBloc, MemberManageState>(
          listener: ((context, state) {
            if (state is MemberManageGetListSuccessState) {
              if (provider.availableRefresh) {
                if (state.users.isNotEmpty && provider.users.isEmpty) {
                  provider.users.clear();
                  provider.users.addAll(state.users);
                  provider.setAvailableUpdate(false);
                }
              }
            }
            if (state is MemberManageAddSuccessfulState) {
              provider.users.clear();
              provider.setAvailableUpdate(true);
              memberManageBloc.add(MemberManageEventGetList(bankId: bankId));
            }
            if (state is MemberManageRemoveSuccessState) {
              provider.users.clear();
              provider.setAvailableUpdate(true);
              memberManageBloc.add(MemberManageEventGetList(bankId: bankId));
            }
            if (state is MemberManageAddFailedStateState) {
              DialogWidget.instance.openMsgDialog(
                  title: 'Không thể thêm thành viên',
                  msg:
                      'Không thể thêm thành viên vào tài khoản ngân hàng này. Vui lòng kiểm tra lại kết nối mạng');
            }
            if (state is MemberManageRemoveFailedState) {
              DialogWidget.instance.openMsgDialog(
                  title: 'Không thể xoá thành viên',
                  msg:
                      'Không thể xoá thành viên vào tài khoản ngân hàng này. Vui lòng kiểm tra lại kết nối mạng');
            }
          }),
          builder: ((context, state) {
            if (state is MemberManageGetListSuccessState) {
              if (state.users.isEmpty) {
                provider.users.clear();
                provider.setAvailableUpdate(true);
              }
            }
            return Column(
              children: [
                (isModalBottom != null && isModalBottom!)
                    ? const Padding(padding: EdgeInsets.only(top: 20))
                    : const SizedBox(),
                (isModalBottom != null && isModalBottom!)
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 80,
                            height: 30,
                            alignment: Alignment.centerRight,
                            child: const Text(
                              'Xong',
                              style: TextStyle(
                                  color: DefaultTheme.GREEN, fontSize: 15),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                _buildTitle('Thêm số điện thoại'),
                _buildDescription(
                    'Số điện thoại được kết nối với thành viên đã đăng ký trong hệ thống.'),
                BorderLayout(
                  width: 500,
                  isError: false,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextFieldWidget(
                    width: width,
                    isObscureText: false,
                    hintText: 'Nhập số điện thoại',
                    controller: _textController,
                    inputType: TextInputType.number,
                    keyboardAction: TextInputAction.next,
                    onChange: (text) {
                      if (_textController.text.length == 10) {
                        memberManageBloc.add(
                          MemberManageEventAdd(
                            bankId: bankId,
                            phoneNo: _textController.text,
                            role: 'MANAGER',
                          ),
                        );
                        _textController.clear();
                      }
                    },
                  ),
                ),
                if (state is MemberManageAddingState)
                  _buildConfirmationWidget(
                      'Đang thêm thành viên vào danh sách.',
                      Theme.of(context).canvasColor,
                      DefaultTheme.GREEN),
                if (state is MemberManageAddSuccessfulState)
                  _buildConfirmationWidget(
                    'Thêm thành công.',
                    DefaultTheme.GREEN.withOpacity(0.5),
                    Theme.of(context).hintColor,
                  ),
                if (state is MemberManageRemovingState)
                  _buildConfirmationWidget(
                      'Đang xoá thành viên khỏi danh sách.',
                      Theme.of(context).canvasColor,
                      DefaultTheme.GREEN),
                if (state is MemberManageRemoveSuccessState)
                  _buildConfirmationWidget(
                    'Xoá thành công thành công.',
                    DefaultTheme.GREEN.withOpacity(0.5),
                    Theme.of(context).hintColor,
                  ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                _buildTitle('Danh sách thành viên'),
                _buildDescription(
                    'Danh sách thành viên được nhận thông báo giao dịch của tài khoản ngân hàng này.'),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Expanded(
                  child: (provider.users.isEmpty)
                      ? const SizedBox()
                      : ListView.builder(
                          itemCount: provider.users.length,
                          shrinkWrap: true,
                          itemBuilder: ((context, index) {
                            return _buildUserElement(
                              context,
                              provider.users[index].bankId,
                              provider.users[index].userId,
                              provider.users[index].fullName,
                              provider.users[index].phoneNo,
                              provider.users[index].role,
                            );
                          }),
                        ),
                ),
              ],
            );
          }),
        );
      }),
    );
  }

  Widget _buildConfirmationWidget(String text, Color bgColor, Color textColor) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 13),
      ),
    );
  }

  Widget _buildUserElement(BuildContext context, String bankId, String userId,
      String fullName, String phoneNo, String role) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/ic-avatar.png',
            width: 40,
            height: 40,
          ),
          const Padding(padding: EdgeInsets.only(left: 5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  phoneNo.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              String bankInformationString =
                  '${fullName.trim()}\n${phoneNo.trim()}';

              await FlutterClipboard.copy(bankInformationString).then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).hintColor,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255, 0.5)',
                  webPosition: 'center',
                ),
              );
            },
            child: const Icon(
              Icons.copy_outlined,
              color: DefaultTheme.GREY_TOP_TAB_BAR,
              size: 20,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          _buildRoleWidget(role),
          const Padding(padding: EdgeInsets.only(left: 5)),
          (role != Stringify.ROLE_CARD_MEMBER_ADMIN &&
                  phoneNo != UserInformationHelper.instance.getPhoneNo())
              ? InkWell(
                  onTap: () {
                    memberManageBloc.add(MemberManageEventRemove(
                        bankId: bankId, userId: userId));
                  },
                  child: const SizedBox(
                    width: 20,
                    height: 20,
                    child: Icon(
                      Icons.remove_circle_outlined,
                      color: DefaultTheme.RED_TEXT,
                    ),
                  ),
                )
              : const SizedBox(
                  width: 20,
                  height: 20,
                ),
          const Padding(padding: EdgeInsets.only(right: 15)),
        ],
      ),
    );
  }

  Widget _buildRoleWidget(String role) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: (role == Stringify.ROLE_CARD_MEMBER_ADMIN)
            ? DefaultTheme.BLUE_TEXT
            : (role == Stringify.ROLE_CARD_MEMBER_MANAGER)
                ? DefaultTheme.GREEN
                : DefaultTheme.GREY_TOP_TAB_BAR,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        (role == Stringify.ROLE_CARD_MEMBER_ADMIN)
            ? 'Admin'
            : (role == Stringify.ROLE_CARD_MEMBER_MANAGER)
                ? 'Quản lý'
                : 'Thành viên',
        style: const TextStyle(
          fontSize: 12,
          color: DefaultTheme.WHITE,
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: 500,
      padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
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

  Widget _buildDescription(String title) {
    return Container(
      width: 500,
      padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12,
          color: DefaultTheme.GREY_TEXT,
        ),
      ),
    );
  }
}
