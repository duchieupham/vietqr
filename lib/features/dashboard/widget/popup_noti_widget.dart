import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../layouts/m_button_widget.dart';

class PopupNotiWidget extends StatefulWidget {
  const PopupNotiWidget({super.key});

  @override
  State<PopupNotiWidget> createState() => _PopupNotiWidgetState();
}

class _PopupNotiWidgetState extends State<PopupNotiWidget> {
  bool? isClose = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.BLACK.withOpacity(0.5),
      // color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: Image.asset(
                              'assets/images/popup-notification-mobile.png')
                          .image,
                      fit: BoxFit.fitHeight)),
            ),
            SizedBox(height: 30),
            Container(
              height: 50,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColor.BLACK.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CheckboxListTile(
                checkboxShape: CircleBorder(),
                title: Text(
                  'Không hiển thị thông tin này ở lần sau',
                  style:
                      TextStyle(color: AppColor.WHITE), // Chỉnh màu chữ nếu cần
                ),
                value: isClose,
                onChanged: (value) {
                  setState(() {
                    isClose = value;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, // Checkbox ở bên trái
                activeColor:
                    AppColor.BLUE_TEXT, // Màu của Checkbox khi được chọn
                checkColor: AppColor.WHITE, // Màu của dấu check trong Checkbox
              ),
            ),
            SizedBox(
              height: 50,
            ),
            MButtonWidget(
              height: 50,
              width: double.infinity,
              isEnable: true,
              margin: EdgeInsets.symmetric(horizontal: 80),
              title: 'Đóng',
              onTap: () {
                if (isClose == true) {
                  // widget.onClose;
                  context
                      .read<DashBoardBloc>()
                      .add(CloseMobileNotificationEvent());
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
