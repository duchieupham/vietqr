import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/theme/bloc/theme_bloc.dart';
import 'package:vierqr/layouts/image/x_image.dart';

import '../commons/constants/configurations/theme.dart';

class RegisterAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final List<Widget>? actions;
  final bool isLeading;
  final VoidCallback? onPressed;
  final VoidCallback? callBackHome;
  final bool showBG;
  final bool centerTitle;

  const RegisterAppBar({
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
    return Container(
      decoration: const BoxDecoration(color: AppColor.WHITE),
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
        leading: isLeading ? _buildBackButton(context) : null,
        leadingWidth: 100,
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
                child: Container(
                  width: 96,
                  height: 56,
                  margin: const EdgeInsets.only(right: 20),
                  child: BlocBuilder<ThemeBloc, ThemeState>(
                    bloc: getIt.get<ThemeBloc>(),
                    buildWhen: (previous, current) => current is UpdateSetting,
                    builder: (context, state) {
                      return XImage(
                        imagePath: state.settingDTO.logoUrl,
                        height: 56,
                        width: 96,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),
            ],
        backgroundColor: Colors.transparent,
      ),
    );
  }

  _handleBack(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: (onPressed == null) ? () => _handleBack(context) : onPressed,
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        width: 100, // Increase width as needed to avoid overflow
        alignment: Alignment.centerLeft,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 18,
            ),
            Text(
              'Trở về',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
