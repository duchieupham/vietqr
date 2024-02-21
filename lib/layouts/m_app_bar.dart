import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';

class MAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final List<Widget>? actions;
  final bool isLeading;
  final VoidCallback? onPressed;
  final VoidCallback? callBackHome;
  final bool showBG;

  const MAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.isLeading = true,
    this.onPressed,
    this.callBackHome,
    this.showBG = true,
  })  : preferredSize = const Size.fromHeight(60),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, page, child) {
      String url = page.settingDTO.themeImgUrl;
      return Container(
        decoration: showBG
            ? BoxDecoration(
                image: page.fileTheme.path.isEmpty
                    ? DecorationImage(
                        image: NetworkImage(url), fit: BoxFit.cover)
                    : DecorationImage(
                        image: FileImage(page.fileTheme), fit: BoxFit.cover))
            : BoxDecoration(),
        child: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.4,
            ),
          ),
          leading: isLeading
              ? IconButton(
                  onPressed: (onPressed == null)
                      ? () => _handleBack(context)
                      : () {
                          onPressed!();
                        },
                  padding: const EdgeInsets.only(left: 20),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 18,
                  ),
                )
              : null,
          centerTitle: true,
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
                  child: Container(
                    width: 50,
                    height: 40,
                    margin: const EdgeInsets.only(right: 20),
                    child: CachedNetworkImage(
                      imageUrl: page.settingDTO.logoUrl,
                      height: 40,
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
