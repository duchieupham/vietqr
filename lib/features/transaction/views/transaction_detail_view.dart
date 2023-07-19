import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/business/events/business_information_event.dart';
import 'package:vierqr/features/generate_qr/blocs/qr_blocs.dart';
import 'package:vierqr/features/generate_qr/events/qr_event.dart';
import 'package:vierqr/features/generate_qr/states/qr_state.dart';
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features/notification/events/notification_event.dart';
import 'package:vierqr/features/transaction/blocs/transaction_bloc.dart';
import 'package:vierqr/features/transaction/events/transaction_event.dart';
import 'package:vierqr/features/transaction/states/transaction_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/notification_input_dto.dart';
import 'package:vierqr/models/qr_recreate_dto.dart';
import 'package:vierqr/models/transaction_input_dto.dart';
import 'package:vierqr/models/transaction_receive_dto.dart';
import 'package:vierqr/services/providers/water_mark_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QRBloc>(
      create: (BuildContext context) => QRBloc(),
      child: TransactionDetailView(),
    );
  }
}

class TransactionDetailView extends StatelessWidget {
  final GlobalKey globalKey = GlobalKey();
  final WaterMarkProvider _waterMarkProvider = WaterMarkProvider(false);
  static late TransactionBloc transactionBloc;
  static late QRBloc qrBloc;
  static TransactionReceiveDTO dto = const TransactionReceiveDTO(
    time: 0,
    status: 0,
    id: '',
    type: 0,
    content: '',
    bankAccount: '',
    bankAccountName: '',
    bankId: '',
    bankCode: '',
    bankName: '',
    imgId: '',
    amount: 0,
    transType: '',
    traceId: '',
    refId: '',
    referenceNumber: '',
  );

  TransactionDetailView({super.key});

  void initialServices(BuildContext context, String transactionId) {
    qrBloc = BlocProvider.of(context);
    transactionBloc = BlocProvider.of(context);
    transactionBloc.add(TransactionEventGetDetail(id: transactionId));
  }

  Future<void> _refresh(String transactionId) async {
    transactionBloc.add(TransactionEventGetDetail(id: transactionId));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String transactionId = args['transactionId'] ?? '';

    initialServices(context, transactionId);
    return Scaffold(
      appBar: const MAppBar(title: 'Chi tiết giao dịch'),
      body: BlocConsumer<QRBloc, QRState>(
        listener: (context, state) {
          if (state is QRRegenerateLoadingState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is QRRegeneratedSuccessState) {
            //pop loading
            Navigator.pop(context);
            if (state.newTransaction) {
              Navigator.pushReplacementNamed(
                context,
                Routes.QR_GENERATED,
                arguments: {
                  'qrGeneratedDTO': state.dto,
                },
              ).then((value) {
                //refresh transaction history
                if (args['transactionBloc'] != null) {
                  String bankId = args['bankId'];
                  TransactionBloc bloc = args['transactionBloc'];
                  TransactionInputDTO transactionInputDTO = TransactionInputDTO(
                    bankId: bankId,
                    offset: 0,
                  );
                  bloc.add(TransactionEventGetList(dto: transactionInputDTO));
                }
                //refresh bank detail
                if (args['bankCardBloc'] != null) {}
                //refresh notification list
                if (args['notificationBloc'] != null) {
                  String userId = args['userId'];
                  NotificationBloc bloc = args['notificationBloc'];
                  NotificationInputDTO dto =
                      NotificationInputDTO(userId: userId, offset: 0);
                  bloc.add(NotificationGetListEvent(dto: dto));
                }
                //refresh business information dashboard
                if (args['businessInformationBloc'] != null) {
                  String userId = args['userId'];
                  BusinessInformationBloc bloc =
                      args['businessInformationBloc'];
                  bloc.add(
                    BusinessInformationEventGetList(
                      userId: userId,
                    ),
                  );
                }
                //refresh business information detail
                if (args['businessInformationBlocDetail'] != null) {
                  String userId = args['userId'];
                  String businessId = args['businessId'];
                  BusinessInformationBloc bloc =
                      args['businessInformationBlocDetail'];
                  bloc.add(
                    BusinessGetDetailEvent(
                      businessId: businessId,
                      userId: userId,
                    ),
                  );
                }
                //refresh business transaction history
                // if (args['businessTransactionBloc'] != null) {
                //   TransactionBloc bloc = args['businessTransactionBloc'];
                //   Future.delayed(const Duration(milliseconds: 200), () {
                //     bloc.add(
                //       TransactionEventGetListBranch(
                //         dto: TransactionBranchInputDTO(
                //             businessId:
                //                 Provider.of<BusinessInformationProvider>(
                //                         context,
                //                         listen: false)
                //                     .businessId,
                //             branchId: 'all',
                //             offset: 0),
                //       ),
                //     );
                //   });
                // }
              });
            } else {
              Navigator.pushNamed(
                context,
                Routes.QR_GENERATED,
                arguments: {
                  'qrGeneratedDTO': state.dto,
                },
              ).then((value) => transactionBloc
                  .add(TransactionEventGetDetail(id: transactionId)));
            }
          }
          if (state is QRRegeneratedFailedState) {
            //pop loading
            Navigator.pop(context);
            DialogWidget.instance.openMsgDialog(
              title: 'Lỗi',
              msg: 'Không thể thực hiện thao tác này. Vui lòng thử lại sau',
            );
          }
        },
        builder: (context, state) {
          return BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              dto = const TransactionReceiveDTO(
                time: 0,
                status: 0,
                id: '',
                type: 0,
                content: '',
                bankAccount: '',
                bankAccountName: '',
                bankId: '',
                bankCode: '',
                bankName: '',
                imgId: '',
                amount: 0,
                transType: '',
                traceId: '',
                refId: '',
                referenceNumber: '',
              );
              if (state is TransactionDetailSuccessState) {
                dto = state.dto;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await _refresh(transactionId);
                      },
                      child: Visibility(
                        visible: dto.id.isNotEmpty,
                        child: RepaintBoundaryWidget(
                          globalKey: globalKey,
                          builder: (key) {
                            return Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(top: 30)),
                                  SizedBox(
                                    width: width,
                                    child: Center(
                                      child: Text(
                                        '${TransactionUtils.instance.getTransType(dto.transType)} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount.toString())} VND',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: TransactionUtils.instance
                                              .getColorStatus(
                                            dto.status,
                                            dto.type,
                                            dto.transType,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 5)),
                                  SizedBox(
                                    width: width,
                                    child: Center(
                                      child: Text(
                                        TransactionUtils.instance
                                            .getStatusString(dto.status),
                                        style: TextStyle(
                                          color: TransactionUtils.instance
                                              .getColorStatus(
                                            dto.status,
                                            dto.type,
                                            dto.transType,
                                          ),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 30)),
                                  UnconstrainedBox(
                                    child: BoxLayout(
                                      width: width - 40,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10)),
                                          Text(
                                            TransactionUtils.instance
                                                .getPrefixBankAccount(
                                                    dto.transType),
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
                                                    '${dto.bankCode} - ${dto.bankName}',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: AppColor.WHITE,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    border: Border.all(
                                                      color: AppColor
                                                          .GREY_TOP_TAB_BAR,
                                                      width: 0.5,
                                                    ),
                                                    image: DecorationImage(
                                                      fit: BoxFit.contain,
                                                      image: ImageUtils.instance
                                                          .getImageNetWork(
                                                              dto.imgId),
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
                                            content: dto.bankAccountName
                                                .toUpperCase(),
                                            isBold: true,
                                          ),
                                          _buildElement1(
                                            context: context,
                                            width: width - 40,
                                            content: dto.bankAccount,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: DividerWidget(
                                                width: width - 40),
                                          ),
                                          _buildElement2(
                                            context: context,
                                            title: 'Thời gian',
                                            content: TimeUtils.instance
                                                .formatDateFromInt(
                                                    dto.time, false),
                                            width: width - 40,
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10)),
                                          if (dto.referenceNumber
                                              .trim()
                                              .isNotEmpty) ...[
                                            _buildElement2(
                                              context: context,
                                              title: 'Mã giao dịch',
                                              content: dto.referenceNumber,
                                              width: width - 40,
                                            ),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10)),
                                          ],
                                          _buildElement2(
                                            context: context,
                                            title: 'Nội dung',
                                            content: dto.content,
                                            width: width - 40,
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10)),
                                          // _buildElement2(
                                          //   context: context,
                                          //   title: 'Trạng thái',
                                          //   content: TransactionUtils.instance
                                          //       .getStatusString(dto.status),
                                          //   width: width - 40,
                                          //   isBold: true,
                                          //   color: TransactionUtils.instance
                                          //       .getColorStatus(
                                          //     dto.status,
                                          //     dto.type,
                                          //     dto.transType,
                                          //   ),
                                          // ),
                                          // const Padding(
                                          //     padding: EdgeInsets.only(top: 10)),
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
                                  const Padding(
                                      padding: EdgeInsets.only(top: 30)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  if (dto.transType == 'D')
                    SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonIconWidget(
                            width: width / 2 - 25,
                            height: 40,
                            icon: Icons.photo_rounded,
                            title: 'Lưu ảnh',
                            function: () async {
                              await saveImage(context);
                            },
                            bgColor: Theme.of(context).cardColor,
                            textColor: AppColor.RED_CALENDAR,
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          ButtonIconWidget(
                            width: width / 2 - 25,
                            height: 40,
                            icon: Icons.share_rounded,
                            title: 'Chia sẻ',
                            function: () async {
                              await shareImage();
                            },
                            bgColor: Theme.of(context).cardColor,
                            textColor: AppColor.GREEN,
                          ),
                        ],
                      ),
                    ),
                  if (dto.transType == 'C')
                    SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (dto.status == 0)
                            ButtonIconWidget(
                              width: width * 0.5,
                              height: 40,
                              icon: Icons.qr_code_rounded,
                              title: 'Hiện mã QR',
                              function: () {
                                QRRecreateDTO qrRecreateDTO = QRRecreateDTO(
                                  bankId: dto.bankId,
                                  amount: dto.amount.toString(),
                                  content: dto.content,
                                  userId: UserInformationHelper.instance
                                      .getUserId(),
                                  newTransaction: false,
                                );
                                qrBloc
                                    .add(QREventRegenerate(dto: qrRecreateDTO));
                              },
                              bgColor: AppColor.ORANGE,
                              textColor: AppColor.WHITE,
                            ),
                          if (dto.status != 0)
                            ButtonIconWidget(
                              width: width * 0.5,
                              height: 40,
                              icon: Icons.refresh_rounded,
                              title: 'Thực hiện lại',
                              function: () {
                                QRRecreateDTO qrRecreateDTO = QRRecreateDTO(
                                  bankId: dto.bankId,
                                  amount: dto.amount.toString(),
                                  content: dto.content,
                                  userId: UserInformationHelper.instance
                                      .getUserId(),
                                  newTransaction: true,
                                );
                                qrBloc
                                    .add(QREventRegenerate(dto: qrRecreateDTO));
                              },
                              bgColor: AppColor.GREEN,
                              textColor: AppColor.WHITE,
                            ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          ButtonIconWidget(
                            width: width * 0.25 - 30,
                            height: 40,
                            icon: Icons.photo_rounded,
                            title: '',
                            function: () async {
                              await saveImage(context);
                            },
                            bgColor: Theme.of(context).cardColor,
                            textColor: AppColor.RED_CALENDAR,
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          ButtonIconWidget(
                            width: width * 0.25 - 30,
                            height: 40,
                            icon: Icons.share_rounded,
                            title: '',
                            function: () async {
                              await shareImage();
                            },
                            bgColor: Theme.of(context).cardColor,
                            textColor: AppColor.GREEN,
                          ),
                        ],
                      ),
                    ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                ],
              );
            },
          );
        },
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

  Future<void> shareImage() async {
    _waterMarkProvider.updateWaterMark(true);
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance
          .shareImage(
            key: globalKey,
            textSharing:
                'Giao dịch ${TransactionUtils.instance.getStatusString(dto.status)} ${TransactionUtils.instance.getTransType(dto.transType)} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount.toString())} VND\nĐược tạo bởi vietqr.vn - Hotline 19006234',
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
