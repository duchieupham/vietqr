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
import 'package:vierqr/features/maintain_charge/blocs/maintain_charge_bloc.dart';
import 'package:vierqr/features/maintain_charge/states/maintain_charge_state.dart';
import 'package:vierqr/services/providers/pin_provider.dart';

import '../../commons/constants/configurations/route.dart';
import '../../commons/utils/encrypt_utils.dart';
import '../../commons/utils/navigator_utils.dart';
import '../../commons/widgets/dialog_widget.dart';
import '../../layouts/m_app_bar.dart';
import '../../models/maintain_charge_create.dart';
import '../../models/user_repository.dart';
import '../../services/local_storage/shared_preference/shared_pref_utils.dart';
import '../../services/providers/maintain_charge_provider.dart';
import 'events/maintain_charge_events.dart';

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

  String? _validateTest;
  late MaintainChargeBloc _bloc;
  final userRes = UserRepository.instance;
  BlocStatus status = BlocStatus.NONE;
  // String textMsg = '';
  String keyValue = '';
  String errorMsg = '';
  bool isClear = false;

  @override
  void initState() {
    super.initState();
    _bloc = MaintainChargeBloc(context);
    // _bloc = BlocProvider.of<MaintainChargeBloc>(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            status = state.status;
            if (isClear) {
              errorMsg = '';
            } else {
              switch (state.msg) {
                case 'E55':
                  errorMsg = 'Mật khẩu không chính xác';
                  Provider.of<MaintainChargeProvider>(context, listen: false)
                      .setIsError(true);
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
                      'Tài khoản ngân hàng không thuộc sử hữu của người dùng';

                  break;
                case 'E127':
                  errorMsg = 'Key không tồn tại hoặc đã được sử dụng';

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
                slivers: [
                  SliverAppBar(
                    pinned: true,
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
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.14),
                            Consumer<MaintainChargeProvider>(
                              builder: (context, value, child) {
                                return Text(
                                  "Nhập mã KEY \nđể kích hoạt nhận BĐSD \nTK ${value.bankName} - ${value.bankAccount}",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
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
                                    selection: TextSelection.collapsed(
                                        offset: formattedText.length),
                                  );
                                }
                                setState(() {
                                  keyValue =
                                      text.replaceAll(RegExp(r'[-\s]+'), '');
                                });
                              },

                              inputFormatters: [
                                UpperCaseTextInputFormatter(),
                              ],
                              controller: _controller,
                              decoration: InputDecoration(
                                  hintText: 'Nhập mã KEY ở đây',
                                  hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: AppColor.BLACK.withOpacity(0.5)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColor.BLUE_TEXT)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              AppColor.BLACK.withOpacity(0.5))),
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      _controller.clear();
                                      isClear = true;
                                      Provider.of<MaintainChargeProvider>(
                                              context,
                                              listen: false)
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
                                errorMsg.isNotEmpty
                                    ? errorMsg
                                    : "Đoạn KEY chứa 12 ký tự.",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: errorMsg.isEmpty
                                        ? AppColor.BLACK
                                        : AppColor.RED_TEXT),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  )
                ],
              ));
        },
      ),
    );
  }

  Widget _bottom(MaintainChargeState state) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
      child: InkWell(
        onTap: _controller.text.length < 12
            ? null
            : () {
                isClear = false;
                Provider.of<MaintainChargeProvider>(context, listen: false)
                    .setIsError(false);
                String phone = SharePrefUtils.getPhone();
                DialogWidget.instance.openConfirmPassDialog(
                  title: "",
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
