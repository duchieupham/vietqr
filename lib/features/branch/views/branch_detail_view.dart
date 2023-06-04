import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/features/branch/events/branch_event.dart';
import 'package:vierqr/features/branch/states/branch_state.dart';
import 'package:vierqr/features/branch/widgets/add_branch_member_widget.dart';
import 'package:vierqr/features/branch/widgets/select_bank_connect_branch_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/account_bank_branch_dto.dart';
import 'package:vierqr/models/account_bank_branch_insert_dto.dart';
import 'package:vierqr/models/branch_information_dto.dart';
import 'package:vierqr/models/branch_member_delete_dto.dart';
import 'package:vierqr/models/business_member_dto.dart';
import 'package:vierqr/services/providers/business_inforamtion_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class BranchDetailView extends StatelessWidget {
  static late BranchBloc _branchBloc;
  static String branchId = '';
  static String businessId = '';
  static String businessName = '';
  static BranchInformationDTO branchInformationDTO = const BranchInformationDTO(
    id: '',
    businessId: '',
    code: '',
    name: '',
    address: '',
    isActive: false,
  );
  static final List<AccountBankBranchDTO> banks = [];
  static final List<Color> colors = [];
  static final List<BusinessMemberDTO> members = [];
  static final _formModalKey = GlobalKey<FormState>();
  const BranchDetailView({super.key});

  void initialServices(BuildContext context, String branchId) {
    colors.clear();
    members.clear();
    banks.clear();
    branchInformationDTO = const BranchInformationDTO(
      id: '',
      businessId: '',
      code: '',
      name: '',
      address: '',
      isActive: false,
    );
    _branchBloc = BlocProvider.of(context);
    _branchBloc.add(BranchEventGetDetail(id: branchId));
    _branchBloc.add(BranchEventGetBanks(id: branchId));
    _branchBloc.add(BranchEventGetMembers(id: branchId));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    branchId = arg['branchId'] ?? '';
    businessId = arg['businessId'] ?? '';
    businessName = arg['businessName'] ?? '';
    initialServices(context, branchId);
    return WillPopScope(
      onWillPop: () async {
        // Provider.of<BusinessInformationProvider>(context, listen: false)
        //     .updateUserRole(0);
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SubHeader(
              title: 'Chi nhánh',
              function: () {
                // Provider.of<BusinessInformationProvider>(context, listen: false)
                //     .updateUserRole(0);
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: BlocConsumer<BranchBloc, BranchState>(
                listener: (context, state) {
                  if (state is BranchDetailSuccessState) {
                    branchInformationDTO = state.dto;
                  }
                  if (state is BranchGetBanksSuccessState) {
                    banks.clear();
                    colors.clear();
                    if (banks.isEmpty) {
                      banks.addAll(state.list);
                      colors.addAll(state.colors);
                    }
                  }
                  if (state is BranchInsertMemberSuccessState ||
                      state is BranchDeleteMemberSuccessState) {
                    members.clear();
                    _branchBloc.add(BranchEventGetMembers(id: branchId));
                  }
                  if (state is BranchConnectBankSuccessState ||
                      state is BranchRemoveBankSuccessState) {
                    initialServices(context, branchId);
                  }
                  if (state is BranchGetMembersSuccessState) {
                    members.clear();
                    if (members.isEmpty) {
                      members.addAll(state.list);
                      Future.delayed(
                        const Duration(milliseconds: 0),
                        () {
                          //update user role
                          int userRole = 0;
                          if (members
                              .where((element) =>
                                  element.userId ==
                                  UserInformationHelper.instance.getUserId())
                              .isNotEmpty) {
                            userRole = members
                                .where((element) =>
                                    element.userId ==
                                    UserInformationHelper.instance.getUserId())
                                .first
                                .role;
                            Provider.of<BusinessInformationProvider>(context,
                                    listen: false)
                                .updateUserRole(userRole);
                          }
                        },
                      );
                    }
                  }
                },
                builder: (context, state) {
                  return ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      _buildTitle(
                        context: context,
                        title: 'Thông tin chi nhánh',
                      ),
                      BoxLayout(
                        width: width - 40,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: BoxLayout(
                          width: width,
                          child: Column(
                            children: [
                              _buildElementInformation(
                                context: context,
                                title: 'Chi nhánh',
                                description: branchInformationDTO.name,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: DividerWidget(width: width),
                              ),
                              _buildElementInformation(
                                context: context,
                                title: 'Doanh nghiệp',
                                description: businessName,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: DividerWidget(width: width),
                              ),
                              _buildElementInformation(
                                context: context,
                                title: 'Code',
                                description: branchInformationDTO.code,
                                isCopy: true,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: DividerWidget(width: width),
                              ),
                              _buildElementInformation(
                                context: context,
                                title: 'Địa chỉ',
                                description: branchInformationDTO.address,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      _buildTitle(
                        context: context,
                        title: 'Tài khoản ngân hàng',
                      ),
                      (banks.isEmpty)
                          ? BoxLayout(
                              width: width,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/ic-card.png',
                                    width: width * 0.4,
                                  ),
                                  const Text(
                                    'Chưa có tài khoản ngân hàng được kết nối.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 10)),
                                  Consumer<BusinessInformationProvider>(
                                    builder: (context, provider, child) {
                                      return (provider.userRole == 5)
                                          ? ButtonIconWidget(
                                              width: width,
                                              icon: Icons.add_rounded,
                                              title:
                                                  'Kết nối TK ngân hàng với doanh nghiệp',
                                              function: () {
                                                DialogWidget.instance
                                                    .showModalBottomContent(
                                                  widget:
                                                      SelectBankConnectBranchWidget(
                                                    branchBloc: _branchBloc,
                                                    branchId: branchId,
                                                    businessId: businessId,
                                                  ),
                                                  height: height * 0.5,
                                                );
                                              },
                                              bgColor: DefaultTheme.GREEN,
                                              textColor: DefaultTheme.WHITE,
                                            )
                                          : const SizedBox();
                                    },
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 10)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: banks.length,
                              itemBuilder: (context, index) {
                                final int userRole =
                                    Provider.of<BusinessInformationProvider>(
                                            context,
                                            listen: false)
                                        .userRole;
                                return _buildElementBank(
                                  context: context,
                                  dto: banks[index],
                                  color: colors[index],
                                  userRole: userRole,
                                );
                              },
                            ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      _buildTitle(
                        context: context,
                        title: 'Danh sách thành viên',
                        label: (members.isEmpty)
                            ? null
                            : '${members.length} thành viên',
                        color: DefaultTheme.BLUE_TEXT,
                        icon: Icons.people_alt_rounded,
                      ),
                      (members.isEmpty)
                          ? BoxLayout(
                              width: width,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(top: 30)),
                                  Icon(
                                    Icons.people_outline_rounded,
                                    size: width * 0.2,
                                    color: DefaultTheme.BLUE_TEXT,
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 30)),
                                  const Text(
                                    'Chưa có tài khoản ngân hàng được kết nối.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 10)),
                                  Consumer<BusinessInformationProvider>(
                                    builder: (context, provider, child) {
                                      return (provider.userRole == 5)
                                          ? ButtonIconWidget(
                                              width: width,
                                              icon: Icons.add_rounded,
                                              title: 'Thêm thành viên',
                                              function: () async {
                                                await DialogWidget.instance
                                                    .showModalBottomContent(
                                                  widget: Form(
                                                    key: _formModalKey,
                                                    child:
                                                        AddBranchMemberWidget(
                                                      branchBloc: _branchBloc,
                                                      branchId: branchId,
                                                      businessId: businessId,
                                                    ),
                                                  ),
                                                  height: height * 0.4,
                                                );
                                              },
                                              bgColor: DefaultTheme.GREEN,
                                              textColor: DefaultTheme.WHITE,
                                            )
                                          : const SizedBox();
                                    },
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 10)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: members.length,
                              itemBuilder: (context, index) {
                                final int userRole =
                                    Provider.of<BusinessInformationProvider>(
                                            context,
                                            listen: false)
                                        .userRole;
                                return _buildElementMember(
                                    context: context,
                                    dto: members[index],
                                    userRole: userRole);
                              },
                            ),
                      const Padding(padding: EdgeInsets.only(bottom: 50)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Consumer<BusinessInformationProvider>(
          builder: (context, provider, child) {
            return (provider.userRole != 4 && provider.userRole != 0)
                ? InkWell(
                    onTap: () async {
                      await DialogWidget.instance.showModalBottomContent(
                        widget: Form(
                          key: _formModalKey,
                          child: AddBranchMemberWidget(
                            branchBloc: _branchBloc,
                            branchId: branchId,
                            businessId: businessId,
                          ),
                        ),
                        height: height * 0.4,
                      );
                    },
                    child: const BoxLayout(
                      width: 40,
                      height: 40,
                      borderRadius: 20,
                      enableShadow: true,
                      padding: EdgeInsets.all(0),
                      child: Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 15,
                        color: DefaultTheme.BLUE_TEXT,
                      ),
                    ),
                  )
                : const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildElementMember(
      {required BuildContext context,
      required BusinessMemberDTO dto,
      required int userRole}) {
    final double width = MediaQuery.of(context).size.width;

    final bool isDelete = (userRole != 4 && userRole != 0) ? true : false;
    return BoxLayout(
      width: width,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          (dto.imgId.isNotEmpty)
              ? Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: ImageUtils.instance.getImageNetWork(dto.imgId),
                    ),
                  ),
                )
              : ClipOval(
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: Image.asset('assets/images/ic-avatar.png'),
                  ),
                ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dto.name.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
                Text(
                  dto.phoneNo,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              getRoleName(dto.role),
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          if (isDelete) ...[
            const Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            InkWell(
              onTap: () {
                BranchMemberDeleteDTO branchMemberDeleteDTO =
                    BranchMemberDeleteDTO(
                  userId: dto.userId,
                  businessId: businessId,
                );
                _branchBloc.add(BranchEventRemove(dto: branchMemberDeleteDTO));
              },
              child: BoxLayout(
                width: 30,
                height: 30,
                borderRadius: 15,
                bgColor: Theme.of(context).canvasColor,
                padding: const EdgeInsets.all(0),
                child: const Icon(
                  Icons.remove_circle_outline_rounded,
                  color: DefaultTheme.RED_TEXT,
                  size: 12,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildElementBank(
      {required BuildContext context,
      required AccountBankBranchDTO dto,
      required Color color,
      required int userRole}) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDelete = (userRole != 4 && userRole != 0) ? true : false;
    return BoxLayout(
      width: width,
      padding: (isDelete)
          ? const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20)
          : const EdgeInsets.only(left: 20, right: 20, top: 20),
      margin: const EdgeInsets.only(bottom: 10),
      bgColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                    color: DefaultTheme.WHITE,
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: ImageUtils.instance.getImageNetWork(dto.imgId),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${dto.bankCode} - ${dto.bankAccount}',
                        style: const TextStyle(
                          color: DefaultTheme.WHITE,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        dto.bankName,
                        style: const TextStyle(
                          color: DefaultTheme.WHITE,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 15)),
          Text(
            dto.userBankName.toUpperCase(),
            style: const TextStyle(
              color: DefaultTheme.WHITE,
              fontSize: 15,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 3)),
          Text(
            'Trạng thái: ${(dto.authenticated) ? 'Đã liên kết' : 'Chưa liên kết'}',
            style: const TextStyle(
              color: DefaultTheme.WHITE,
              fontSize: 12,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          if (!isDelete) ...[
            DividerWidget(width: width),
            ButtonIconWidget(
              width: width,
              height: 40,
              icon: Icons.info_rounded,
              title: 'Chi tiết',
              textSize: 15,
              function: () {
                Navigator.pushNamed(
                  context,
                  Routes.BANK_CARD_DETAIL_VEW,
                  arguments: {
                    'bankId': dto.bankId,
                  },
                );
              },
              bgColor: DefaultTheme.TRANSPARENT,
              textColor: DefaultTheme.WHITE,
            ),
          ],
          if (isDelete) ...[
            SizedBox(
              width: width,
              child: Row(
                children: [
                  ButtonIconWidget(
                    width: width / 2 - 35,
                    height: 30,
                    icon: Icons.info_rounded,
                    title: 'Chi tiết',
                    textSize: 12,
                    function: () {
                      Navigator.pushNamed(
                        context,
                        Routes.BANK_CARD_DETAIL_VEW,
                        arguments: {
                          'bankId': dto.bankId,
                        },
                      );
                    },
                    bgColor: Theme.of(context).cardColor.withOpacity(0.3),
                    textColor: DefaultTheme.WHITE,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  ButtonIconWidget(
                    width: width / 2 - 35,
                    height: 30,
                    textSize: 12,
                    icon: Icons.remove_circle_outline_rounded,
                    title: 'Huỷ kết nối',
                    function: () {
                      String userId =
                          UserInformationHelper.instance.getUserId();
                      AccountBankBranchInsertDTO accountBankBranchInsertDTO =
                          AccountBankBranchInsertDTO(
                        userId: userId,
                        bankId: dto.bankId,
                        businessId: businessId,
                        branchId: branchId,
                      );
                      _branchBloc.add(BranchEventRemoveBank(
                          dto: accountBankBranchInsertDTO));
                    },
                    bgColor: Theme.of(context).cardColor.withOpacity(0.3),
                    textColor: DefaultTheme.WHITE,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildElementInformation({
    required BuildContext context,
    required String title,
    required String description,
    bool? isCopy,
    bool? isDescriptionBold,
    Color? descriptionColor,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontWeight: (isDescriptionBold != null && isDescriptionBold)
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: (descriptionColor != null)
                    ? descriptionColor
                    : Theme.of(context).hintColor,
              ),
            ),
          ),
          if (isCopy != null && isCopy)
            InkWell(
              onTap: () async {
                await FlutterClipboard.copy(description).then(
                  (value) => Fluttertoast.showToast(
                    msg: 'Đã sao chép',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).hintColor,
                    fontSize: 15,
                    webBgColor: 'rgba(255, 255, 255)',
                    webPosition: 'center',
                  ),
                );
              },
              child: const Icon(
                Icons.copy_rounded,
                color: DefaultTheme.GREY_TEXT,
                size: 15,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTitle({
    required BuildContext context,
    required String title,
    String? label,
    IconData? icon,
    Color? color,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: width,
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (label != null) ...[
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: color!.withOpacity(0.2),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: color,
                      size: 15,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String getRoleName(int role) {
    String result = '';
    if (role == 5) {
      result = 'Admin';
    } else if (role == 1) {
      result = 'Quản lý';
    } else if (role == 3) {
      result = 'Quản lý chi nhánh';
    } else {
      result = 'Thành viên';
    }
    return result;
  }
}
