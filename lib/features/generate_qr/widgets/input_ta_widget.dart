import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/generate_qr/widgets/cal_keyboard_widget.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputTAWidget extends StatelessWidget {
  final VoidCallback onNext;

  const InputTAWidget({
    Key? key,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // const Padding(padding: EdgeInsets.only(bottom: 50)),
        Expanded(
          flex: 1,
          child: Center(
            child: Consumer<CreateQRProvider>(
              builder: (context, value, child) {
                return RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: DefaultTheme.GREEN,
                    ),
                    children: [
                      TextSpan(
                        text: value.currencyFormatted,
                      ),
                      TextSpan(
                        text: ' VND',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        // const Padding(padding: EdgeInsets.only(bottom: 50)),
        CalKeyboardWidget(
          width: width,
          height: height * 0.65,
          onNext: onNext,
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20))
      ],
    );
  }
}
