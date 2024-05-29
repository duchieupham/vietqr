import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/create_store/create_store.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/store/merchant_dto.dart';

class InfoMerchantView extends StatefulWidget {
  final VoidCallback onAddMerchant;
  final Function(String) callBack;

  const InfoMerchantView(
      {super.key, required this.onAddMerchant, required this.callBack});

  @override
  State<InfoMerchantView> createState() => _InfoMerchantViewState();
}

class _InfoMerchantViewState extends State<InfoMerchantView> {
  late CreateStoreBloc _bloc;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = CreateStoreBloc(context);
    controller.addListener(_loadMore);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(GetListMerchantEvent());
    });
  }

  void _loadMore() {
    final maxScroll = controller.position.maxScrollExtent;
    if (controller.offset >= maxScroll && !controller.position.outOfRange) {
      _bloc.add(GetListMerchantEvent(loadMore: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: GestureDetector(
        onTap: _hideKeyBoard,
        child: Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/ic-merchant-3D.png', height: 100),
              Text(
                'Đầu tiên, vui lòng chọn\ndoanh nghiệp của bạn',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: AppColor.GREY_TEXT),
                  children: [
                    TextSpan(text: 'Một doanh nghiệp có nhiều cửa hàng.\n'),
                    TextSpan(
                        text:
                            'Tạo một doanh nghiệp mới hoặc chọn doanh nghiệp đã có của bạn.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              MButtonWidget(
                title: 'Thêm doanh nghiệp mới',
                radius: 20,
                isEnable: true,
                colorEnableBgr: AppColor.TRANSPARENT,
                colorEnableText: AppColor.BLUE_TEXT,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                border: Border.all(color: AppColor.BLUE_TEXT),
                onTap: widget.onAddMerchant.call,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocConsumer<CreateStoreBloc, CreateStoreState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state.merchants.isEmpty) return const SizedBox();
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ...List.generate(state.merchants.length, (index) {
                            MerchantDTO dto = state.merchants[index];
                            return _buildItemBank(dto);
                          }),
                          if (state.isLoadMore)
                            Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(),
                              ),
                            )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemBank(MerchantDTO dto) {
    return GestureDetector(
      onTap: () => widget.callBack.call(dto.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColor.grey979797, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    '${dto.totalTerminals} cửa hàng',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
            Image.asset('assets/images/ic-navigate-next-blue.png', width: 44)
          ],
        ),
      ),
    );
  }

  void _hideKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
