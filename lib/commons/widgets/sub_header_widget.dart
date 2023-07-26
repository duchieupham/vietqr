import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class SubHeader extends StatelessWidget {
  final String title;
  final VoidCallback? function;
  final VoidCallback? callBackHome;

  const SubHeader(
      {Key? key, required this.title, this.function, this.callBackHome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bgr-sub-header.png'),
              fit: BoxFit.cover)),
      height: 100,
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: (function == null)
                ? () {
                    Navigator.of(context).pop();
                  }
                : function,
            child: Image.asset(
              'assets/images/ic-pop.png',
              fit: BoxFit.contain,
              color: AppColor.BLACK,
              height: 30,
              width: 30,
            ),
          ),
          const Padding(padding: EdgeInsets.only(right: 10)),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          GestureDetector(
            onTap: (callBackHome == null)
                ? () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                : callBackHome,
            child: Image.asset(
              'assets/images/ic-viet-qr.png',
              height: 20,
            ),
          ),
          const Padding(padding: EdgeInsets.only(right: 10)),
        ],
      ),
    );
  }
}
