import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/sliver_header.dart';
import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/features/business/views/business_overview.dart';
import 'package:vierqr/features/business/views/business_transaction_view.dart';
import 'package:vierqr/features/transaction/blocs/transaction_bloc.dart';
import 'package:vierqr/features/transaction/events/transaction_event.dart';
import 'package:vierqr/models/business_item_dto.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';
import 'package:vierqr/services/providers/business_inforamtion_provider.dart';

class BusinessInformationView extends StatefulWidget {
  const BusinessInformationView({super.key});

  @override
  State<StatefulWidget> createState() => _BusinessInformationView();
}

class _BusinessInformationView extends State<BusinessInformationView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  static late PageController _pageController;
  final List<Widget> _businessScreens = [];
  static late BranchBloc _branchBloc;
  static late TransactionBloc _transactionBloc;

  @override
  void initState() {
    super.initState();

    _branchBloc = BlocProvider.of(context);
    _transactionBloc = BlocProvider.of(context);
    _pageController = PageController(
      initialPage:
          Provider.of<BusinessInformationProvider>(context, listen: false)
              .indexSelected,
      keepPage: true,
    );
    _scrollController.addListener(() {
      _scrollListener(context);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void initialServices(BuildContext context, String businessId) {
    _businessScreens.addAll(
      [
        BusinessOverView(
          key: const PageStorageKey('BUSINESS_OVERVIEW'),
          branchBloc: _branchBloc,
          transactionBloc: _transactionBloc,
          businessId: businessId,
          onTransactionNext: () {
            _animatedToPage(1);
          },
        ),
        BusinessTransactionView(
          key: const PageStorageKey('BUSINESS_TRANSACTION'),
          branchBloc: _branchBloc,
          transactionBloc: _transactionBloc,
          scrollController: _scrollController,
        ),
        Container(
          width: 400,
          height: 1000,
          color: Colors.blue,
        ),
      ],
    );
  }

  void _scrollListener(BuildContext context) {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Đã cuộn tới cuối danh sách
      // Thực hiện công việc của bạn ở đây
      if (Provider.of<BusinessInformationProvider>(context, listen: false)
              .indexSelected ==
          1) {
        String businessId =
            Provider.of<BusinessInformationProvider>(context, listen: false)
                .input
                .businessId;
        String branchId =
            Provider.of<BusinessInformationProvider>(context, listen: false)
                .filterSelected
                .branchId;
        int offset =
            Provider.of<BusinessInformationProvider>(context, listen: false)
                    .input
                    .offset +
                20;
        TransactionBranchInputDTO inputDTO = TransactionBranchInputDTO(
            businessId: businessId, branchId: branchId, offset: offset);
        Provider.of<BusinessInformationProvider>(context, listen: false)
            .updateInput(inputDTO);
        _transactionBloc.add(TransactionEventFetchBranch(dto: inputDTO));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String heroId = args['heroId'];
    BusinessItemDTO dto = args['businessItem'];
    initialServices(context, dto.businessId);
    return WillPopScope(
      onWillPop: () async {
        Provider.of<BusinessInformationProvider>(context, listen: false)
            .reset();
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return NestedScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,

                // slivers: [
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      collapsedHeight: MediaQuery.of(context).size.width * 0.25,
                      floating: false,
                      expandedHeight: MediaQuery.of(context).size.width * 0.6,
                      flexibleSpace: SliverHeader(
                        minHeight: MediaQuery.of(context).size.width * 0.25,
                        maxHeight: MediaQuery.of(context).size.width * 0.6,
                        businessName: dto.name,
                        heroId: heroId,
                        imgId: dto.imgId,
                        coverImgId: dto.coverImgId,
                      ),
                    ),
                    // Widget được pin
                    SliverPersistentHeader(
                      pinned: true, // pin widget này
                      delegate: MyPersistentHeaderDelegate(
                        // widget của bạn
                        child: Container(
                          width: width,
                          height: 60,
                          alignment: Alignment.center,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Consumer<BusinessInformationProvider>(
                            builder: (context, provider, child) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: _businessScreens.length,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      _animatedToPage(index);
                                    },
                                    child: Container(
                                      width: width / 3,
                                      height: 60,
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          border: (provider.indexSelected ==
                                                  index)
                                              ? const Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          DefaultTheme.GREEN),
                                                )
                                              : null,
                                          // borderRadius: BorderRadius.circular(6),
                                          // color: (provider.indexSelected == index)
                                          //     ? DefaultTheme.GREEN
                                          //         .withOpacity(0.3)
                                          //     : DefaultTheme.TRANSPARENT,
                                        ),
                                        child: Text(
                                          _getTitle(index),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                                (provider.indexSelected ==
                                                        index)
                                                    ? FontWeight.w500
                                                    : FontWeight.normal,
                                            color: (provider.indexSelected ==
                                                    index)
                                                ? DefaultTheme.GREEN
                                                : Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: PageView(
                  key: const PageStorageKey('BUSINESS_PAGE_VIEW'),
                  allowImplicitScrolling: true,
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    Provider.of<BusinessInformationProvider>(context,
                            listen: false)
                        .updateIndex(index);
                  },
                  children: _businessScreens,
                ),

                // ],
              );
            }),
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
                    color: DefaultTheme.BLACK_BUTTON.withOpacity(0.6),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: DefaultTheme.WHITE,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle(int index) {
    String result = '';
    if (index == 0) {
      result = 'Tổng quan';
    } else if (index == 1) {
      result = 'Giao dịch';
    } else if (index == 2) {
      result = 'Thành viên';
    }
    return result;
  }

  //navigate to page
  void _animatedToPage(int index) {
    try {
      _scrollController.animateTo(
        0, // Giá trị offset
        duration: const Duration(milliseconds: 200), // Thời gian di chuyển
        curve: Curves.easeInOut, // Độ cong của đường di chuyển
      );
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutQuart,
      );
    } catch (e) {
      _pageController = PageController(
        initialPage:
            Provider.of<BusinessInformationProvider>(context, listen: false)
                .indexSelected,
        keepPage: true,
      );
      _animatedToPage(index);
    }
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
      color: DefaultTheme.TRANSPARENT,
      alignment: Alignment.center,
      child: child, // Widget được pin
    );
  }

  @override
  bool shouldRebuild(covariant MyPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
