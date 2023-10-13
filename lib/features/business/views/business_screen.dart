import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/branch/widgets/add_branch_member_widget.dart';
import 'package:vierqr/features/branch/widgets/select_bank_connect_branch_widget.dart';
import 'package:vierqr/features/business/blocs/business_bloc.dart';
import 'package:vierqr/features/business/events/business_event.dart';
import 'package:vierqr/features/business/states/business_state.dart';
import 'package:vierqr/features/business/widgets/select_branch_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/business_item_dto.dart';
import 'package:vierqr/models/related_transaction_receive_dto.dart';
import 'package:vierqr/services/providers/dashboard_provider.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BusinessBloc>(
      create: (BuildContext context) => BusinessBloc(context),
      child: _BusinessScreen(),
    );
  }
}

class _BusinessScreen extends StatefulWidget {
  @override
  State<_BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<_BusinessScreen>
    with AutomaticKeepAliveClientMixin {
  late BusinessBloc _businessBloc;
  final carouselController = CarouselController();
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

  initialServices(BuildContext context) {
    _businessBloc = BlocProvider.of(context);
  }

  Future<void> _refresh() async {
    _businessBloc.add(BusinessInitEvent(isLoading: true));
  }

  @override
  void initState() {
    super.initState();
    initialServices(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _businessBloc.add(BusinessInitEvent(isLoading: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<DashboardProvider>(
      create: (_) => DashboardProvider(),
      child: BlocConsumer<BusinessBloc, BusinessState>(
        bloc: context.read<BusinessBloc>(),
        listener: (context, state) {
          if (state.status == BlocStatus.DELETED) {
            _refresh();
          }
          if (state.status == BlocStatus.DELETED_ERROR) {
            DialogWidget.instance.openMsgDialog(
              title: 'Xoá thất bại',
              msg: 'Đã có lỗi xảy ra, bạn vui lòng thử lại sau.',
              isSecondBT: false,
            );
          }

          if (state.status == BlocStatus.SUCCESS) {
            Provider.of<DashboardProvider>(context, listen: false)
                .updateBusinessLength(state.list.length);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const MAppBar(title: 'Doanh nghiệp'),
            body: state.status == BlocStatus.LOADING
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(
                    width: width,
                    height: height,
                    child: Stack(
                      children: [
                        state.list.isNotEmpty
                            ? Positioned(
                                top: 28,
                                left: 0,
                                right: 0,
                                child: SizedBox(
                                  height: height - 28,
                                  child: ListView(
                                    children: [
                                      _buildBusinessWidget(context, state.list),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Consumer<DashboardProvider>(
                                          builder: (context, provider, child) {
                                        return _buildButtonList(context,
                                            dto: state
                                                .list[provider.businessSelect]);
                                      }),
                                      const SizedBox(
                                        height: 28,
                                      ),
                                      _buildIndicatorDot(),
                                      const SizedBox(
                                        height: 200,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 80),
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                        'Bạn chưa thuộc doanh nghiệp nào')),
                              ),
                        Positioned(
                          bottom: 20,
                          right: 0,
                          left: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonWidget(
                                width: 170,
                                height: 40,
                                text: 'Tạo doanh nghiệp',
                                textColor: AppColor.WHITE,
                                bgColor: AppColor.BLUE_TEXT,
                                borderRadius: 20,
                                enableShadow: true,
                                function: () async {
                                  await Navigator.pushNamed(
                                      context, Routes.ADD_BUSINESS_VIEW);
                                  _refresh();
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildIndicatorDot() {
    return Consumer<DashboardProvider>(builder: (context, provider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(provider.businessLength, (index) {
          return Container(
            height: 10,
            width: 10,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: index == provider.businessSelect
                  ? AppColor.BLUE_TEXT
                  : AppColor.GREY_BG,
              border: Border.all(width: 1, color: AppColor.BLUE_TEXT),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildBusinessWidget(
      BuildContext context, List<BusinessItemDTO> listBusinessItemDTO) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CarouselSlider(
          carouselController: carouselController,
          items: List.generate(listBusinessItemDTO.length, (index) {
            return _buildBusinessItem(
              context: context,
              dto: listBusinessItemDTO[index],
            );
          }).toList(),
          options: CarouselOptions(
            viewportFraction: 1,
            aspectRatio: 0.8,
            disableCenter: true,
            onPageChanged: ((index, reason) {
              Provider.of<DashboardProvider>(context, listen: false)
                  .updateBusinessSelect(index);
            }),
          )),
    );
  }

  Widget _buildBusinessItem(
      {required BuildContext context, required BusinessItemDTO dto}) {
    final double width = MediaQuery.of(context).size.width;
    String heroId = dto.businessId;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.BUSINESS_INFORMATION_VIEW,
          arguments: {'heroId': heroId},
        ).then((value) {
          heroId = value.toString();
          _businessBloc.add(BusinessInitEvent());
        });
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Theme.of(context).cardColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleItemBusiness(dto),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          child: _buildChip(
                            context: context,
                            icon: Icons.people_rounded,
                            text: '${dto.totalMember} thành viên',
                            color: AppColor.GREY_TEXT,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildChip(
                            context: context,
                            icon: Icons.business_rounded,
                            color: AppColor.GREY_TEXT,
                            text: '${dto.totalBranch} chi nhánh',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (dto.address.isNotEmpty)
                      SizedBox(
                        width: width - 40,
                        child: _buildChip(
                          context: context,
                          icon: Icons.location_on_outlined,
                          color: AppColor.GREY_TEXT,
                          text: dto.address,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 14, bottom: 8),
                    child: Text(
                      'Tài khoản đã kết nối',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  (dto.bankAccounts.isEmpty)
                      ? const Padding(
                          padding: EdgeInsets.only(left: 14, bottom: 8),
                          child: Text('Chưa có tài khoản được kết nối'),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: dto.bankAccounts.length > 3
                              ? 3
                              : dto.bankAccounts.length,
                          itemBuilder: (context, index) {
                            return _buildElementMember(
                                dto: dto.bankAccounts[index]);
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 6,
                            );
                          },
                        ),
                  if (dto.bankAccounts.length > 3)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 14),
                      child: Text(
                        '${dto.bankAccounts.length - 3} ngân hàng khác',
                        style: const TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            color: AppColor.BLUE_TEXT),
                      ),
                    )
                  else
                    const SizedBox(
                      height: 20,
                    ),
                  const Padding(
                    padding: EdgeInsets.only(left: 14, bottom: 8),
                    child: Text(
                      'Giao dịch gần đây',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  (dto.transactions.isEmpty)
                      ? const Padding(
                          padding: EdgeInsets.only(left: 14, bottom: 8),
                          child: Text('Chưa có giao dịch nào'),
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
                              businessId: dto.businessId,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 8,
                            );
                          },
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildElementMember({
    required BankAccountInBusiness dto,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          (dto.imageId.isNotEmpty)
              ? Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColor.GREY_TEXT.withOpacity(0.5), width: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: ImageUtils.instance.getImageNetWork(dto.imageId),
                    ),
                  ),
                )
              : ClipOval(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset('assets/images/ic-avatar.png'),
                  ),
                ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dto.bankCode} - ${dto.bankAccount}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  dto.userBankName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonList(BuildContext context,
      {required BusinessItemDTO dto}) {
    double height = MediaQuery.of(context).size.height;
    if (dto.role == TypeRole.ADMIN.role) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: ButtonIconWidget(
                  width: 40,
                  height: 40,
                  pathIcon: 'assets/images/ic-person-blue.png',
                  title: 'Thêm thành viên',
                  textSize: 11,
                  iconSize: 25,
                  function: () async {
                    final data =
                        await DialogWidget.instance.showModelBottomSheet(
                      context: context,
                      height: height * 0.5,
                      padding: EdgeInsets.zero,
                      widget: SelectBranchWidget(
                        businessId: dto.businessId,
                        tySelect: TypeSelect.MEMBER,
                      ),
                    );

                    if (!mounted) return;
                    if (data != null && data is String) {
                      await DialogWidget.instance.showModelBottomSheet(
                        context: context,
                        widget: AddBranchMemberWidget(
                          branchId: data,
                          businessId: dto.businessId,
                        ),
                        height: height * 0.7,
                      );

                      _businessBloc.add(BusinessInitEvent(isLoading: true));
                    }
                  },
                  bgColor: Theme.of(context).cardColor,
                  textColor: AppColor.BLUE_TEXT,
                  borderRadius: 30,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ButtonIconWidget(
                  width: 40,
                  height: 40,
                  pathIcon: 'assets/images/ic-card-blue.png',
                  title: 'Kết nối TK',
                  textSize: 11,
                  iconSize: 25,
                  function: () async {
                    final data =
                        await DialogWidget.instance.showModelBottomSheet(
                      context: context,
                      height: height * 0.5,
                      padding: EdgeInsets.zero,
                      widget: SelectBranchWidget(
                        businessId: dto.businessId,
                      ),
                    );

                    if (!mounted) return;
                    if (data != null && data is String) {
                      final isCheck =
                          await DialogWidget.instance.showModalBottomContent(
                        context: context,
                        widget: SelectBankConnectBranchWidget(
                          branchId: data,
                          businessId: dto.businessId,
                        ),
                        height: height * 0.7,
                      );

                      if (isCheck) {
                        _refresh();
                        eventBus.fire(GetListBankScreen());
                      }
                    }
                  },
                  bgColor: Theme.of(context).cardColor,
                  textColor: AppColor.BLUE_TEXT,
                  borderRadius: 30,
                ),
              ),
            ),
            ButtonIconWidget(
              width: 40,
              height: 40,
              pathIcon: 'assets/images/ic-trash.png',
              title: '',
              iconSize: 30,
              function: () async {
                DialogWidget.instance.openMsgDialog(
                  title: 'Xoá doanh nghiệp',
                  msg: 'Bạn có chắc chắn muốn xoá doanh nghiệp này?',
                  isSecondBT: true,
                  functionConfirm: () {
                    Navigator.of(context).pop();
                    _businessBloc.add(BusinessRemoveBusinessEvent(
                        businessId: dto.businessId));
                  },
                );
              },
              bgColor: Theme.of(context).cardColor,
              textColor: AppColor.RED_TEXT,
              borderRadius: 30,
            ),
            const SizedBox(
              width: 6,
            )
          ],
        ),
      );
    }
    return const SizedBox(
      height: 40,
    );
  }

  Widget _buildTitleItemBusiness(BusinessItemDTO dto) {
    return Stack(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.fromLTRB(12, 16, 0, 8),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8), topLeft: Radius.circular(8)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: (dto.coverImgId.isNotEmpty)
                  ? ImageUtils.instance.getImageNetWork(dto.coverImgId)
                  : Image.asset(
                      'assets/images/ic-avatar-business.png',
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                    ).image,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8), topLeft: Radius.circular(8)),
            gradient: LinearGradient(
                colors: [
                  AppColor.BLACK_DARK,
                  AppColor.BLACK_DARK.withOpacity(0.1),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: (dto.imgId.isNotEmpty)
                        ? ImageUtils.instance.getImageNetWork(dto.imgId)
                        : Image.asset(
                            'assets/images/ic-avatar-business.png',
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                          ).image,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  dto.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      color: AppColor.WHITE),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTransactionItem({
    required BuildContext context,
    required RelatedTransactionReceiveDTO dto,
    required String businessId,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {},
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${TransactionUtils.instance.getTransType(dto.transType)} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)} VND',
                    style: TextStyle(
                      fontSize: 12,
                      color: TransactionUtils.instance
                          .getColorStatus(dto.status, dto.type, dto.transType),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                TimeUtils.instance.formatTimeDateFromInt(dto.time),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 15,
          color: color,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
          ),
        ),
      ],
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

  @override
  bool get wantKeepAlive => true;
}
