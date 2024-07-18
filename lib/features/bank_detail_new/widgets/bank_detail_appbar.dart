import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class BankDetailAppbar extends StatefulWidget {
  final Function(int) onSelect;
  final int selected;
  final ValueNotifier<bool> isScroll;

  const BankDetailAppbar(
      {super.key,
      required this.onSelect,
      required this.isScroll,
      required this.selected});

  @override
  State<BankDetailAppbar> createState() => _BankDetailAppbarState();
}

class _BankDetailAppbarState extends State<BankDetailAppbar> {
  List<String> listTitle = [
    'Chi tiết',
    'Giao dịch',
    'Thống kê',
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isScroll,
      builder: (context, value, child) {
        return Container(
          height: 100,
          padding: const EdgeInsets.only(top: 50, bottom: 0),
          // color: AppColor.TRANSPARENT,
          decoration: BoxDecoration(
            color: value ? AppColor.WHITE : AppColor.WHITE,
            gradient: value
                ? const LinearGradient(
                    colors: [
                      Color(0xFFE1EFFF),
                      Color(0xFFE5F9FF),
                    ],
                    end: Alignment.centerRight,
                    begin: Alignment.centerLeft,
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
              ),
              // Spacer(),
              const SizedBox(
                width: 10,
              ),
              ...listTitle.map(
                (title) {
                  int index = listTitle.indexOf(title);
                  bool isSelected = widget.selected == index;
                  return GestureDetector(
                    onTap: () {
                      widget.onSelect(index);
                      // setState(() {
                      //   _selectedIndex = index;
                      // });
                      // print(title);
                    },
                    child: Container(
                      height: 30,
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFF00C6FF),
                                  Color(0xFF0072FF),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                      ),
                      child: Text(
                        title,
                        maxLines: 1,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColor.GREY_TEXT,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
