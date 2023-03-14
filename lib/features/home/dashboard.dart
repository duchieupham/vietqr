import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/business/events/business_information_event.dart';
import 'package:vierqr/features/business/states/business_information_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/business_item_dto.dart';
import 'package:vierqr/models/related_transaction_receive_dto.dart';
import 'package:vierqr/services/providers/shortcut_provider.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class DashboardView extends StatelessWidget {
  final BusinessInformationBloc businessInformationBloc;
  // static final List<TransactionReceiveDashBoardDTO> listSample = [
  //   const TransactionReceiveDashBoardDTO(
  //     amount: '100000',
  //     bankAccount: '1000006789',
  //     time: 1678356976051,
  //     status: 0,
  //   ),
  //   const TransactionReceiveDashBoardDTO(
  //     amount: '30000',
  //     bankAccount: '1000006789',
  //     time: 1678356976051,
  //     status: 1,
  //   ),
  //   const TransactionReceiveDashBoardDTO(
  //     amount: '5000000',
  //     bankAccount: '1000006789',
  //     time: 1678356976051,
  //     status: 1,
  //   ),
  //   const TransactionReceiveDashBoardDTO(
  //     amount: '2500000',
  //     bankAccount: '1000006789',
  //     time: 1678356976051,
  //     status: 0,
  //   ),
  //   const TransactionReceiveDashBoardDTO(
  //     amount: '999000',
  //     bankAccount: '1000006789',
  //     time: 1678356976051,
  //     status: 1,
  //   ),
  // ];
  const DashboardView({
    Key? key,
    required this.businessInformationBloc,
  }) : super(key: key);

  initialServices(BuildContext context) {
    String userId = UserInformationHelper.instance.getUserId();
    businessInformationBloc
        .add(BusinessInformationEventGetList(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    initialServices(context);
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildSuggestion(context),
            _buildShortcut(context),
            _buildBusinessWidget(context),
            const Padding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessWidget(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BlocConsumer<BusinessInformationBloc, BusinessInformationState>(
      listener: (context, state) {
        if (state is BusinessInformationInsertSuccessfulState) {
          String userId = UserInformationHelper.instance.getUserId();
          businessInformationBloc
              .add(BusinessInformationEventGetList(userId: userId));
        }
      },
      builder: (context, state) {
        if (state is BusinessLoadingListState) {
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
        if (state is BusinessGetListSuccessfulState) {
          if (state.list.isEmpty) {
            return SizedBox(
              width: width,
              height: 200,
              child: const Center(
                child: Text(''),
              ),
            );
          } else {
            return Column(
              children: [
                _buildTitle('Doanh nghiệp', DefaultTheme.GREEN),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    return _buildBusinessItem(
                      context: context,
                      dto: state.list[index],
                    );
                  },
                ),
              ],
            );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildBusinessItem(
      {required BuildContext context, required BusinessItemDTO dto}) {
    final double width = MediaQuery.of(context).size.width;
    String heroId = dto.businessId;
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            child: Stack(
              children: [
                Hero(
                  tag: heroId,
                  child: Container(
                    width: width,
                    height: width * 9 / 16,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.3),
                      image: (dto.coverImgId.isNotEmpty)
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: ImageUtils.instance
                                  .getImageNetWork(dto.coverImgId),
                            )
                          : null,
                    ),
                  ),
                ),
                Container(
                  width: width,
                  height: width * 9 / 16,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        DefaultTheme.TRANSPARENT,
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.4),
                        Theme.of(context).scaffoldBackgroundColor,
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: InkWell(
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
                      });
                    },
                    child: const BoxLayout(
                      width: 85,
                      borderRadius: 40,
                      alignment: Alignment.center,
                      child: Text(
                        'Chi tiết',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  child: SizedBox(
                    width: width - 50,
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (dto.imgId.isNotEmpty)
                                  ? ImageUtils.instance
                                      .getImageNetWork(dto.imgId)
                                  : Image.asset(
                                      'assets/images/ic-avatar-business.png',
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                    ).image,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 20)),
                        Expanded(
                          child: Text(
                            dto.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: width,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildChip(
                  context: context,
                  icon: Icons.assignment_ind_rounded,
                  color: DefaultTheme.RED_CALENDAR,
                  text: getRoleName(dto.role),
                ),
                _buildChip(
                  context: context,
                  icon: Icons.business_rounded,
                  color: DefaultTheme.GREEN,
                  text: '${dto.totalBranch} chi nhánh',
                ),
                _buildChip(
                  context: context,
                  icon: Icons.people_rounded,
                  text: '${dto.totalMember} thành viên',
                  color: DefaultTheme.BLUE_TEXT,
                ),
              ],
            ),
          ),
          if (dto.transactions.isEmpty) ...[
            const Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              width: width,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Chưa có giao dịch nào'),
            ),
          ],
          if (dto.transactions.isNotEmpty) ...[
            const Padding(padding: EdgeInsets.only(top: 30)),
            SizedBox(
              width: width,
              child: const Text(
                'Giao dịch gần đây',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dto.transactions.length,
                itemBuilder: (context, index) {
                  return _buildTransactionItem(
                    context: context,
                    dto: dto.transactions[index],
                  );
                },
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            InkWell(
              onTap: () {},
              child: BoxLayout(
                width: width,
                height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                bgColor: DefaultTheme.TRANSPARENT,
                child: const Text(
                  'Xem thêm',
                  style: TextStyle(
                    color: DefaultTheme.GREEN,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required BuildContext context,
    required RelatedTransactionReceiveDTO dto,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '+ ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)}',
                  style: TextStyle(
                    fontSize: 18,
                    color: TransactionUtils.instance.getColorStatus(dto.status),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 3)),
                Text(
                  'Đến: ${dto.bankAccount}',
                  style: const TextStyle(
                    color: DefaultTheme.GREY_TEXT,
                  ),
                ),
              ],
            ),
          ),
          Text(
            TimeUtils.instance.formatDateFromInt(dto.time, true),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 5)),
          Icon(
            TransactionUtils.instance.getIconStatus(dto.status),
            size: 15,
            color: TransactionUtils.instance.getColorStatus(dto.status),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return UnconstrainedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: color,
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestion(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<SuggestionWidgetProvider>(
      builder: (context, provider, child) {
        return (provider.getSuggestion())
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTitle(
                    'Gợi ý',
                    DefaultTheme.ORANGE,
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
                          color: DefaultTheme.BLUE_TEXT,
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
                          color: DefaultTheme.RED_CALENDAR,
                          function: () {
                            Navigator.of(context).pushNamed(Routes.USER_EDIT);
                          },
                        )
                      : const SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: (provider.getSuggestion()) ? 20 : 0,
                    ),
                    child: DividerWidget(width: width),
                  ),
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
                          'Phím tắt',
                          DefaultTheme.BLUE_TEXT,
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
                              color: DefaultTheme.GREY_TEXT,
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
                        _buildShorcutIcon(
                          widgetWidth: width,
                          title: 'Tạo doanh nghiệp',
                          icon: Icons.business_rounded,
                          color: DefaultTheme.GREEN,
                          function: () {
                            Navigator.pushNamed(
                                context, Routes.ADD_BUSINESS_VIEW);
                          },
                        ),
                        _buildShorcutIcon(
                          widgetWidth: width,
                          title: 'Thêm TK\nngân hàng',
                          icon: Icons.credit_card_rounded,
                          color: DefaultTheme.PURPLE_NEON,
                          function: () {
                            Navigator.pushNamed(context, Routes.ADD_BANK_CARD);
                          },
                        ),
                        _buildShorcutIcon(
                          widgetWidth: width,
                          title: 'Mở TK\nMB Bank',
                          icon: Icons.account_balance_rounded,
                          color: DefaultTheme.BLUE_DARK,
                          function: () {
                            DialogWidget.instance.openMsgDialog(
                              title: 'Đang phát triển',
                              msg: 'Tính năng đang được phát triển',
                            );
                          },
                        ),
                        _buildShorcutIcon(
                          widgetWidth: width,
                          title: 'Nạp tiền\nđiện thoại',
                          icon: Icons.phone_iphone_rounded,
                          color: DefaultTheme.RED_CALENDAR,
                          function: () {
                            DialogWidget.instance.openMsgDialog(
                              title: 'Đang phát triển',
                              msg: 'Tính năng đang được phát triển',
                            );
                          },
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     left: 20,
                  //     right: 20,
                  //     top: (provider.expanded) ? 20 : 0,
                  //   ),
                  //   child: DividerWidget(width: width),
                  // ),
                ],
              )
            : const SizedBox();
      },
    );
  }

  Widget _buildShorcutIcon(
      {required double widgetWidth,
      required String title,
      required IconData icon,
      required Color color,
      required VoidCallback function}) {
    return InkWell(
      onTap: function,
      child: BoxLayout(
        width: widgetWidth * 0.2,
        height: widgetWidth * 0.2,
        padding: const EdgeInsets.all(0),
        bgColor: DefaultTheme.TRANSPARENT,
        // enableShadow: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: widgetWidth * 0.05,
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: color,
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
                      color: DefaultTheme.GREY_TEXT,
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
    if (role == 0) {
      result = 'Admin';
    } else if (role == 1) {
      result = 'Quản lý';
    } else if (role == 2) {
      result = 'Quản lý chi nhánh';
    } else {
      result = 'Thành viên';
    }
    return result;
  }
}
