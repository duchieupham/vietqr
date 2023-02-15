import 'package:flutter/cupertino.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/checkbox_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/services/providers/shortcut_provider.dart';
import 'package:vierqr/services/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSettingView extends StatelessWidget {
  const ThemeSettingView({super.key});

  //theme UI controller
  static late PageController _themeUIController;
  static late ThemeProvider _themeProvider;
  //asset UI list
  static final List<String> _assetList = [
    'assets/images/ic-light-theme.png',
    'assets/images/ic-dark-theme.png',
    'assets/images/ic-system-theme.png',
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _themeUIController = PageController(
      initialPage: _themeProvider.getThemeIndex(),
      viewportFraction: 0.65,
    );
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SubHeader(title: 'Giao diện'),
          Expanded(
            child: ListView(
              children: [
                //UI view
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 60),
                  width: width,
                  height: 200,
                  child: PageView.builder(
                    controller: _themeUIController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _assetList.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        _assetList[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
                //
                Container(
                  width: width,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: DefaultTheme.cardDecoration(context),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _assetList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          await _themeProvider.updateThemeByIndex(index);
                          _themeUIController.animateToPage(
                              _themeProvider.getThemeIndex(),
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInToLinear);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(getTitleTheme(index)),
                              const Spacer(),
                              //check box
                              Consumer<ThemeProvider>(
                                builder: (context, provider, child) {
                                  return CheckBoxWidget(
                                    check: (provider.getThemeIndex() == index),
                                    size: 25,
                                    function: () {},
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: DefaultTheme.GREY_TEXT,
                        height: 0.5,
                      );
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                BoxLayout(
                    width: width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 5, bottom: 5),
                    child: Row(
                      children: [
                        const Text('Phím tắt:'),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Consumer<ShortcutProvider>(
                            builder: (context, provider, child) {
                          return Text(
                            (provider.enableShortcut) ? 'Hiện' : 'Ẩn',
                            style:
                                const TextStyle(color: DefaultTheme.GREY_TEXT),
                          );
                        }),
                        const Spacer(),
                        Consumer<ShortcutProvider>(
                          builder: (context, provider, child) {
                            return Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: provider.enableShortcut,
                                activeColor: DefaultTheme.GREEN,
                                onChanged: ((_) {
                                  provider.updateEnableShortcut(
                                      !provider.enableShortcut);
                                }),
                              ),
                            );
                          },
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getTitleTheme(int index) {
    String title = '';
    if (index == 0) {
      title = 'Sáng';
    } else if (index == 1) {
      title = 'Tối';
    } else {
      title = 'Hệ thống';
    }
    return title;
  }
}
