import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/features/branch/events/branch_event.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/business/events/business_information_event.dart';
import 'package:vierqr/features/business/states/business_information_state.dart';
import 'package:vierqr/features/transaction/blocs/transaction_bloc.dart';
import 'package:vierqr/features/transaction/events/transaction_event.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/branch_filter_insert_dto.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';
import 'package:vierqr/services/providers/business_inforamtion_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class BusinessOverView extends StatelessWidget {
  static BusinessDetailDTO dto = const BusinessDetailDTO(
    id: '',
    name: '',
    address: '',
    code: '',
    imgId: '',
    coverImgId: '',
    taxCode: '',
    userRole: 0,
    managers: [],
    branchs: [],
    transactions: [],
    active: false,
  );

  final BranchBloc branchBloc;
  final TransactionBloc transactionBloc;
  final VoidCallback onTransactionNext;
  final String businessId;
  static late BusinessInformationBloc businessInformationBloc;

  const BusinessOverView({
    super.key,
    required this.branchBloc,
    required this.transactionBloc,
    required this.onTransactionNext,
    required this.businessId,
  });

  void initialServices(BuildContext context) {
    String userId = UserInformationHelper.instance.getUserId();
    businessInformationBloc = BlocProvider.of(context);
    businessInformationBloc
        .add(BusinessGetDetailEvent(businessId: businessId, userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return BlocConsumer<BusinessInformationBloc, BusinessInformationState>(
      listener: (context, state) {
        if (state is BusinessGetDetailSuccessState) {
          dto = state.dto;
          String userId = UserInformationHelper.instance.getUserId();
          String businessId = dto.id;
          int role = dto.userRole;
          BranchFilterInsertDTO branchFilter = BranchFilterInsertDTO(
              userId: userId, role: role, businessId: businessId);
          branchBloc.add(BranchEventGetFilter(dto: branchFilter));
          transactionBloc.add(
            TransactionEventGetListBranch(
              dto: TransactionBranchInputDTO(
                  businessId: businessId, branchId: 'all', offset: 0),
            ),
          );
          Future.delayed(const Duration(milliseconds: 0), () {
            Provider.of<BusinessInformationProvider>(context, listen: false)
                .updateInput(
              TransactionBranchInputDTO(
                  businessId: businessId, branchId: 'all', offset: 0),
            );
          });
        }
      },
      builder: (context, state) {
        return ListView(
          shrinkWrap: false,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const Padding(padding: EdgeInsets.only(top: 30)),
            _buildTitle(
              context: context,
              title: 'Thông tin doanh nghiệp',
              functionName: 'Cập nhật',
              function: () {},
            ),
            BoxLayout(
              width: width - 40,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: BoxLayout(
                width: width,
                child: Column(
                  children: [
                    _buildElementInformation(
                      context: context,
                      title: 'Code',
                      description: dto.code,
                      isCopy: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: DividerWidget(width: width),
                    ),
                    _buildElementInformation(
                      context: context,
                      title: 'Địa chỉ',
                      description: dto.address,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: DividerWidget(width: width),
                    ),
                    _buildElementInformation(
                      context: context,
                      title: 'Mã số thuế',
                      description:
                          (dto.taxCode.isEmpty) ? 'Chưa cập nhật' : dto.taxCode,
                      isCopy: true,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            InkWell(
              onTap: () {},
              child: Container(
                height: 40,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Cập nhật ảnh bìa',
                  style: TextStyle(
                    fontSize: 15,
                    color: DefaultTheme.GREEN,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: 40,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Cập nhật ảnh đại diện',
                  style: TextStyle(
                    fontSize: 15,
                    color: DefaultTheme.GREEN,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            _buildTitle(
              context: context,
              title: 'Quản trị viên',
              label: '${dto.managers.length} thành viên',
              color: DefaultTheme.BLUE_TEXT,
              icon: Icons.people_alt_rounded,
              function: () {},
              functionName: 'Cập nhật',
            ),
            BoxLayout(
              width: width - 40,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsetsDirectional.all(0),
                itemCount: dto.managers.length,
                itemBuilder: (context, index) {
                  return _buildMemberList(
                      context: context, index: index, dto: dto.managers[index]);
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: DividerWidget(width: width),
                  );
                },
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            InkWell(
              onTap: () {},
              child: Container(
                height: 40,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Thêm mới',
                  style: TextStyle(
                    fontSize: 15,
                    color: DefaultTheme.GREEN,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            _buildTitle(
              context: context,
              title: 'Chi nhánh',
              label: '${dto.branchs.length} chi nhánh',
              color: DefaultTheme.GREEN,
              icon: Icons.business_rounded,
              // function: () {},
              // functionName: 'Cập nhật',
            ),
            BoxLayout(
              width: width - 40,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: BoxLayout(
                  width: width,
                  child: ListView.separated(
                    itemCount: dto.branchs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsetsDirectional.all(0),
                    itemBuilder: (context, index) {
                      return _buildBranchList(
                        context: context,
                        dto: dto.branchs[index],
                        index: index,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: DividerWidget(width: width),
                      );
                    },
                  )),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            InkWell(
              onTap: () {},
              child: Container(
                height: 40,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Thêm mới',
                  style: TextStyle(
                    fontSize: 15,
                    color: DefaultTheme.GREEN,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            _buildTitle(
              context: context,
              title: 'Giao dịch gần đây',
              functionName: 'Xem thêm',
              function: onTransactionNext,
            ),
            BoxLayout(
              width: width - 40,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: BoxLayout(
                width: width,
                child: (dto.transactions.isEmpty)
                    ? const Center(
                        child: Text('Không có giao dịch nào'),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        itemCount: dto.transactions.length,
                        itemBuilder: (context, index) {
                          return _buildTransactionItem(
                            context: context,
                            dto: dto.transactions[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return DividerWidget(width: width);
                        },
                      ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 50)),
          ],
        );
      },
    );
  }

  Widget _buildTransactionItem({
    required BuildContext context,
    required BusinessTransactionDTO dto,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25,
            height: 25,
            child: Icon(
              TransactionUtils.instance
                  .getIconStatus(dto.status, dto.tranStype),
              color: TransactionUtils.instance
                  .getColorStatus(dto.status, dto.type, dto.tranStype),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${TransactionUtils.instance.getTransType(dto.tranStype)} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)}',
                  style: TextStyle(
                    fontSize: 18,
                    color: TransactionUtils.instance
                        .getColorStatus(dto.status, dto.type, dto.tranStype),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 3)),
                Text(
                  'Đến TK: ${dto.bankAccount}',
                  style: const TextStyle(),
                ),
                const Padding(padding: EdgeInsets.only(top: 3)),
                Text(
                  dto.content.trim(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: DefaultTheme.GREY_TEXT,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text(
              TimeUtils.instance.formatDateFromInt(dto.time, true),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),

          // const Padding(padding: EdgeInsets.only(left: 5)),
          // Icon(
          //   TransactionUtils.instance.getIconStatus(dto.status),
          //   size: 15,
          //   color: TransactionUtils.instance.getColorStatus(dto.status),
          // ),
        ],
      ),
    );
  }

  Widget _buildElementInformation({
    required BuildContext context,
    required String title,
    required String description,
    bool? isCopy,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(title),
          ),
          Expanded(child: Text(description)),
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
    VoidCallback? function,
    String? functionName,
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
              const Padding(padding: EdgeInsets.only(left: 5)),
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
            if (function != null) ...[
              const Spacer(),
              InkWell(
                onTap: function,
                child: Text(
                  (functionName != null) ? functionName : 'Chi tiết',
                  style: const TextStyle(
                    fontSize: 15,
                    color: DefaultTheme.GREEN,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBranchList({
    required BuildContext context,
    required BusinessBranchDTO dto,
    required int index,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          _buildElementInformation(
            context: context,
            title: 'Chi nhánh',
            description: dto.name,
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          _buildElementInformation(
            context: context,
            title: 'Code',
            description: dto.code,
            isCopy: true,
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          _buildElementInformation(
            context: context,
            title: 'Địa chỉ',
            description: dto.address,
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          _buildElementInformation(
            context: context,
            title: 'Thành viên',
            description: (dto.totalMember == 0)
                ? 'Chưa có thành viên'
                : '${dto.totalMember} thành viên',
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          _buildElementInformation(
            context: context,
            title: 'Quản lý',
            description: (dto.manager.id.isEmpty)
                ? 'Chưa có quản lý'
                : '${dto.manager.lastName} ${dto.manager.middleName} ${dto.manager.firstName}'
                    .trim(),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          (dto.banks.isNotEmpty)
              ? SizedBox(
                  width: width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text('TK đối soát'),
                      ),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          itemCount: dto.banks.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: width - 100,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: DefaultTheme.WHITE,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                                        width: 0.5,
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: ImageUtils.instance
                                            .getImageNetWork(
                                                dto.banks[index].imgId),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 5)),
                                  Text(
                                    '${dto.banks[index].bankCode} - ${dto.banks[index].bankAccount}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      await FlutterClipboard.copy(
                                              '${dto.banks[index].bankCode} - ${dto.banks[index].bankAccount}')
                                          .then(
                                        (value) => Fluttertoast.showToast(
                                          msg: 'Đã sao chép',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          textColor:
                                              Theme.of(context).hintColor,
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
                          },
                          separatorBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: DividerWidget(width: width),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : _buildElementInformation(
                  context: context,
                  title: 'TK đối soát',
                  description: 'Chưa liên kết',
                ),
          const Padding(padding: EdgeInsets.only(top: 10)),

          //   description: (dto.bankAccount.id.isEmpty)
          //       ? 'Chưa liên kết'
          //       : '${dto.bankAccount.bankCode} - ${dto.bankAccount.bankAccount}',
          //   isCopy: (dto.bankAccount.id.isEmpty) ? false : true,
          // ),
        ],
      ),
    );
  }

  Widget _buildMemberList(
      {required BuildContext context,
      required BusinessManagerDTO dto,
      required int index}) {
    final double width = MediaQuery.of(context).size.width;
    final bool isAdmin = (dto.role == 0);
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          (dto.imgId.isNotEmpty)
              ? Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
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
                  '${dto.lastName} ${dto.middleName} ${dto.firstName}'.trim(),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  dto.phoneNo,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(5),
            //   color: (isAdmin) ? DefaultTheme.BLUE_TEXT : DefaultTheme.ORANGE,
            // ),
            child: Text(
              (isAdmin) ? 'Admin' : 'Quản lý',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5),
          ),
        ],
      ),
    );
  }
}
