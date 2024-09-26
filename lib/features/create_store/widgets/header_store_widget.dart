import 'package:flutter/cupertino.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class HeaderStoreWidget extends StatelessWidget {
  final String nameStore;
  final String title;
  final String? desTitle;

  const HeaderStoreWidget({
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
              'assets/images/logo-store-3D.png',
              height: 100,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: RichText(
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 14,
                      color: AppColor.BLACK,
                      fontWeight: FontWeight.w400),
                  children: [
                    const TextSpan(text: 'Cửa hàng:\n'),
                    TextSpan(
                      text: nameStore,
                      style: const TextStyle(
                          fontSize: 15,
                          color: AppColor.BLACK,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
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
