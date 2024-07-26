import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/widget_qr.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_detail_bank.dart';
import 'package:vierqr/features/create_qr/create_qr_screen.dart';
import 'package:vierqr/features/merchant/create_merchant_screen.dart';
import 'package:vierqr/features/merchant/merchant_screen.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_account_remove_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/merchant_dto.dart';
import 'package:vierqr/models/qr_bank_detail.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class InfoDetailBankAccount extends StatefulWidget {
  final BankCardBloc bloc;
  final RefreshCallback refresh;
  final AccountBankDetailDTO dto;
  final QRGeneratedDTO qrGeneratedDTO;
  final String bankId;
  final bool isRegisterMerchant;
  final MerchantDTO? merchantDTO;
  final GestureTapCallback? onChangePage;
  final GestureTapCallback? onChangePageThongKe;
  final Function(QRDetailBank) updateQRGeneratedDTO;

  const InfoDetailBankAccount({
    super.key,
    required this.bloc,
    required this.refresh,
    required this.dto,
    required this.qrGeneratedDTO,
    required this.bankId,
    this.onChangePage,
    this.onChangePageThongKe,
    this.merchantDTO,
    this.isRegisterMerchant = false,
    required this.updateQRGeneratedDTO,
  });

  @override
  State<InfoDetailBankAccount> createState() => _InfoDetailBankAccountState();
}

class _InfoDetailBankAccountState extends State<InfoDetailBankAccount> {
  String get userId => SharePrefUtils.getProfile().userId;

  final globalKey = GlobalKey();

  bool get small => MediaQuery.of(context).size.width < 400;

  bool get isMerchant =>
      widget.dto.bankCode != 'BIDV' &&
      widget.dto.authenticated &&
      widget.dto.userId == SharePrefUtils.getProfile().userId;

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
              textColor: Theme.of(context).hintColor,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RefreshIndicator(
              onRefresh: widget.refresh,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: small ? 8 : 12),
                    Center(
                      child: Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            '${5 - (widget.dto.transCount ?? 0)}/5 GD miễn phí',
                            style: const TextStyle(
                                fontSize: 12, color: AppColor.BLUE_TEXT),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: small ? 8 : 12),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Nhận tiền từ mọi ngân hàng và ví điện thử có hỗ trợ VietQR',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    RepaintBoundaryWidget(
                      globalKey: globalKey,
                      builder: (key) {
                        return WidgetQr(
                          qrGeneratedDTO: widget.qrGeneratedDTO,
                          isVietQR: true,
                          updateQRGeneratedDTO: widget.updateQRGeneratedDTO,
                        );
                      },
                    ),
                    if (widget.dto.bankTypeStatus == 1) _buildStatusConnect(),
                    const Padding(padding: EdgeInsets.only(top: 16)),
                    _buildTitle(title: 'Thông tin tài khoản'),
                    BoxLayout(
                      width: width,
                      borderRadius: 8,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              DialogWidget.instance.showModelBottomSheet(
                                borderRadius: BorderRadius.circular(16),
                                widget: BottomSheetDetail(
                                  dto: widget.dto,
                                ),
                              );
                            },
                            child: _buildElement(
                              icon: 'assets/images/ic-detail-blue.png',
                              context: context,
                              width: width,
                              title: 'Chi tiết tài khoản',
                              description: 'Xem thông tin liên kết tài khoản',
                            ),
                          ),
                          if (isMerchant) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: DividerWidget(width: width),
                            ),
                            GestureDetector(
                              onTap: _onMerchant,
                              child: _buildElement(
                                icon: 'assets/images/ic-business-blue.png',
                                context: context,
                                width: width,
                                title: 'Đại lý',
                                description:
                                    'Quản lý doanh nghiệp, các hoá đơn thanh toán',
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: DividerWidget(width: width),
                          ),
                          GestureDetector(
                            onTap: () {
                              // widget.onChangePage!();
                              widget.onChangePageThongKe!();
                            },
                            child: _buildElement(
                              icon: 'assets/images/ic-transaction-blue.png',
                              context: context,
                              width: width,
                              title: 'Lịch sử giao dịch',
                              description:
                                  'Truy vấn thông tin biến động số dư của tài khoản',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: DividerWidget(width: width),
                          ),
                          GestureDetector(
                            onTap: () {
                              // widget.onChangePageThongKe!();
                              widget.onChangePage!();
                            },
                            child: _buildElement(
                              icon: 'assets/images/ic-statistic-blue.png',
                              context: context,
                              width: width,
                              title: 'Thống kê',
                              description:
                                  'Xem thông tin thống kê biến động số dư của tài khỏan',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (userId == widget.dto.userId) ...[
                      const SizedBox(height: 16),
                      _buildTitle(title: 'Cài đặt'),
                      BoxLayout(
                        width: width,
                        borderRadius: 8,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.dto.authenticated) ...[
                              GestureDetector(
                                onTap: () {
                                  DialogWidget.instance.openMsgDialog(
                                    title: 'Huỷ liên kết',
                                    msg: 'Bạn có chắc chắn muốn huỷ liên kết?',
                                    isSecondBT: true,
                                    functionConfirm: _unLink,
                                  );
                                },
                                child: _buildElement(
                                  icon: '',
                                  context: context,
                                  width: width,
                                  title: 'Hủy liên kết',
                                  description:
                                      'Ngừng nhận biến động số dư trên hệ thống VietQR',
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: DividerWidget(width: width),
                              ),
                            ],
                            GestureDetector(
                              onTap: () {
                                if (widget.dto.authenticated) {
                                  DialogWidget.instance.openMsgDialog(
                                    title: 'Không thể xoá TK',
                                    msg:
                                        'Vui lòng huỷ liên kết tài khoản ngân hàng trước khi xoá.',
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
                              child: _buildElement(
                                icon: 'assets/images/ic-remove-red.png',
                                context: context,
                                width: width,
                                title: 'Xóa tài khoản ngân hàng',
                                description:
                                    'Gỡ bỏ tài khoản ngân hàng ra khỏi danh sách tài khoản của bạn',
                              ),
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
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: const BoxDecoration(color: AppColor.WHITE),
          child: ButtonIconWidget(
            height: 40,
            pathIcon: 'assets/images/qr-contact-other-white.png',
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
            },
            textColor: AppColor.WHITE,
            bgColor: AppColor.BLUE_TEXT,
          ),
        ),
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

  Widget _buildElement({
    required BuildContext context,
    required double width,
    required String title,
    required String description,
    required String icon,
  }) {
    return Container(
      color: Colors.transparent,
      width: width,
      child: Row(
        children: [
          if (icon.isNotEmpty)
            Image.asset(
              icon,
              width: 32,
            )
          else
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.remove_circle_outline,
                color: AppColor.RED_TEXT,
                size: 18,
              ),
            ),
          SizedBox(
            width: icon.isNotEmpty ? 16 : 22,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusConnect() {
    if (widget.dto.authenticated) {
      if (userId == widget.dto.userId) {
        return Center(
          child: Container(
            // width: 170,
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColor.BLUE_TEXT,
                      borderRadius: BorderRadius.circular(30)),
                  child: Image.asset(
                    'assets/images/ic-linked-bank-white.png',
                    height: 24,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'Tài khoản đã liên kết',
                  style: TextStyle(color: AppColor.BLUE_TEXT),
                )
              ],
            ),
          ),
        );
      }

      return Center(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: AppColor.ORANGE_DARK,
                    borderRadius: BorderRadius.circular(30)),
                child: Image.asset(
                  'assets/images/ic_share_code.png',
                  height: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'Tài khoản được chia sẻ',
                style: TextStyle(color: AppColor.ORANGE_DARK),
              )
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: GestureDetector(
          onTap: _onLinked,
          child: Container(
            width: 170,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                color: AppColor.BLUE_TEXT,
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/ic-linked-bank-white.png',
                  height: 30,
                ),
                const Text(
                  'Liên kết tài khoản',
                  style: TextStyle(fontSize: 12, color: AppColor.WHITE),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  void _onMerchant() async {
    if (widget.isRegisterMerchant) {
      final data = await NavigatorUtils.navigatePage(
          context,
          MerchantScreen(
            customerId: widget.merchantDTO?.customerId ?? '',
            bankId: widget.bankId,
          ),
          routeName: CreateMerchantScreen.routeName);
      if (data != null) {
        widget.bloc.add(GetMerchantEvent());
      }
    } else {
      NavigatorUtils.navigatePage(
          context, CreateMerchantScreen(bankDetail: widget.dto),
          routeName: CreateMerchantScreen.routeName);
    }
  }

  void _onLinked() async {
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
    await NavigatorUtils.navigatePage(
            context, AddBankScreen(bankTypeDTO: bankTypeDTO),
            routeName: AddBankScreen.routeName)
        .then((value) {
      if (value is bool) {
        widget.bloc.add(const BankCardGetDetailEvent());
      }
    });
  }

  void _unLink() {
    Navigator.of(context).pop();
    if (widget.dto.unLinkBIDV) {
      Map<String, dynamic> body = {
        'ewalletToken': widget.dto.ewalletToken,
        'bankAccount': widget.dto.bankAccount,
        'bankCode': widget.dto.bankCode,
      };
      widget.bloc.add(BankCardEventUnLink(body: body));
    } else {
      widget.bloc.add(
          BankCardEventUnRequestOTP(accountNumber: widget.dto.bankAccount));
    }
  }
}
