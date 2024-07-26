import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';

class DisconnectWidget extends StatelessWidget {
  final TypeInternet type;

  const DisconnectWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: type == TypeInternet.CONNECT
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.BLACK_DARK.withOpacity(0.95)),
              child: const Row(
                children: [
                  Icon(
                    Icons.wifi,
                    color: AppColor.GREEN,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Đã có kết nối internet',
                    style: TextStyle(color: AppColor.WHITE),
                  )
                ],
              ),
            )
          : type == TypeInternet.DISCONNECT
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.BLACK_DARK.withOpacity(0.95)),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.wifi_off,
                        color: AppColor.error700,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Mất kết nối internet',
                        style: TextStyle(color: AppColor.WHITE),
                      )
                    ],
                  ),
                )
              : const SizedBox(),
    );
  }
}
