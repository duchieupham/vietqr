import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PopupGuideWidget extends StatefulWidget {
  const PopupGuideWidget({super.key});

  @override
  State<PopupGuideWidget> createState() => _PopupGuideWidgetState();
}

class _PopupGuideWidgetState extends State<PopupGuideWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        height: MediaQuery.of(context).size.height * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(
                    'Hướng dẫn lấy thông tin \nWebhook trên Google Chat',
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
