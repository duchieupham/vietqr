import 'package:flutter/material.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class ItemService extends StatelessWidget {
  const ItemService({
    super.key,
    required this.pathIcon,
    required this.title,
    required this.onTap,
  });

  final String pathIcon;
  final String title;
  final VoidCallback onTap;

  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: getDeviceType() == 'phone' ? width / 5 - 7 : 70,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            XImage(
              imagePath: pathIcon,
              height: 45,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
