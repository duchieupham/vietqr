import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'dart:math' as math;

import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
import 'package:vierqr/features/bank_card/states/bank_card_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class BankCardSelectView extends StatelessWidget {
  final BankCardBloc bankCardBloc;
  static final List<BankAccountDTO> bankAccounts = [];
  static final List<Color> cardColors = [];

  const BankCardSelectView({
    super.key,
    required this.bankCardBloc,
  });

  initialServices(BuildContext context) {
    bankAccounts.clear();
    cardColors.clear();
    String userId = UserInformationHelper.instance.getUserId();
    bankCardBloc.add(BankCardEventGetList(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    final double maxListHeight = MediaQuery.of(context).size.height - 250;
    initialServices(context);
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 80)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: BlocConsumer<BankCardBloc, BankCardState>(
                listener: (context, state) {
                  if (state is BankCardGetListSuccessState) {
                    resetProvider(context);
                    if (bankAccounts.isEmpty) {
                      bankAccounts.addAll(state.list);
                      cardColors.addAll(state.colors);
                    }
                  }
                  if (state is BankCardRemoveSuccessState ||
                      state is BankCardInsertSuccessfulState) {
                    getListBank(context);
                  }
                },
                builder: (context, state) {
                  if (state is BankCardLoadingState) {
                    return const CircularProgressIndicator(
                      color: DefaultTheme.GREEN,
                    );
                  }
                  return StackedList(
                    maxListHeight: maxListHeight,
                    list: bankAccounts,
                    colors: cardColors,
                  );
                },
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 70)),
      ],
    );
  }

  void getListBank(BuildContext context) {
    bankAccounts.clear();
    cardColors.clear();
  }

  void resetProvider(BuildContext context) {
    bankAccounts.clear();
  }
}

class StackedList extends StatefulWidget {
  final double maxListHeight;
  final List<BankAccountDTO> list;
  final List<Color> colors;

  const StackedList({
    super.key,
    required this.maxListHeight,
    required this.list,
    required this.colors,
  });

  @override
  State<StatefulWidget> createState() => _StackedList();
}

class _StackedList extends State<StackedList> {
  static const double _minHeight = 40;
  static const double _maxHeight = 150;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double sizedBox = (widget.list.length * _maxHeight) * 0.75;
    final double height = (sizedBox < _maxHeight)
        ? _maxHeight
        : (sizedBox > widget.maxListHeight)
            ? widget.maxListHeight - 60
            : sizedBox;
    final bool isPinned = height % (_minHeight + _maxHeight) < _minHeight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.list.isNotEmpty)
          Container(
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: DefaultTheme.PURPLE_NEON.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.credit_card_rounded,
                  color: DefaultTheme.PURPLE_NEON,
                  size: 15,
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  '${widget.list.length} tài khoản ngân hàng được thêm',
                  style: const TextStyle(
                    color: DefaultTheme.PURPLE_NEON,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        (widget.list.isEmpty)
            ? ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Container(
                  width: width,
                  height: _maxHeight,
                  color: Theme.of(context).cardColor,
                  alignment: Alignment.center,
                  child: Column(children: [
                    SizedBox(
                      width: 150,
                      height: 100,
                      child: Image.asset(
                        'assets/images/ic-card.png',
                      ),
                    ),
                    const Text('Chưa có tài khoản ngân hàng được thêm.'),
                  ]),
                ),
              )
            : SizedBox(
                height: height,
                child: CustomScrollView(
                  slivers: widget.list.map(
                    (item) {
                      int index = widget.list.indexOf(item);
                      return StackedListChild(
                        minHeight: _minHeight,
                        maxHeight:
                            widget.list.indexOf(item) == widget.list.length - 1
                                ? MediaQuery.of(context).size.height
                                : _maxHeight,
                        pinned: isPinned,
                        floating: true,
                        child: _buildCardItem(
                          context: context,
                          index: index,
                          dto: widget.list[index],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
        Container(
          width: width - 40,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: InkWell(
            onTap: () {
              Provider.of<AddBankProvider>(context, listen: false)
                  .updateSelect(1);
              Navigator.pushNamed(context, Routes.ADD_BANK_CARD,
                  arguments: {'pageIndex': 1});
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add_rounded,
                  color: DefaultTheme.GREEN,
                  size: 15,
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  'Thêm TK ngân hàng',
                  style: TextStyle(
                    fontSize: 15,
                    color: DefaultTheme.GREEN,
                  ),
                ),
              ],
            ),
          ),
        ),
        DividerWidget(width: width),
        Container(
          width: width - 40,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(15)),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.copy_rounded,
                  color: DefaultTheme.BLUE_TEXT,
                  size: 15,
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  'Sao chép mã VietQR',
                  style: TextStyle(
                    fontSize: 15,
                    color: DefaultTheme.BLUE_TEXT,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardItem(
      {required BuildContext context,
      required int index,
      required BankAccountDTO dto}) {
    final double width = MediaQuery.of(context).size.width;
    return (dto.id.isNotEmpty)
        ? Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: widget.colors[index],
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 0.5,
                ),
              ),
            ),
            child: SizedBox(
              width: width,
              height: 100,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    height: 60,
                    width: width,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                            color: DefaultTheme.WHITE,
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: ImageUtils.instance.getImageNetWork(
                                dto.imgId,
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Expanded(
                          child: Text(
                            '${dto.bankCode} - ${dto.bankAccount}\n${dto.bankName}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: DefaultTheme.WHITE,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  SizedBox(
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 20)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dto.userBankName.toUpperCase(),
                                style: const TextStyle(
                                  color: DefaultTheme.WHITE,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                (dto.isAuthenticated)
                                    ? 'Trạng thái: Đã liên kết'
                                    : 'Trạng thái: Chưa liên kết',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: DefaultTheme.WHITE,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.BANK_CARD_DETAIL_VEW,
                              arguments: {
                                'bankId': dto.id,
                              },
                            );
                          },
                          child: const BoxLayout(
                            width: 85,
                            borderRadius: 10,
                            alignment: Alignment.center,
                            child: Text(
                              'Chi tiết',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 20)),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}

class StackedListChild extends StatelessWidget {
  final double minHeight;
  final double maxHeight;
  final bool pinned;
  final bool floating;
  final Widget child;

  SliverPersistentHeaderDelegate get _delegate => _StackedListDelegate(
      minHeight: minHeight, maxHeight: maxHeight, child: child);

  const StackedListChild({
    Key? key,
    required this.minHeight,
    required this.maxHeight,
    required this.child,
    this.pinned = false,
    this.floating = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverPersistentHeader(
        key: key,
        pinned: pinned,
        delegate: _delegate,
      );
}

class _StackedListDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StackedListDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StackedListDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight / 2 ||
        minHeight != oldDelegate.minHeight / 2 ||
        child != oldDelegate.child;
  }
}
