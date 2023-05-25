import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/features/token/blocs/token_bloc.dart';
import 'package:vierqr/features/token/events/token_event.dart';

class DisconnectWidget extends StatelessWidget {
  final TokenBloc tokenBloc;

  const DisconnectWidget({
    super.key,
    required this.tokenBloc,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        SizedBox(
          width: width * 0.4,
          child: Image.asset(
            'assets/images/ic-disconnect.png',
          ),
        ),
        const Text(
          'Mất kết nối',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        const Text(
          'Vui lòng kiểm tra lại kết nối mạng, đảm bảo rằng Wifi hoặc dữ liệu di động được bật.',
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20)),
        ButtonIconWidget(
          width: width - 40,
          height: 40,
          icon: Icons.refresh_rounded,
          title: 'Thử lại',
          function: () {
            tokenBloc.add(const TokenEventCheckValid());
            Navigator.pop(context);
          },
          bgColor: Theme.of(context).canvasColor,
          textColor: Theme.of(context).hintColor,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 30),
        ),
      ],
    );
  }
}
