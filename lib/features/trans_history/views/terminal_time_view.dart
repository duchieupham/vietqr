import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

class TerminalTimeView extends StatefulWidget {
  final DateTime? toDate;
  final DateTime fromDate;

  const TerminalTimeView({
    super.key,
    required this.toDate,
    required this.fromDate,
  });

  @override
  State<TerminalTimeView> createState() => _TerminalTimeViewState();
}

class _TerminalTimeViewState extends State<TerminalTimeView> {
  DateTime? toDate;
  DateTime? fromDate;

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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColor.WHITE, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.clear, color: AppColor.TRANSPARENT),
              Expanded(
                child: Text(
                  'Chọn thời gian',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.clear),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 24, top: 40),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    DateTime? date = await showDateTimePicker(
                      context: context,
                      initialDate: fromDate,
                      firstDate:
                          Jiffy(DateTime.now()).subtract(months: 5).dateTime,
                      lastDate: Jiffy(DateTime.now()).add(months: 5).dateTime,
                    );
                    setState(() {
                      fromDate = date;
                    });
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.GREY_EBEBEB,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: const Text(
                            'Từ ngày',
                            style: TextStyle(
                                fontSize: 14, color: AppColor.GREY_TEXT),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ...[
                          Text(
                            TimeUtils.instance.formatDateToString(fromDate),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 16,
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    DateTime? date = await showDateTimePicker(
                      context: context,
                      initialDate: toDate,
                      firstDate:
                          Jiffy(DateTime.now()).subtract(months: 5).dateTime,
                      lastDate: Jiffy(DateTime.now()).add(months: 5).dateTime,
                    );

                    setState(() {
                      toDate = date;
                    });
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.GREY_EBEBEB,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: const Text(
                            'Đến ngày',
                            style: TextStyle(
                                fontSize: 14, color: AppColor.GREY_TEXT),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ...[
                          Text(
                            toDate == null
                                ? 'Chọn ngày'
                                : TimeUtils.instance.formatDateToString(toDate),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          MButtonWidget(
            title: 'Xong',
            isEnable: toDate != null,
            colorDisableBgr: AppColor.GREY_BUTTON,
            colorDisableText: AppColor.BLACK,
            margin: EdgeInsets.zero,
            onTap: () => Navigator.pop(context, [fromDate, toDate]),
          ),
          const SizedBox(height: 12),
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
