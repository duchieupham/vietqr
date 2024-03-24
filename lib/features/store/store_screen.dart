import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/features/store/store.dart';
import 'package:vierqr/models/store/merchant_dto.dart';

import 'views/info_store_view.dart';
import 'views/suggest_create_store_view.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with AutomaticKeepAliveClientMixin {
  late StoreBloc bloc;

  DateFormat get _format => DateFormat('yyyy-MM-dd HH:mm:ss');

  DateTime get _now =>
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final controller = ScrollController();

  MerchantDTO _dto = MerchantDTO();
  StreamSubscription? _subscription;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    bloc = StoreBloc(context);
    controller.addListener(_loadMore);
    _subscription = eventBus.on<ReloadStoreEvent>().listen((data) {
      if (data.isUpdate) bloc.add(UpdateListStoreEvent(data.id));
      if (!data.isUpdate) bloc.add(GetMerchantsEvent());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetMerchantsEvent());
    });
  }

  Future<void> _onRefresh() async {
    String toDate = _format.format(
        _now.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)));
    bloc.add(GetTotalStoreByDayEvent(
        merchantId: _dto.id, fromDate: _format.format(_now), toDate: toDate));
    bloc.add(GetListStoreEvent(
        merchantId: _dto.id,
        fromDate: _format.format(_now),
        toDate: toDate,
        refresh: true));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<StoreBloc>(
      create: (context) => bloc,
      child: BlocConsumer<StoreBloc, StoreState>(
        listener: (context, state) {
          if (state.request == StoreType.GET_MERCHANTS) {
            if (state.merchants.isNotEmpty) {
              _dto = state.merchants.first;
              setState(() {});
            }

            String toDate = _format.format(_now
                .add(const Duration(days: 1))
                .subtract(const Duration(seconds: 1)));
            bloc.add(GetTotalStoreByDayEvent(
                merchantId: _dto.id,
                fromDate: _format.format(_now),
                toDate: toDate));
            bloc.add(GetListStoreEvent(
                merchantId: _dto.id,
                fromDate: _format.format(_now),
                toDate: toDate));
          }

          if (state.request == StoreType.GET_STORES) {
            _loading = false;
            setState(() {});
          }
        },
        builder: (context, state) {
          if (_loading)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (state.isEmpty)
            return SuggestCreateStoreView(
              onRefresh: _onRefresh,
            );
          return InfoStoreView(
            totalStoreDTO: state.totalStoreDTO,
            merchants: state.merchants,
            dto: _dto,
            callBack: (value) {
              if (value == null) return;
              setState(() {
                _dto = value;
              });
              _onRefresh();
            },
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
          merchantId: _dto.id,
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

  @override
  bool get wantKeepAlive => true;
}
