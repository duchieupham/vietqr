import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/models/store/data_filter.dart';

class DropFilterWidget extends StatelessWidget {
  final List<DataFilter> list;
  final DataFilter filter;
  final Function(DataFilter?) callBack;
  final String? title;

  const DropFilterWidget({
    super.key,
    required this.list,
    required this.filter,
    required this.callBack,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(title!, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          height: 44,
          decoration: BoxDecoration(
              color: AppColor.WHITE,
              border: Border.all(
                  color: AppColor.BLACK_BUTTON.withOpacity(0.5), width: 0.5),
              borderRadius: BorderRadius.circular(6)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<DataFilter>(
              isExpanded: true,
              selectedItemBuilder: (context) {
                return list.map(
                  (item) {
                    return DropdownMenuItem<DataFilter>(
                      value: item,
                      alignment: AlignmentDirectional.topStart,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  },
                ).toList();
              },
              items: list.map((item) {
                return DropdownMenuItem<DataFilter>(
                  value: item,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.name,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
              value: filter,
              onChanged: callBack.call,
              buttonStyleData: ButtonStyleData(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.WHITE,
                ),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.expand_more),
                iconSize: 14,
                iconEnabledColor: AppColor.BLACK,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
