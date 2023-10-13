import 'package:float_bubble/float_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/add_bank/views/bank_input_widget.dart';
import 'package:vierqr/features/create_qr/views/calculator_view.dart';
import 'package:vierqr/features/create_qr_un_authen/blocs/qrcode_un_authen_bloc.dart';
import 'package:vierqr/features/create_qr_un_authen/states/qrcode_un_authen_state.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/bank_type_dto.dart';

import '../../services/providers/create_qr_un_authen_provider.dart';
import 'events/qrcode_un_authen_event.dart';

class CreateQrUnQuthen extends StatefulWidget {
  const CreateQrUnQuthen({Key? key}) : super(key: key);

  @override
  State<CreateQrUnQuthen> createState() => _CreateQrUnQuthenState();
}

class _CreateQrUnQuthenState extends State<CreateQrUnQuthen> {
  final TextEditingController bankAccountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController =
      TextEditingController(text: '');
  final TextEditingController contentController =
      TextEditingController(text: '');

  List<BankTypeDTO> list = [];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const MAppBar(title: 'Tạo mã VietQR'),
      body: BlocProvider<QRCodeUnUTBloc>(
        create: (context) => QRCodeUnUTBloc()..add(LoadDataBankTypeEvent()),
        child: BlocConsumer<QRCodeUnUTBloc, QRCodeUnUTState>(
          listener: (context, state) {
            if (state is CreateQRLoadingState) {
              DialogWidget.instance.openLoadingDialog();
            }

            if (state is CreateSuccessfulState) {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }

              Navigator.pushNamed(context, Routes.SHOW_QR,
                  arguments: state.dto);
            }
            if (state is GetBankTYpeSuccessState) {
              list = state.list;
            }
          },
          builder: (context, state) {
            return ChangeNotifierProvider(
              create: (context) => CreateQrUnATProvider(),
              child: Consumer<CreateQrUnATProvider>(
                builder: (context, provider, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(top: 30)),
                                  _buildListBank(provider, height),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 15)),
                                  TextFieldCustom(
                                    isObscureText: false,
                                    maxLines: 1,
                                    enable:
                                        provider.bankType.bankCode.isNotEmpty,
                                    fillColor:
                                        provider.bankType.bankCode.isNotEmpty
                                            ? null
                                            : AppColor.GREY_EBEBEB,
                                    controller: bankAccountController,
                                    textFieldType: TextfieldType.LABEL,
                                    title: 'Số tài khoản *',
                                    hintText: 'Nhập số tài khoản',
                                    inputType: TextInputType.text,
                                    keyboardAction: TextInputAction.next,
                                    onChange: (value) {
                                      provider.updateBankAccountErr(
                                        (bankAccountController.text.isEmpty ||
                                            !StringUtils.instance.isNumeric(
                                                bankAccountController.text)),
                                      );
                                    },
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 5)),
                                  Visibility(
                                    visible: provider.bankAccountErr,
                                    child: const Text(
                                      'Số tài khoản không hợp lệ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.RED_TEXT,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 15)),
                                  TextFieldCustom(
                                    isObscureText: false,
                                    maxLines: 1,
                                    enable:
                                        provider.bankType.bankCode.isNotEmpty,
                                    fillColor:
                                        provider.bankType.bankCode.isNotEmpty
                                            ? null
                                            : AppColor.GREY_EBEBEB,
                                    controller: nameController,
                                    textFieldType: TextfieldType.LABEL,
                                    title: 'Chủ tài khoản \u002A',
                                    hintText: 'Nhập tên chủ tài khoản',
                                    inputType: TextInputType.text,
                                    keyboardAction: TextInputAction.next,
                                    onChange: (value) {
                                      provider.updateNameErr(
                                        nameController.text.isEmpty,
                                      );
                                    },
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 5)),
                                  Visibility(
                                    visible: provider.nameErr,
                                    child: const Text(
                                      'Chủ tài khoản không hợp lệ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.RED_TEXT,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 15)),
                                  if (provider.showMoreOption) ...[
                                    MTextFieldCustom(
                                      isObscureText: false,
                                      maxLines: 1,
                                      enable:
                                          provider.bankType.bankCode.isNotEmpty,
                                      fillColor:
                                          provider.bankType.bankCode.isNotEmpty
                                              ? null
                                              : AppColor.GREY_EBEBEB,
                                      textFieldType: TextfieldType.LABEL,
                                      title: 'Số tiền',
                                      hintText: 'Nhập số tiền ít nhất 1000',
                                      inputType: TextInputType.number,
                                      controller: amountController,
                                      keyboardAction: TextInputAction.next,
                                      onChange: (value) {
                                        if (amountController.text.isNotEmpty) {
                                          if (StringUtils.instance.isNumeric(
                                              amountController.text)) {
                                            provider.updateAmountErr(false);
                                            if (amountController.text.length >=
                                                4) {
                                              provider.updateValidCreate(true);
                                            } else {
                                              provider.updateValidCreate(false);
                                            }
                                          } else {
                                            provider.updateAmountErr(true);
                                            provider.updateValidCreate(false);
                                          }
                                        } else {
                                          provider.updateAmountErr(false);
                                          provider.updateValidCreate(true);
                                        }
                                      },
                                      suffixIcon: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'VND',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColor.textBlack),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () async {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              final data = await NavigatorUtils
                                                  .navigatePage(context,
                                                      CalculatorScreen());

                                              if (data != null &&
                                                  data is String) {
                                                double money =
                                                    double.parse(data);
                                                amountController.text =
                                                    StringUtils.formatNumber(
                                                        money.round());
                                                provider.updateMoney(
                                                    money.round().toString());
                                              }
                                            },
                                            child: Image.asset(
                                              'assets/images/logo-calculator.png',
                                              width: 28,
                                              height: 28,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                      ),
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 5)),
                                    if (provider.isAmountErr)
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Số tiền không đúng định dạng',
                                          style: TextStyle(
                                            color: AppColor.RED_CALENDAR,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 15)),
                                    TextFieldCustom(
                                      isObscureText: false,
                                      maxLines: 1,
                                      enable:
                                          provider.bankType.bankCode.isNotEmpty,
                                      fillColor:
                                          provider.bankType.bankCode.isNotEmpty
                                              ? null
                                              : AppColor.GREY_EBEBEB,
                                      controller: contentController,
                                      textFieldType: TextfieldType.LABEL,
                                      title: 'Nội dung (50 ký tự)',
                                      hintText: 'Nội dung mã QR',
                                      inputType: TextInputType.text,
                                      keyboardAction: TextInputAction.done,
                                      onChange: (value) {},
                                    ),
                                  ],
                                  UnconstrainedBox(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (provider.showMoreOption) {
                                          provider.updateShowMoreOption(true);
                                        } else {
                                          provider.updateShowMoreOption(
                                              amountController.text.length > 4);
                                        }
                                      },
                                      child: Container(
                                        width: 160,
                                        height: 40,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 28),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                color: AppColor.BLUE_TEXT)),
                                        child: Text(
                                          provider.showMoreOption
                                              ? 'Đóng tuỳ chọn'
                                              : 'Tuỳ chọn thêm',
                                          style: TextStyle(
                                              color: AppColor.BLUE_TEXT),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: ButtonWidget(
                                height: 40,
                                text: 'Tạo mã VietQR',
                                borderRadius: 5,
                                textColor: AppColor.WHITE,
                                bgColor: !provider.isValidCreate
                                    ? AppColor.GREY_TEXT
                                    : AppColor.BLUE_TEXT,
                                function: () {
                                  if (!provider.isValidCreate) {
                                  } else if (provider
                                      .bankType.bankCode.isNotEmpty) {
                                    provider.updateBankAccountErr(
                                      (bankAccountController.text.isEmpty ||
                                          !StringUtils.instance.isNumeric(
                                              bankAccountController.text)),
                                    );
                                    provider.updateNameErr(
                                      nameController.text.isEmpty,
                                    );
                                    if (provider.isValidUnauthenticateForm()) {
                                      Map<String, dynamic> data = {};
                                      data['bankAccount'] =
                                          bankAccountController.text;
                                      data['userBankName'] =
                                          nameController.text;
                                      data['bankCode'] =
                                          provider.bankType.bankCode;
                                      data['amount'] = amountController.text;
                                      data['content'] = StringUtils.instance
                                          .removeDiacritic(
                                              contentController.text);

                                      BlocProvider.of<QRCodeUnUTBloc>(context)
                                          .add(QRCodeUnUTCreateQR(data: data));
                                    }
                                  } else {
                                    DialogWidget.instance.openMsgDialog(
                                      title: 'Không thể tạo',
                                      msg: 'Vui lòng chọn ngân hàng thụ hưởng',
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: kToolbarHeight + 30,
                          child: FloatBubble(
                            show: true,
                            initialAlignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  final data =
                                      await NavigatorUtils.navigatePage(
                                          context, CalculatorScreen());

                                  if (data != null && data is String) {
                                    double money = double.parse(data);
                                    amountController.text =
                                        StringUtils.formatNumber(money.round());
                                    provider
                                        .updateMoney(money.round().toString());
                                  }
                                },
                                child: Opacity(
                                  opacity: 0.6,
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 30),
                                    alignment: Alignment.bottomRight,
                                    child: Image.asset(
                                      'assets/images/logo-calculator.png',
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListBank(CreateQrUnATProvider provider, double height) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ngân hàng *',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            final data = await DialogWidget.instance.showModelBottomSheet(
              context: context,
              padding: EdgeInsets.zero,
              widget: ModelBottomSheetView(
                tvTitle: 'Chọn ngân hàng',
                ctx: context,
                list: list,
                isSearch: true,
                data: provider.bankType,
              ),
              height: height * 0.6,
            );
            if (data is int) {
              bankAccountController.clear();
              nameController.clear();
              provider.resetValidate();
              provider.updateBankType(list[data]);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: AppColor.WHITE,
            ),
            child: Row(
              children: [
                if (provider.bankType.bankCode.isNotEmpty)
                  Container(
                    width: 60,
                    height: 30,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ImageUtils.instance
                              .getImageNetWork(provider.bankType.imageId)),
                    ),
                  )
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    provider.bankType.bankName.isNotEmpty
                        ? provider.bankType.name
                        : 'Chọn ngân hàng',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: provider.bankType.id.isNotEmpty
                            ? AppColor.BLACK
                            : AppColor.GREY_TEXT),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColor.GREY_TEXT,
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
