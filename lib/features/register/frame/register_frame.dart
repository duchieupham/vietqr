import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';

class RegisterFrame extends StatelessWidget {
  final Widget mobileChildren;
  final List<Widget> webChildren;

  const RegisterFrame({
    super.key,
    required this.mobileChildren,
    required this.webChildren,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return (PlatformUtils.instance.checkResize(width))
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width * 0.3,
                height: height * 0.8,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg-qr.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
              ),
              Container(
                width: width * 0.5,
                height: height * 0.8,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: SizedBox(
                    width: width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: webChildren,
                    ),
                  ),
                ),
              ),
            ],
          )
        : mobileChildren;
  }
}
