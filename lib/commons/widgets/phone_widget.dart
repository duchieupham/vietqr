import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class PhoneWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;

  final TextEditingController phoneController;
  final bool isShowTitle;
  final bool autoFocus;

  const PhoneWidget({
    super.key,
    this.onChanged,
    this.onSubmit,
    required this.phoneController,
    this.isShowTitle = false,
    this.autoFocus = false,
  });

  @override
  State<PhoneWidget> createState() => _BodyWidget();
}

class _BodyWidget extends State<PhoneWidget> {
  late FocusNode myFocusPhone;

  @override
  void initState() {
    super.initState();
    myFocusPhone = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    var countryDropDown = Container(
      decoration: const BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5),
        ),
      ),
      // child: Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: const [
      //     SizedBox(
      //       width: 16,
      //     ),
      //     Text(
      //       '+84',
      //       style: TextStyle(fontSize: 14.0),
      //     ),
      //     SizedBox(
      //       width: 8,
      //     ),
      //     VerticalDivider(
      //       color: AppColor.GREY_LIGHT,
      //       thickness: 1,
      //     ),
      //   ],
      // ),
    );
    return Column(
      children: [
        if (widget.isShowTitle)
          const Row(
            children: [
              SizedBox(
                child: Text(
                  'Số điện thoại',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColor.RED_EC1010,
                ),
              ),
            ],
          ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            children: [
              countryDropDown,
              Expanded(
                child: TextFormField(
                  onFieldSubmitted: widget.onSubmit,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: widget.phoneController,
                  onChanged: widget.onChanged,
                  autofocus: widget.autoFocus,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    fillColor: AppColor.WHITE,
                    filled: true,
                    border: InputBorder.none,
                    hintText: 'Nhập số điện thoại ở đây',
                    hintStyle:
                        TextStyle(color: AppColor.GREY_TEXT, fontSize: 15),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                  ),
                  inputFormatters: [
                    PhoneInputFormatter(
                        allowEndlessPhone: false,
                        defaultCountryCode: 'VN',
                        shouldCorrectNumber: false)
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
