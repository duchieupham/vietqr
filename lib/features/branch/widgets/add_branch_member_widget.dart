import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/models/branch_member_insert_dto.dart';
import 'package:vierqr/models/business_member_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/providers/search_clear_provider.dart';

class AddBranchMemberWidget extends StatefulWidget {
  final String businessId;
  final String branchId;

  const AddBranchMemberWidget({
    super.key,
    required this.businessId,
    required this.branchId,
  });

  @override
  State<AddBranchMemberWidget> createState() => _AddBranchMemberWidgetState();
}

class _AddBranchMemberWidgetState extends State<AddBranchMemberWidget> {
  final nameController = TextEditingController();

  final SearchClearProvider searchClearProvider = SearchClearProvider(false);

  final _formAddMemberKey = GlobalKey<FormState>();

  String message = '';

  static BusinessMemberDTO dtoDefault = BusinessMemberDTO(
    userId: '',
    status: '',
    existed: TypeAddMember.MORE.existed,
    imgId: '',
    name: '',
    phoneNo: '',
    role: 0,
  );

  BusinessMemberDTO _dto = BusinessMemberDTO(
    userId: '',
    status: '',
    existed: 0,
    imgId: '',
    name: '',
    phoneNo: '',
    role: 0,
  );

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
                        color: AppColor.BLUE_TEXT,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(width: width),
          const Padding(padding: EdgeInsets.only(top: 30)),
          Expanded(
            child: Column(
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
                if (message.trim().isNotEmpty && !isError)
                  Expanded(
                    child: Center(
                      child: Text(
                        message,
                      ),
                    ),
                  )
                else
                  (_dto.userId.isNotEmpty && message.trim().isEmpty)
                      ? _buildSearchItem(context: context, dto: _dto)
                      : const SizedBox(),
              ],
            ),
          ),
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
                        _searchMember();
                      } else {
                        message = '';
                        isError = false;
                        setState(() {
                          _dto = dtoDefault;
                        });
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
          if (dto.typeMember == TypeAddMember.ADDED)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.GREY_VIEW,
              ),
              child: Row(
                children: const [
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
                ],
              ),
            )
          else if (isLoading)
            Container(
              color: AppColor.TRANSPARENT,
              margin: const EdgeInsets.only(right: 8),
              width: 24,
              height: 24,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColor.BLUE_TEXT,
                ),
              ),
            )
          else
            InkWell(
              onTap: () {
                BranchMemberInsertDTO branchMemberInsertDTO =
                    BranchMemberInsertDTO(
                  branchId: widget.branchId,
                  businessId: widget.businessId,
                  userId: dto.userId,
                  role: 4,
                );
                _insertMember(branchMemberInsertDTO);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.BLUE_TEXT,
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.add_rounded,
                      color: AppColor.WHITE,
                      size: 13,
                    ),
                    Text(
                      'Thêm',
                      style: TextStyle(
                        color: AppColor.WHITE,
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void reset(BuildContext context) {
    nameController.clear();
    message = '';
    searchClearProvider.updateClearSearch(false);
    setState(() {
      _dto = dtoDefault;
    });
  }

  bool isLoading = false;
  bool isError = false;

  void _insertMember(dto) async {
    try {
      setState(() {
        _dto.setExisted(2);
        isLoading = true;
        isError = false;
        message = '';
      });
      final ResponseMessageDTO result =
          await branchRepository.insertMember(dto);
      if (!mounted) return;
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        _dto.setExisted(1);
        isLoading = false;
        setState(() {});
      } else {
        _dto.setExisted(0);
        message = ErrorUtils.instance.getErrorMessage(result.message);
        isLoading = false;
        isError = true;
        setState(() {});

        await DialogWidget.instance
            .openMsgDialog(title: 'Không thể thêm thành viên', msg: message);
      }
    } catch (e) {
      LOG.error(e.toString());
      _dto.setExisted(0);
      isLoading = false;
      isError = true;
      ResponseMessageDTO result =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      message = ErrorUtils.instance.getErrorMessage(result.message);
      setState(() {});

      await DialogWidget.instance
          .openMsgDialog(title: 'Không thể thêm thành viên', msg: message);
    }
  }

  void _searchMember() async {
    try {
      isError = false;
      message = '';
      setState(() {});
      final responseDTO = await branchRepository.searchMemberBranch(
          nameController.text.trim().replaceAll(" ", ""), widget.businessId);
      if (!mounted) return;
      if (responseDTO.status.isNotEmpty) {
        ResponseMessageDTO result = responseDTO;
        message = CheckUtils.instance.getCheckMessage(result.message);
        _dto = dtoDefault;

        setState(() {});
      } else {
        BusinessMemberDTO result = responseDTO;
        _dto = result;
        setState(() {});
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
