import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class CustomRadio extends StatefulWidget {
  final int value;
  final int groupValue;
  final void Function(int) onChanged;
  final bool isDisable;

  const CustomRadio({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.isDisable = false,
  }) : super(key: key);

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    bool selected = (widget.value == widget.groupValue);

    return InkWell(
      onTap: () => widget.onChanged(widget.value),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.GREY_BG,
          border: Border.all(
              color: !widget.isDisable
                  ? selected
                      ? AppColor.BLUE_TEXT
                      : AppColor.grey979797
                  : AppColor.grey979797.withOpacity(0.7),
              width: 1.5),
        ),
        child: Icon(
          Icons.circle,
          size: 20,
          color: selected ? AppColor.BLUE_TEXT : AppColor.GREY_BG,
        ),
      ),
    );
  }
}
