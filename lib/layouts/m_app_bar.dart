import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final List<Widget>? actions;
  final bool isLeading;

  const MAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.isLeading = true,
  })  : preferredSize = const Size.fromHeight(56),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bgr-header.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            height: 1.4,
          ),
        ),
        leading: isLeading
            ? IconButton(
                onPressed: () => _handleBack(context),
                padding: const EdgeInsets.only(left: 20),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              )
            : null,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: actions ??
            [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Container(
                  width: 60,
                  height: 40,
                  margin: const EdgeInsets.only(right: 20),
                  child: Image.asset(
                    'assets/images/ic-viet-qr.png',
                    height: 40,
                  ),
                ),
              ),
            ],
        backgroundColor: Colors.transparent,
      ),
    );
  }

  _handleBack(BuildContext context) => Navigator.of(context).pop();
}
