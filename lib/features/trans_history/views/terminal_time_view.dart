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
  DateTime? toDate;
  DateTime? fromDate;
  MonthCalculator monthCalculator = MonthCalculator();

  @override
  void initState() {
    super.initState();
    setState(() {
      toDate = widget.toDate;
      fromDate = widget.fromDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColor.WHITE, borderRadius: BorderRadius.circular(16)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
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
                  if (toDate != null) {
                    int numberOfMonths = monthCalculator.calculateMonths(
                        date ?? DateTime.now(), toDate ?? DateTime.now());
                    if (numberOfMonths > 3) {
                      DialogWidget.instance.openMsgDialog(
                          title: 'Không hợp lệ',
                          msg:
                              'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
                    } else {
                      setState(() {
                        fromDate = date;
                      });
                    }
                  } else {
                    setState(() {
                      fromDate = date;
                    });
                  }
                  widget.updateFromDate(fromDate!);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.5),
                          width: 0.5),
                      borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Từ:',
                        style:
                            TextStyle(fontSize: 12, color: AppColor.textBlack),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          TimeUtils.instance.formatDateToString(fromDate),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
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
                      fromDate ?? DateTime.now(), date ?? DateTime.now());
                  if (numberOfMonths > 3) {
                    DialogWidget.instance.openMsgDialog(
                        title: 'Không hợp lệ',
                        msg:
                            'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
                  } else {
                    setState(() {
                      toDate = date;
                    });
                  }
                },
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.5),
                          width: 0.5),
                      borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    children: [
                      const Text(
                        'Đến:',
                        style:
                            TextStyle(fontSize: 12, color: AppColor.textBlack),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          toDate == null
                              ? 'Chọn ngày'
                              : TimeUtils.instance.formatDateToString(toDate),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
