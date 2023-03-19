import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/generate_qr/blocs/qr_blocs.dart';
import 'package:vierqr/features/generate_qr/events/qr_event.dart';
import 'package:vierqr/features/generate_qr/states/qr_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/services/providers/search_clear_provider.dart';

class InputContentWidget extends StatelessWidget {
  final BankAccountDTO bankAccountDTO;
  final TextEditingController msgController;
  static final _formKey = GlobalKey<FormState>();
  static bool _isInitial = false;
  static late QRBloc qrBloc;

  static final SearchClearProvider msgClearProvider =
      SearchClearProvider(false);

  const InputContentWidget({
    Key? key,
    required this.bankAccountDTO,
    required this.msgController,
  }) : super(key: key);

  void initialServices(BuildContext context) {
    if (!_isInitial) {
      _isInitial = true;
      qrBloc = BlocProvider.of(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return BlocListener<QRBloc, QRState>(
      listener: (context, state) {
        if (state is QRGenerateLoadingState) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state is QRGeneratedFailedState) {
          Navigator.pop(context);
          DialogWidget.instance
              .openMsgDialog(title: 'Lỗi', msg: 'Vui lòng thử lại sau.');
        }
        if (state is QRGeneratedSuccessfulState) {
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: 0), () {
            msgController.clear();
            Provider.of<CreateQRProvider>(context, listen: false).reset();
          });
          Navigator.pushReplacementNamed(
            context,
            Routes.QR_GENERATED,
            arguments: {
              'qrGeneratedDTO': state.dto,
              'bankAccountDTO': bankAccountDTO,
            },
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                BoxLayout(
                  width: width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  borderRadius: 15,
                  child: Column(
                    children: [
                      if (bankAccountDTO.type == 1) ...[
                        _buildInformationItem(
                          context: context,
                          title: 'Doanh nghiệp',
                          description: bankAccountDTO.businessName,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: DividerWidget(width: width),
                        ),
                        _buildInformationItem(
                          context: context,
                          title: 'Chi nhánh',
                          description: bankAccountDTO.branchName,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: DividerWidget(width: width),
                        ),
                      ],
                      _buildInformationItem(
                        context: context,
                        title: 'Ngân hàng',
                        description: bankAccountDTO.bankName,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: DividerWidget(width: width),
                      ),
                      _buildInformationItem(
                        context: context,
                        title: 'Số TK',
                        description: bankAccountDTO.bankAccount,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: DividerWidget(width: width),
                      ),
                      _buildInformationItem(
                        context: context,
                        title: 'Số tiền',
                        description: Provider.of<CreateQRProvider>(context)
                            .currencyFormatted,
                        descriptionColor: DefaultTheme.GREEN,
                        unit: 'VND',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          Container(
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: DefaultTheme.BLACK.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: width - 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Mẫu nội dung: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          DialogWidget.instance.openMsgDialog(
                            title: 'Đang phát triển',
                            msg: 'Tính năng hiên đang phát triển',
                          );
                        },
                        child: const Text(
                          'Chỉnh sửa',
                          style: TextStyle(
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            color: DefaultTheme.GREEN,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 15)),
                SizedBox(
                  width: width - 30,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildChoiceChip(
                        context,
                        'Thanh toan',
                      ),
                      _buildChoiceChip(
                        context,
                        'Chuyen khoan den ${bankAccountDTO.bankAccount}',
                      ),
                      if (bankAccountDTO.type == 1) ...[
                        _buildChoiceChip(
                          context,
                          'Thanh toan cho ${bankAccountDTO.businessName}',
                        ),
                        _buildChoiceChip(
                          context,
                          'Giao dich ${bankAccountDTO.branchName}',
                        ),
                      ],
                      if (bankAccountDTO.type == 0) ...[
                        _buildChoiceChip(
                          context,
                          'Chuyen khoan cho ${bankAccountDTO.userBankName}',
                        ),
                        _buildChoiceChip(
                          context,
                          'Giao dich ngay ${TimeUtils.instance.formatDate(DateTime.now().toString())}',
                        ),
                      ],
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Container(
                      width: width - 20,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                          width: 0.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.notes_rounded,
                            size: 15,
                            color: DefaultTheme.GREY_TEXT,
                          ),
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFieldWidget(
                                width: width,
                                hintText: 'Nội dung thanh toán',
                                controller: msgController,
                                maxLength: 50,
                                autoFocus: false,
                                keyboardAction: TextInputAction.done,
                                onChange: (value) {
                                  if (msgController.text.isNotEmpty) {
                                    msgClearProvider.updateClearSearch(true);
                                  } else {
                                    msgClearProvider.updateClearSearch(false);
                                  }
                                },
                                inputType: TextInputType.text,
                                isObscureText: false,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              DialogWidget.instance.openMsgDialog(
                                title: 'Đang phát triển',
                                msg: 'Tính năng đang được phát triển',
                              );
                            },
                            child: const Icon(
                              Icons.document_scanner_outlined,
                              color: DefaultTheme.GREEN,
                              size: 18,
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: msgClearProvider,
                            builder: (_, provider, child) {
                              return Visibility(
                                visible: provider == true,
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        msgController.clear();
                                        msgClearProvider
                                            .updateClearSearch(false);
                                      },
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 15,
                                        color: DefaultTheme.GREY_TEXT,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                ButtonIconWidget(
                  width: width - 20,
                  height: 40,
                  icon: Icons.add_rounded,
                  borderRadius: 10,
                  title: 'Tạo QR giao dịch',
                  function: () {
                    if (StringUtils.instance
                        .isValidTransactionContent(msgController.text)) {
                      QRCreateDTO dto = QRCreateDTO(
                        bankId: bankAccountDTO.id,
                        amount: Provider.of<CreateQRProvider>(context,
                                listen: false)
                            .transactionAmount,
                        content: StringUtils.instance
                            .removeDiacritic(msgController.text)
                            .trim(),
                        branchId: bankAccountDTO.branchId,
                        businessId: bankAccountDTO.businessId,
                      );
                      qrBloc.add(QREventGenerate(dto: dto));
                    } else {
                      DialogWidget.instance.openMsgDialog(
                        title: 'Nội dung không hợp lệ',
                        msg:
                            'Nội dung thanh toán chứa ký tự không hợp lệ. Vui lòng không nhập các ký tự đặc biệt',
                      );
                    }
                  },
                  bgColor: DefaultTheme.GREEN,
                  textColor: DefaultTheme.WHITE,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationItem({
    required BuildContext context,
    required String title,
    required String description,
    String? unit,
    Color? descriptionColor,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: (descriptionColor != null)
                    ? descriptionColor
                    : Theme.of(context).hintColor,
                fontSize: 15,
              ),
            ),
          ),
          if (unit != null) ...[
            const Padding(padding: EdgeInsets.only(left: 5)),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChoiceChip(
    BuildContext context,
    String text,
    // ValueChanged<Object>? onTap,
  ) {
    return UnconstrainedBox(
      child: InkWell(
        onTap: () {
          msgClearProvider.updateClearSearch(true);
          msgController.value = msgController.value.copyWith(
            text: text.toString(),
          );
          // return onTap!(text);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).canvasColor,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
