import 'package:flutter/material.dart';

class SubHeader extends StatelessWidget {
  final String title;
  VoidCallback? function;

  SubHeader({Key? key, required this.title, this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      height: 80,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: (function == null)
                ? () {
                    Navigator.of(context).pop();
                  }
                : function,
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
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop('isBackHome');
            },
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
    );
  }
}
