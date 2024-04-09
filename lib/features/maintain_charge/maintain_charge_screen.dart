import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/maintain_charge/blocs/maintain_charge_bloc.dart';
import 'package:vierqr/features/maintain_charge/states/maintain_charge_state.dart';
import 'package:vierqr/services/providers/pin_provider.dart';

import '../../commons/constants/configurations/route.dart';
import '../../commons/utils/encrypt_utils.dart';
import '../../commons/utils/format_price.dart';
import '../../commons/utils/navigator_utils.dart';
import '../../commons/widgets/dialog_widget.dart';
import '../../layouts/m_app_bar.dart';
import '../../models/annual_fee_dto.dart';
import '../../models/maintain_charge_create.dart';
import '../../models/user_repository.dart';
import '../../services/local_storage/shared_preference/shared_pref_utils.dart';
import '../../services/providers/maintain_charge_provider.dart';
import 'events/maintain_charge_events.dart';
import 'views/annual_fee_screen.dart';

class MaintainChargeScreen extends StatefulWidget {
  final int type;
  final String bankId;
  const MaintainChargeScreen({
    super.key,
    required this.type,
    required this.bankId,
  });

  @override
  State<MaintainChargeScreen> createState() => _MaintainChargeScreenState();
}

class _MaintainChargeScreenState extends State<MaintainChargeScreen> {
  final TextEditingController _controller = TextEditingController(text: '');
  final TextEditingController _editingController =
      TextEditingController(text: '');

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

  void initData() async {
    _bloc.add(GetAnnualFeeListEvent());
  }

  @override
  void initState() {
    super.initState();

    _bloc = MaintainChargeBloc(context);
    if (widget.type == 1)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initData();
      });

    // _bloc = BlocProvider.of<MaintainChargeBloc>(context);
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
                  errorMsg = 'Key không tồn tại hoặc đã được sử dụng';
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
              bottomNavigationBar: _bottom(state),
              body: CustomScrollView(
                physics: widget.type == 0
                    ? NeverScrollableScrollPhysics()
                    : AlwaysScrollableScrollPhysics(),
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
                  SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                      if (widget.type == 0)
                        _activeKeyWidget()
                      else
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
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              Consumer<MaintainChargeProvider>(
                builder: (context, value, child) {
                  return Text(
                    "Chọn gói phí \nđể kích hoạt nhận BĐSD \nTK ${value.bankName} - ${value.bankAccount}",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Container(
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: value.listAnnualFee.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 30,
                    mainAxisExtent: 120,
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
                          selectFeeAmount = value.listAnnualFee[index].amount;
                        });
                      },
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 110,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 30, 20, 30),
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
                                    Text(
                                      "${value.listAnnualFee[index].duration} tháng",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: isSelect
                                            ? AppColor.BLUE_TEXT
                                            : AppColor.BLACK,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
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
                                        const SizedBox(width: 2),
                                        Text(
                                          "VND",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: isSelect
                                                  ? AppColor.BLUE_TEXT
                                                  : AppColor.BLACK),
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
                                  right: 0,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 2, 15, 2),
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: AppColor.ORANGE,
                                      borderRadius: BorderRadius.circular(50),
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
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.14),
          Consumer<MaintainChargeProvider>(
            builder: (context, value, child) {
              return Text(
                "Nhập mã KEY \nđể kích hoạt nhận BĐSD \nTK ${value.bankName} - ${value.bankAccount}",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              );
            },
          ),
          SizedBox(height: 12),
          TextFormField(
            keyboardType: TextInputType.multiline,
            // maxLength: 14,
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
            },

            inputFormatters: [
              UpperCaseTextInputFormatter(),
            ],
            controller: _controller,
            decoration: InputDecoration(
                hintText: 'Nhập mã KEY ở đây',
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
                    Provider.of<MaintainChargeProvider>(context, listen: false)
                        .setIsError(false);
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
              errorMsg.isNotEmpty ? errorMsg : "Đoạn KEY chứa 12 ký tự.",
              style: TextStyle(
                  fontSize: 15,
                  color: errorMsg.isEmpty ? AppColor.BLACK : AppColor.RED_TEXT),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottom(MaintainChargeState state) {
    return widget.type == 0
        ? Container(
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
            child: InkWell(
              onTap: _controller.text.length < 12
                  ? null
                  : () {
                      isClear = false;
                      Provider.of<MaintainChargeProvider>(context,
                              listen: false)
                          .setIsError(false);
                      String phone = SharePrefUtils.getPhone();
                      DialogWidget.instance.openConfirmPassDialog(
                        editingController: _editingController,
                        title: "",
                        onClose: () {
                          Provider.of<PinProvider>(context, listen: false)
                              .reset();
                          Provider.of<MaintainChargeProvider>(context,
                                  listen: false)
                              .setIsError(false);
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
                            "Tổng tiền:",
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
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Provider.of<MaintainChargeProvider>(context,
                                  listen: false)
                              .setIsError(false);
                          String phone = SharePrefUtils.getPhone();
                          DialogWidget.instance.openConfirmPassDialog(
                            editingController: _editingController,
                            title: "",
                            onClose: () {
                              Provider.of<PinProvider>(context, listen: false)
                                  .reset();
                              Provider.of<MaintainChargeProvider>(context,
                                      listen: false)
                                  .setIsError(false);
                              Navigator.of(context).pop();
                            },
                            onDone: (pin) {
                              _bloc.add(RequestActiveAnnualFeeEvent(
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
