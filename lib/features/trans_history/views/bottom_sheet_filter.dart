import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/trans_history/blocs/trans_history_provider.dart';
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
  final FilterTransaction filterTerminal;
  final Function(
      TransactionInputDTO,
      FilterTimeTransaction,
      FilterTransaction,
      String valueSearch,
      FilterStatusTransaction filterStatusTransaction,
      FilterTransaction filterTerminal) onApply;
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
    required this.bankId,
    required this.filterStatusTransaction,
    required this.filterTerminal,
    this.isOwner = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ChangeNotifierProvider<TransProvider>(
        create: (context) => TransProvider()
          ..updateTerminals(
            terminals,
            bankId,
            fromDate,
            toDate,
            filterTimeTransaction,
            keyword,
            filterTransaction,
            filterStatusTransaction,
            filterTerminal,
            isOwner,
          ),
        child: Consumer<TransProvider>(builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(
                height: 20,
              ),
              if (!isOwner) ...[
                Text(
                  'Nhóm/Chi nhánh',
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
                              child: DropdownButton<TerminalResponseDTO>(
                                value: provider.terminalResponseDTO,
                                icon: const RotatedBox(
                                  quarterTurns: 5,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: AppColor.WHITE,
                                  ),
                                ),
                                underline: const SizedBox.shrink(),
                                onChanged: (TerminalResponseDTO? value) {
                                  provider.updateTerminalResponseDTO(value!);
                                  // onRefresh(provider);
                                },
                                items: provider.terminals
                                    .map<DropdownMenuItem<TerminalResponseDTO>>(
                                        (TerminalResponseDTO value) {
                                  return DropdownMenuItem<TerminalResponseDTO>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: Text(
                                        value.name,
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
                const SizedBox(
                  height: 16,
                ),
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
                                  ? provider.listFilter
                                      .map<DropdownMenuItem<FilterTransaction>>(
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
                                  : provider.listFilterNotOwner
                                      .map<DropdownMenuItem<FilterTransaction>>(
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
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              if (isOwner && provider.valueFilter.id == 4) ...[
                Text(
                  'Nhóm/Chi nhánh',
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
                              child: DropdownButton<TerminalResponseDTO>(
                                value: provider.terminalResponseDTO,
                                icon: const RotatedBox(
                                  quarterTurns: 5,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: AppColor.WHITE,
                                  ),
                                ),
                                underline: const SizedBox.shrink(),
                                onChanged: (TerminalResponseDTO? value) {
                                  provider.updateKeyword(value?.id ?? '');
                                  provider.updateTerminalResponseDTO(value!);
                                  // onRefresh(provider);
                                },
                                items: provider.terminals
                                    .map<DropdownMenuItem<TerminalResponseDTO>>(
                                        (TerminalResponseDTO value) {
                                  return DropdownMenuItem<TerminalResponseDTO>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: Text(
                                        value.name,
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
              ],
              _buildFormStatus(),
              _buildFormSearch(),
              const SizedBox(
                height: 16,
              ),
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
                          provider.onSearch((dto) {
                            onApply(
                                dto,
                                provider.valueTimeFilter,
                                provider.valueFilter,
                                provider.keywordSearch,
                                provider.statusValue,
                                provider.valueFilterTerminal);
                          });
                          Navigator.pop(context);
                        }),
                  )
                ],
              )
            ],
          );
        }),
      ),
    );
  }

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
                if (!provider.enableDropTime)
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
                                provider.changeTimeFilter(value, context,
                                    (dto) {
                                  // _bloc.add(TransactionEventGetList(dto));
                                });
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
                  )
                else
                  Container(
                    width: MediaQuery.of(context).size.width - 68,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    margin: EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: AppColor.BLACK_BUTTON.withOpacity(0.5),
                            width: 0.5)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => provider.openBottomTime(context, (dto) {
                            // _bloc.add(TransactionEventGetList(dto));
                          }),
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Text(
                                  'Từ ${TimeUtils.instance.formatDateToString(provider.fromDate, isExport: true)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.BLACK,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Đến ${TimeUtils.instance.formatDateToString(provider.toDate, isExport: true)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.BLACK,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => provider.resetFilterTime((dto) {
                            // _bloc.add(TransactionEventGetList(dto));
                          }),
                          child: const Icon(
                            Icons.clear,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
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
              // MButtonWidget(
              //   title: 'Tìm kiếm',
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   margin: EdgeInsets.zero,
              //   colorEnableBgr: AppColor.BLUE_TEXT,
              //   colorEnableText: AppColor.WHITE,
              //   isEnable: true,
              //   height: 46,
              //   onTap: () => provider.onSearch((dto) {
              //     _bloc.add(TransactionEventGetList(dto));
              //   }),
              // ),
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
                      onChanged: (FilterStatusTransaction? value) {
                        provider.changeStatusFilter(value, (dto) {
                          // _bloc.add(TransactionEventGetList(dto));
                        });
                      },
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
