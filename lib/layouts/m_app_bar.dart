import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/theme/bloc/theme_bloc.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class MAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final List<Widget>? actions;
  final bool isLeading;
  final VoidCallback? onPressed;
  final VoidCallback? callBackHome;
  final bool showBG;
  final bool centerTitle;

  const MAppBar({
    super.key,
    required this.title,
    this.actions,
    this.isLeading = true,
    this.onPressed,
    this.callBackHome,
    this.showBG = true,
    this.centerTitle = true,
  }) : preferredSize = const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      bloc: getIt.get<ThemeBloc>(),
      buildWhen: (previous, current) =>
          current is UpdateSetting || current is UpdateBannerSuccess,
      builder: (context, state) {
        String url = state.settingDTO.themeImgUrl;
        File bannerApp = state.bannerApp;
        return Container(
          decoration: showBG
              ? BoxDecoration(
                  image: bannerApp.path.isEmpty
                      ? DecorationImage(
                          image: NetworkImage(url), fit: BoxFit.cover)
                      : DecorationImage(
                          image: FileImage(bannerApp), fit: BoxFit.cover))
              : null,
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
            centerTitle: centerTitle,
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
                    child: XImage(
                      imagePath: state.settingDTO.logoUrl,
                      height: 56,
                      width: 96,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
            backgroundColor: Colors.transparent,
          ),
        );
      },
    );
  }

  _handleBack(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }
}
