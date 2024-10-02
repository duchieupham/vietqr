import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';

class AppBarAddBank extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final List<Widget>? actions;
  final bool isLeading;
  final VoidCallback? onPressed;
  final VoidCallback? callBackHome;

  const AppBarAddBank({
    super.key,
    this.actions,
    this.isLeading = true,
    this.onPressed,
    this.callBackHome,
  }) : preferredSize = const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenProvider>(builder: (context, page, child) {
      String url = page.settingDTO.themeImgUrl;
      return Container(
        decoration: const BoxDecoration(color: AppColor.WHITE),
        child: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          leading: isLeading
              ? InkWell(
                  onTap: (onPressed == null)
                      ? () => _handleBack(context)
                      : () {
                          onPressed!();
                        },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 20,
                        ),
                        Text(
                          'Trở về',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : null,
          leadingWidth: 100,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: actions ??
              [
                GestureDetector(
                  onTap: (callBackHome == null)
                      ? () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }
                      : callBackHome,
                  child: SizedBox(
                    width: 96,
                    height: 56,
                    // margin: const EdgeInsets.only(right: 20),
                    child: CachedNetworkImage(
                      imageUrl: page.settingDTO.logoUrl,
                      height: 56,
                      width: 96,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
          backgroundColor: Colors.transparent,
        ),
      );
    });
  }

  _handleBack(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }
}
