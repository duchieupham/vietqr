import 'package:flutter/material.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          SubHeader(
            title: 'Nạp tiền điẹn thoại',
            function: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Future.delayed(const Duration(milliseconds: 200), () {
                Navigator.of(context).pop();
              });
            },
            callBackHome: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Text('Số điện thoại: '),
                Expanded(
                  child: TextFieldWidget(
                    hintText: '',
                    height: 50,
                    controller: TextEditingController(),
                    keyboardAction: TextInputAction.next,
                    onChange: (value) {},
                    inputType: TextInputType.number,
                    isObscureText: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
