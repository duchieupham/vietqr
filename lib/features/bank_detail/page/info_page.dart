import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dudv_base/dudv_base.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/utils/printer_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_remove_dto.dart';
import 'package:vierqr/services/sqflite/local_database.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/features/create_qr/create_qr_screen.dart';
import 'package:vierqr/features/printer/views/printing_view.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class InfoDetailBankAccount extends StatefulWidget {
  final BankCardBloc bloc;
  final RefreshCallback refresh;
  final AccountBankDetailDTO dto;
  final QRGeneratedDTO qrGeneratedDTO;
  final String bankId;
  final GestureTapCallback? onChangePage;

  InfoDetailBankAccount({
    Key? key,
    required this.bloc,
    required this.refresh,
    required this.dto,
    required this.qrGeneratedDTO,
    required this.bankId,
    this.onChangePage,
  }) : super(key: key);

  @override
  State<InfoDetailBankAccount> createState() => _InfoDetailBankAccountState();
}

class _InfoDetailBankAccountState extends State<InfoDetailBankAccount> {
  String get userId => UserInformationHelper.instance.getUserId();

  final globalKey = GlobalKey();

  void onSaveImage(BuildContext context) async {
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await ShareUtils.instance.saveImageToGallery(globalKey).then(
          (value) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).cardColor,
              fontSize: 15,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.refresh,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RepaintBoundaryWidget(
                    globalKey: globalKey,
                    builder: (key) {
                      return VietQr(
                          qrGeneratedDTO: widget.qrGeneratedDTO,
                          isVietQR: true);
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  _buildTitle(title: 'Thông tin liên kết'),
                  BoxLayout(
                    width: width,
                    borderRadius: 8,
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: (widget.dto.bankCode.trim().toUpperCase() != 'MB')
                          ? 20
                          : 0,
                    ),
                    child: Column(
                      children: [
                        _buildElement(
                          context: context,
                          width: width,
                          title: 'Trạng thái',
                          isAuthenticated: widget.dto.authenticated,
                          description: (widget.dto.authenticated)
                              ? 'Đã liên kết'
                              : 'Chưa liên kết',
                        ),
                        if (!widget.dto.authenticated) ...[
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          const Text(
                            'Liên kết TK ngân hàng để nhận thông báo biến động số dư',
                            style: TextStyle(
                              // fontSize: 12,
                              color: AppColor.GREY_TEXT,
                            ),
                          ),
                        ],
                        if (widget.dto.nationalId.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: _buildElement(
                              context: context,
                              width: width,
                              title: 'CCCD/CMT',
                              description: widget.dto.nationalId,
                            ),
                          ),
                        ],
                        if (widget.dto.phoneAuthenticated.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: _buildElement(
                              context: context,
                              width: width,
                              title: 'SĐT xác thực',
                              description: widget.dto.phoneAuthenticated,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        if (!widget.dto.authenticated &&
                            widget.dto.bankCode.trim().toUpperCase() == 'MB' &&
                            (userId == widget.dto.userId)) ...[
                          DividerWidget(width: width),
                          const SizedBox(height: 10),
                          ButtonIconWidget(
                            width: width,
                            icon: Icons.link_rounded,
                            title: 'Liên kết ngay',
                            function: () {
                              BankTypeDTO bankTypeDTO = BankTypeDTO(
                                id: widget.dto.bankTypeId,
                                bankCode: widget.dto.bankCode,
                                bankName: widget.dto.bankName,
                                imageId: widget.dto.imgId,
                                bankShortName: widget.dto.bankCode,
                                status: widget.dto.bankTypeStatus,
                                caiValue: widget.dto.caiValue,
                                bankId: widget.dto.id,
                                bankAccount: widget.dto.bankAccount,
                                userBankName: widget.dto.userBankName,
                              );

                              NavigatorUtils.navigatePage(context,
                                      AddBankScreen(bankTypeDTO: bankTypeDTO),
                                      routeName: AddBankScreen.routeName)
                                  .then((value) {
                                if (value is bool) {
                                  widget.bloc
                                      .add(const BankCardGetDetailEvent());
                                }
                              });

                              // Navigator.pushNamed(
                              //   context,
                              //   Routes.ADD_BANK_CARD,
                              //   arguments: {
                              //     'step': 1,
                              //     'bankAccount': widget.dto.bankAccount,
                              //     'name': widget.dto.userBankName,
                              //     'bankDTO': bankTypeDTO,
                              //     'bankId': widget.dto.id,
                              //   },
                              // ).then((value) {
                              //   if (value is bool) {
                              //     widget.bloc
                              //         .add(const BankCardGetDetailEvent());
                              //   }
                              // });
                            },
                            bgColor: AppColor.TRANSPARENT,
                            textColor: AppColor.GREEN,
                          ),
                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  if (userId == widget.dto.userId) ...[
                    const SizedBox(height: 16),
                    _buildTitle(title: 'Thiết lập nâng cao'),
                    BoxLayout(
                      width: width,
                      borderRadius: 8,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.dto.authenticated)
                            ButtonIconWidget(
                              width: width,
                              height: 40,
                              bgColor: AppColor.TRANSPARENT,
                              textColor: AppColor.BLUE_TEXT,
                              icon: Icons.remove_circle_outline,
                              iconSize: 18,
                              customPaddingIcon:
                                  const EdgeInsets.only(right: 20),
                              alignment: Alignment.centerLeft,
                              title: 'Huỷ liên kết TK ngân hàng',
                              function: () {
                                DialogWidget.instance.openMsgDialog(
                                  title: 'Huỷ liên kết',
                                  msg: 'Bạn có chắc chắn muốn huỷ liên kết?',
                                  isSecondBT: true,
                                  functionConfirm: () {
                                    Navigator.of(context).pop();
                                    widget.bloc.add(
                                      BankCardEventUnlink(
                                          accountNumber:
                                              widget.dto.bankAccount),
                                    );
                                  },
                                );
                              },
                            ),
                          ButtonIconWidget(
                            width: width,
                            height: 40,
                            bgColor: AppColor.TRANSPARENT,
                            textColor: AppColor.BLUE_TEXT,
                            icon: Icons.delete_outline,
                            iconSize: 18,
                            customPaddingIcon: const EdgeInsets.only(right: 20),
                            alignment: Alignment.centerLeft,
                            title: 'Xoá TK ngân hàng',
                            function: () {
                              if (widget.dto.authenticated) {
                                DialogWidget.instance.openMsgDialog(
                                  title: 'Cảnh báo',
                                  msg:
                                      'Bạn phải huỷ liên kết Tk ngân hàng này trước khi xoá',
                                );
                              } else {
                                BankAccountRemoveDTO bankAccountRemoveDTO =
                                    BankAccountRemoveDTO(
                                  bankId: widget.bankId,
                                  type: widget.dto.type,
                                  isAuthenticated: widget.dto.authenticated,
                                );
                                widget.bloc.add(BankCardEventRemove(
                                    dto: bankAccountRemoveDTO));
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        SizedBox(
          width: width,
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonIconWidget(
                width: width * 0.2,
                height: 40,
                pathIcon: 'assets/images/ic-print-blue.png',
                title: '',
                function: () async {
                  BluetoothPrinterDTO bluetoothPrinterDTO =
                      await LocalDatabase.instance.getBluetoothPrinter(userId);
                  if (bluetoothPrinterDTO.id.isNotEmpty) {
                    bool isPrinting = false;
                    if (!isPrinting) {
                      isPrinting = true;
                      DialogWidget.instance.showFullModalBottomContent(
                          widget: const PrintingView());
                      await PrinterUtils.instance
                          .print(widget.qrGeneratedDTO)
                          .then((value) {
                        Navigator.pop(context);
                        isPrinting = false;
                      });
                    }
                  } else {
                    DialogWidget.instance.openMsgDialog(
                        title: 'Không thể in',
                        msg:
                            'Vui lòng kết nối với máy in để thực hiện việc in.');
                  }
                },
                bgColor: Theme.of(context).cardColor,
                textColor: AppColor.ORANGE,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              ButtonIconWidget(
                width: width * 0.2,
                height: 40,
                pathIcon: 'assets/images/ic-edit-avatar-setting.png',
                title: '',
                function: () {
                  Provider.of<AuthProvider>(context, listen: false)
                      .updateAction(false);
                  onSaveImage(context);
                },
                bgColor: Theme.of(context).cardColor,
                textColor: AppColor.RED_CALENDAR,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              ButtonIconWidget(
                width: width * 0.2,
                height: 40,
                pathIcon: 'assets/images/ic-copy-blue.png',
                title: '',
                function: () async {
                  await FlutterClipboard.copy(ShareUtils.instance
                          .getTextSharing(widget.qrGeneratedDTO))
                      .then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Theme.of(context).cardColor,
                      textColor: Theme.of(context).hintColor,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
                bgColor: Theme.of(context).cardColor,
                textColor: AppColor.BLUE_TEXT,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              ButtonIconWidget(
                width: width * 0.2,
                height: 40,
                pathIcon: 'assets/images/ic-share-blue.png',
                title: '',
                function: () {
                  Provider.of<AuthProvider>(context, listen: false)
                      .updateAction(false);
                  Navigator.pushNamed(context, Routes.QR_SHARE_VIEW,
                      arguments: {'qrGeneratedDTO': widget.qrGeneratedDTO});
                },
                bgColor: Theme.of(context).cardColor,
                textColor: AppColor.BLUE_TEXT,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Row(
          children: [
            ButtonIconWidget(
              height: 40,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              iconSize: 28,
              pathIcon: 'assets/images/ic-trans-history.png',
              bgColor: AppColor.WHITE,
              textSize: 12,
              title: 'Lịch sử giao dịch',
              function: () {
                widget.onChangePage!();
              },
              textColor: AppColor.BLUE_TEXT,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ButtonIconWidget(
                height: 40,
                icon: Icons.add_rounded,
                textSize: 12,
                title: 'Tạo QR giao dịch',
                function: () {
                  BankAccountDTO bankAccountDTO = BankAccountDTO(
                    id: widget.dto.id,
                    bankAccount: widget.dto.bankAccount,
                    userBankName: widget.dto.userBankName,
                    bankCode: widget.dto.bankCode,
                    bankName: widget.dto.bankName,
                    imgId: widget.dto.imgId,
                    type: widget.dto.type,
                    isAuthenticated: widget.dto.authenticated,
                  );
                  NavigatorUtils.navigatePage(
                      context, CreateQrScreen(bankAccountDTO: bankAccountDTO),
                      routeName: CreateQrScreen.routeName);
                  // Navigator.pushNamed(
                  //   context,
                  //   Routes.CREATE_QR,
                  //   arguments: {'bankInfo': bankAccountDTO},
                  // );
                },
                textColor: AppColor.WHITE,
                bgColor: AppColor.BLUE_TEXT,
              ),
            ),
          ],
        ),
        Padding(
            padding: EdgeInsets.only(
                bottom: (PlatformUtils.instance.isIOsApp()) ? 20 : 20)),
      ],
    );
  }

  Widget _buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget _buildElement(
      {required BuildContext context,
      required double width,
      required String title,
      required String description,
      bool? isAuthenticated}) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
            ),
          ),
          const Spacer(),
          if (isAuthenticated != null) ...[
            Icon(
              (isAuthenticated)
                  ? Icons.check_rounded
                  : Icons.pending_actions_rounded,
              size: 18,
              color: (isAuthenticated) ? AppColor.BLUE_TEXT : AppColor.ORANGE,
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
          ],
          Text(
            description,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: (isAuthenticated != null && isAuthenticated)
                  ? AppColor.BLUE_TEXT
                  : (isAuthenticated != null && !isAuthenticated)
                      ? AppColor.ORANGE
                      : Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
