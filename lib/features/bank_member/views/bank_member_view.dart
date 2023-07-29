import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/user_information_utils.dart';
import 'package:vierqr/commons/widgets/bank_card_widget.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/bank_member/blocs/bank_member_bloc.dart';
import 'package:vierqr/features/bank_member/events/bank_member_event.dart';
import 'package:vierqr/features/bank_member/states/bank_member_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_member_dto.dart';
import 'package:vierqr/models/bank_member_insert_dto.dart';
import 'package:vierqr/services/providers/search_clear_provider.dart';

class BankMemberView extends StatelessWidget {
  static final TextEditingController phoneController = TextEditingController();
  static final _formKey = GlobalKey<FormState>();

  static final List<BankMemberDTO> bankMembers = [];
  static late BankMemberBloc bankMemberBloc;

  static final SearchClearProvider searchClearProvider =
      SearchClearProvider(false);

  const BankMemberView({super.key});

  void initialServices(BuildContext context, String bankId) {
    if (bankMembers.isEmpty) {
      bankMemberBloc = BlocProvider.of(context);
      bankMemberBloc.add(BankMemberEventGetList(bankId: bankId));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    BankAccountDTO dto = arg['bankAccountDTO'];
    initialServices(context, dto.id);
    return Scaffold(
      body: Column(
        children: [
          SubHeader(
              title: 'Thành viên',
              function: () {
                bankMemberBloc.add(BankMemberInitialEvent());
                bankMembers.clear();
                phoneController.clear();
                Navigator.of(context).pop();
              }),
          BankCardWidget(dto: dto, width: width - 40),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const Padding(padding: EdgeInsets.only(top: 20)),
                const Text(
                  'Danh sách thành viên',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                BlocConsumer<BankMemberBloc, BankMemberState>(
                  listener: (context, state) {
                    if (state is BankMemberGetListSuccessfulState) {
                      bankMembers.clear();
                      if (state.list.isNotEmpty) {
                        bankMembers.addAll(state.list);
                      }
                    }
                    if (state is BankMemberInsertSuccessfulState ||
                        state is BankMemberRemoveSuccessfulState) {
                      phoneController.clear();
                      searchClearProvider.updateClearSearch(false);
                      bankMemberBloc
                          .add(BankMemberEventGetList(bankId: dto.id));
                    }
                    if (state is BankMemberRemoveFailedState) {
                      DialogWidget.instance.openMsgDialog(
                        title: 'Không thể xoá thành viên',
                        msg: state.message,
                      );
                    }
                  },
                  builder: (context, state) {
                    return Visibility(
                      visible: bankMembers.isNotEmpty,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bankMembers.length,
                        itemBuilder: (context, index) {
                          return _buildMemberItem(
                            context: context,
                            dto: bankMembers[index],
                            type: 0,
                            bankId: dto.id,
                            userRole: dto.type,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return DividerWidget(width: width);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          BlocBuilder<BankMemberBloc, BankMemberState>(
            builder: (context, state) {
              BankMemberDTO memberSearchDTO = const BankMemberDTO(
                  id: '',
                  userId: '',
                  firstName: '',
                  middleName: '',
                  lastName: '',
                  phoneNo: '',
                  imgId: '',
                  role: 0,
                  status: '');
              if (state is BankMemberCheckAddedBeforeState) {
                memberSearchDTO = bankMembers
                    .where((element) => element.phoneNo == phoneController.text)
                    .first;
              }
              if (state is BankMemberInitialState) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state is BankMemberCheckFailedState ||
                        state is BankMemberCheckSuccessfulState ||
                        state is BankMemberCheckNotExistedState ||
                        state is BankMemberCheckAddedBeforeState)
                      const Text(
                        'Kết quả tìm kiếm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (state is BankMemberCheckNotExistedState)
                      Container(
                        width: width,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const Text(
                              'Số điện thoại không tồn tại trong hệ thống. ',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Text(
                                'Tạo tài khoản',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.GREEN,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (state is BankMemberCheckAddedBeforeState)
                      _buildMemberItem(
                        context: context,
                        dto: memberSearchDTO,
                        type: 2,
                        bankId: dto.id,
                        userRole: dto.type,
                      ),
                    if (state is BankMemberCheckFailedState)
                      BoxLayout(
                        width: width - 40,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        borderRadius: 5,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        bgColor: AppColor.RED_CALENDAR.withOpacity(0.3),
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            color: AppColor.RED_TEXT,
                          ),
                        ),
                      ),
                    if (state is BankMemberCheckSuccessfulState)
                      _buildMemberItem(
                        context: context,
                        dto: state.dto,
                        type: 1,
                        bankId: dto.id,
                        userRole: dto.type,
                      ),
                  ],
                ),
              );
            },
          ),
          BoxLayout(
            width: width,
            borderRadius: 50,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 15,
                  color: Theme.of(context).hintColor,
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFieldWidget(
                      width: width,
                      hintText: 'Thêm thành viên bằng số điện thoại',
                      controller: phoneController,
                      keyboardAction: TextInputAction.done,
                      onChange: (value) {
                        if (phoneController.text.isNotEmpty) {
                          searchClearProvider.updateClearSearch(true);
                        } else {
                          searchClearProvider.updateClearSearch(false);
                        }
                        if (phoneController.text.length >= 10 &&
                            phoneController.text.length <= 12) {
                          BankMemberInsertDTO insertDTO = BankMemberInsertDTO(
                            bankId: dto.id,
                            userId: '',
                            phoneNo: phoneController.text,
                            role: UserInformationUtils.instance
                                .getRoleForInsert(dto.type),
                          );
                          bankMemberBloc
                              .add(BankMemberEventCheck(dto: insertDTO));
                        } else {
                          bankMemberBloc.add(BankMemberInitialEvent());
                        }
                      },
                      inputType: TextInputType.text,
                      isObscureText: false,
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: searchClearProvider,
                  builder: (_, provider, child) {
                    return Visibility(
                      visible: provider == true,
                      child: InkWell(
                        onTap: () {
                          phoneController.clear();
                          searchClearProvider.updateClearSearch(false);
                          bankMemberBloc.add(BankMemberInitialEvent());
                        },
                        child: Icon(
                          Icons.close_rounded,
                          size: 15,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  //type = 0 => item list
  //type = 1 => search result
  Widget _buildMemberItem({
    required BuildContext context,
    required String bankId,
    required BankMemberDTO dto,
    required int type,
    required int userRole,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return BoxLayout(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      bgColor: AppColor.TRANSPARENT,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: (dto.imgId != '')
                      ? ImageUtils.instance.getImageNetWork(dto.imgId)
                      : Image.asset(
                          'assets/images/ic-avatar.png',
                          width: 40,
                          height: 40,
                        ).image),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      UserInformationUtils.instance.formatFullName(
                          dto.firstName, dto.middleName, dto.lastName),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    if (type == 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: UserInformationUtils.instance
                              .getMemberRoleColor(dto.role),
                        ),
                        child: Text(
                          UserInformationUtils.instance
                              .formatMemberRole(dto.role),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColor.WHITE,
                          ),
                        ),
                      )
                  ],
                ),
                Text(
                  dto.phoneNo,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (type == 0 &&
              dto.role != Stringify.CARD_TYPE_BUSINESS &&
              userRole == Stringify.CARD_TYPE_BUSINESS)
            InkWell(
              onTap: () {
                bankMemberBloc.add(BankMemberRemoveEvent(id: dto.id));
              },
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.remove_rounded,
                  color: Theme.of(context).hintColor,
                  size: 15,
                ),
              ),
            ),
          if (type == 1)
            ButtonIconWidget(
              width: 80,
              icon: Icons.add_rounded,
              title: 'Thêm',
              function: () {
                BankMemberInsertDTO insertDTO = BankMemberInsertDTO(
                  bankId: bankId,
                  userId: dto.userId,
                  phoneNo: phoneController.text,
                  role:
                      UserInformationUtils.instance.getRoleForInsert(userRole),
                );
                bankMemberBloc.add(BankMemberEventInsert(dto: insertDTO));
              },
              bgColor: AppColor.GREEN,
              textColor: AppColor.WHITE,
            ),
          if (type == 2)
            ButtonIconWidget(
              width: 100,
              icon: Icons.check_rounded,
              title: 'Đã thêm',
              function: () {},
              bgColor: Theme.of(context).cardColor,
              textColor: AppColor.BLUE_TEXT,
            ),
        ],
      ),
    );
  }
}
