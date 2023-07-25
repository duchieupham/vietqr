import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class PhoneWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController phoneController;

  const PhoneWidget({super.key, this.onChanged, required this.phoneController});

  @override
  State<PhoneWidget> createState() => _BodyWidget();
}

class _BodyWidget extends State<PhoneWidget> {
  dynamic _selectedCountryCode;
  final List<String> _countryCodes = ['+84'];
  late FocusNode myFocusPhone;

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = _countryCodes.first;
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          // DropdownButtonHideUnderline(
          //   child: ButtonTheme(
          //     alignedDropdown: true,
          //     child: DropdownButton(
          //       value: _selectedCountryCode,
          //       items: _countryCodes.map((String value) {
          //         return DropdownMenuItem<String>(
          //           value: value,
          //           child: Text(
          //             value,
          //             style: const TextStyle(fontSize: 14.0),
          //           ),
          //         );
          //       }).toList(),
          //       onChanged: (value) {
          //         setState(() {
          //           _selectedCountryCode = value;
          //         });
          //       },
          //     ),
          //   ),
          // ),
          SizedBox(
            width: 16,
          ),
          Text(
            '+84',
            style: TextStyle(fontSize: 14.0),
          ),
          SizedBox(
            width: 8,
          ),
          VerticalDivider(
            color: Colors.black,
            thickness: 0.2,
          ),
        ],
      ),
    );
    return Column(
      children: [
        Row(
          children: const [
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
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: widget.phoneController,
                  onChanged: widget.onChanged,
                  autofocus: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    fillColor: AppColor.WHITE,
                    filled: true,
                    border: InputBorder.none,
                    hintText: '090 123 4567',
                    hintStyle:
                        TextStyle(color: AppColor.GREY_TEXT, fontSize: 14),
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
