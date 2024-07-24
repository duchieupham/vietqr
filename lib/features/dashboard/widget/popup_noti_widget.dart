import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/widget/popup_bank_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';

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
    return Container(
      height: 840,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 20, height: 20),
              const XImage(
                imagePath: 'assets/images/ic-viet-qr.png',
                width: 80,
                height: 40,
              ),
              InkWell(
                onTap: () {
                  if (isClose.value == true) {
                    getIt
                        .get<DashBoardBloc>()
                        .add(CloseMobileNotificationEvent());
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: const Icon(
                  Icons.clear,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
              child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const Text(
                'Thông báo cập nhật\nphí dịch vụ phần mềm VietQR',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Container(
                // height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'VietQR thông báo về việc áp dụng thu phí dịch vụ đối với các tính năng nhận Biến động số dư. Áp dụng cho các tài khoản ngân hàng đã tích hợp liên kết.\n\nPhí dịch vụ sẽ được áp dụng từ ngày 02/05/2024. Chúng tôi hy vọng Quý khách hàng có những trải nghiệm dịch vụ tốt nhất mà VietQR mang lại.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mức giá áp dụng',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.GREY_TEXT,
                              ),
                            ),
                            SizedBox(height: 4),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFF00C6FF),
                                  Color(0xFF0072FF),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Text(
                                '55,000 VND / Tháng',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = const LinearGradient(
                                      colors: [
                                        Color(0xFF00C6FF),
                                        Color(0xFF0072FF),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(
                                        const Rect.fromLTWH(0, 0, 200, 30)),
                                ),
                              ),
                            ),
                            Text(
                              'Khách hàng cá nhân',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.GREY_TEXT,
                              ),
                            ),
                            SizedBox(height: 12),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFF00C6FF),
                                  Color(0xFF0072FF),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Text(
                                '110,000 VND / Tháng',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = const LinearGradient(
                                      colors: [
                                        Color(0xFF00C6FF),
                                        Color(0xFF0072FF),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(
                                        const Rect.fromLTWH(0, 0, 200, 30)),
                                ),
                              ),
                            ),
                            Text(
                              'Khách hàng doanh nghiệp',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.GREY_TEXT,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const XImage(
                    imagePath: 'assets/images/ic-infinity.png',
                    width: 60,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF00C6FF),
                            Color(0xFF0072FF),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: Text(
                          'Giải pháp tối ưu cho doanh nghiệp của bạn',
                          style: TextStyle(
                            fontSize: 11,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [
                                  Color(0xFF00C6FF),
                                  Color(0xFF0072FF),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(
                                  const Rect.fromLTWH(0, 0, 200, 30)),
                          ),
                        ),
                      ),
                      const Text(
                        'Đăng ký để trải nghiệm các\ntính năng không giới hạn.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      XImage(
                        imagePath: 'assets/images/ic-noti-bdsd-black.png',
                        width: 30,
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          'Nhận thông báo biến động số dư',
                          style: TextStyle(fontSize: 11),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      XImage(
                        imagePath: 'assets/images/ic-earth-black.png',
                        width: 30,
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          'Chia sẻ BĐSD qua nền tảng mạng xã hội',
                          style: TextStyle(fontSize: 11),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      XImage(
                        imagePath: 'assets/images/ic-store-black.png',
                        width: 30,
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          'Quản lý doanh thu các cửa hàng',
                          style: TextStyle(fontSize: 11),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
          // Container(
          //   color: AppColor.RED_CALENDAR,
          //   width: double.infinity,
          //   child: ValueListenableBuilder<bool>(
          //       valueListenable: isClose,
          //       child: const Text(
          //         'Không hiển thị thông tin này ở lần sau',
          //         style: TextStyle(color: AppColor.BLACK, fontSize: 12),
          //       ),
          //       builder: (context, value, child) {
          //         return CheckboxListTile(
          //           side: const BorderSide(color: Colors.black),
          //           checkboxShape: const CircleBorder(),
          //           title: child,
          //           value: value,
          //           onChanged: (result) {
          //             isClose.value = result ?? false;
          //           },
          //           controlAffinity: ListTileControlAffinity.leading,
          //           activeColor: AppColor.BLUE_TEXT,
          //           checkColor: AppColor.WHITE,
          //           contentPadding: EdgeInsets.zero,
          //         );
          //       }),
          // ),
          Container(
            // height: 50,
            // width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ValueListenableBuilder<bool>(
              valueListenable: isClose,
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      side: const BorderSide(color: Colors.black),
                      shape: const CircleBorder(),
                      value: value,
                      onChanged: (result) {
                        isClose.value = result ?? false;
                      },
                      activeColor: AppColor.BLUE_TEXT,
                      checkColor: AppColor.WHITE,
                    ),
                    const Text(
                      'Không hiển thị thông tin này ở lần sau',
                      style: TextStyle(
                        color: AppColor.BLACK,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // const SizedBox(height: 10),
          InkWell(
            onTap: () {
              if (isClose.value == true) {
                getIt.get<DashBoardBloc>().add(CloseMobileNotificationEvent());
                Navigator.of(context).pop();
                DialogWidget.instance.showModelBottomSheet(
                    borderRadius: BorderRadius.circular(16),
                    widget: PopupBankWidget());
                // Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop();
                DialogWidget.instance.showModelBottomSheet(
                    borderRadius: BorderRadius.circular(16),
                    widget: PopupBankWidget());
              }
              // Navigator.of(context).pop();
              // DialogWidget.instance.showModelBottomSheet(
              //     borderRadius: BorderRadius.circular(16),
              //     widget: PopupBankWidget());
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                        colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: Center(
                  child: Text(
                    'Đăng ký dịch vụ phần mềm VietQR ngay!',
                    style: TextStyle(fontSize: 13, color: AppColor.WHITE),
                  ),
                ),
              ),
            ),
          )

          // MButtonWidget(
          //   height: 50,
          //   width: double.infinity,
          //   isEnable: true,
          //   margin: const EdgeInsets.symmetric(horizontal: 80),
          //   title: 'Đóng',
          //   onTap: () {
          //     if (isClose.value == true) {
          //       getIt.get<DashBoardBloc>().add(CloseMobileNotificationEvent());
          //     } else {
          //       Navigator.of(context).pop();
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
