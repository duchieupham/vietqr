import 'package:flutter/cupertino.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class HeaderMerchantWidget extends StatelessWidget {
  final String nameStore;
  final String title;
  final String? desTitle;

  const HeaderMerchantWidget({
    super.key,
    required this.nameStore,
    required this.title,
    this.desTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/logo-business-3D.png',
              height: 100,
            ),
          ],
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (desTitle != null) ...[
          Text(
            desTitle!,
            style: const TextStyle(color: AppColor.GREY_TEXT),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
