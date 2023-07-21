import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/qr_recreate_dto.dart';
import 'package:vierqr/services/providers/water_mark_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'blocs/transaction_bloc.dart';
import 'events/transaction_event.dart';
import 'states/transaction_state.dart';
import 'widgets/detail_image_view.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String transactionId = args['transactionId'] ?? '';

    return BlocProvider<TransactionBloc>(
      create: (BuildContext context) => TransactionBloc(context, transactionId),
      child: _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatefulWidget {
  @override
  State<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<_BodyWidget> {
  late TransactionBloc _bloc;

  final globalKey = GlobalKey();
  final _waterMarkProvider = WaterMarkProvider(false);

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(context);
    });
  }

  initData(BuildContext context) {
    _bloc.add(TransactionEventGetDetail());
  }

  Future<void> onRefresh() async {
    _bloc.add(TransactionEventGetDetail());
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) async {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state.status == BlocStatus.UNLOADING) {
          Navigator.pop(context);
        }

        if (state.type == TransactionType.LOAD_DATA) {
          _bloc.add(const TransactionEventGetImage(isLoading: false));
        }

        if (state.type == TransactionType.REFRESH) {
          if (state.newTransaction) {
            await Navigator.pushReplacementNamed(
              context,
              Routes.CREATE_QR,
              arguments: {
                'qr': state.qrGeneratedDTO,
              },
            );
          }
        }
      },
      builder: (context, state) {
        // if (state.status == BlocStatus.LOADING) {
        //   return const Center(
        //     child: SizedBox(
        //       width: 30,
        //       height: 30,
        //       child: CircularProgressIndicator(
        //         color: AppColor.BLUE_TEXT,
        //       ),
        //     ),
        //   );
        // }
        return Scaffold(
          appBar: const MAppBar(title: 'Chi tiết giao dịch'),
          body: RefreshIndicator(
            onRefresh: onRefresh,
            child: Column(
              children: [
                Visibility(
                  visible: state.dto?.id != null,
                  child: RepaintBoundaryWidget(
                    globalKey: globalKey,
                    builder: (key) {
                      return Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 30)),
                            SizedBox(
                              width: width,
                              child: Center(
                                child: Text(
                                  '${state.dto?.getTransType} ${state.dto?.getAmount} VND',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: TransactionUtils.instance
                                        .getColorStatus(
                                      state.dto?.status ?? 0,
                                      state.dto?.type ?? 0,
                                      state.dto?.transType ?? '',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 5)),
                            SizedBox(
                              width: width,
                              child: Center(
                                child: Text(
                                  state.dto?.getStatus ?? '',
                                  style: TextStyle(
                                    color: TransactionUtils.instance
                                        .getColorStatus(
                                      state.dto?.status ?? 0,
                                      state.dto?.type ?? 0,
                                      state.dto?.transType ?? '',
                                    ),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 30)),
                            UnconstrainedBox(
                              child: BoxLayout(
                                width: width - 40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(top: 10)),
                                    Text(
                                      state.dto?.getPrefixBankAccount ?? '',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColor.GREY_TEXT,
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 5)),
                                    SizedBox(
                                      width: width - 40,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${state.dto?.bankCode ?? ''} - ${state.dto?.bankName ?? ''}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: AppColor.WHITE,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                color:
                                                    AppColor.GREY_TOP_TAB_BAR,
                                                width: 0.5,
                                              ),
                                              image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image: ImageUtils.instance
                                                    .getImageNetWork(
                                                        state.dto?.imgId ?? ''),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 5)),
                                    _buildElement1(
                                      context: context,
                                      width: width - 40,
                                      content:
                                          (state.dto?.bankAccountName ?? '')
                                              .toUpperCase(),
                                      isBold: true,
                                    ),
                                    _buildElement1(
                                      context: context,
                                      width: width - 40,
                                      content: state.dto?.bankAccount ?? '',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: DividerWidget(width: width - 40),
                                    ),
                                    _buildElement2(
                                      context: context,
                                      title: 'Thời gian',
                                      content: TimeUtils.instance
                                          .formatDateFromInt(
                                              state.dto?.time ?? 0, false),
                                      width: width - 40,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 10)),
                                    if ((state.dto?.referenceNumber ?? '')
                                        .trim()
                                        .isNotEmpty) ...[
                                      _buildElement2(
                                        context: context,
                                        title: 'Mã giao dịch',
                                        content:
                                            state.dto?.referenceNumber ?? '',
                                        width: width - 40,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 10)),
                                    ],
                                    _buildElement2(
                                      context: context,
                                      title: 'Nội dung',
                                      content: state.dto?.content ?? '',
                                      width: width - 40,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 10)),
                                  ],
                                ),
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _waterMarkProvider,
                              builder: (_, provider, child) {
                                return Visibility(
                                  visible: provider == true,
                                  child: Container(
                                    width: width,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: RichText(
                                      textAlign: TextAlign.right,
                                      text: const TextSpan(
                                        style: TextStyle(
                                          color: AppColor.GREY_TEXT,
                                          fontSize: 12,
                                        ),
                                        children: [
                                          TextSpan(text: 'Được tạo bởi '),
                                          TextSpan(
                                            text: 'vietqr.vn',
                                            style: TextStyle(
                                              color: AppColor.BLUE_TEXT,
                                              fontSize: 12,
                                            ),
                                          ),
                                          TextSpan(text: ' - '),
                                          TextSpan(text: 'Hotline '),
                                          TextSpan(
                                            text: '19006234',
                                            style: TextStyle(
                                              color: AppColor.BLUE_TEXT,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Padding(padding: EdgeInsets.only(top: 30)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (state.listImage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Đính kèm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: List.generate(
                            state.listImage.length,
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => DetailImageView(
                                          image:
                                              state.listImage.elementAt(index)),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 100,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColor.WHITE,
                                    image: DecorationImage(
                                      image: ImageUtils.instance
                                          .getImageNetWork(
                                              state.listImage[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
          bottomSheet: _buildButton(
            context: context,
            onClick: (index) {},
            onPaid: () {
              QRRecreateDTO qrRecreateDTO = QRRecreateDTO(
                bankId: state.dto?.bankId ?? '',
                amount: (state.dto?.amount ?? 0).toString(),
                content: state.dto?.content ?? '',
                userId: UserInformationHelper.instance.getUserId(),
                newTransaction: true,
              );
              _bloc.add(TransEventQRRegenerate(dto: qrRecreateDTO));
            },
          ),
        );
      },
    );
  }

  Widget _buildButton(
      {required BuildContext context,
      GestureTapCallback? onPaid,
      bool isEnable = false,
      required Function(int) onClick}) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: MButtonWidget(
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.refresh,
                          color: AppColor.WHITE,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Thực hiện lại',
                          style: TextStyle(
                            color: AppColor.WHITE,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    title: '',
                    isEnable: true,
                    margin: const EdgeInsets.only(left: 20),
                    onTap: onPaid,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        borderRadius: BorderRadius.circular(5)),
                    child: Image.asset(
                      'assets/images/ic-img-blue.png',
                      width: 42,
                      height: 34,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        borderRadius: BorderRadius.circular(5)),
                    child: Image.asset(
                      'assets/images/ic-share-blue.png',
                      width: 42,
                      height: 34,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildElement1({
    required double width,
    required BuildContext context,
    required String content,
    bool? isBold,
  }) {
    return Container(
      width: width,
      height: 20,
      alignment: Alignment.centerLeft,
      child: Text(
        content,
        style: TextStyle(
          fontWeight:
              (isBold != null && isBold) ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildElement2({
    required double width,
    required BuildContext context,
    required String title,
    required String content,
    Color? color,
    bool? isBold,
  }) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColor.GREY_TEXT,
              ),
            ),
          ),
          Expanded(
            child: Text(
              content,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: (color != null) ? color : Theme.of(context).hintColor,
                fontWeight: (isBold != null && isBold)
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
