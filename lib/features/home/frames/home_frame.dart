import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/web_widgets/header_mweb_widget.dart';
import 'package:vierqr/commons/widgets/web_widgets/header_web_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/services/providers/home_tab_provider.dart';

class HomeFrame extends StatelessWidget {
  final double width;
  final double height;
  final Widget widget1;
  final Widget widget2;
  final Widget widget3;
  final Widget mobileWidget;

  const HomeFrame({
    super.key,
    required this.width,
    required this.height,
    required this.widget1,
    required this.widget2,
    required this.widget3,
    required this.mobileWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: (PlatformUtils.instance.resizeWhen(width, 800))
            ? const DecorationImage(
                image: AssetImage('assets/images/bg-qr.png'), fit: BoxFit.cover)
            : null,
      ),
      child: Consumer<HomeTabProvider>(
        builder: (context, provider, child) {
          return (PlatformUtils.instance.isWeb())
              ? (PlatformUtils.instance.resizeWhen(width, 800))
                  ? Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear,
                          width: provider.isExpanded ? 200 : 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                          ),
                          child: Column(
                            children: [
                              //logo
                              const Padding(padding: EdgeInsets.only(top: 15)),
                              Image.asset(
                                (provider.isExpanded)
                                    ? 'assets/images/ic-viet-qr.png'
                                    : 'assets/images/ic-viet-qr-small-trans.png',
                                width: (provider.isExpanded) ? 100 : 30,
                              ),
                              //widget 1
                              Expanded(child: widget1),
                              //button expanded
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    provider
                                        .updateExpanded(!provider.isExpanded);
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    margin: const EdgeInsets.only(
                                        right: 10, bottom: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(
                                      (provider.isExpanded)
                                          ? Icons.navigate_before_rounded
                                          : Icons.navigate_next_rounded,
                                      color: DefaultTheme.GREY_TEXT,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              HeaderWebWidget(
                                width: width,
                                height: height,
                              ),
                              const Padding(padding: EdgeInsets.only(top: 20)),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10)),
                                    Expanded(
                                      child: BoxLayout(
                                        width: width,
                                        height: height,
                                        borderRadius: 5,
                                        padding: const EdgeInsets.all(10),
                                        child: widget2,
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(right: 10)),
                                    BoxLayout(
                                      width: 400,
                                      height: height,
                                      borderRadius: 5,
                                      padding: const EdgeInsets.all(10),
                                      child: widget3,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(right: 10)),
                                  ],
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20)),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: width,
                      height: height,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HeaderMWebWidget(
                            width: width,
                            height: height,
                            isSubHeader: false,
                          ),
                          DividerWidget(width: width),
                          BoxLayout(
                            width: width,
                            borderRadius: 0,
                            padding: const EdgeInsets.only(bottom: 5),
                            child: SizedBox(
                              width: width,
                              height: 50,
                              child: Center(
                                child: widget1,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                const Padding(
                                    padding: EdgeInsets.only(top: 20)),
                                BoxLayout(
                                  width: width,
                                  borderRadius: 5,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      SizedBox(
                                        width: width,
                                        child: SizedBox(
                                          width: width,
                                          height: 600,
                                          child: widget3,
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      SizedBox(
                                        width: width,
                                        height: 500,
                                        child: widget2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
              : mobileWidget;
        },
      ),
    );
  }
}
