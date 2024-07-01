import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/widget/custom_switch_view.dart';
import 'package:vierqr/features/theme/bloc/theme_bloc.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/models/theme_dto.dart';

import 'states/custom_radio.dart';

class ThemeSettingView extends StatefulWidget {
  ThemeSettingView({super.key});

  static String routeName = '/theme_setting';

  @override
  State<ThemeSettingView> createState() => _ThemeSettingViewState();
}

class _ThemeSettingViewState extends State<ThemeSettingView> {
  final DashBoardBloc _bloc = getIt.get<DashBoardBloc>();
  final ThemeBloc _themeBloc = getIt.get<ThemeBloc>();

  @override
  void initState() {
    super.initState();
    _themeBloc
      ..add(LoadThemesEvent())
      ..add(InitThemeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(title: 'Cài đặt giao diện'),
      backgroundColor: AppColor.GREY_BG,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            renderConfigBright(),
            const SizedBox(height: 24),
            renderThemeAppConfig(),
          ],
        ),
      ),
    );
  }

  Widget renderThemeAppConfig() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chủ đề',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        BlocBuilder<ThemeBloc, ThemeState>(
          bloc: _themeBloc,
          buildWhen: (previous, current) => current is UpdateSetting,
          builder: (context, state) {
            return _buildContainer(
              color:
                  state.settingDTO.isEvent ? AppColor.GREY_BG : AppColor.WHITE,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  renderThemes(state.settingDTO),
                  renderEventTheme(state.settingDTO),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget renderEventTheme(SettingAccountDTO settingDTO) {
    return BlocBuilder<ThemeBloc, ThemeState>(
        bloc: _themeBloc,
        builder: (context, state) {
          if (settingDTO.isEvent) {
            return InkWell(
              onTap: () {
                print('object');
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(8))),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: state.bannerApp.path.isNotEmpty
                          ? Image.file(
                              state.bannerApp,
                              width: 90,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: settingDTO.themeImgUrl,
                              width: 90,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sự kiện'),
                        SizedBox(height: 4),
                        Text(
                          'Chủ đề sự kiện đang được diễn ra.',
                          style: TextStyle(
                              fontSize: 12, color: AppColor.grey979797),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CustomRadio(
                      value: state.themeNotEvent.type,
                      groupValue: settingDTO.themeType,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }

  Widget renderThemes(SettingAccountDTO settingDTO) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      bloc: _themeBloc,
      builder: (context, state) {
        List<File> imageList = state.files;

        if (imageList.isEmpty) {
          return const SizedBox(
            height: 50,
            width: 90,
          );
        }

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            ThemeDTO e = state.themes[index];
            File xFile = imageList[index];
            return InkWell(
              onTap: () => onSelect(e),
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(bottom: 16, top: 16),
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: xFile.path.isNotEmpty
                            ? Image.file(
                                xFile,
                                width: 90,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                ImageConstant.bgrHeader,
                                width: 90,
                                height: 50,
                                fit: BoxFit.cover,
                              )),
                    const SizedBox(width: 12),
                    Text(e.name),
                    const Spacer(),
                    CustomRadio(
                      value: state.themeNotEvent.type,
                      groupValue: e.type,
                      isDisable: settingDTO.isEvent,
                      onChanged: (value) {
                        if (e.xFile != null && e.xFile!.path.isNotEmpty) {
                          onSelect(e);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget renderConfigBright() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hiển thị',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _buildContainer(
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Giữ màn hình sáng khi hiện QR',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(height: 4),
                    Text(
                        'Hệ thống giữ thiết bị của bạn luôn sáng ở những màn hình có thông tin mã QR.',
                        style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              BlocBuilder<ThemeBloc, ThemeState>(
                bloc: _themeBloc,
                buildWhen: (previous, current) => current is UpdateSetting,
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        state.settingDTO.keepScreenOn ? 'Bật' : 'Tắt',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      CustomSwitch(
                        value: state.settingDTO.keepScreenOn,
                        onChanged: (value) {
                          _themeBloc.add(UpdateAppBrightEvent(value));
                        },
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContainer({
    required Widget child,
    Color? color,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color ?? AppColor.WHITE,
      ),
      child: child,
    );
  }

  onSelect(ThemeDTO e) {
    if (_themeBloc.state.settingDTO.themeType == 0) return;
    _themeBloc.add(UpdateThemeAppEvent(e));
    // _bloc.add(UpdateThemeEvent(e.type, _themeBloc.state.themes));
  }
}
