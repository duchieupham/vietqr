import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';

import '../../../commons/constants/configurations/app_images.dart';
import '../../../commons/constants/configurations/theme.dart';

class ActiveSuccessScreen extends StatefulWidget {
  final int? type;
  const ActiveSuccessScreen({super.key, required this.type});

  @override
  State<ActiveSuccessScreen> createState() => _ActiveSuccessScreenState();
}

class _ActiveSuccessScreenState extends State<ActiveSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottom(),
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            leadingWidth: 100,
            // leading: InkWell(
            //   onTap: () {
            //     Navigator.of(context).pop();
            //   },
            //   child: Container(
            //     padding: const EdgeInsets.only(left: 8),
            //     child: Row(
            //       children: [
            //         Icon(
            //           Icons.keyboard_arrow_left,
            //           color: Colors.black,
            //           size: 25,
            //         ),
            //         const SizedBox(width: 2),
            //         Text(
            //           "Trở về",
            //           style: TextStyle(color: Colors.black, fontSize: 14),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
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
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Container(
                padding: const EdgeInsets.only(top: 60),
                // padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Image.asset(
                      widget.type == 0
                          ? AppImages.icSuccessInBlue
                          : AppImages.icPendingTrans,
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.type == 0
                          ? "Kích hoạt dịch vụ \nphần mềm VietQR thành công!"
                          : 'Mã VietQR  hết hạn thanh toán',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    widget.type == 1
                        ? Text(
                            'Hoá đơn thanh toán dịch vụ nhận biến động số dư hết hạn. Vui lòng chọn lại gói dịch vụ và tiến hành thanh toán.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget _bottom() {
    return Container(
      height: 150,
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
      child: Column(
        children: [
          widget.type == 1
              ? InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashBoardScreen(),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        // color: AppColor.BLUE_TEXT,
                        border: Border.all(color: AppColor.BLUE_TEXT, width: 1),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        "Về trang chủ",
                        style:
                            TextStyle(fontSize: 13, color: AppColor.BLUE_TEXT),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          widget.type == 1 ? SizedBox(height: 10) : const SizedBox.shrink(),
          InkWell(
            onTap: () {
              widget.type == 1
                  ? Navigator.of(context).pop()
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashBoardScreen(),
                      ));
              ;
            },
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColor.BLUE_TEXT,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  widget.type == 0 ? "Hoàn thành" : 'Chọn lại gói dịch vụ',
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
