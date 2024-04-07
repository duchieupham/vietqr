import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';

import '../../../commons/constants/configurations/app_images.dart';
import '../../../commons/constants/configurations/theme.dart';

class ActiveSuccessScreen extends StatefulWidget {
  const ActiveSuccessScreen({super.key});

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
        slivers: [
          SliverAppBar(
            pinned: true,
            leadingWidth: 100,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                      size: 25,
                    ),
                    const SizedBox(width: 2),
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
                      AppImages.icSuccessInBlue,
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Kích hoạt dịch vụ \nhận BĐSD thành công!",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )
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
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
      child: InkWell(
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
              color: AppColor.BLUE_TEXT,
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Text(
              "Hoàn thành",
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
