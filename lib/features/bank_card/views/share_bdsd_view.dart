import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_provider.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/branch_member_insert_dto.dart';
import 'package:vierqr/models/business_member_dto.dart';
import 'package:vierqr/models/member_branch_model.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/providers/search_clear_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class ShareBDSDView extends StatefulWidget {
  @override
  State<ShareBDSDView> createState() => _ShareBDSDViewState();
}

class _ShareBDSDViewState extends State<ShareBDSDView> {
  int step = 0;
  BankAccountDTO _dto = BankAccountDTO.fromJson({});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppbar(context),
        Expanded(child: _buildStep()),
      ],
    );
  }

  Widget _buildStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColor.BLUE_TEXT,
                          ),
                          child: Text(
                            '1',
                            style: TextStyle(color: AppColor.WHITE),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: step == 1 ? AppColor.BLUE_TEXT : Colors.grey,
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Chọn TK đã kết nối\ndoanh nghiệp',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: step == 1 ? AppColor.BLUE_TEXT : Colors.grey,
                            height: 2,
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: step == 1
                                ? AppColor.BLUE_TEXT
                                : AppColor.greyF0F0F0,
                          ),
                          child: Text(
                            '2',
                            style: TextStyle(
                                color: step == 1
                                    ? AppColor.WHITE
                                    : AppColor.grey979797),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Thêm thành viên',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: step == 1
                              ? AppColor.textBlack
                              : AppColor.grey979797,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Expanded(
          child: step == 0
              ? _BuildStepFirst(
                  onTap: (value) {
                    _dto = value;
                    step = 1;
                    setState(() {});
                  },
                )
              : _BuildStepSecond(
                  dto: _dto,
                  onBack: () {
                    setState(() {
                      step = 0;
                    });
                  },
                ),
        )
      ],
    );
  }

  Widget _buildAppbar(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.clear, color: AppColor.TRANSPARENT),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Chia sẻ BĐSD',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.clear),
          ),
        ],
      ),
    );
  }
}

class _BuildStepFirst extends StatelessWidget {
  final Function(BankAccountDTO) onTap;

  const _BuildStepFirst({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Danh sách Tk khả dụng',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Consumer<DashBoardProvider>(
                builder: (context, provider, child) {
                  return Stack(
                    children: provider.listBanks.map(
                      (item) {
                        int index = provider.listBanks.indexOf(item);
                        return Padding(
                          padding: EdgeInsets.only(top: index * 97),
                          child: _buildCardItem(
                            context: context,
                            index: index,
                            maxLengthList: provider.listBanks.length,
                            dto: item,
                            onTap: onTap,
                          ),
                        );
                      },
                    ).toList(),
                  );
                },
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Text(
            'Nếu bạn chưa có tài khoản khả dụng nào,\n hãy kết nối TK ngân hàng với tổ chức doanh nghiệp',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        MButtonWidget(
          title: '',
          padding: const EdgeInsets.symmetric(horizontal: 12),
          isEnable: true,
          onTap: () async {
            Navigator.pushNamed(context, Routes.BUSINESS);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/ic-next-user.png', width: 32),
              Expanded(
                child: Center(
                  child: Text(
                    'Kết nối doanh nghiệp',
                    style: TextStyle(color: AppColor.WHITE),
                  ),
                ),
              ),
              Image.asset(
                'assets/images/ic-next-user.png',
                color: AppColor.WHITE,
                width: 32,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildCardItem(
      {required BuildContext context,
      required int index,
      required BankAccountDTO dto,
      int maxLengthList = 0,
      required Function(BankAccountDTO) onTap}) {
    String userId = UserInformationHelper.instance.getUserId();
    final double width = MediaQuery.of(context).size.width;
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    });

    return (dto.id.isNotEmpty)
        ? GestureDetector(
            onTap: () async {
              onTap(dto);
            },
            child: Container(
              width: width,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColor.WHITE, width: 14),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: dto.bankColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: _buildTitleCard(dto, userId),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget _buildTitleCard(BankAccountDTO dto, String userId) {
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      height: 35,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    image: ImageUtils.instance.getImageNetWork(
                      dto.imgId,
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${dto.bankCode} - ${dto.bankAccount}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColor.WHITE,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    dto.userBankName.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColor.WHITE, fontSize: 10, height: 1.4),
                  ),
                ],
              ),
              if (dto.isAuthenticated)
                Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    color: dto.userId == userId
                        ? AppColor.BLUE_TEXT
                        : AppColor.ORANGE,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColor.WHITE,
                    size: 8,
                  ),
                )
            ],
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(top: 10, right: 6),
            child: Icon(
              Icons.arrow_forward_ios,
              color: AppColor.WHITE,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildStepSecond extends StatefulWidget {
  final BankAccountDTO dto;
  final Function() onBack;

  const _BuildStepSecond({required this.dto, required this.onBack});

  @override
  State<_BuildStepSecond> createState() => _BuildStepSecondState();
}

class _BuildStepSecondState extends State<_BuildStepSecond> {
  final nameController = TextEditingController();

  final searchClearProvider = SearchClearProvider(false);

  String message = '';

  bool isLoading = false;
  bool isError = false;

  int typeSearch = 0;

  Timer? _debounce;

  final dtoDefault = BusinessMemberDTO(
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

  List<MemberBranchModel> listMember = [];

  void _searchMember() async {
    try {
      isError = false;
      String data = nameController.text;
      message = '';
      setState(() {});

      if (typeSearch == 1) {
        data = nameController.text.trim().replaceAll(' ', '-');
      }
      final responseDTO = await branchRepository.searchMemberBranch(
          data.trim().replaceAll(" ", ""), widget.dto.businessId, typeSearch);
      if (!mounted) return;
      if (responseDTO is BusinessMemberDTO) {
        BusinessMemberDTO result = responseDTO;
        _dto = result;
        listMember = [];
        setState(() {});
      } else if (responseDTO is ResponseMessageDTO) {
        ResponseMessageDTO result = responseDTO;
        message = CheckUtils.instance.getCheckMessage(result.message);
        _dto = dtoDefault;
        listMember = [];

        setState(() {});
      } else if (responseDTO is List<MemberBranchModel>) {
        listMember = responseDTO;
        _dto = dtoDefault;
        setState(() {});
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void _onChange(Object value) {
    if (nameController.text.isNotEmpty) {
      searchClearProvider.updateClearSearch(true);
    } else {
      searchClearProvider.updateClearSearch(false);
    }
    if (typeSearch == 0) {
      if (nameController.text.length >= 5 && nameController.text.length <= 12) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 300), () {
          _searchMember();
        });
      } else {
        message = '';
        isError = false;
        setState(() {
          _dto = dtoDefault;
        });
      }
    } else {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        _searchMember();
      });
    }
  }

  void _insertMember(dto, {int? index}) async {
    try {
      setState(() {
        if (index != null && typeSearch == 1) {
          listMember[index].setExisted(2);
        } else {
          _dto.setExisted(2);
        }
        isLoading = true;
        isError = false;
        message = '';
      });
      final ResponseMessageDTO result =
          await branchRepository.insertMember(dto);
      if (!mounted) return;
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        if (index != null) {
          listMember[index].setExisted(1);
        } else {
          _dto.setExisted(1);
        }
        isLoading = false;
        setState(() {});
      } else {
        if (index != null && typeSearch == 1) {
          listMember[index].setExisted(0);
        } else {
          _dto.setExisted(0);
        }
        message = ErrorUtils.instance.getErrorMessage(result.message);
        isLoading = false;
        isError = true;
        setState(() {});

        await DialogWidget.instance
            .openMsgDialog(title: 'Không thể thêm thành viên', msg: message);
      }
    } catch (e) {
      LOG.error(e.toString());
      if (index != null && typeSearch == 1) {
        listMember[index].setExisted(0);
      } else {
        _dto.setExisted(0);
      }
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

  void reset(BuildContext context) {
    nameController.clear();
    message = '';
    searchClearProvider.updateClearSearch(false);
    isLoading = false;
    setState(() {
      _dto = dtoDefault;
      listMember = [];
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: MTextFieldCustom(
              isObscureText: false,
              maxLines: 1,
              controller: nameController,
              fillColor: AppColor.greyF0F0F0,
              textFieldType: TextfieldType.DEFAULT,
              hintText: 'Tìm kiếm người dùng',
              inputType: TextInputType.text,
              keyboardAction: TextInputAction.next,
              onChange: _onChange,
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Theme.of(context).hintColor,
              ),
              suffixIcon: ValueListenableBuilder(
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
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Kết quả tìm kiếm',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (message.trim().isNotEmpty && !isError)
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Center(
                      child: Text(
                        message,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            listMember.isNotEmpty
                ? Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: List.generate(listMember.length, (index) {
                          BusinessMemberDTO dto = BusinessMemberDTO(
                            userId: listMember[index].id ?? '',
                            status: '',
                            existed: listMember[index].existed ?? 0,
                            imgId: listMember[index].imgId ?? '',
                            name: listMember[index].fullName,
                            phoneNo: listMember[index].phoneNo ?? '',
                            role: 0,
                          );
                          return _buildSearchItem(
                              context: context, dto: dto, index: index);
                        }).toList(),
                      ),
                    ),
                  )
                : (_dto.userId.isNotEmpty && message.trim().isEmpty)
                    ? Expanded(
                        child: Column(
                          children: [
                            _buildSearchItem(context: context, dto: _dto),
                          ],
                        ),
                      )
                    : const Expanded(child: SizedBox()),
          MButtonWidget(
            title: 'Trở về',
            isEnable: true,
            onTap: widget.onBack,
          )
        ],
      ),
    );
  }

  Widget _buildSearchItem(
      {required BuildContext context,
      required BusinessMemberDTO dto,
      int? index}) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
          else if (isLoading && dto.existed == 2)
            Container(
              color: AppColor.TRANSPARENT,
              margin: const EdgeInsets.only(right: 8),
              width: 24,
              height: 24,
              child: const Center(
                child: CircularProgressIndicator(color: AppColor.BLUE_TEXT),
              ),
            )
          else
            InkWell(
              onTap: () {
                BranchMemberInsertDTO branchMemberInsertDTO =
                    BranchMemberInsertDTO(
                  branchId: widget.dto.branchId,
                  businessId: widget.dto.businessId,
                  userId: dto.userId,
                  role: 4,
                );
                _insertMember(branchMemberInsertDTO, index: index);
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            'Lọc theo',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              setState(() {
                typeSearch = 0;
              });
            },
            child: Container(
              width: 110,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: typeSearch == 0
                    ? AppColor.BLUE_TEXT.withOpacity(0.8)
                    : AppColor.greyF0F0F0,
              ),
              child: const Text('Số điện thoại'),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                typeSearch = 1;
              });
            },
            child: Container(
              width: 110,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: typeSearch == 1
                    ? AppColor.BLUE_TEXT.withOpacity(0.8)
                    : AppColor.greyF0F0F0,
              ),
              child: const Text('Họ tên'),
            ),
          ),
        ],
      ),
    );
  }
}
