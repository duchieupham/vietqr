import 'package:flutter/material.dart';

class MyFloatingButton extends StatefulWidget {
  const MyFloatingButton({super.key});

  @override
  _MyFloatingButtonState createState() => _MyFloatingButtonState();
}

class _MyFloatingButtonState extends State<MyFloatingButton> {
  bool _show = true;
  @override
  Widget build(BuildContext context) {
    return _show
        ? FloatingActionButton(
            onPressed: () {
              var sheetController = showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  context: context,
                  builder: (context) => const BottomSheetWidget());

              _showButton(false);

              // sheetController.closed.then((value) {
              //   _showButton(true);
              // });
            },
          )
        : Container();
  }

  void _showButton(bool value) {
    setState(() {
      _show = value;
    });
  }
}

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key});

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      // margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
      height: 160,
    );
  }
}
