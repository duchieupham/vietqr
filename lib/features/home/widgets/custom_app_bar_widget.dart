import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final double? preferredHeight;
  final double? preferredWidth;
  final String? title;
  final Widget? child;

  const CustomAppBarWidget(
      {super.key,
      this.preferredHeight,
      this.preferredWidth,
      this.title,
      this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: preferredHeight ?? kToolbarHeight,
        width: preferredWidth ?? MediaQuery.of(context).size.width,
        child: child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    'assets/images/ic-pop.png',
                    fit: BoxFit.contain,
                    height: 30,
                    width: 30,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                const Spacer(),
                Text(
                  title ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).cardColor,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      'assets/images/ic-viet-qr-small-trans.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
              ],
            ),
        // Add your custom widget content here
      ),
    );
  }

  @override
  Size get preferredSize => Size(
      preferredWidth ?? double.infinity, preferredHeight ?? kToolbarHeight);
}
