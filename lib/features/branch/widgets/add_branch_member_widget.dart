import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/features/branch/events/branch_event.dart';
import 'package:vierqr/features/branch/states/branch_state.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/branch_member_insert_dto.dart';
import 'package:vierqr/models/business_member_dto.dart';
import 'package:vierqr/services/providers/search_clear_provider.dart';

class AddBranchMemberWidget extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final String branchId;
  final String businessId;
  final SearchClearProvider searchClearProvider = SearchClearProvider(false);
  static final _formAddMemberKey = GlobalKey<FormState>();
  static String message = '';
  static BusinessMemberDTO dto = const BusinessMemberDTO(
    userId: '',
    status: '',
    existed: 0,
    imgId: '',
    name: '',
    phoneNo: '',
    role: 0,
  );

  AddBranchMemberWidget({
    super.key,
    required this.branchId,
    required this.businessId,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
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
                        color: DefaultTheme.GREEN,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(width: width),
          const Padding(padding: EdgeInsets.only(top: 30)),
          BlocBuilder<BranchBloc, BranchState>(
            builder: (context, state) {
              if (state is BranchInsertMemberLoadingState) {
                return SizedBox(
                  width: width,
                  height: 200,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: DefaultTheme.GREEN,
                    ),
                  ),
                );
              }

              if (state is BranchSeachMemberSuccessState) {
                message = '';
                dto = state.dto;
              }
              if (state is BranchSearchMemberNotFoundState) {
                message = state.message;
                dto = const BusinessMemberDTO(
                  userId: '',
                  status: '',
                  existed: 0,
                  imgId: '',
                  name: '',
                  phoneNo: '',
                  role: 0,
                );
              }
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
                  (message.trim().isNotEmpty && dto.userId.isEmpty)
                      ? BoxLayout(
                          width: width,
                          borderRadius: 5,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          bgColor: Theme.of(context).canvasColor,
                          child: Text(
                            message,
                          ),
                        )
                      : (dto.userId.isNotEmpty && message.trim().isEmpty)
                          ? _buildSearchItem(
                              context: context,
                              dto: dto,
                            )
                          : const SizedBox(),
                ],
              );
            },
          ),
          const Spacer(),
          Form(
            key: _formAddMemberKey,
            child: BorderLayout(
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
                    controller: nameController,
                    inputType: TextInputType.number,
                    autoFocus: false,
                    keyboardAction: TextInputAction.done,
                    onChange: (text) {
                      if (nameController.text.isNotEmpty) {
                        searchClearProvider.updateClearSearch(true);
                      } else {
                        searchClearProvider.updateClearSearch(false);
                      }
                      if (nameController.text.length >= 10 &&
                          nameController.text.length <= 12) {
                        context.read<BranchBloc>().add(BranchEventSearchMember(
                            phoneNo: nameController.text,
                            businessId: businessId));
                      } else {
                        message = '';
                        dto = const BusinessMemberDTO(
                          userId: '',
                          status: '',
                          existed: 0,
                          imgId: '',
                          name: '',
                          phoneNo: '',
                          role: 0,
                        );
                        context.read<BranchBloc>().add(BranchEventInitial());
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
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  Widget _buildSearchItem(
      {required BuildContext context, required BusinessMemberDTO dto}) {
    final double width = MediaQuery.of(context).size.width;
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
                Text(dto.name.trim()),
                Text(dto.phoneNo),
              ],
            ),
          ),
          (dto.existed == 1)
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: DefaultTheme.GREY_VIEW,
                  ),
                  child: Row(children: const [
                    Icon(
                      Icons.check_rounded,
                      color: DefaultTheme.GREEN,
                      size: 13,
                    ),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Text(
                      'Đã thêm',
                      style: TextStyle(color: DefaultTheme.GREEN),
                    )
                  ]),
                )
              : InkWell(
                  onTap: () {
                    BranchMemberInsertDTO branchMemberInsertDTO =
                        BranchMemberInsertDTO(
                      branchId: branchId,
                      businessId: businessId,
                      userId: dto.userId,
                      role: 4,
                    );
                    context.read<BranchBloc>().add(
                        BranchEventInsertMember(dto: branchMemberInsertDTO));
                    reset(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: DefaultTheme.GREEN,
                    ),
                    child: Row(children: const [
                      Icon(
                        Icons.add_rounded,
                        color: DefaultTheme.WHITE,
                        size: 13,
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Text(
                        'Thêm',
                        style: TextStyle(
                          color: DefaultTheme.WHITE,
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
    nameController.clear();
    message = '';
    dto = const BusinessMemberDTO(
      userId: '',
      status: '',
      existed: 0,
      imgId: '',
      name: '',
      phoneNo: '',
      role: 0,
    );
    searchClearProvider.updateClearSearch(false);
    // context.read<BranchBloc>().add(BranchEventInitial());
  }
}
