import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/qr_recreate_dto.dart';
import 'package:vierqr/models/transaction_receive_dto.dart';
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
    _bloc.add(const TransactionEventGetDetail());
  }

  Future<void> onRefresh() async {
    _bloc.add(const TransactionEventGetDetail());
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
          } else {
            Navigator.pushNamed(
              context,
              Routes.CREATE_QR,
              arguments: {
                'qr': state.qrGeneratedDTO,
                'page': 1,
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
            dto: state.dto,
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
      TransactionReceiveDTO? dto,
      required Function(int) onClick}) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (dto?.transType == 'C')
                  Expanded(
                    child: Row(
                      children: [
                        if (dto?.status != 0)
                          Expanded(
                            child: MButtonWidget(
                              title: '',
                              isEnable: true,
                              margin: const EdgeInsets.only(left: 20),
                              onTap: onPaid,
                              child: Row(
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
                            ),
                          )
                        else if (dto?.status == 0)
                          Expanded(
                            child: MButtonWidget(
                              title: '',
                              isEnable: true,
                              margin: const EdgeInsets.only(left: 20),
                              onTap: () {
                                QRRecreateDTO qrRecreateDTO = QRRecreateDTO(
                                  bankId: dto?.bankId ?? '',
                                  amount: (dto?.amount ?? '').toString(),
                                  content: dto?.content ?? '',
                                  userId: UserInformationHelper.instance
                                      .getUserId(),
                                  newTransaction: false,
                                );
                                _bloc.add(
                                    TransEventQRRegenerate(dto: qrRecreateDTO));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/ic-qr-dashboard.png',
                                    color: AppColor.WHITE,
                                    width: 28,
                                    height: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Hiện mã QR',
                                    style: TextStyle(
                                      color: AppColor.WHITE,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            saveImage(context);
                          },
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
                          onTap: () {
                            shareImage(dto);
                          },
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
                  ),
                if (dto?.transType == 'D')
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ButtonIconWidget(
                              height: 40,
                              pathIcon: 'assets/images/ic-img-blue.png',
                              textColor: AppColor.BLUE_TEXT,
                              iconPathColor: AppColor.BLUE_TEXT,
                              iconSize: 22,
                              title: 'Lưu ảnh',
                              textSize: 12,
                              bgColor: AppColor.WHITE,
                              borderRadius: 5,
                              function: () async {
                                saveImage(context);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: ButtonIconWidget(
                              title: 'Chia sẻ',
                              height: 40,
                              pathIcon: 'assets/images/ic-share-blue.png',
                              textColor: AppColor.BLUE_TEXT,
                              bgColor: AppColor.WHITE,
                              iconPathColor: AppColor.BLUE_TEXT,
                              iconSize: 22,
                              borderRadius: 5,
                              textSize: 12,
                              function: () async {
                                shareImage(dto);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> saveImage(BuildContext context) async {
    _waterMarkProvider.updateWaterMark(true);
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.saveImageToGallery(globalKey).then((value) {
        _waterMarkProvider.updateWaterMark(false);
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: 'Đã lưu ảnh',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).cardColor,
          fontSize: 15,
        );
      });
    });
  }

  Future<void> shareImage(TransactionReceiveDTO? dto) async {
    _waterMarkProvider.updateWaterMark(true);
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance
          .shareImage(
            key: globalKey,
            textSharing:
                'Giao dịch ${TransactionUtils.instance.getStatusString(dto?.status ?? 0)} ${TransactionUtils.instance.getTransType(dto?.transType ?? '')} ${CurrencyUtils.instance.getCurrencyFormatted((dto?.amount ?? 0).toString())} VND\nĐược tạo bởi vietqr.vn - Hotline 1900.6234',
          )
          .then((value) => _waterMarkProvider.updateWaterMark(false));
    });
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
