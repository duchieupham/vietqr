import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/month_calculator.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';

class TerminalTimeView extends StatefulWidget {
  final DateTime? toDate;
  final DateTime fromDate;
  final Function(DateTime?) updateToDate;
  final Function(DateTime?) updateFromDate;

  const TerminalTimeView({
    super.key,
    required this.toDate,
    required this.fromDate,
    required this.updateToDate,
    required this.updateFromDate,
  });

  @override
  State<TerminalTimeView> createState() => _TerminalTimeViewState();
}

class _TerminalTimeViewState extends State<TerminalTimeView> {
  DateTime toDate = DateTime.now();
  DateTime fromDate = DateTime.now();
  MonthCalculator monthCalculator = MonthCalculator();

  @override
  void initState() {
    super.initState();
    setState(() {
      toDate = widget.toDate ?? DateTime.now();
      fromDate = widget.fromDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
          color: AppColor.WHITE, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                DateTime? date = await showDateTimePicker(
                  context: context,
                  initialDate: fromDate,
                  firstDate: DateTime(2021, 6),
                  lastDate: DateTime.now(),
                );

                int numberOfMonths = monthCalculator.calculateMonths(
                    date ?? DateTime.now(), toDate);

                if (numberOfMonths > 3) {
                  DialogWidget.instance.openMsgDialog(
                      title: 'Cảnh báo',
                      msg: 'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
                } else if ((date ?? DateTime.now()).isAfter(toDate)) {
                  DialogWidget.instance.openMsgDialog(
                      title: 'Cảnh báo',
                      msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
                } else {
                  setState(() {
                    fromDate = date ?? DateTime.now();
                  });

                  widget.updateFromDate(fromDate);
                }
              },
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.GREY_BG,
                  border: Border.all(color: AppColor.GREY_LIGHT),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Từ: ',
                      style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        TimeUtils.instance.formatDateToString(fromDate),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 12,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () async {
                DateTime? date = await showDateTimePicker(
                  context: context,
                  initialDate: toDate,
                  firstDate: DateTime(2021, 6),
                  lastDate: DateTime.now(),
                );
                int numberOfMonths = monthCalculator.calculateMonths(
                    fromDate, date ?? DateTime.now());

                if (numberOfMonths > 3) {
                  DialogWidget.instance.openMsgDialog(
                      title: 'Cảnh báo',
                      msg: 'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
                } else if ((date ?? DateTime.now()).isBefore(fromDate)) {
                  DialogWidget.instance.openMsgDialog(
                      title: 'Cảnh báo',
                      msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
                } else {
                  setState(() {
                    toDate = date ?? DateTime.now();
                  });
                  widget.updateToDate(toDate);
                }
              },
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.GREY_BG,
                  border: Border.all(color: AppColor.GREY_LIGHT),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Đến: ',
                      style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        TimeUtils.instance.formatDateToString(toDate),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 12,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }
}
