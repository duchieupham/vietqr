import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/layouts/box_layout.dart';
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
  final TextEditingController nameController = TextEditingController();

  final SearchClearProvider searchClearProvider = SearchClearProvider(false);

  final _formAddMemberKey = GlobalKey<FormState>();

  String message = '';

  TypeAddMember _typeMember = TypeAddMember.MORE;

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
          Column(
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
              (message.trim().isNotEmpty && _dto.userId.isEmpty)
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
                  : (_dto.userId.isNotEmpty && message.trim().isEmpty)
                      ? _buildSearchItem(
                          context: context,
                          dto: _dto,
                          existed: _typeMember,
                        )
                      : const SizedBox(),
            ],
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
                        _searchMember();
                      } else {
                        message = '';
                        setState(() {
                          _dto = dtoDefault;
                          _typeMember = TypeAddMember.MORE;
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
      {required BuildContext context,
      required BusinessMemberDTO dto,
      required TypeAddMember existed}) {
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
          (existed == TypeAddMember.ADDED)
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
                      color: AppColor.GREEN,
                      size: 13,
                    ),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Text(
                      'Đã thêm',
                      style: TextStyle(color: AppColor.GREEN),
                    )
                  ]),
                )
              : (existed == TypeAddMember.AWAIT)
                  ? Container(
                      color: AppColor.TRANSPARENT,
                      margin: const EdgeInsets.only(right: 8),
                      width: 24,
                      height: 24,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.GREEN,
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        BranchMemberInsertDTO branchMemberInsertDTO =
                            BranchMemberInsertDTO(
                          branchId: widget.branchId,
                          businessId: widget.businessId,
                          userId: dto.userId,
                          role: 4,
                        );
                        _insertMember(branchMemberInsertDTO);
                        // reset(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.GREEN,
                        ),
                        child: Row(
                          children: const [
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
      _typeMember = dtoDefault.typeMember;
    });
  }

  void _insertMember(dto) async {
    try {
      setState(() {
        _typeMember = TypeAddMember.AWAIT;
      });
      final ResponseMessageDTO result =
          await branchRepository.insertMember(dto);
      if (!mounted) return;
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        setState(() {
          _typeMember = TypeAddMember.ADDED;
        });
      } else {
        ErrorUtils.instance.getErrorMessage(result.message);
      }
    } catch (e) {
      ResponseMessageDTO result =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      LOG.error(e.toString());
      ErrorUtils.instance.getErrorMessage(result.message);
    }
  }

  void _searchMember() async {
    try {
      final responseDTO = await branchRepository.searchMemberBranch(
          nameController.text.trim(), widget.businessId);
      if (!mounted) return;
      if (responseDTO.status.isNotEmpty) {
        ResponseMessageDTO result = responseDTO;
        CheckUtils.instance.getCheckMessage(result.message);
        message = result.message;
        setState(() {
          _dto = dtoDefault;
          _typeMember = dtoDefault.typeMember;
        });
      } else {
        BusinessMemberDTO result = responseDTO;
        setState(() {
          _dto = result;
        });
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
