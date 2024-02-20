import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/trans_history/blocs/trans_history_provider.dart';
import 'package:vierqr/features/trans_history/views/terminal_time_view.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/models/transaction_input_dto.dart';

class BottomSheetFilter extends StatelessWidget {
  final List<TerminalResponseDTO> terminals;
  final String bankId;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isOwner;
  final FilterTimeTransaction filterTimeTransaction;
  final FilterTransaction filterTransaction;
  final FilterStatusTransaction filterStatusTransaction;
  final String keyword;
  final String codeTerminal;
  final FilterTransaction filterTerminal;
  final TerminalResponseDTO? terminalResponseDTO;
  final Function(
    TransactionInputDTO,
    DateTime fromDate,
    DateTime? toDate,
    FilterTimeTransaction,
    FilterTransaction,
    String valueSearch,
    String codeTerminal,
    FilterStatusTransaction filterStatusTransaction,
    FilterTransaction filterTerminal,
    TerminalResponseDTO terminalResponseDTO,
  ) onApply;
  final Function reset;

  const BottomSheetFilter({
    Key? key,
    required this.onApply,
    required this.terminals,
    required this.fromDate,
    required this.toDate,
    required this.filterTimeTransaction,
    required this.reset,
    required this.filterTransaction,
    required this.keyword,
    required this.codeTerminal,
    required this.bankId,
    required this.filterStatusTransaction,
    required this.filterTerminal,
    required this.terminalResponseDTO,
    this.isOwner = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        color: Colors.transparent,
        child: ChangeNotifierProvider<TransProvider>(
          create: (context) => TransProvider(isOwner, terminals)
            ..updateTerminals(
              terminals,
              bankId,
              fromDate,
              toDate,
              filterTimeTransaction,
              keyword,
              codeTerminal,
              filterTransaction,
              filterStatusTransaction,
              filterTerminal,
              terminalRes: terminalResponseDTO,
            ),
          child: Consumer<TransProvider>(builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 4),
                  child: Row(
                    children: [
                      const Spacer(),
                      const SizedBox(
                        width: 48,
                      ),
                      Text(
                        'Bộ lọc giao dịch',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.clear,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (!isOwner) ...[
                  Text(
                    'Cửa hàng',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  _buildDropListTerminal(),
                  const SizedBox(height: 16),
                ],
                Text(
                  'Lọc theo',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 12),
                        padding: EdgeInsets.only(left: 16, right: 12),
                        height: 50,
                        decoration: BoxDecoration(
                            color: AppColor.WHITE,
                            border: Border.all(
                                color: AppColor.BLACK_BUTTON.withOpacity(0.5),
                                width: 0.5),
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButton<FilterTransaction>(
                                value: provider.valueFilter,
                                icon: const RotatedBox(
                                  quarterTurns: 5,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: AppColor.WHITE,
                                  ),
                                ),
                                underline: const SizedBox.shrink(),
                                onChanged: (value) {
                                  provider.changeFilter(value, (dto) {});
                                },
                                items: isOwner
                                    ? provider.listFilter.map<
                                            DropdownMenuItem<
                                                FilterTransaction>>(
                                        (FilterTransaction value) {
                                        return DropdownMenuItem<
                                            FilterTransaction>(
                                          value: value,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 4),
                                            child: Text(
                                              value.title,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        );
                                      }).toList()
                                    : provider.listFilterNotOwner.map<
                                            DropdownMenuItem<
                                                FilterTransaction>>(
                                        (FilterTransaction value) {
                                        return DropdownMenuItem<
                                            FilterTransaction>(
                                          value: value,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 4),
                                            child: Text(
                                              value.title,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                              ),
                            ),
                            const RotatedBox(
                              quarterTurns: 5,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (isOwner && provider.valueFilter.id == 4) ...[
                  Text(
                    'Cửa hàng',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  _buildDropListTerminal(),
                ],
                _buildFormStatus(),
                _buildFormSearch(),
                const SizedBox(height: 16),
                _buildDropTime(),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                          borderRadius: 5,
                          height: 40,
                          text: 'Xóa bộ lọc',
                          textColor: AppColor.BLUE_TEXT,
                          bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                          function: () {
                            reset();
                            Navigator.pop(context);
                          }),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: ButtonWidget(
                          borderRadius: 5,
                          height: 40,
                          text: 'Áp dụng',
                          textColor: AppColor.WHITE,
                          bgColor: AppColor.BLUE_TEXT,
                          function: () {
                            if (provider.toDate == null) {
                              provider.updateToDate(DateTime.now());
                            }

                            if (provider.fromDate.millisecondsSinceEpoch >
                                provider.toDate!.millisecondsSinceEpoch) {
                              DialogWidget.instance.openMsgDialog(
                                  title: 'Không hợp lệ',
                                  msg:
                                      'Ngày bắt đầu không được lớn hơn ngày kết thúc');
                              return;
                            }

                            provider.onSearch((dto) {
                              onApply(
                                dto,
                                provider.fromDate,
                                provider.toDate,
                                provider.valueTimeFilter,
                                provider.valueFilter,
                                provider.keywordSearch,
                                provider.codeTerminal,
                                provider.statusValue,
                                provider.valueFilterTerminal,
                                provider.terminalResponseDTO,
                              );
                            });
                            Navigator.pop(context);
                          }),
                    )
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDropListTerminal() =>
      Consumer<TransProvider>(builder: (context, provider, child) {
        return Container(
          margin: EdgeInsets.only(top: 12),
          height: 50,
          decoration: BoxDecoration(
              color: AppColor.WHITE,
              border: Border.all(
                  color: AppColor.BLACK_BUTTON.withOpacity(0.5), width: 0.5),
              borderRadius: BorderRadius.circular(6)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<TerminalResponseDTO>(
              isExpanded: true,
              selectedItemBuilder: (context) {
                return provider.terminals
                    .map(
                      (item) => DropdownMenuItem<TerminalResponseDTO>(
                        value: item,
                        child: MTextFieldCustom(
                          isObscureText: false,
                          maxLines: 1,
                          enable: isOwner,
                          fillColor: AppColor.WHITE,
                          value: isOwner
                              ? provider.keywordSearch
                              : provider.terminalResponseDTO.name,
                          styles: TextStyle(fontSize: 14),
                          textFieldType: TextfieldType.DEFAULT,
                          maxLength: 10,
                          contentPadding: EdgeInsets.zero,
                          hintText: isOwner
                              ? 'Nhập hoặc chọn cửa hàng'
                              : 'Chọn cửa hàng',
                          inputType: TextInputType.text,
                          keyboardAction: TextInputAction.next,
                          onChange: provider.updateKeyword,
                        ),
                      ),
                    )
                    .toList();
              },
              items: provider.terminals.map((item) {
                return DropdownMenuItem<TerminalResponseDTO>(
                  value: item,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                      if (provider.terminals.length > 1) ...[
                        const Divider(),
                      ]
                    ],
                  ),
                );
              }).toList(),
              value: provider.terminalResponseDTO,
              onChanged: provider.updateTerminalResponseDTO,
              buttonStyleData: ButtonStyleData(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.WHITE,
                ),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.expand_more),
                iconSize: 18,
                iconEnabledColor: AppColor.BLACK,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
              ),
              menuItemStyleData: MenuItemStyleData(
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        );
      });

  Widget _buildDropTime() {
    return Consumer<TransProvider>(builder: (context, provider, child) {
      return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thời gian',
              style: TextStyle(
                  fontSize: 14,
                  color: AppColor.BLACK,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 12),
                    padding: EdgeInsets.only(left: 16, right: 12),
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        border: Border.all(
                            color: AppColor.BLACK_BUTTON.withOpacity(0.5),
                            width: 0.5),
                        borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButton<FilterTimeTransaction>(
                            value: provider.valueTimeFilter,
                            icon: const RotatedBox(
                              quarterTurns: 5,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: AppColor.WHITE,
                              ),
                            ),
                            underline: const SizedBox.shrink(),
                            onChanged: (FilterTimeTransaction? value) {
                              provider.changeTimeFilter(
                                  value, context, (dto) {});
                            },
                            items: provider.listTimeFilter
                                .map<DropdownMenuItem<FilterTimeTransaction>>(
                                    (FilterTimeTransaction value) {
                              return DropdownMenuItem<FilterTimeTransaction>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    value.title,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const RotatedBox(
                          quarterTurns: 5,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (provider.enableDropTime) ...[
              const SizedBox(height: 16),
              TerminalTimeView(
                toDate: provider.toDate,
                fromDate: provider.fromDate,
                updateFromDate: provider.updateFromDate,
                updateToDate: provider.updateToDate,
              ),
            ]
          ],
        ),
      );
    });
  }

  Widget _buildFormSearch() {
    return Consumer<TransProvider>(builder: (context, provider, child) {
      if (provider.valueFilter.id.typeTrans != TypeFilter.ALL &&
          provider.valueFilter.id.typeTrans != TypeFilter.STATUS_TRANS) {
        if (isOwner && provider.valueFilter.id == 4) {
          return const SizedBox.shrink();
        }
        return Container(
          height: 48,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: AppColor.BLACK_BUTTON.withOpacity(0.5), width: 0.5)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFieldCustom(
                  isObscureText: false,
                  fillColor: AppColor.WHITE,
                  title: '',
                  controller: provider.controller,
                  hintText: provider.hintText,
                  inputType: TextInputType.text,
                  keyboardAction: TextInputAction.next,
                  onChange: provider.updateKeyword,
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }

  Widget _buildFormStatus() {
    return Consumer<TransProvider>(builder: (context, provider, child) {
      if (provider.valueFilter.id.typeTrans == TypeFilter.STATUS_TRANS) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.WHITE,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Trạng thái giao dịch',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 4),
                padding: EdgeInsets.only(left: 16, right: 12),
                height: 50,
                decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    border: Border.all(
                        color: AppColor.BLACK_BUTTON.withOpacity(0.5),
                        width: 0.5),
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                  children: [
                    DropdownButton<FilterStatusTransaction>(
                      value: provider.statusValue,
                      icon: const RotatedBox(
                        quarterTurns: 5,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: AppColor.WHITE,
                        ),
                      ),
                      underline: const SizedBox.shrink(),
                      onChanged: provider.changeStatusFilter,
                      items: provider.listStatus
                          .map<DropdownMenuItem<FilterStatusTransaction>>(
                              (FilterStatusTransaction value) {
                        return DropdownMenuItem<FilterStatusTransaction>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              value.title,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const RotatedBox(
                      quarterTurns: 5,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }

      return const SizedBox();
    });
  }
}
