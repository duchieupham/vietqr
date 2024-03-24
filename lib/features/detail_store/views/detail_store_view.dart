import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/widget/edit_store_screen.dart';
import 'package:vierqr/features/detail_store/blocs/detail_store_bloc.dart';
import 'package:vierqr/features/detail_store/events/detail_store_event.dart';
import 'package:vierqr/features/detail_store/states/detail_store_state.dart';
import 'package:vierqr/features/web_view/views/custom_inapp_webview.dart';
import 'package:vierqr/models/store/detail_store_dto.dart';
import 'package:vierqr/models/store/member_store_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class DetailStoreView extends StatefulWidget {
  final String terminalId;
  final Function(int) callBack;
  final Function(DetailStoreDTO) updateStore;

  const DetailStoreView(
      {super.key,
      required this.terminalId,
      required this.callBack,
      required this.updateStore});

  @override
  State<DetailStoreView> createState() => _DetailStoreViewState();
}

class _DetailStoreViewState extends State<DetailStoreView>
    with AutomaticKeepAliveClientMixin {
  late DetailStoreBloc bloc;
  late PageController _controller;
  int _pageIndex = 0;

  DateFormat get _dateFormat => DateFormat('yyyy-MM-dd HH:mm:ss');

  DateTime get now => DateTime.now();

  DateTime _formatFromDate(DateTime now) {
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    return fromDate;
  }

  DateTime _endDate(DateTime now) {
    DateTime fromDate = _formatFromDate(now);
    return fromDate
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    bloc = DetailStoreBloc(context, terminalId: widget.terminalId);
    _controller = PageController(initialPage: 0, keepPage: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    String fromDate = _dateFormat.format(_formatFromDate(DateTime.now()));
    String toDate = _dateFormat.format(_endDate(DateTime.now()));
    bloc.add(GetMembersStoreEvent());
    bloc.add(GetDetailStoreEvent(
      fromDate: fromDate,
      toDate: toDate,
    ));
  }

  void _onChangedPage(int value) => setState(() => _pageIndex = value);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<DetailStoreBloc>(
      create: (context) => bloc,
      child: BlocConsumer<DetailStoreBloc, DetailStoreState>(
        listener: (context, state) {
          if (state.status == BlocStatus.LOADING_PAGE) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            Navigator.pop(context);
          }

          if (state.request == DetailStoreType.GET_DETAIL) {
            widget.updateStore(state.detailStore!);
          }

          if (state.request == DetailStoreType.REMOVE_MEMBER) {
            _loadData();
          }
        },
        builder: (context, state) {
          if (state.detailStore == null)
            return const Center(
              child: CircularProgressIndicator(),
            );
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInfo(state.detailStore!, state.members.length),
                const SizedBox(height: 24),
                _buildQRBox(state.detailStore!),
                const SizedBox(height: 24),
                _buildMembers(state.members, state.detailStore!),
                const SizedBox(height: 24),
                _buildFeature(),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildInfo(DetailStoreDTO dto, int totalMember) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.WHITE,
      ),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dto.terminalName,
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16),
                    ),
                  ),
                  if (dto.admin)
                    GestureDetector(
                      onTap: () async {
                        await NavigatorUtils.navigatePage(
                            context,
                            EditStoreScreen(
                              terminalId: widget.terminalId,
                              detailStoreDTO: dto,
                              isUpdate: true,
                            ),
                            routeName: 'detail_group');
                        _loadData();
                      },
                      child: Image.asset('assets/images/ic-edit-phone.png',
                          width: 34),
                    ),
                ],
              ),
              Text(
                dto.terminalCode,
                maxLines: 1,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis, color: AppColor.GREY_TEXT),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildItemTotal(
                  title: '${dto.totalTrans} giao dịch',
                  content: CurrencyUtils.instance
                      .getCurrencyFormatted((dto.totalAmount).toString()),
                  des: 'Doanh thu',
                  image: 'assets/images/ic-money-white.png',
                ),
              ),
              Expanded(
                child: _buildItemTotal(
                  content:
                      '${(dto.ratePrevDate).toString().replaceAll('-', '')}%',
                  des: 'So với hôm qua',
                  image: (dto.ratePrevDate) >= 0
                      ? 'assets/images/ic-uptrend-white.png'
                      : 'assets/images/ic-downtrend-white.png',
                  contentColor: (dto.ratePrevDate) >= 0
                      ? AppColor.GREEN
                      : AppColor.RED_EC1010,
                  iconColor: (dto.ratePrevDate) >= 0
                      ? AppColor.GREEN
                      : AppColor.RED_CALENDAR,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (dto.terminalAddress.isNotEmpty) ...[
            const Divider(thickness: 1, color: AppColor.GREY_BORDER),
            Row(
              children: [
                Image.asset(
                  'assets/images/ic-location-black.png',
                  width: 34,
                ),
                Expanded(
                  child: Text(
                    dto.terminalAddress,
                    maxLines: 1,
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                )
              ],
            ),
          ],
          const Divider(thickness: 1, color: AppColor.GREY_BORDER),
          Row(
            children: [
              Image.asset(
                'assets/images/ic-card-counting-blue.png',
                color: AppColor.BLACK,
                width: 34,
              ),
              Expanded(
                child: Text(
                  '${dto.bankShortName} - ${dto.bankAccount}',
                  maxLines: 2,
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
          const Divider(thickness: 1, color: AppColor.GREY_BORDER),
          Row(
            children: [
              Image.asset('assets/images/ic-member-black.png', width: 34),
              Expanded(
                child: Text(
                  '$totalMember thành viên',
                  maxLines: 1,
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQRBox(DetailStoreDTO dto) {
    return Column(
      children: [
        GestureDetector(
          onTap: _onActiveQRBox,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE9B71D),
                  Color(0xFFFFE79F),
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/box-3D-icon.png',
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đăng ký QR Box ngay!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hiển thị mã VietQR cửa hàng và nhận thông báo thanh toán ngày trên thiết bị.',
                        style: TextStyle(fontSize: 14, color: AppColor.BLACK),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (dto.totalSubTerminal > 0) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Danh sách thiết bị QR Box',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 1, 8, 1),
                decoration: BoxDecoration(
                  color: AppColor.BLUE_TEXT.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Text('${dto.totalSubTerminal}',
                        style: TextStyle(color: AppColor.BLUE_TEXT)),
                    Image.asset('assets/images/ic-terminal-blue.png', width: 25)
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 195,
            child: PageView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              onPageChanged: _onChangedPage,
              children: List.generate(dto.subTerminals.length, (index) {
                SubTerminal sub = dto.subTerminals[index];
                return _itemQRBox(sub);
              }),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(dto.subTerminals.length, (index) {
              if (_pageIndex == index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    Icons.circle,
                    size: 12,
                    color: AppColor.GREY_TEXT.withOpacity(0.6),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(Icons.circle_outlined, size: 12),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _itemQRBox(SubTerminal sub) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.WHITE,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/box-3D-small-icon.png',
                width: 60,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      sub.subTerminalName,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/ic-location-black.png',
                          width: 34,
                        ),
                        Expanded(
                          child: Text(
                            sub.subTerminalAddress,
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(thickness: 1, color: AppColor.GREY_BORDER),
          Row(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/ic-income-blue.png',
                    width: 34,
                  ),
                  Text('${sub.totalTrans} giao dịch'),
                ],
              ),
              const SizedBox(width: 8),
              Text('-'),
              const SizedBox(width: 8),
              Row(
                children: [
                  Text(
                    CurrencyUtils.instance
                        .getCurrencyFormatted((sub.totalAmount).toString()),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColor.BLUE_TEXT,
                    ),
                  ),
                  Text(' VND doanh thu'),
                ],
              ),
            ],
          ),
          const Divider(thickness: 1, color: AppColor.GREY_BORDER),
          Row(
            children: [
              Image.asset(
                sub.ratePrevDate < 0
                    ? 'assets/images/ic-downtrend-box.png'
                    : 'assets/images/ic-uptrend-box.png',
                width: 34,
              ),
              Expanded(
                child: Text('${sub.ratePrevDate}% so với hôm qua'),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMembers(List<MemberStoreDTO> members, DetailStoreDTO dto) {
    if (members.isEmpty) return const SizedBox();
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Danh sách nhân viên',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 1, 8, 1),
              decoration: BoxDecoration(
                color: AppColor.BLUE_TEXT.withOpacity(0.25),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Text('${members.length}',
                      style: TextStyle(color: AppColor.BLUE_TEXT)),
                  Image.asset('assets/images/ic-member-bdsd-blue.png',
                      width: 25)
                ],
              ),
            ),
          ],
        ),
        ...List.generate(members.length, (index) {
          MemberStoreDTO member = members[index];
          return _itemMember(member, dto.admin);
        })
      ],
    );
  }

  Widget _buildFeature() {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chức năng',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.WHITE,
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => widget.callBack(1),
                child: _buildElement(
                  icon: 'assets/images/ic-popup-bank-qr.png',
                  context: context,
                  width: width,
                  title: 'Mã VietQR cửa hàng',
                  description: 'Xem thông tin mã VietQR cửa hàng',
                ),
              ),
              const Divider(thickness: 1, color: AppColor.GREY_BORDER),
              GestureDetector(
                onTap: () => widget.callBack(2),
                child: _buildElement(
                  icon: 'assets/images/ic-transaction-blue.png',
                  context: context,
                  width: width,
                  title: 'Lịch sửa giao dịch',
                  description:
                      'Truy vấn thông tin biến động số dư của cửa hàng',
                ),
              ),
              const Divider(thickness: 1, color: AppColor.GREY_BORDER),
              GestureDetector(
                onTap: () {},
                child: _buildElement(
                  icon: 'assets/images/ic-statistic-blue.png',
                  context: context,
                  width: width,
                  title: 'Thống kê',
                  description:
                      'Xem thông tin thống kê biến động số dư của tài khoản',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildElement({
    required BuildContext context,
    required double width,
    required String title,
    required String description,
    required String icon,
  }) {
    return Container(
      color: Colors.transparent,
      width: width,
      child: Row(
        children: [
          Image.asset(icon, width: 40),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  maxLines: 2,
                  style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTotal(
      {String? title,
      required String content,
      required String des,
      required String image,
      Color? contentColor,
      Color? iconColor}) {
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: iconColor ?? AppColor.BLUE_TEXT,
            ),
            child: Image.asset(image, width: 32),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title,
                    style: TextStyle(fontSize: 12),
                  ),
                Wrap(
                  children: [
                    if (content.isNotEmpty)
                      Text(
                        content,
                        style: TextStyle(
                            color: contentColor ?? AppColor.BLUE_TEXT,
                            fontSize: 12),
                      ),
                    if (contentColor == null)
                      Text(
                        ' VND',
                        style:
                            TextStyle(color: AppColor.GREY_TEXT, fontSize: 12),
                      ),
                  ],
                ),
                if (des.isNotEmpty)
                  Text(
                    des,
                    maxLines: 2,
                    style: TextStyle(color: AppColor.GREY_TEXT, fontSize: 10),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemMember(MemberStoreDTO dto, bool isRemove) {
    return GestureDetector(
      child: Container(
        height: 54,
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: AppColor.WHITE, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            const SizedBox(width: 12),
            dto.imgId.isNotEmpty
                ? Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                          image: ImageUtils.instance.getImageNetWork(dto.imgId),
                          fit: BoxFit.cover),
                    ),
                  )
                : Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                          image: AssetImage('assets/images/ic-avatar.png')),
                    ),
                  ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.fullName.trim(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    dto.phoneNo,
                    style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  color: AppColor.BLUE_TEXT.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                dto.role,
                style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
              ),
            ),
            if (isRemove && !dto.isOwner)
              GestureDetector(
                onTap: () => bloc.add(RemoveMemberEvent(userId: dto.id)),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: 18,
                    color: AppColor.RED_TEXT,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _onActiveQRBox() {
    NavigatorUtils.navigatePage(
        context,
        CustomInAppWebView(
          url: 'https://vietqr.vn/service/may-ban-hang/active?mid=0',
          userId: SharePrefUtils.getProfile().userId,
        ),
        routeName: CustomInAppWebView.routeName);
  }
}
