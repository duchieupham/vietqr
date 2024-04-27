import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

class DialogPickDate extends StatefulWidget {
  final DateTime dateTime;

  const DialogPickDate({super.key, required this.dateTime});

  @override
  State<DialogPickDate> createState() => _DialogPickDateState();
}

class _DialogPickDateState extends State<DialogPickDate> {
  List<int> listMonth = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> listYear = [];

  int _monthSelect = 0;
  int _year = 0;

  DateTime get _now => DateTime.now();

  @override
  void initState() {
    super.initState();
    _monthSelect = widget.dateTime.month;
    _year = widget.dateTime.year;
    for (int i = 0; i < 5; i++) {
      int yearNow = _now.year;
      listYear.add(yearNow - i);
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                        dropdownColor: AppColor.grey979797,
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
                IconButton(
                  onPressed: () {
                    if (_year >= _now.year) {
                      return;
                    }
                    _year++;
                    updateState();
                  },
                  color: Colors.white,
                  icon: Icon(Icons.keyboard_arrow_up_outlined),
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.only(right: 12, left: 12, top: 16),
                ),
                IconButton(
                  onPressed: () {
                    _year--;
                    updateState();
                  },
                  color: Colors.white,
                  icon: Icon(Icons.keyboard_arrow_down_outlined),
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.only(right: 12, left: 12, top: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            height: 160,
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
              itemCount: listMonth.length,
              itemBuilder: (context, index) {
                var data = listMonth[index];
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
