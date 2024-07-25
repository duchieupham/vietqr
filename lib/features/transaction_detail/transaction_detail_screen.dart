import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/create_qr/create_qr_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/trans_update/trans_update_screen.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/notify_trans_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/models/transaction_receive_dto.dart';
import 'package:vierqr/services/providers/water_mark_provider.dart';

import 'blocs/transaction_bloc.dart';
import 'events/transaction_event.dart';
import 'states/transaction_state.dart';
import 'widgets/detail_image_view.dart';

class TransactionDetailScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  static String routeName = '/TransactionDetailScreen';

  @override
  Widget build(BuildContext context) {
    // return BlocProvider<TransactionBloc>(
    //   create: (BuildContext context) => TransactionBloc(
    //     transactionId: transactionId,
    //     transactionRepository: getIt.get<TransactionRepository>(),
    //   ),
    //   child: _BodyWidget(),
    // );

    return _BodyWidget(transactionId);
  }
}

class _BodyWidget extends StatefulWidget {
  const _BodyWidget(this.transactionId);

  final String transactionId;

  @override
  State<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<_BodyWidget> {
  late TransactionBloc _bloc;
  late AuthProvider authProvider;

  final noteController = TextEditingController();

  final globalKey = GlobalKey();
  final _waterMarkProvider = WaterMarkProvider(false);
  MerchantRole role = MerchantRole();

  @override
  void initState() {
    super.initState();
    // _bloc = BlocProvider.of(context);
    _bloc = getIt.get<TransactionBloc>(param1: widget.transactionId);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(context);
    });
  }

  void onRole(TransactionReceiveDTO dto) {
    bool isOwner = false;
    final banks = [...authProvider.listBank];
    BankAccountDTO bankDTO = banks.firstWhere(
        (element) => element.id == dto.bankId,
        orElse: () => BankAccountDTO());
    setState(() {
      isOwner = bankDTO.isOwner;
      role.isOwner = bankDTO.isOwner;
    });
    if (isOwner) return;

    SettingAccountDTO settingDTO = authProvider.settingDTO;
    List<MerchantRole> merchantRoles = [...settingDTO.merchantRoles];
    MerchantRole merchantDTO = merchantRoles.firstWhere(
        (element) => element.bankId == bankDTO.id,
        orElse: () => MerchantRole())
      ..isOwner = isOwner;
    if (merchantDTO.bankId.isEmpty) return;
    role = merchantDTO;
    setState(() {});
  }

  initData(BuildContext context) {
    _bloc.add(const TransactionEventGetDetail(isLoading: true));
  }

  Future<void> onRefresh() async {
    _bloc.add(const TransactionEventGetDetail());
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BlocConsumer<TransactionBloc, TransactionState>(
      bloc: _bloc,
      listener: (context, state) async {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state.status == BlocStatus.UNLOADING) {
          Navigator.pop(context);
        }

        if (state.type == TransactionType.LOAD_DATA) {
          onRole(state.dto!);
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
                context, CreateQrScreen(qrDto: state.qrGeneratedDTO),
                routeName: CreateQrScreen.routeName);
          } else {
            NavigatorUtils.navigatePage(
                context, CreateQrScreen(qrDto: state.qrGeneratedDTO, page: 1),
                routeName: CreateQrScreen.routeName);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const MAppBar(title: 'Chi tiết giao dịch'),
          body: Stack(
            children: [
              RefreshIndicator(
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
                            const Padding(padding: EdgeInsets.only(top: 24)),
                            SizedBox(
                              width: width,
                              child: Center(
                                child: Text(
                                  '${state.dto?.getTransType} ${state.dto?.getAmount} VND',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: state.dto?.getColorStatus,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: width,
                              child: Center(
                                child: Text(
                                  state.dto?.getStatus ?? '',
                                  style: TextStyle(
                                    color: state.dto?.getColorStatus,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildInfoTransWidget(state, width),
                            const SizedBox(height: 24),
                            _buildAccountWidget(state, width),
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
                            const SizedBox(height: 24),
                            _buildImagesWidget(state, width),
                            UnconstrainedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ghi chú',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: width - 40,
                                    child: TextFieldCustom(
                                      isObscureText: false,
                                      fillColor: AppColor.WHITE,
                                      title: '',
                                      contentPadding: const EdgeInsets.symmetric(
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
                            const SizedBox(height: 24),
                            _buildButtonWidget(state),
                            const SizedBox(height: 12),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (state.status == BlocStatus.LOADING_PAGE)
                const Positioned(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
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
      padding: const EdgeInsets.only(bottom: 16.0),
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
          textColor: Theme.of(context).hintColor,
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

  void onDetailImage(String image) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailImageView(image: image),
      ),
    );
  }

  Widget _buildImagesWidget(TransactionState state, double width) {
    if (state.listImage.isEmpty) return const SizedBox.shrink();
    return UnconstrainedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tệp đính kèm',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            width: width - 40,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.WHITE,
            ),
            child: Row(
              children: [
                Text(
                  '${state.listImage.length} tệp đính kèm',
                  style: const TextStyle(color: AppColor.GREY_TEXT),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onDetailImage(state.listImage.elementAt(0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Xem',
                          style: TextStyle(
                            color: AppColor.BLUE_TEXT,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: List.generate(
                            state.listImage.length,
                            (index) {
                              String url = state.listImage[index];
                              return _buildItemImage(url);
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildItemImage(String url) {
    return GestureDetector(
      onTap: () => onDetailImage(url),
      child: Container(
        width: 100,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColor.WHITE,
          image: DecorationImage(
            image: ImageUtils.instance.getImageNetWork(url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTransWidget(TransactionState state, double width) {
    return UnconstrainedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin giao dịch',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                        state.dto?.time ?? 0, false,
                        isShowHHmmFirst: true)),
                if (state.dto?.type != 0)
                  _buildItem(
                      'Thời gian thanh toán:',
                      TimeUtils.instance.formatDateFromInt(
                          state.dto?.timePaid ?? 0, false,
                          isShowHHmmFirst: true)),
                if (state.dto!.referenceNumber.isNotEmpty)
                  _buildItem('Mã giao dịch:', state.dto?.referenceNumber ?? ''),
                if (state.dto!.orderId.isNotEmpty)
                  _buildItem('Mã đơn hàng:', state.dto?.orderId ?? ''),
                if (state.dto!.terminalCode.isNotEmpty)
                  _buildItem('Mã điểm bán:', state.dto?.terminalCode ?? ''),
                _buildItem(
                  'Trạng thái:',
                  TransactionUtils.instance
                      .getStatusString(state.dto?.status ?? 0),
                  style: TextStyle(
                    color: TransactionUtils.instance.getColorStatus(
                      state.dto?.status ?? 0,
                      state.dto?.type ?? 0,
                      state.dto?.transType ?? 'D',
                    ),
                  ),
                ),
                _buildItem(
                  'Loại giao dịch:',
                  state.dto?.getTitleType() ?? 'Khác',
                ),
                _buildItem(
                  'Nội dung:',
                  state.dto?.content ?? '',
                  style: const TextStyle(color: AppColor.GREY_TEXT),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountWidget(TransactionState state, double width) {
    return UnconstrainedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tài khoản nhận',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        state.dto?.bankCode ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColor.WHITE,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppColor.GREY_TOP_TAB_BAR,
                            width: 0.5,
                          ),
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: ImageUtils.instance
                                .getImageNetWork(state.dto?.imgId ?? ''),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildItem('Số tài khoản', state.dto?.bankAccount ?? ''),
                const SizedBox(height: 6),
                _buildItem(
                  'Tên tài khoản',
                  (state.dto?.bankAccountName ?? '').toUpperCase(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonWidget(TransactionState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          MButtonWidget(
            title: 'Cập nhật ghi chú',
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.only(bottom: 12),
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
          if ((state.dto?.transType.trim() != 'D') && role.isAdmin ||
              role.isRequestTrans)
            MButtonWidget(
              title: 'Cập nhật cửa hàng',
              padding: const EdgeInsets.symmetric(horizontal: 20),
              colorEnableBgr: AppColor.BLUE_TEXT,
              colorEnableText: AppColor.WHITE,
              isEnable: true,
              margin: const EdgeInsets.only(bottom: 12),
              onTap: () => onUpdateTerminal(state.dto!),
            ),
        ],
      ),
    );
  }

  void onUpdateTerminal(TransactionReceiveDTO dto) async {
    NotifyTransDTO data = NotifyTransDTO(
      traceId: dto.traceId,
      transactionReceiveId: dto.id,
      bankAccount: dto.bankAccount,
      bankName: dto.bankName,
      bankCode: dto.bankCode,
      amount: dto.amount.toString(),
      bankId: dto.bankId,
      time: dto.time,
      timePaid: dto.timePaid,
      refId: dto.refId,
      referenceNumber: dto.referenceNumber,
      terminalCode: dto.terminalCode,
      transType: dto.transType,
    );

    await NavigatorUtils.navigatePage(
        context, TransUpdateScreen(dto: data, role: role),
        routeName: TransUpdateScreen.routeName);

    onRefresh();
  }
}
