import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/sliver_header.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/business/events/business_information_event.dart';
import 'package:vierqr/features/business/states/business_information_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/branch_filter_insert_dto.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/business_item_dto.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';
import 'package:vierqr/services/providers/business_inforamtion_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class BusinessInformationView extends StatefulWidget {
  const BusinessInformationView({super.key});

  @override
  State<StatefulWidget> createState() => _BusinessInformationView();
}

class _BusinessInformationView extends State<BusinessInformationView>
    with TickerProviderStateMixin {
  BusinessDetailDTO businessDetailDTO = const BusinessDetailDTO(
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
  late BusinessInformationBloc _businessInformationBloc;

  String heroId = '';

  @override
  void initState() {
    super.initState();
    _businessInformationBloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  initData(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String userId = UserInformationHelper.instance.getUserId();
    String businessId = '';

    if (args.containsKey('heroId')) {
      heroId = args['heroId'];
      businessId = heroId;
    }

    _businessInformationBloc
        .add(BusinessGetDetailEvent(businessId: businessId, userId: userId));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initData(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<BusinessInformationProvider>(context, listen: false)
            .reset();
        Navigator.pop(context);
        return false;
      },
      child: BlocConsumer<BusinessInformationBloc, BusinessInformationState>(
          listener: (context, state) {
        if (state.status == BlocStatus.SUCCESS) {
          businessDetailDTO = state.dto!;
          String businessId = businessDetailDTO.id;
          String userId = UserInformationHelper.instance.getUserId();

          Future.delayed(
            const Duration(milliseconds: 0),
            () {
              //update user role
              int userRole = 0;
              if (businessDetailDTO.managers
                  .where((element) => element.userId == userId)
                  .isNotEmpty) {
                userRole = businessDetailDTO.managers
                    .where((element) => element.userId == userId)
                    .first
                    .role;
                Provider.of<BusinessInformationProvider>(context, listen: false)
                    .updateUserRole(userRole);
              }
              //update for select box transaction
              Provider.of<BusinessInformationProvider>(context, listen: false)
                  .updateInput(
                TransactionBranchInputDTO(
                    businessId: businessId, branchId: 'all', offset: 0),
              );
            },
          );

          Provider.of<BusinessInformationProvider>(context, listen: false)
              .updateBusinessId(businessId);
        }
      }, builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return NestedScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          pinned: true,
                          collapsedHeight:
                              MediaQuery.of(context).size.width * 0.25,
                          floating: false,
                          expandedHeight:
                              MediaQuery.of(context).size.width * 0.6,
                          flexibleSpace: SliverHeader(
                            minHeight: MediaQuery.of(context).size.width * 0.25,
                            maxHeight: MediaQuery.of(context).size.width * 0.6,
                            businessName: businessDetailDTO.name,
                            heroId: businessDetailDTO.id,
                            imgId: businessDetailDTO.imgId,
                            coverImgId: businessDetailDTO.coverImgId,
                          ),
                        ),
                        // Widget được pin
                      ];
                    },
                    body: ListView(
                      shrinkWrap: false,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        _buildTitle(
                          context: context,
                          title: 'Thông tin doanh nghiệp',
                          // functionName: 'Cập nhật',
                          // function: () {},
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
                                  title: 'Code',
                                  description: businessDetailDTO.code,
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
                                  description: businessDetailDTO.address,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: DividerWidget(width: width),
                                ),
                                _buildElementInformation(
                                  context: context,
                                  title: 'Mã số thuế',
                                  descriptionColor:
                                      (businessDetailDTO.taxCode.isEmpty)
                                          ? AppColor.GREY_TEXT
                                          : null,
                                  description:
                                      (businessDetailDTO.taxCode.isEmpty)
                                          ? 'Chưa cập nhật'
                                          : businessDetailDTO.taxCode,
                                  isCopy: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        _buildTitle(
                          context: context,
                          title: 'Quản trị viên',
                          label:
                              '${businessDetailDTO.managers.length} quản trị viên',
                          color: AppColor.BLUE_TEXT,
                          icon: Icons.people_alt_rounded,
                        ),
                        BoxLayout(
                          width: width - 40,
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsetsDirectional.all(0),
                            itemCount: businessDetailDTO.managers.length,
                            itemBuilder: (context, index) {
                              return _buildMemberList(
                                  context: context,
                                  index: index,
                                  dto: businessDetailDTO.managers[index]);
                            },
                            separatorBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: DividerWidget(width: width),
                              );
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        _buildTitle(
                          context: context,
                          title: 'Chi nhánh',
                          label:
                              '${businessDetailDTO.branchs.length} chi nhánh',
                          color: AppColor.BLUE_TEXT,
                          icon: Icons.business_rounded,
                        ),
                        SizedBox(
                          width: width,
                          child: ListView.builder(
                            itemCount: businessDetailDTO.branchs.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsetsDirectional.all(0),
                            itemBuilder: (context, index) {
                              return _buildBranchList(
                                context: context,
                                dto: businessDetailDTO.branchs[index],
                                index: index,
                              );
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        _buildTitle(
                          context: context,
                          title: 'Giao dịch gần đây',
                        ),
                        BoxLayout(
                          width: width - 40,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: BoxLayout(
                            width: width,
                            child: (businessDetailDTO.transactions.isEmpty)
                                ? const Center(
                                    child: Text('Không có giao dịch nào'),
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(0),
                                    itemCount:
                                        businessDetailDTO.transactions.length +
                                            1,
                                    itemBuilder: (context, index) {
                                      return (index ==
                                              businessDetailDTO
                                                  .transactions.length)
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: ButtonIconWidget(
                                                width: width,
                                                icon: Icons.more_horiz_rounded,
                                                title: 'Xem thêm',
                                                function: () {
                                                  BranchFilterInsertDTO brandDTO =
                                                      BranchFilterInsertDTO(
                                                          userId:
                                                              UserInformationHelper
                                                                  .instance
                                                                  .getUserId(),
                                                          role:
                                                              businessDetailDTO
                                                                  .userRole,
                                                          businessId:
                                                              businessDetailDTO
                                                                  .id);
                                                  Navigator.pushNamed(
                                                      context,
                                                      Routes
                                                          .BUSINESS_TRANSACTION,
                                                      arguments: {
                                                        'brandDTO': brandDTO
                                                      });
                                                },
                                                bgColor: AppColor.TRANSPARENT,
                                                textColor: AppColor.BLUE_TEXT,
                                              ),
                                            )
                                          : _buildTransactionItem(
                                              context: context,
                                              dto: businessDetailDTO
                                                  .transactions[index],
                                              businessId: businessDetailDTO.id,
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
                    ),
                  );
                },
              ),
              Positioned(
                top: 50,
                right: 10,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Provider.of<BusinessInformationProvider>(context,
                            listen: false)
                        .reset();
                    Navigator.pop(context, heroId);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColor.BLACK_BUTTON.withOpacity(0.6),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColor.WHITE,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTransactionItem({
    required BuildContext context,
    required BusinessTransactionDTO dto,
    required String businessId,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        String userId = UserInformationHelper.instance.getUserId();
        Navigator.pushNamed(
          context,
          Routes.TRANSACTION_DETAIL,
          arguments: {
            'transactionId': dto.transactionId,
            'businessInformationBlocDetail':
                context.read<BusinessInformationBloc>(),
            'userId': userId,
            'businessId': businessId,
          },
        );
      },
      child: Container(
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
                      color: AppColor.GREY_TEXT,
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
          ],
        ),
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
                color: AppColor.GREY_TEXT,
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

  Widget _buildBranchList({
    required BuildContext context,
    required BusinessBranchDTO dto,
    required int index,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return BoxLayout(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 20)),
          _buildElementInformation(
            context: context,
            title: 'Chi nhánh',
            description: dto.name,
            isDescriptionBold: true,
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
            descriptionColor: (dto.totalMember == 0)
                ? AppColor.GREY_TEXT
                : AppColor.BLUE_TEXT,
            description: (dto.totalMember == 0)
                ? 'Chưa có thành viên'
                : '${dto.totalMember} thành viên',
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
                                      color: AppColor.WHITE,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: AppColor.GREY_TOP_TAB_BAR,
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
                                      color: AppColor.GREY_TEXT,
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
                  descriptionColor: AppColor.GREY_TEXT,
                  description: 'Chưa liên kết',
                ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          DividerWidget(width: width),
          ButtonIconWidget(
            width: width,
            height: 40,
            icon: Icons.info_rounded,
            title: 'Chi tiết',
            function: () async {
              await Navigator.pushNamed(
                context,
                Routes.BRANCH_DETAIL,
                arguments: {
                  'branchId': dto.id,
                  'businessId': businessDetailDTO.id,
                  'businessName': businessDetailDTO.name,
                },
              );
              if (!mounted) return;
              initData(context);
            },
            bgColor: AppColor.TRANSPARENT,
            textColor: AppColor.BLUE_TEXT,
          ),
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

class MyPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  MyPersistentHeaderDelegate({required this.child});

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 45.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColor.TRANSPARENT,
      alignment: Alignment.center,
      child: child, // Widget được pin
    );
  }

  @override
  bool shouldRebuild(covariant MyPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
