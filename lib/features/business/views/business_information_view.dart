import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/sliver_header.dart';
import 'package:vierqr/models/business_item_dto.dart';

class BusinessInformationView extends StatefulWidget {
  const BusinessInformationView({super.key});

  @override
  State<StatefulWidget> createState() => _BusinessInformationView();
}

class _BusinessInformationView extends State<BusinessInformationView> {
  static final ScrollController _scrollController = ScrollController();
  late double _maxScrollExtent;
  late double _currentScroll;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      //show button back to top
      // if (_scrollController.position.pixels >= 150) {
      //   Provider.of<ScrollProvider>(context, listen: false)
      //       .updateBackToTop(true);
      // } else if (_scrollController.position.pixels < 150) {
      //   Provider.of<ScrollProvider>(context, listen: false)
      //       .updateBackToTop(false);
      // }
      //pagging
      //get max scroll position
      _maxScrollExtent = _scrollController.position.maxScrollExtent;
      //get current scroll position
      _currentScroll = _scrollController.position.pixels;
      //check whether scroll controller scroll to end and list is end.
      if (_maxScrollExtent - _currentScroll == 0) {
        // &&
        //   !_newsPageProvider.hasListEnd) {
        // _newsPageProvider.turnNextPage();
        // _thumbnailNewsBloc.add(NewsEventGetThumbnail(
        //     categoryNewsId: categoryDTO.id,
        //     page: _newsPageProvider.currentPage));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String imgId = args['img'];
    String heroId = args['heroId'];
    BusinessItemDTO dto = args['businessItem'];
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Stack(
            children: [
              CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                slivers: [
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
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Container();
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 50,
                right: 10,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
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
      ),
    );
  }

  Future<void> _refresh() async {}
}
