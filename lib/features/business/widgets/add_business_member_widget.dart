import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/business/blocs/business_member_bloc.dart';
import 'package:vierqr/features/business/events/business_member_event.dart';
import 'package:vierqr/features/business/states/business_member_state.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/business_member_dto.dart';
import 'package:vierqr/services/providers/add_business_provider.dart';
import 'package:vierqr/services/providers/search_clear_provider.dart';

class AddBusinessMemberWidget extends StatelessWidget {
  final TextEditingController memberController;

  static late BusinessMemberBloc businessMemberBloc;

  static final SearchClearProvider searchClearProvider =
      SearchClearProvider(false);

  const AddBusinessMemberWidget({
    super.key,
    required this.memberController,
  });

  void initialServices(BuildContext context) {
    businessMemberBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: width,
            height: 50,
            child: Row(
              children: [
                const SizedBox(
                  width: 80,
                  height: 50,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Thêm thành viên',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    reset(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 80,
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'Xong',
                      style: TextStyle(
                        color: AppColor.GREEN,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(width: width),
          const Padding(padding: EdgeInsets.only(top: 30)),
          BlocBuilder<BusinessMemberBloc, BusinessMemberState>(
            builder: (context, state) {
              if (state is BusinessMemberSearchState) {
                return Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Kết quả tìm kiếm',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _buildSearchItem(
                      context: context,
                      dto: state.dto,
                    ),
                  ],
                );
              }
              if (state is BusinessMemberSearchNotFoundState) {
                return Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Kết quả tìm kiếm',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    BoxLayout(
                      width: width,
                      borderRadius: 5,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      bgColor: Theme.of(context).canvasColor,
                      child: Text(
                        state.message,
                      ),
                    ),
                  ],
                );
              }
              if (state is BusinessMemberInitialState) {
                return const SizedBox();
              }
              return const SizedBox();
            },
          ),
          const Spacer(),
          BorderLayout(
            width: width,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            isError: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 15,
                  color: Theme.of(context).hintColor,
                ),
                TextFieldWidget(
                  titleWidth: 80,
                  width: width - 110,
                  isObscureText: false,
                  hintText: 'Nhập số điện thoại',
                  controller: memberController,
                  inputType: TextInputType.number,
                  autoFocus: false,
                  keyboardAction: TextInputAction.done,
                  onChange: (text) {
                    if (memberController.text.isNotEmpty) {
                      searchClearProvider.updateClearSearch(true);
                    } else {
                      searchClearProvider.updateClearSearch(false);
                    }
                    if (memberController.text.length >= 10 &&
                        memberController.text.length <= 12) {
                      businessMemberBloc.add(BusinessMemberEventSearch(
                          phone: memberController.text));
                    } else {
                      businessMemberBloc.add(BusinessMemberEventInitial());
                    }
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: searchClearProvider,
                  builder: (_, provider, child) {
                    return Visibility(
                      visible: provider == true,
                      child: InkWell(
                        onTap: () {
                          reset(context);
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

  Widget _buildSearchItem(
      {required BuildContext context, required BusinessMemberDTO dto}) {
    final double width = MediaQuery.of(context).size.width;
    final bool isExistedMember =
        Provider.of<AddBusinessProvider>(context, listen: false)
            .isExistedMember(dto.userId);
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          (dto.imgId.isNotEmpty)
              ? Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: ImageUtils.instance.getImageNetWork(dto.imgId),
                    ),
                  ),
                )
              : ClipOval(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/images/ic-avatar.png'),
                  ),
                ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dto.name),
                Text(dto.phoneNo),
              ],
            ),
          ),
          (isExistedMember)
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColor.GREY_VIEW,
                  ),
                  child: Row(children: const [
                    Icon(
                      Icons.check_rounded,
                      color: AppColor.BLUE_TEXT,
                      size: 13,
                    ),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Text(
                      'Đã thêm',
                      style: TextStyle(color: AppColor.BLUE_TEXT),
                    )
                  ]),
                )
              : InkWell(
                  onTap: () {
                    BusinessMemberDTO result = BusinessMemberDTO(
                      userId: dto.userId,
                      name: dto.name,
                      role: 1,
                      phoneNo: dto.phoneNo,
                      imgId: dto.imgId,
                      status: dto.status,
                      existed: 0,
                    );
                    Provider.of<AddBusinessProvider>(context, listen: false)
                        .addMemberList(result);
                    reset(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.GREEN,
                    ),
                    child: Row(children: const [
                      Icon(
                        Icons.add_rounded,
                        color: AppColor.WHITE,
                        size: 13,
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Text(
                        'Thêm',
                        style: TextStyle(
                          color: AppColor.WHITE,
                        ),
                      )
                    ]),
                  ),
                ),
        ],
      ),
    );
  }

  void reset(BuildContext context) {
    memberController.clear();
    searchClearProvider.updateClearSearch(false);
    businessMemberBloc.add(BusinessMemberEventInitial());
  }
}
