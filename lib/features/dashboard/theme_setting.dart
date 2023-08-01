import 'package:flutter/cupertino.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/checkbox_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
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
      appBar: const MAppBar(title: 'Cài đặt giao diện'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: AppColor.cardDecoration(context,
                color: AppColor.gray.withOpacity(0.1)),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _assetList.length,
              itemBuilder: (context, index) {
                return Consumer<ThemeProvider>(
                    builder: (context, provider, child) {
                  return InkWell(
                    onTap: () async {
                      // await _themeProvider.updateThemeByIndex(index);
                      // _themeUIController.animateToPage(
                      //     _themeProvider.getThemeIndex(),
                      //     duration: const Duration(milliseconds: 200),
                      //     curve: Curves.easeInToLinear);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: index == provider.getThemeIndex()
                          ? const BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)))
                          : null,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(getTitleTheme(index)),
                          const Spacer(),
                          //check box
                          CheckBoxWidget(
                            check: (provider.getThemeIndex() == index),
                            size: 25,
                            color: !(provider.getThemeIndex() == index)
                                ? AppColor.gray.withOpacity(0.5)
                                : null,
                            function: () {},
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: AppColor.gray.withOpacity(0.6),
                  height: 0.5,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
                'Hệ thống sớm mang lại phần tuỳ chỉnh giao diện để người dùng cá nhân hoá giáo diện của mình.'),
          )
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
