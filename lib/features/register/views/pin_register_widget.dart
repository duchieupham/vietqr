import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class PinRegisterWidget extends StatefulWidget {
  final double pinSize;
  final int pinLength;
  final Function(String) onDone;

  const PinRegisterWidget({
    super.key,
    required this.pinSize,
    required this.pinLength,
    required this.onDone,
  });

  @override
  State<PinRegisterWidget> createState() => _PinRegisterWidgetState();
}

class _PinRegisterWidgetState extends State<PinRegisterWidget> {
  bool _isShowText = false;
  int _length = -1;

  List listValue = [];

  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      listValue.add('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  height: widget.pinSize + 5,
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    itemCount: widget.pinLength,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: ((context, index) {
                      return UnconstrainedBox(
                        child: Container(
                          width: widget.pinSize,
                          height: widget.pinSize,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.pinSize),
                            color: (_length <= index)
                                ? AppColor.TRANSPARENT
                                : _isShowText
                                    ? AppColor.TRANSPARENT
                                    : AppColor.GREY_TOP_TAB_BAR,
                            border: Border.all(
                              width: 2,
                              color: AppColor.GREY_TOP_TAB_BAR,
                            ),
                          ),
                          child: _isShowText
                              ? Text(
                                  listValue[index],
                                  textAlign: TextAlign.center,
                                )
                              : null,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              TextField(
                obscureText: true,
                maxLength: widget.pinLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                showCursor: false,
                decoration: const InputDecoration(
                  counterStyle: TextStyle(
                    height: 0,
                  ),
                  counterText: '',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: AppColor.TRANSPARENT),
                keyboardType: TextInputType.number,
                onChanged: ((text) {
                  setState(() {
                    for (int i = 0; i < widget.pinLength; i++) {
                      if (i < text.length) {
                        listValue[i] = text[i];
                      } else {
                        listValue[i] = '';
                      }
                    }

                    _length = text.length;
                    if (text.length == widget.pinLength) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      widget.onDone(text);
                    }
                  });
                }),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _isShowText = !_isShowText;
            });
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: !_isShowText
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
        )
      ],
    );
  }
}
