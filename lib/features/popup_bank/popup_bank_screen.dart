import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dashed_line.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_new.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_detail/bank_card_detail_screen.dart';
import 'package:vierqr/features/bank_detail/repositories/bank_card_repository.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_add_user_bdsd.dart';
import 'package:vierqr/features/bank_detail/views/dialog_otp.dart';
import 'package:vierqr/features/create_qr/create_qr_screen.dart';
import 'package:vierqr/features/popup_bank/blocs/popup_bank_bloc.dart';
import 'package:vierqr/features/popup_bank/events/popup_bank_event.dart';
import 'package:vierqr/features/popup_bank/popup_bank_share.dart';
import 'package:vierqr/features/popup_bank/states/popup_bank_state.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_account_remove_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/confirm_otp_bank_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class PopupBankScreen extends StatelessWidget {
  final String tag;
  final BankAccountDTO dto;
  final int index;

  const PopupBankScreen({
    super.key,
    required this.tag,
    required this.dto,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PopupBankBloc>(
      create: (BuildContext context) => PopupBankBloc(dto),
      child: _PopupBankScreen(tag: tag, dto: dto, index: index),
    );
  }
}

class _PopupBankScreen extends StatefulWidget {
  final String tag;
  final BankAccountDTO dto;
  final int index;

  _PopupBankScreen({required this.tag, required this.dto, required this.index});

  @override
  State<_PopupBankScreen> createState() => _PopupBankScreenState();
}

class _PopupBankScreenState extends State<_PopupBankScreen> {
  late PopupBankBloc bloc;
  final bankCardRepository = BankCardRepository();
  final otpController = TextEditingController();

  final globalKey = GlobalKey();

  double get paddingHorizontal => 45;

  bool get small => MediaQuery.of(context).size.height < 800;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: 'Card_${widget.index}',
        flightShuttleBuilder: (flightContext, animation, flightDirection,
            fromHeroContext, toHeroContext) {
          // Tạo và trả về một widget mới để tham gia vào hiệu ứng chuyển động
          return Material(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg-qr-vqr.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
        child: BlocConsumer<PopupBankBloc, PopupBankState>(
          listener: (context, state) async {
            if (state.status == BlocStatus.LOADING) {
              DialogWidget.instance.openLoadingDialog();
            }

            if (state.status == BlocStatus.UNLOADING) {
              Navigator.pop(context);
            }

            if (state.request == PopupBankType.UN_LINK) {
              onShowDialogUnLinked(state.requestId ?? '', state.bankAccountDTO);
            }

            if (state.request == PopupBankType.OTP ||
                state.request == PopupBankType.DELETED ||
                state.request == PopupBankType.UN_BDSD) {
              eventBus.fire(GetListBankScreen());
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! > 20.0) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg-qr-vqr.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: small ? 40 : kToolbarHeight),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close,
                                  color: AppColor.WHITE, size: small ? 28 : 36),
                              padding: EdgeInsets.only(
                                  left: 16, bottom: small ? 4 : 16),
                              constraints: const BoxConstraints(),
                            ),
                            SizedBox(height: small ? 8 : 24),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: small ? 60 : paddingHorizontal),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColor.GREY_BG,
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: small ? 60 : 80,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: ImageUtils.instance
                                              .getImageNetWork(
                                                  widget.dto.imgId),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: small ? 40 : 60,
                                      child: VerticalDashedLine(),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 8),
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.bankAccountDTO.bankAccount,
                                              style: TextStyle(
                                                  color: AppColor.BLACK,
                                                  fontSize: small ? 12 : 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              state.bankAccountDTO.userBankName
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: AppColor.textBlack,
                                                fontSize: small ? 10 : 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: small ? 40 : 60,
                                      child: VerticalDashedLine(),
                                    ),
                                    GestureDetector(
                                      onTap: () => onCopy(state.bankAccountDTO),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Image.asset(
                                          'assets/images/ic-copy-blue.png',
                                          width: small ? 24 : 36,
                                          height: 36,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            RepaintBoundaryWidget(
                              globalKey: globalKey,
                              builder: (key) {
                                return VietQrNew(
                                    qrCode: state.bankAccountDTO.qrCode);
                              },
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildBottomBar(
                            title: 'Lưu ảnh vào thư viện',
                            url: 'assets/images/ic-edit-avatar-setting.png',
                            onTap: () =>
                                onSaveImage(context, state.bankAccountDTO),
                          ),
                          _buildBottomBar(
                              title: 'Chia sẻ mã QR',
                              url: 'assets/images/ic-share-blue.png',
                              onTap: () => onShare(state.bankAccountDTO)),
                          _buildBottomBar(
                              title: 'Chi tiết',
                              url: 'assets/images/ic-popup-bank-detail.png',
                              onTap: () {
                                NavigatorUtils.navigatePage(
                                    context,
                                    BankCardDetailScreen(
                                        bankId: state.bankAccountDTO.id),
                                    routeName: BankCardDetailScreen.routeName);
                              }),
                          _buildBottomBar(
                            title: 'Tạo QR giao dịch',
                            url: 'assets/images/ic-popup-bank-qr.png',
                            onTap: () => NavigatorUtils.navigatePage(
                                context,
                                CreateQrScreen(
                                    bankAccountDTO: state.bankAccountDTO),
                                routeName: CreateQrScreen.routeName),
                          ),
                          if (isLinked(state.bankAccountDTO))
                            _buildBottomBar(
                              title: 'Liên kết tài khoản',
                              url: 'assets/images/ic-linked-bank-in-list.png',
                              onTap: () =>
                                  onLinkedAccount(state.bankAccountDTO),
                              colorIcon: AppColor.BLUE_TEXT,
                            ),
                          if (state.bankAccountDTO.isAuthenticated &&
                              state.bankAccountDTO.isOwner)
                            _buildBottomBar(
                              title: 'Chia sẻ biến động số dư',
                              url: 'assets/images/ic-popup-bank-share-bdsd.png',
                              onTap: () => onShareBDSD(state.bankAccountDTO),
                            ),
                          if (isStopShareBDSD(state.bankAccountDTO))
                            _buildBottomBar(
                                title: 'Ngừng nhận biến động số dư',
                                url:
                                    'assets/images/ic-popup-bank-stop-share-bdsd.png',
                                color: AppColor.RED_EC1010,
                                onTap: () {
                                  String userId =
                                      UserHelper.instance.getUserId();
                                  String bankId = state.bankAccountDTO.id;
                                  bloc.add(PopupBankEventUnRegisterBDSD(
                                      userId, bankId));
                                }),
                          if (!state.bankAccountDTO.isAuthenticated &&
                              state.bankAccountDTO.isOwner)
                            _buildBottomBar(
                                title: 'Xoá tài khoản ngân hàng',
                                url: 'assets/images/ic-popup-bank-remove.png',
                                color: AppColor.RED_EC1010,
                                onTap: () =>
                                    _onRemoveBank(state.bankAccountDTO)),
                          if (isUnLinked(state.bankAccountDTO))
                            _buildBottomBar(
                              title: 'Huỷ liên kết',
                              url: 'assets/images/ic-popup-bank-remove.png',
                              color: AppColor.RED_EC1010,
                              onTap: () => onUnLinked(state.bankAccountDTO),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool isLinked(BankAccountDTO dto) {
    return (!dto.isAuthenticated && dto.isOwner && dto.bankTypeStatus == 1);
  }

  bool isStopShareBDSD(BankAccountDTO dto) {
    return (dto.isAuthenticated && !dto.isOwner && dto.bankTypeStatus == 1);
  }

  bool isUnLinked(BankAccountDTO dto) {
    return (dto.isAuthenticated && dto.isOwner && dto.bankTypeStatus == 1);
  }

  void onSaveImage(BuildContext context, BankAccountDTO bankAccountDTO) async {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: bankAccountDTO.bankCode,
      bankName: bankAccountDTO.bankName,
      bankAccount: bankAccountDTO.bankAccount,
      userBankName: bankAccountDTO.userBankName,
      qrCode: bankAccountDTO.qrCode,
      imgId: bankAccountDTO.imgId,
    );
    NavigatorUtils.navigatePage(
        context, PopupBankShare(dto: dto, type: TypeImage.SAVE),
        routeName: PopupBankShare.routeName);
  }

  void onCopy(BankAccountDTO bankAccountDTO) async {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: bankAccountDTO.bankCode,
      bankName: bankAccountDTO.bankName,
      bankAccount: bankAccountDTO.bankAccount,
      userBankName: bankAccountDTO.userBankName,
      qrCode: bankAccountDTO.qrCode,
      imgId: bankAccountDTO.imgId,
    );

    await FlutterClipboard.copy(ShareUtils.instance.getTextSharing(dto))
        .then((value) {
      Fluttertoast.showToast(
        msg: 'Đã sao chép',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).hintColor,
        fontSize: 15,
        webBgColor: 'rgba(255, 255, 255)',
        webPosition: 'center',
      );
    });
  }

  void onShare(BankAccountDTO bankAccountDTO) {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: bankAccountDTO.bankCode,
      bankName: bankAccountDTO.bankName,
      bankAccount: bankAccountDTO.bankAccount,
      userBankName: bankAccountDTO.userBankName,
      qrCode: bankAccountDTO.qrCode,
      imgId: bankAccountDTO.imgId,
    );
    NavigatorUtils.navigatePage(
        context, PopupBankShare(dto: dto, type: TypeImage.SHARE),
        routeName: PopupBankShare.routeName);
  }

  void onLinkedAccount(BankAccountDTO dto) async {
    BankTypeDTO bankTypeDTO = BankTypeDTO(
      id: '',
      bankCode: dto.bankCode,
      bankName: dto.bankName,
      imageId: dto.imgId,
      bankShortName: dto.bankCode,
      status: dto.bankTypeStatus,
      caiValue: '',
      userBankName: dto.userBankName,
      bankAccount: dto.bankAccount,
      bankId: dto.id,
    );

    final data = await NavigatorUtils.navigatePage(
        context, AddBankScreen(bankTypeDTO: bankTypeDTO),
        routeName: AddBankScreen.routeName);
    if (data != null && data is bool) {
      if (data) {
        dto.isAuthenticated = true;
        bloc.add(UpdateBankAccountEvent(dto));
      }
    }
  }

  void onUnLinked(BankAccountDTO dto) {
    DialogWidget.instance.openMsgDialog(
      title: 'Huỷ liên kết',
      msg: 'Bạn có chắc chắn muốn huỷ liên kết?',
      isSecondBT: true,
      functionConfirm: () {
        Navigator.of(context).pop();
        bloc.add(PopupBankEventUnlink(dto.bankAccount));
      },
    );
  }

  void onShowDialogUnLinked(String requestId, BankAccountDTO dto) {
    showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return DialogOTPView(
          phone: dto.phoneAuthenticated,
          onResend: () {
            onUnLinked(dto);
          },
          onChangeOTP: (value) {
            otpController.value = otpController.value.copyWith(text: value);
          },
          onTap: () {
            ConfirmOTPBankDTO confirmDTO = ConfirmOTPBankDTO(
              requestId: requestId,
              otpValue: otpController.text,
              applicationType: 'MOBILE',
              bankAccount: dto.bankAccount,
            );
            bloc.add(PopupBankEventUnConfirmOTP(confirmDTO));
          },
        );
      },
    );
  }

  Widget _buildBottomBar({
    GestureTapCallback? onTap,
    required String url,
    required String title,
    Color? color,
    Color? colorIcon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: small ? 0 : 6),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColor.grey979797.withOpacity(0.4))),
        ),
        child: Row(
          children: [
            Image.asset(
              url,
              width: small ? 24 : 36,
              height: 36,
              color: colorIcon,
            ),
            Text(
              title,
              style: TextStyle(
                color: color ?? AppColor.BLUE_TEXT,
                fontSize: small ? 10 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onShareBDSD(BankAccountDTO dto) async {
    // await DialogWidget.instance.showModelBottomSheet(
    //   isDismissible: true,
    //   height: MediaQuery.of(context).size.height * 0.8,
    //   margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 200),
    //   borderRadius: BorderRadius.circular(16),
    //   widget: BottomSheetAddUserBDSD(bankId: dto.id),
    // );
  }

  void updateState() {
    setState(() {});
  }

  void _onRemoveBank(BankAccountDTO dto) {
    if (dto.isAuthenticated) {
      DialogWidget.instance.openMsgDialog(
        title: 'Cảnh báo',
        msg: 'Bạn phải huỷ liên kết Tk ngân hàng này trước khi xoá',
      );
    } else {
      BankAccountRemoveDTO bankAccountRemoveDTO = BankAccountRemoveDTO(
        bankId: dto.id,
        type: dto.type,
        isAuthenticated: dto.isAuthenticated,
      );
      bloc.add(PopupBankEventRemove(bankAccountRemoveDTO));
    }
  }
}
