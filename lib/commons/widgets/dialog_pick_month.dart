import 'package:flutter/material.dart';

import '../../layouts/m_button_widget.dart';
import '../constants/configurations/theme.dart';

class DialogPickDate extends StatefulWidget {
  final DateTime dateTime;

  const DialogPickDate({super.key, required this.dateTime});

  @override
  State<DialogPickDate> createState() => _DialogPickDateState();
}

class _DialogPickDateState extends State<DialogPickDate> {
  List<int> listMonth = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> listMonthNow = [];

  List<int> listYear = [];

  int _monthSelect = 0;
  int _year = 0;

  DateTime get _now => DateTime.now();

  @override
  void initState() {
    super.initState();
    _monthSelect = widget.dateTime.month;
    _year = widget.dateTime.year;
    for (int i = 0; i < 2; i++) {
      int yearNow = _now.year;
      listYear.add(yearNow - i);
    }
    for (int i = 1; i <= _monthSelect; i++) {
      listMonthNow.add(i);
    }
    updateState();
  }

  DateTime convertStringToDate() {
    DateTime dateTime = DateTime(_year, _monthSelect);

    return dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      height: 500,
      width: 500,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.lightBlue,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$_monthSelect - $_year',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      DropdownButton<int>(
                        value: _year,
                        elevation: 16,
                        onChanged: (int? value) {
                          _year = value!;
                          updateState();
                        },
                        dropdownColor: AppColor.GREY_979797,
                        items: listYear.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              '$value',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: AppColor.WHITE,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2,
                ),
                itemCount: _year == widget.dateTime.year
                    ? listMonthNow.length
                    : listMonth.length,
                itemBuilder: (context, index) {
                  var data = _year == widget.dateTime.year
                      ? listMonthNow[index]
                      : listMonth[index];
                  return GestureDetector(
                    onTap: () async {
                      _monthSelect = data;
                      updateState();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: data == _monthSelect
                              ? Colors.lightBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5)),
                      alignment: Alignment.center,
                      child: Text(
                        'Tháng $data',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: data == _monthSelect
                                ? Colors.white
                                : AppColor.BLACK_TEXT),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MButtonWidget(
                title: 'Đóng',
                isEnable: true,
                width: 80,
                margin: EdgeInsets.only(right: 20, bottom: 20),
                colorEnableText: Colors.black,
                colorEnableBgr: AppColor.BANK_CARD_COLOR_2,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              MButtonWidget(
                title: 'Xác nhận',
                width: 80,
                margin: EdgeInsets.only(right: 20, bottom: 20),
                isEnable: true,
                onTap: () {
                  DateTime _date = convertStringToDate();
                  Navigator.of(context).pop(_date);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void updateState() {
    setState(() {});
  }
}
