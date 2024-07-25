import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/month_calculator.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/features/bank_detail/views/dialog_pick_date.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/providers/statistical_provider.dart';

class BottomSheetStatistical extends StatefulWidget {
  final List<TerminalResponseDTO> listTerminal;
  final Function(
      DateTime date,
      DateTime timeDay,
      TerminalResponseDTO terminal,
      String codeSearch,
      String keySearch,
      StatisticStatusData statusData) onApply;
  final DateTime dateFilter;
  final DateTime timeDay;
  final TerminalResponseDTO terminalDto;
  final StatisticStatusData statusData;
  final List<StatisticStatusData> listStatusData;

  final String keySearch;
  final String codeSearch;
  final bool isOwner;
  final Function() reset;

  const BottomSheetStatistical({
    super.key,
    required this.listTerminal,
    required this.onApply,
    required this.dateFilter,
    required this.timeDay,
    required this.terminalDto,
    required this.keySearch,
    required this.codeSearch,
    required this.isOwner,
    required this.reset,
    required this.statusData,
    required this.listStatusData,
  });

  @override
  State<BottomSheetStatistical> createState() => _BottomSheetStatisticalState();
}

class _BottomSheetStatisticalState extends State<BottomSheetStatistical> {
  MonthCalculator monthCalculator = MonthCalculator();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        color: Colors.transparent,
        child: ChangeNotifierProvider<StatisticProvider>(
          create: (context) => StatisticProvider(widget.isOwner)
            ..updateData(
              listTerminal: widget.listTerminal,
              dateTimeFilter: widget.dateFilter,
              statusData: widget.statusData,
              terminal: widget.terminalDto,
              keySearchParent: widget.keySearch,
              codeSearchParent: widget.codeSearch,
              listStatusData: widget.listStatusData,
              timeDayParent: widget.timeDay,
            ),
          child: Consumer<StatisticProvider>(
            builder: (context, provider, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAppbar(context),
                  const SizedBox(height: 24),
                  _buildDropListTerminal(),
                  const SizedBox(height: 24),
                  _buildDropStatus(),
                  const SizedBox(height: 24),
                  _buildDropTime(),
                  const SizedBox(height: 80),
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
                              widget.reset();
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
                              widget.onApply(
                                  provider.dateFilter,
                                  provider.timeDay,
                                  provider.terminalResponseDTO,
                                  provider.codeSearch,
                                  provider.keySearch,
                                  provider.statisticStatusData);
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDropListTerminal() =>
      Consumer<StatisticProvider>(builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cửa hàng',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  border: Border.all(
                      color: AppColor.BLACK_BUTTON.withOpacity(0.5),
                      width: 0.5),
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
                              enable: widget.isOwner,
                              fillColor: AppColor.WHITE,
                              value: widget.isOwner
                                  ? provider.keySearch
                                  : provider.terminalResponseDTO.name,
                              styles: const TextStyle(fontSize: 14),
                              textFieldType: TextfieldType.DEFAULT,
                              maxLength: 10,
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Chọn cửa hàng',
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
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
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
            ),
          ],
        );
      });

  Widget _buildDropStatus() =>
      Consumer<StatisticProvider>(builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Lọc theo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  border: Border.all(
                      color: AppColor.BLACK_BUTTON.withOpacity(0.5),
                      width: 0.5),
                  borderRadius: BorderRadius.circular(6)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<StatisticStatusData>(
                  isExpanded: true,
                  selectedItemBuilder: (context) {
                    return provider.listStatisticStatus
                        .map(
                          (item) => DropdownMenuItem<StatisticStatusData>(
                            value: item,
                            child: MTextFieldCustom(
                              isObscureText: false,
                              maxLines: 1,
                              enable: false,
                              fillColor: AppColor.WHITE,
                              value: provider.statisticStatusData.name,
                              styles: const TextStyle(fontSize: 14),
                              textFieldType: TextfieldType.DEFAULT,
                              maxLength: 10,
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Chọn cửa hàng',
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.next,
                              onChange: provider.updateKeyword,
                            ),
                          ),
                        )
                        .toList();
                  },
                  items: provider.listStatisticStatus.map((item) {
                    return DropdownMenuItem<StatisticStatusData>(
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  }).toList(),
                  value: provider.statisticStatusData,
                  onChanged: provider.updateStatusData,
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
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
            ),
          ],
        );
      });

  Widget _buildDropTime() {
    return Consumer<StatisticProvider>(builder: (context, provider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Thời gian (${provider.statisticStatusData.type == 0 ? 'ngày' : 'tháng'})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => provider.statisticStatusData.type == 1
                ? _onPickMonth(provider)
                : _onPickDay(provider),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: 50,
              decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  border: Border.all(
                      color: AppColor.BLACK_BUTTON.withOpacity(0.5),
                      width: 0.5),
                  borderRadius: BorderRadius.circular(6)),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      provider.statisticStatusData.type == 0
                          ? provider.getTimeDay
                          : provider.getDateTime,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAppbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 4),
      child: Row(
        children: [
          const Spacer(),
          const SizedBox(
            width: 48,
          ),
          const Text(
            'Bộ lọc thống kê',
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
    );
  }

  void _onPickMonth(StatisticProvider provider) async {
    final result = await showDialog(
      barrierDismissible: false,
      context: NavigationService.context!,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
            child: DialogPickDate(
              dateTime: provider.dateFilter,
            ),
          ),
        );
      },
    );

    if (result != null && result is DateTime) {
      provider.updateDateFilter(result);
    }
  }

  void _onPickDay(StatisticProvider provider) async {
    DateTime? date = await showDateTimePicker(
      context: context,
      initialDate: provider.timeDay,
      firstDate: DateTime(2021, 6),
      lastDate: DateTime.now(),
    );

    provider.updateTimeDay(date);
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    return selectedDate;
  }
}
