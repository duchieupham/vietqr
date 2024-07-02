import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class DefaultAppbarWidget extends StatelessWidget {
  const DefaultAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      leadingWidth: 100,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          // height: 40,
          color: AppColor.WHITE,
        ),
      ),
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.only(left: 8),
          child: const Row(
            children: [
              Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 25,
              ),
              SizedBox(width: 2),
              Text(
                "Trở về",
                style: TextStyle(color: Colors.black, fontSize: 14),
              )
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Image.asset(
            AppImages.icLogoVietQr,
            width: 95,
            fit: BoxFit.fitWidth,
          ),
        )
      ],
    );
  }
}
