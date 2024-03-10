import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/features/store/store.dart';

import 'views/info_store_view.dart';
import 'views/suggest_create_store_view.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late StoreBloc bloc;

  DateFormat get _format => DateFormat('yyyy-MM-dd HH:mm:ss');

  DateTime get _now =>
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc = StoreBloc(context);
    controller.addListener(_loadMore);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String toDate = _format.format(_now
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1)));

      bloc.add(GetTotalStoreByDayEvent(
          merchantId: '', fromDate: _format.format(_now), toDate: toDate));
      bloc.add(GetListStoreEvent(
          merchantId: '', fromDate: _format.format(_now), toDate: toDate));
    });
  }

  Future<void> _onRefresh() async {
    String toDate = _format.format(
        _now.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)));

    bloc.add(GetTotalStoreByDayEvent(
        merchantId: '', fromDate: _format.format(_now), toDate: toDate));
    bloc.add(GetListStoreEvent(
        merchantId: '',
        fromDate: _format.format(_now),
        toDate: toDate,
        refresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoreBloc>(
      create: (context) => bloc,
      child: BlocConsumer<StoreBloc, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.isEmpty) return SuggestCreateStoreView();
          return InfoStoreView(
            totalStoreDTO: state.totalStoreDTO,
            stores: state.stores,
            controller: controller,
            onRefresh: _onRefresh,
          );
        },
      ),
    );
  }

  void _onMore() {
    String toDate = _format.format(
        _now.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)));
    bloc.add(
      GetListStoreEvent(
          merchantId: '',
          fromDate: _format.format(_now),
          toDate: toDate,
          isLoadMore: true),
    );
  }

  void _loadMore() {
    final maxScroll = controller.position.maxScrollExtent;
    if (controller.offset >= maxScroll && !controller.position.outOfRange) {
      _onMore();
    }
  }

  @override
  void dispose() {
    controller.removeListener(_loadMore);
    controller.dispose();
    super.dispose();
  }
}
