import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
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
  final ValueNotifier<bool> isClose = ValueNotifier(false);

  @override
  void dispose() {
    isClose.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.BLACK.withOpacity(0.5),
      // color: Colors.transparent,
      child: SizedBox(
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
                      image: Image.asset(ImageConstant.popupNotificationMobile)
                          .image,
                      fit: BoxFit.fitHeight)),
            ),
            const SizedBox(height: 30),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColor.BLACK.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ValueListenableBuilder<bool>(
                  valueListenable: isClose,
                  child: const Text(
                    'Không hiển thị thông tin này ở lần sau',
                    style: TextStyle(
                        color: AppColor.WHITE,
                        fontSize: 13), // Chỉnh màu chữ nếu cần
                  ),
                  builder: (context, value, child) {
                    return CheckboxListTile(
                      side: const BorderSide(color: Colors.white),
                      checkboxShape: const CircleBorder(),
                      title: child,
                      value: value,
                      onChanged: (result) {
                        isClose.value = result ?? false;
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      // Checkbox ở bên trái
                      activeColor: AppColor.BLUE_TEXT,
                      // Màu của Checkbox khi được chọn
                      checkColor:
                          AppColor.WHITE, // Màu của dấu check trong Checkbox
                    );
                  }),
            ),
            const SizedBox(
              height: 50,
            ),
            MButtonWidget(
              height: 50,
              width: double.infinity,
              isEnable: true,
              margin: const EdgeInsets.symmetric(horizontal: 80),
              title: 'Đóng',
              onTap: () {
                if (isClose.value == true) {
                  getIt
                      .get<DashBoardBloc>()
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
