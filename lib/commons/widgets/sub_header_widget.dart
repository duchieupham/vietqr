import 'package:flutter/material.dart';

class SubHeader extends StatelessWidget {
  final String title;
  VoidCallback? function;

  SubHeader({Key? key, required this.title, this.function}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      height: 80,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            //  color: Colors.red,
            child: InkWell(
              onTap: (function == null)
                  ? () {
                      Navigator.of(context).pop();
                      ;
                    }
                  : function,
              child: Image.asset(
                'assets/images/ic-pop.png',
                fit: BoxFit.contain,
                height: 30,
                width: 30,
              ),
            ),
          ),
          Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Container(
            width: 30,
            height: 30,
          ),
        ],
      ),
    );
  }
}
