import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/branch/widgets/add_branch_member_widget.dart';
import 'package:vierqr/features/branch/widgets/select_bank_connect_branch_widget.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/business_item_dto.dart';
import 'package:vierqr/models/related_transaction_receive_dto.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/shortcut_provider.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'blocs/dashboard_bloc.dart';
import 'widgets/select_branch_widget.dart';

class DashboardScreen extends StatefulWidget {
  final AsyncCallback? voidCallback;

  const DashboardScreen({
    Key? key,
    this.voidCallback,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin {
  late DashboardBloc _dashboardBloc;

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
    _dashboardBloc = BlocProvider.of(context);
  }

  Future<void> _refresh() async {
    _dashboardBloc.add(DashboardInitEvent(isLoading: true));
  }

  @override
  void initState() {
    super.initState();
    initialServices(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dashboardBloc.add(DashboardInitEvent(isLoading: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSuggestion(context),
              _buildShortcut(context),
              _buildBusinessWidget(context),
              const Padding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessWidget(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BlocConsumer<DashboardBloc, DashboardState>(
      bloc: context.read<DashboardBloc>(),
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == BlocStatus.LOADING) {
          return SizedBox(
            width: width,
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColor.BLUE_TEXT,
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Doanh nghiệp',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: List.generate(state.list.length, (index) {
                  return _buildBusinessItem(
                    context: context,
                    dto: state.list[index],
                  );
                }).toList(),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildBusinessItem(
      {required BuildContext context, required BusinessItemDTO dto}) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    String heroId = dto.businessId;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.BUSINESS_INFORMATION_VIEW,
          arguments: {
            'heroId': heroId,
            'img': dto.coverImgId,
            'businessItem': dto,
          },
        ).then((value) {
          heroId = value.toString();
          _dashboardBloc.add(DashboardInitEvent());
        });
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColor.BLACK_LIGHT.withOpacity(0.1),
              blurRadius: 1,
            ),
          ],
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: (dto.imgId.isNotEmpty)
                          ? ImageUtils.instance.getImageNetWork(dto.imgId)
                          : Image.asset(
                              'assets/images/ic-avatar-business.png',
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
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
                    ),
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 10,
                    color: Theme.of(context).hintColor,
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChip(
                    context: context,
                    icon: Icons.business_rounded,
                    color: AppColor.GREY_TEXT,
                    text: '${dto.totalBranch} chi nhánh',
                  ),
                  const SizedBox(height: 4),
                  _buildChip(
                    context: context,
                    icon: Icons.people_rounded,
                    text: '${dto.totalMember} thành viên',
                    color: AppColor.GREY_TEXT,
                  ),
                ],
              ),
            ),
            if (dto.role == TypeRole.ADMIN.role) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final data =
                            await DialogWidget.instance.showModelBottomSheet(
                          context: context,
                          padding: EdgeInsets.zero,
                          widget: SelectBranchWidget(
                            businessId: dto.businessId,
                          ),
                          height: height * 0.5,
                        );

                        if (!mounted) return;
                        if (data != null && data is String) {
                          final result = await DialogWidget.instance
                              .showModalBottomContent(
                            context: context,
                            widget: SelectBankConnectBranchWidget(
                              branchId: data,
                              businessId: dto.businessId,
                            ),
                            height: height * 0.7,
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Kết nối TK ngân hàng',
                          style: TextStyle(
                            color: AppColor.GREEN,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
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
                          final result =
                              await DialogWidget.instance.showModelBottomSheet(
                            context: context,
                            widget: AddBranchMemberWidget(
                              branchId: data,
                              businessId: dto.businessId,
                            ),
                            height: height * 0.5,
                          );

                          _dashboardBloc
                              .add(DashboardInitEvent(isLoading: true));
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Thêm thành viên',
                          style: TextStyle(
                            color: AppColor.BLUE_TEXT,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required BuildContext context,
    required RelatedTransactionReceiveDTO dto,
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
            'businessInformationBloc': _dashboardBloc,
            'userId': userId
          },
        );
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: Icon(
                TransactionUtils.instance
                    .getIconStatus(dto.status, dto.transType),
                color: TransactionUtils.instance
                    .getColorStatus(dto.status, dto.type, dto.transType),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${TransactionUtils.instance.getTransType(dto.transType)} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: TransactionUtils.instance
                          .getColorStatus(dto.status, dto.type, dto.transType),
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

  Widget _buildChip({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget _buildSuggestion(BuildContext context) {
    return Consumer<SuggestionWidgetProvider>(
      builder: (context, provider, child) {
        return (provider.getSuggestion())
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTitle(
                    'Gợi ý',
                    AppColor.ORANGE,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  (provider.showCameraPermission)
                      ? _buildSuggestionBox(
                          context: context,
                          status: 'Quyền truy cập camera bị từ chối',
                          text:
                              'Cho phép truy cập quyền máy ảnh để thực hiện các chức năng quét mã QR/Barcode',
                          icon: Icons.camera_alt_rounded,
                          buttonIcon: Icons.settings_rounded,
                          color: AppColor.BLUE_TEXT,
                          function: () async {
                            await openAppSettings();
                          },
                        )
                      : const SizedBox(),
                  (provider.showUserUpdate)
                      ? _buildSuggestionBox(
                          context: context,
                          status: 'Thông tin cá nhân chưa được cập nhật',
                          text: 'Cập nhật thông tin cá nhân',
                          icon: Icons.person,
                          buttonIcon: Icons.navigate_next_rounded,
                          color: AppColor.RED_CALENDAR,
                          function: () async {
                            final data = await Navigator.of(context)
                                .pushNamed(Routes.USER_EDIT);
                          },
                        )
                      : const SizedBox(),
                ],
              )
            : const SizedBox();
      },
    );
  }

  Widget _buildShortcut(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<ShortcutProvider>(
      builder: (context, provider, child) {
        return (provider.enableShortcut)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTitle(
                          'Tiện ích',
                          AppColor.BLUE_TEXT,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            provider.updateExpanded(!provider.expanded);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20, top: 20),
                            child: Icon(
                              (provider.expanded)
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 25,
                              color: AppColor.GREY_TEXT,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  if (provider.expanded) ...[
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShortcutIcon(
                          context: context,
                          widgetWidth: width,
                          title: 'Tạo doanh nghiệp',
                          description: 'Quản lý doanh nghiệp trên hệ thống',
                          icon: Icons.business_rounded,
                          color: AppColor.GREEN,
                          function: () {
                            Navigator.pushNamed(
                                context, Routes.ADD_BUSINESS_VIEW);
                          },
                        ),
                        _buildShortcutIcon(
                          context: context,
                          widgetWidth: width,
                          title: 'Tài khoản ngân hàng',
                          description: 'Thêm và Liên kết tài khoản ngân hàng',
                          icon: Icons.credit_card_rounded,
                          color: AppColor.PURPLE_NEON,
                          function: () {
                            Navigator.pushNamed(context, Routes.ADD_BANK_CARD)
                                .then(
                              (value) {
                                Provider.of<BankAccountProvider>(context,
                                        listen: false)
                                    .reset();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ],
              )
            : const SizedBox();
      },
    );
  }

  Widget _buildShortcutIcon({
    required BuildContext context,
    required double widgetWidth,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback function,
    required String description,
  }) {
    return InkWell(
      onTap: function,
      child: BoxLayout(
        width: widgetWidth * 0.45,
        height: 80,
        padding: const EdgeInsets.all(10),
        bgColor: Theme.of(context).cardColor,
        borderRadius: 5,
        enableShadow: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: widgetWidth * 0.05,
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.GREY_TEXT,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 20,
              color: color,
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionBox({
    required BuildContext context,
    required String status,
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback function,
    IconData? buttonIcon,
  }) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: function,
      child: BoxLayout(
        width: width,
        borderRadius: 10,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        bgColor: color.withOpacity(0.2),
        enableShadow: true,
        child: Row(
          children: [
            Icon(
              icon,
              size: 25,
              color: color,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 13,
                      color: color,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    text,
                  ),
                ],
              ),
            ),
            (buttonIcon != null)
                ? Container(
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      buttonIcon,
                      size: 15,
                      color: AppColor.GREY_TEXT,
                    ),
                  )
                : const SizedBox(
                    width: 25,
                    height: 25,
                  ),
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

  @override
  bool get wantKeepAlive => true;
}
