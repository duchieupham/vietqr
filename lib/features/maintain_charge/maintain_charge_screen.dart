import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/maintain_charge/blocs/maintain_charge_bloc.dart';
import 'package:vierqr/features/maintain_charge/states/maintain_charge_state.dart';
import 'package:vierqr/features/maintain_charge/views/popup_detail_widget.dart';
import 'package:vierqr/services/providers/pin_provider.dart';

import '../../commons/constants/configurations/route.dart';
import '../../commons/constants/configurations/stringify.dart';
import '../../commons/utils/encrypt_utils.dart';
import '../../commons/utils/format_price.dart';
import '../../commons/utils/log.dart';
import '../../commons/utils/navigator_utils.dart';
import '../../commons/widgets/dialog_widget.dart';
import '../../layouts/m_app_bar.dart';
import '../../models/annual_fee_dto.dart';
import '../../models/maintain_charge_create.dart';
import '../../models/user_repository.dart';
import '../../services/local_notification/notification_service.dart';
import '../../services/local_storage/shared_preference/shared_pref_utils.dart';
import '../../services/providers/maintain_charge_provider.dart';
import '../dashboard/dashboard_screen.dart';
import 'events/maintain_charge_events.dart';
import 'views/annual_fee_screen.dart';

class MaintainChargeScreen extends StatefulWidget {
  final int type;
  final String bankId;
  final String bankCode;
  final String bankName;
  final String bankAccount;
  final String userBankName;
  const MaintainChargeScreen({
    super.key,
    required this.type,
    required this.bankId,
    required this.bankCode,
    required this.bankName,
    required this.bankAccount,
    required this.userBankName,
  });

  @override
  State<MaintainChargeScreen> createState() => _MaintainChargeScreenState();
}

class _MaintainChargeScreenState extends State<MaintainChargeScreen> {
  final TextEditingController _controller = TextEditingController(text: '');
  final TextEditingController _editingController =
      TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  FocusNode node = FocusNode();

  String? _validateTest;
  late MaintainChargeBloc _bloc;
  final userRes = UserRepository.instance;
  BlocStatus status = BlocStatus.NONE;
  // String textMsg = '';
  String keyValue = '';
  String errorMsg = '';
  bool isClear = false;
  bool isSelected = false;
  String? selectedId = '';
  int? selectFeeAmount = 0;
  List<AnnualFeeDTO>? annualList;
  bool? isPayment = false;

  void initData() async {
    _bloc.add(GetAnnualFeeListEvent());
  }

  @override
  void initState() {
    super.initState();

    _bloc = MaintainChargeBloc(context);
    if (widget.type == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initData();
        onFcmMessage();
      });
    }
  }

  void onFcmMessage() async {
    await NotificationService().initialNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Xử lý push notification nếu ứng dụng đang chạy
      LOG.info(
          "Push notification received: ${message.notification?.title} - ${message.notification?.body}");
      LOG.info("receive data: ${message.data}");
      //process when receive data
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _editingController.dispose();
  }

  bool isDialogOpen(BuildContext context) {
    // Check if the Navigator has any routes on the stack
    return Navigator.of(context).canPop();
  }

  String formatInput(String input) {
    input = input.replaceAll(
        RegExp(r'\W'), ''); // Remove non-alphanumeric characters
    if (input.length > 12) {
      input = input.substring(0, 12); // Truncate to 12 characters
    }
    input = input.replaceAllMapped(
      RegExp(r'.{4}'),
      (match) => '${match.group(0)} - ',
    );

    if (input.endsWith(' - ') && input.length > 0) {
      final lastNonDashIndex = input.lastIndexOf(RegExp(r'[^ -]'));
      if (lastNonDashIndex != -1) {
        input = input.substring(0, lastNonDashIndex + 1);
      }
    }
    return input.trim(); // Remove trailing whitespace
  }

  void onSubmit() {
    isClear = false;
    Provider.of<AuthProvider>(context, listen: false).checkStateLogin(false);
    String phone = SharePrefUtils.getPhone();
    DialogWidget.instance.openConfirmPassDialog(
      editingController: _editingController,
      title: "Nhập mật khẩu ứng dụng\nVietQR để xác thực",
      onClose: () {
        Provider.of<PinProvider>(context, listen: false).reset();
        Provider.of<AuthProvider>(context, listen: false)
            .checkStateLogin(false);
        Navigator.of(context).pop();
      },
      onDone: (pin) {
        _bloc.add(MaintainChargeEvent(
            dto: MaintainChargeCreate(
          type: widget.type,
          key: keyValue,
          bankId: widget.bankId,
          userId: userRes.userId,
          password: EncryptUtils.instance.encrypted(
            phone,
            pin,
          ),
        )));
        _editingController.text = '';
      },
    );
  }

  void _onOpenPopup() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => PopupDetailAnnualFee(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaintainChargeBloc>(
      create: (context) => _bloc,
      child: BlocBuilder<MaintainChargeBloc, MaintainChargeState>(
        builder: (context, state) {
          if (state.status == BlocStatus.ERROR) {
            // status = state.status;
            if (isClear) {
              errorMsg = '';
            } else {
              switch (state.msg) {
                case 'E55':
                  errorMsg = 'Mật khẩu không chính xác';
                  break;
                case 'E25':
                  errorMsg = 'TK ngân hàng không tồn tại trong hệ thống';
                  break;
                case 'E101':
                  errorMsg =
                      'TK ngân hàng chưa liên kết với hệ thống VietQR';
                  break;
                case 'E126':
                  errorMsg =
                      'Bạn không có quyền thực hiện mở khóa TK ngân hàng này';
                  break;
                case 'E127':
                  errorMsg = 'Mã không tồn tại hoặc đã được sử dụng';
                  break;
                case 'E132':
                  errorMsg = 'Gói phí không tồn tại, vui lòng thử lại';
                  break;
                case 'E05':
                  errorMsg = 'Lỗi không xác định';
                  break;
                case 'E128':
                  errorMsg = 'Không tìm thấy yêu cầu, vui lòng thử lại';
                  break;
                case 'E129':
                  errorMsg = 'Quá thời gian thực hiện, vui lòng thử lại';
                  break;
                case 'E70':
                  errorMsg = 'Phương thức thanh toán không hợp lệ';
                  break;
                case 'E65':
                  errorMsg = 'Xác thực thất bại. Vui lòng thử lại sau';
                  break;
                default:
                  errorMsg = '';
              }
            }
          } else if (state.status == BlocStatus.SUCCESS) {
            errorMsg = '';
          }
          return Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: true,
              bottomNavigationBar: widget.type == 1 ? _bottom(state) : null,
              body: CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: false,
                    leadingWidth: 100,
                    leading: InkWell(
                      onTap: () {
                        Provider.of<MaintainChargeProvider>(context,
                                listen: false)
                            .resetBank();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.black,
                              size: 25,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              "Trở về",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Image.asset(
                          AppImages.icLogoVietQr,
                          width: 95,
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    ],
                  ),
                  if (widget.type == 0)
                    SliverToBoxAdapter(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: _activeKeyWidget()),
                            _bottom(state),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildListDelegate(<Widget>[
                        _annualFeeWidget(),
                      ]),
                    )
                ],
              ));
        },
      ),
    );
  }

  Widget _annualFeeWidget() {
    return Consumer<MaintainChargeProvider>(
      builder: (context, value, child) {
        if (value.listAnnualFee.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              Consumer<MaintainChargeProvider>(
                builder: (context, value, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Chọn gói phí kích hoạt ",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "dịch vụ phần mềm VietQR",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "TK ${value.bankName} - ${value.bankAccount}",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: GridView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: value.listAnnualFee.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 30,
                    mainAxisExtent: 135,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.2,
                  ),
                  itemBuilder: (context, index) {
                    bool isSelect =
                        selectedId == value.listAnnualFee[index].feeId;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedId = value.listAnnualFee[index].feeId;
                          // selectFeeAmount = value.listAnnualFee[index].amount! *
                          //     value.listAnnualFee[index].duration!;
                          selectFeeAmount =
                              value.listAnnualFee[index].totalWithVat;
                        });
                      },
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 120,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.fromLTRB(17, 20, 17, 20),
                                decoration: BoxDecoration(
                                  color: isSelect
                                      ? AppColor.BLUE_TEXT.withOpacity(0.3)
                                      : AppColor.TRANSPARENT,
                                  border: Border.all(
                                      color: isSelect
                                          ? AppColor.BLUE_TEXT
                                          : AppColor.GREY_DADADA,
                                      width: 0.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${value.listAnnualFee[index].duration}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: AppColor.BLACK,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "tháng",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: AppColor.BLACK,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formatNumber(value
                                              .listAnnualFee[index].amount),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: AppColor.BLUE_TEXT,
                                              fontWeight: isSelect
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "VND/THÁNG",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColor.BLACK
                                                  .withOpacity(0.3)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          value.listAnnualFee[index].description != ''
                              ? Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 2, 15, 2),
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF209493),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${value.listAnnualFee[index].description}",
                                        style: TextStyle(
                                          color: AppColor.WHITE,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _activeKeyWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Consumer<MaintainChargeProvider>(
            builder: (context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nhập mã kích hoạt",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "dịch vụ phần mềm VietQR",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "TK ${value.bankName} - ${value.bankAccount}",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 12),
          TextFormField(
            focusNode: node,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.multiline,
            onFieldSubmitted: (value) {
              final formattedText = formatInput(value);
              if (formattedText != _controller.text) {
                _controller.value = TextEditingValue(
                  text: formattedText,
                  selection:
                      TextSelection.collapsed(offset: formattedText.length),
                );
              }
              setState(() {
                keyValue = value.replaceAll(RegExp(r'[-\s]+'), '');
              });
              onSubmit();
            },
            onChanged: (text) {
              final formattedText = formatInput(text);
              if (formattedText != _controller.text) {
                _controller.value = TextEditingValue(
                  text: formattedText,
                  selection:
                      TextSelection.collapsed(offset: formattedText.length),
                );
              }
              setState(() {
                keyValue = text.replaceAll(RegExp(r'[-\s]+'), '');
              });
              if (keyValue.length == 12) onSubmit();
            },
            inputFormatters: [
              UpperCaseTextInputFormatter(),
            ],
            controller: _controller,
            decoration: InputDecoration(
                hintText: 'Nhập mã ở đây',
                hintStyle: TextStyle(
                    fontSize: 15, color: AppColor.BLACK.withOpacity(0.5)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColor.BLUE_TEXT)),
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.BLACK.withOpacity(0.5))),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _controller.clear();
                    isClear = true;
                    Provider.of<AuthProvider>(context, listen: false)
                        .checkStateLogin(false);
                    setState(() {
                      keyValue = '';
                    });
                  },
                )),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: Text(
              errorMsg.isNotEmpty ? errorMsg : "Đoạn mã chứa 12 ký tự.",
              style: TextStyle(
                  fontSize: 15,
                  color: errorMsg.isEmpty ? AppColor.BLACK : AppColor.RED_TEXT),
              textAlign: TextAlign.right,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottom(MaintainChargeState state) {
    return widget.type == 0
        ? Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 0),
            margin: const EdgeInsets.only(bottom: 150),
            child: InkWell(
              onTap: _controller.text.length < 12
                  ? null
                  : () {
                      onSubmit();
                    },
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: _controller.text.length < 12
                        ? AppColor.GREY_BUTTON
                        : AppColor.BLUE_TEXT,
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      "Tiếp tục",
                      style: TextStyle(
                          fontSize: 13,
                          color: _controller.text.length > 12
                              ? Colors.white
                              : AppColor.BLACK),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: _controller.text.length > 12
                          ? Colors.white
                          : AppColor.BLACK,
                      size: 16,
                    )
                  ],
                ),
              ),
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height * 0.12,
            // margin: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                MySeparator(
                  color: AppColor.GREY_DADADA,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, bottom: 30, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tổng tiền",
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                selectFeeAmount != 0
                                    ? formatNumber(selectFeeAmount)
                                    : '0',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.BLUE_TEXT,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "VND",
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: _onOpenPopup,
                                child: Icon(
                                  Icons.info_outline,
                                  color: AppColor.BLUE_TEXT,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Provider.of<AuthProvider>(context, listen: false)
                              .checkStateLogin(false);
                          String phone = SharePrefUtils.getPhone();
                          DialogWidget.instance.openConfirmPassDialog(
                            editingController: _editingController,
                            title: "Nhập mật khẩu ứng dụng\nVietQR để xác thực",
                            onClose: () {
                              Provider.of<PinProvider>(context, listen: false)
                                  .reset();
                              Provider.of<AuthProvider>(context, listen: false)
                                  .checkStateLogin(false);
                              Navigator.of(context).pop();
                            },
                            onDone: (pin) {
                              _bloc.add(RequestActiveAnnualFeeEvent(
                                bankAccount: widget.bankAccount,
                                userBankName: widget.userBankName,
                                bankCode: widget.bankCode,
                                bankName: widget.bankName,
                                type: widget.type,
                                feeId: selectedId!,
                                bankId: widget.bankId,
                                userId: userRes.userId,
                                password: EncryptUtils.instance.encrypted(
                                  phone,
                                  pin,
                                ),
                              ));
                              _editingController.text = '';
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          width: 160,
                          decoration: BoxDecoration(
                            color: selectedId!.isNotEmpty
                                ? AppColor.BLUE_TEXT
                                : AppColor.GREY_DADADA,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              "Thanh toán",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: selectedId!.isNotEmpty
                                      ? AppColor.WHITE
                                      : AppColor.BLACK),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Convert all characters to uppercase
    final String formattedText = newValue.text.toUpperCase();

    // Return the formatted value
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
