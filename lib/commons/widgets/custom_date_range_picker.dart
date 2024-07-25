import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class CustomDateRangePicker extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  CustomDateRangePicker({this.initialStartDate, this.initialEndDate});

  @override
  _CustomDateRangePickerState createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  DateTime lastDay = DateTime.now().add(const Duration(days: 28));
  DateTime getThreeMonthPrevious() {
    DateTime now = DateTime.now();
    int newMonth = now.month - 3;
    int newYear = now.year;
    int newDay = now.day;

    if (newMonth < 1) {
      newMonth = 12; // Set month to December
      newYear--; // Decrement year
    }

    return DateTime(newYear, newMonth, newDay);
  }

  bool _isDisabled(DateTime day) {
    if (day.isAfter(DateTime.now()) || day.isBefore(getThreeMonthPrevious())) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _rangeStart = widget.initialStartDate;
    _rangeEnd = widget.initialEndDate;
    if (widget.initialStartDate != null) {
      _focusedDay = widget.initialStartDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEnableButton = false;
    if (_startDate != null && _endDate != null) {
      isEnableButton = true;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chọn thời gian\nhiển thị giao dịch',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const XImage(
                  imagePath: 'assets/images/ic-close-black.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: _startDate == null
                      ? [
                          const Color(0xFFA6C5FF),
                          const Color(0xFFC5CDFF),
                        ]
                      : [AppColor.BLACK, AppColor.BLACK],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: Text(
                  _startDate != null
                      ? _startDate!.toLocal().toIso8601String().substring(0, 10)
                      : 'Ngày bắt đầu',
                  style: const TextStyle(fontSize: 16, color: AppColor.WHITE),
                ),
              ),
              const XImage(
                imagePath: 'assets/images/ic-next-black.png',
                width: 40,
                fit: BoxFit.fitWidth,
              ),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: _startDate != null && _endDate == null
                      ? [
                          const Color(0xFFA6C5FF),
                          const Color(0xFFC5CDFF),
                        ]
                      : _endDate != null
                          ? [AppColor.BLACK, AppColor.BLACK]
                          : [
                              const Color(0xFF666A72),
                              const Color(0xFF666A72),
                            ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: Text(
                  _endDate != null
                      ? _endDate!.toLocal().toIso8601String().substring(0, 10)
                      : 'Ngày kết thúc',
                  style: const TextStyle(fontSize: 16, color: AppColor.WHITE),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Năm ${DateTime.now().year}',
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
        Expanded(
          child: TableCalendar(
            locale: 'vi_VN',
            firstDay: DateTime.utc(2023, 12, 31),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_startDate, day) || isSameDay(_endDate, day);
            },
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_startDate, selectedDay) ||
                  !isSameDay(_endDate, selectedDay)) {
                setState(() {
                  if (_rangeSelectionMode == RangeSelectionMode.toggledOff) {
                    _startDate = selectedDay;
                    _endDate = null;
                    _rangeStart = selectedDay;
                    _rangeEnd = null;
                    _rangeSelectionMode = RangeSelectionMode.toggledOn;
                  } else if (_rangeSelectionMode ==
                      RangeSelectionMode.toggledOn) {
                    _endDate = selectedDay;
                    _rangeEnd = selectedDay;
                    _rangeSelectionMode = RangeSelectionMode.toggledOff;
                  }
                  _focusedDay = focusedDay;
                });
              }
            },
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                if (start!.isAfter(DateTime.now())) {
                  start = DateTime.now();
                }
<<<<<<< Updated upstream
                if (end != null && end!.isAfter(DateTime.now())) {
                  end = DateTime.now();
                }
=======
                // if (end != null && end!.isAtSameMomentAs(DateTime.now())) {
                //   end = DateTime.now();
                // }
                if (end != null && end!.isAfter(DateTime.now())) {
                  end = DateTime.now();
                }
                // if (start == end) {
                //   _startDate = start;
                //   _endDate = end;
                //   _rangeStart = start;
                //   _rangeEnd = end;
                //   _rangeSelectionMode = RangeSelectionMode.toggledOff;
                // } else {
                //   _startDate = start;
                //   _endDate = end;
                //   _rangeStart = start;
                //   _rangeEnd = end;
                //   _rangeSelectionMode = RangeSelectionMode.toggledOn;
                // }
                // _focusedDay = focusedDay;
>>>>>>> Stashed changes

                _startDate = start;
                _endDate = end;
                _focusedDay = focusedDay;
                _rangeStart = start;
                _rangeEnd = end;
                _rangeSelectionMode = RangeSelectionMode.toggledOn;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: const HeaderStyle(
              headerPadding: EdgeInsets.only(bottom: 20, top: 8),
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronVisible: false,
              rightChevronVisible: false,
              // formatButtonShowsNext: false,
            ),
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(color: AppColor.BLACK),
              // holidayTextStyle: TextStyle(color: AppColor.BLACK),
              tablePadding: EdgeInsets.symmetric(horizontal: 18),
              rangeHighlightColor: Color(0xFFE5F9FF),
              // rangeStartDecoration: BoxDecoration(
              //   color: Color(0xFFE5F9FF),
              // ),
              // rangeEndDecoration: BoxDecoration(
              //   color: Color(0xFFE5F9FF),
              // ),
              // withinRangeDecoration: BoxDecoration(color: Color(0xFFE5F9FF)),
              selectedDecoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF00C6FF),
                  Color(0xFF0072FF),
                ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                shape: BoxShape.circle,
              ),
            ),
            enabledDayPredicate: (date) {
              // return !date.isAfter(DateTime.now());
              return !_isDisabled(date);
            },
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: const TextStyle(color: Colors.black, fontSize: 12),
              weekendStyle: const TextStyle(color: Colors.red, fontSize: 12),
              dowTextFormatter: (date, locale) {
                switch (date.weekday) {
                  case DateTime.monday:
                    return 'T2';
                  case DateTime.tuesday:
                    return 'T3';
                  case DateTime.wednesday:
                    return 'T4';
                  case DateTime.thursday:
                    return 'T5';
                  case DateTime.friday:
                    return 'T6';
                  case DateTime.saturday:
                    return 'T7';
                  case DateTime.sunday:
                    return 'CN';
                }
                return '';
              },
            ),
            calendarBuilders: CalendarBuilders(
              disabledBuilder: (context, date, focusedDay) {
                return Center(
                  child: Text(
                    date.day.toString(),
                    style: const TextStyle(color: AppColor.GREY_TOP_TAB_BAR),
                  ),
                );
              },
              outsideBuilder: (context, date, focusedDay) {
                return Center(
                  child: Text(
                    date.day.toString(),
                    style: const TextStyle(color: Color(0xFF00C6FF)),
                  ),
                );
              },
              headerTitleBuilder: (context, day) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          final previousMonth =
                              DateTime(_focusedDay.year, _focusedDay.month - 1);
                          if (previousMonth
                              .isAfter(DateTime.utc(2023, 12, 31))) {
                            setState(() {
                              _focusedDay = previousMonth;
                            });
                          }
                        },
                        child: Text(
                          'Tháng ${(day.month - 1 == 0 ? 12 : day.month - 1).toString()}',
                          style: const TextStyle(
                              fontSize: 15, color: AppColor.GREY_TEXT),
                        ),
                      ),
                      Text(
                        'Tháng ${day.month.toString()}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      InkWell(
                        onTap: () {
                          final nextMonth =
                              DateTime(_focusedDay.year, _focusedDay.month + 1);
                          if (nextMonth.isBefore(lastDay)) {
                            setState(() {
                              _focusedDay = nextMonth;
                            });
                          }
                        },
                        child: Text(
                          'Tháng ${(day.month + 1 == 13 ? 1 : day.month + 1).toString()}',
                          style: const TextStyle(
                              fontSize: 15, color: AppColor.GREY_TEXT),
                        ),
                      ),
                    ],
                  ),
                );
              },
              todayBuilder: (context, date, _) {
                return Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF00C6FF),
                        Color(0xFF0072FF),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: Text(
                      '${date.day}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const Text(
          'Lưu ý: Hệ thống chỉ cho phép truy vấn GD 3 tháng gần nhất',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: isEnableButton
              ? () {
                  if (_startDate != null && _endDate != null) {
                    Navigator.of(context)
                        .pop(DateTimeRange(start: _startDate!, end: _endDate!));
                  }
                }
              : null,
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 35),
            height: 40,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: isEnableButton
                    ? [
                        const Color(0xFF00C6FF),
                        const Color(0xFF0072FF),
                      ]
                    : [
                        const Color(0xFFF0F4FA),
                        const Color(0xFFF0F4FA),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              'Lưu thay đổi',
              maxLines: 1,
              style: TextStyle(
                color: isEnableButton ? AppColor.WHITE : Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        )
      ],
    );
  }
}
