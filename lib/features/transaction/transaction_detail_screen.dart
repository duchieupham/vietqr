import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/create_qr/create_qr_screen.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
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

  final noteController = TextEditingController();

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
          noteController.text = state.dto?.note ?? '';
          _bloc.add(const TransactionEventGetImage(isLoading: false));
        }

        if (state.type == TransactionType.UPDATE_NOTE) {
          Fluttertoast.showToast(
            msg: 'Cập nhật thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }

        if (state.type == TransactionType.REFRESH) {
          if (state.newTransaction) {
            await NavigatorUtils.navigatePage(
                context, CreateQrScreen(qrDto: state.qrGeneratedDTO));
          } else {
            NavigatorUtils.navigatePage(
                context, CreateQrScreen(qrDto: state.qrGeneratedDTO, page: 1));
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const MAppBar(title: 'Chi tiết giao dịch'),
          body: RefreshIndicator(
            onRefresh: onRefresh,
            child: Visibility(
              visible: state.dto?.id != null,
              child: RepaintBoundaryWidget(
                globalKey: globalKey,
                builder: (key) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    height: MediaQuery.of(context).size.height,
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
                                color: TransactionUtils.instance.getColorStatus(
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
                                color: TransactionUtils.instance.getColorStatus(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thông tin giao dịch',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              BoxLayout(
                                borderRadius: 5,
                                width: width - 40,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    _buildItem(
                                        'Thời gian tạo:',
                                        TimeUtils.instance.formatDateFromInt(
                                            state.dto?.time ?? 0, false)),
                                    if (state.dto?.type != 0)
                                      _buildItem(
                                          'Thời gian thanh toán:',
                                          TimeUtils.instance.formatDateFromInt(
                                              state.dto?.timePaid ?? 0, false)),
                                    if (state.dto!.referenceNumber.isNotEmpty)
                                      _buildItem('Mã giao dịch:',
                                          state.dto?.referenceNumber ?? ''),
                                    if (state.dto!.orderId.isNotEmpty)
                                      _buildItem('Mã đơn hàng:',
                                          state.dto?.orderId ?? ''),
                                    if (state.dto!.terminalCode.isNotEmpty)
                                      _buildItem('Mã điểm bán:',
                                          state.dto?.terminalCode ?? ''),
                                    _buildItem(
                                      'Trạng thái:',
                                      TransactionUtils.instance.getStatusString(
                                          state.dto?.status ?? 0),
                                      style: TextStyle(
                                        color: TransactionUtils.instance
                                            .getColorStatus(
                                          state.dto?.status ?? 0,
                                          state.dto?.type ?? 0,
                                          state.dto?.transType ?? 'D',
                                        ),
                                      ),
                                    ),
                                    _buildItem(
                                      'Loại giao dịch:',
                                      state.dto?.type == 0 ? 'VietQR' : 'Khác',
                                    ),
                                    _buildItem(
                                      'Nội dung:',
                                      state.dto?.content ?? '',
                                      style: const TextStyle(
                                          color: AppColor.GREY_TEXT),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        UnconstrainedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tài khoản nhận',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              BoxLayout(
                                borderRadius: 5,
                                width: width - 40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    _buildItem(
                                      'Ngân hàng',
                                      state.dto?.bankCode ?? '',
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${state.dto?.bankCode ?? ''}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            width: 24,
                                            height: 24,
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
                                    _buildItem('Số tài khoản',
                                        state.dto?.bankAccount ?? ''),
                                    const SizedBox(height: 6),
                                    _buildItem(
                                      'Tên tài khoản',
                                      (state.dto?.bankAccountName ?? '')
                                          .toUpperCase(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                        if (state.listImage.isNotEmpty)
                          UnconstrainedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tệp đính kèm',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: width - 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColor.WHITE,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${state.listImage.length} tệp đính kèm',
                                        style: TextStyle(
                                            color: AppColor.GREY_TEXT),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Xem',
                                                style: TextStyle(
                                                  color: AppColor.BLUE_TEXT,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Row(
                                                children: List.generate(
                                                  state.listImage.length,
                                                  (index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                DetailImageView(
                                                                    image: state
                                                                        .listImage
                                                                        .elementAt(
                                                                            index)),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 100,
                                                        height: 160,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: AppColor.WHITE,
                                                          image:
                                                              DecorationImage(
                                                            image: ImageUtils
                                                                .instance
                                                                .getImageNetWork(
                                                                    state.listImage[
                                                                        index]),
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
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        UnconstrainedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ghi chú',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: width - 40,
                                child: TextFieldCustom(
                                  isObscureText: false,
                                  maxLines: 4,
                                  fillColor: AppColor.WHITE,
                                  title: '',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  controller: noteController,
                                  hintText: 'Nhập ghi chú tại đây',
                                  inputType: TextInputType.text,
                                  keyboardAction: TextInputAction.next,
                                  onChange: (value) {},
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            MButtonWidget(
                              title: 'Cập nhật ghi chú',
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              colorEnableBgr: AppColor.BLUE_TEXT,
                              colorEnableText: AppColor.WHITE,
                              isEnable: true,
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();

                                Map<String, dynamic> body = {
                                  'note': noteController.text,
                                  'id': state.dto?.id,
                                };
                                _bloc.add(UpdateNoteEvent(body));
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem(
    String title,
    String value, {
    TextStyle? style,
    int? maxLines,
    Widget? child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColor.GREY_TEXT),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: child ??
                Text(
                  value,
                  style: style,
                  maxLines: maxLines,
                  textAlign: TextAlign.right,
                ),
          ),
        ],
      ),
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
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColor.GREY_TEXT,
              ),
            ),
          ),
          Expanded(
            flex: 3,
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
