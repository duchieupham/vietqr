import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';

class ChooseBankTypeWidget extends StatelessWidget {
  const ChooseBankTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Column(
        children: [
          SizedBox(
            width: width,
            height: 50,
            child: Row(
              children: [
                const SizedBox(
                  width: 80,
                  height: 50,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Chọn gói dịch vụ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 80,
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'Xong',
                      style: TextStyle(
                        color: AppColor.GREEN,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(width: width),
          const Padding(padding: EdgeInsets.only(top: 30)),
          // _buildButton(
          //   context: context,
          //   title: 'Tổ chức cá nhân',
          //   description: 'Nội dung miêu tả',
          //   icon: Icons.person_rounded,
          //   color: DefaultTheme.BLUE_TEXT,
          //   onTap: () {
          //     Navigator.pop(context, 0);
          //   },
          // ),
          // const Padding(padding: EdgeInsets.only(top: 10)),
          _buildButton(
            context: context,
            title: 'Gói dịch vụ VietQR Pro',
            description: 'Nội dung miêu tả',
            icon: Icons.shopping_bag_rounded,
            color: AppColor.GREEN,
            onTap: () {
              Navigator.pop(context, 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: BoxLayout(
        width: width,
        bgColor: Theme.of(context).canvasColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Text(description),
                ],
              ),
            ),
            const SizedBox(
              width: 30,
              height: 30,
              child: Icon(
                Icons.navigate_next_rounded,
                color: AppColor.GREY_TEXT,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
