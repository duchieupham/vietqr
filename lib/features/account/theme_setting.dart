import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/widget/custom_switch_view.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            ...[
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
                    Consumer<AuthProvider>(builder: (context, provider, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            provider.settingDTO.keepScreenOn ? 'Bật' : 'Tắt',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 8),
                          CustomSwitch(
                            value: provider.settingDTO.keepScreenOn,
                            onChanged: (value) {
                              _bloc.add(UpdateKeepBrightEvent(value));
                            },
                          )
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            ...[
              const Text(
                'Chủ đề',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Consumer<AuthProvider>(builder: (context, provider, _) {
                provider.loadThemes();
                return _buildContainer(
                  color: provider.settingDTO.isEvent
                      ? AppColor.GREY_BG
                      : AppColor.WHITE,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      StreamBuilder<List<File>>(
                        stream: provider.themesStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<File> imageList = snapshot.data as List<File>;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children:
                                    List.generate(imageList.length, (index) {
                                  ThemeDTO e = provider.themes[index];
                                  File xFile = imageList[index];
                                  return GestureDetector(
                                    onTap: () => onSelect(provider, e),
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.only(
                                          bottom: 16, top: 16),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                            value: provider.themeNotEvent.type,
                                            groupValue: e.type,
                                            isDisable:
                                                provider.settingDTO.isEvent,
                                            onChanged: (value) {
                                              if (e.xFile != null &&
                                                  e.xFile!.path.isNotEmpty) {
                                                onSelect(provider, e);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          } else {
                            return const SizedBox(
                              height: 50,
                              width: 90,
                            );
                          }
                        },
                      ),
                      if (provider.settingDTO.isEvent)
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(8))),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: provider.bannerApp.path.isNotEmpty
                                      ? Image.file(
                                          provider.bannerApp,
                                          width: 90,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl:
                                              provider.settingDTO.themeImgUrl,
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
                                    const SizedBox(height: 4),
                                    Text(
                                      'Chủ đề sự kiện đang được diễn ra.',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColor.grey979797),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                CustomRadio(
                                  value: provider.themeNotEvent.type,
                                  groupValue: provider.settingDTO.themeType,
                                  onChanged: (value) {},
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
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

  onSelect(AuthProvider provider, ThemeDTO e) {
    if (provider.settingDTO.themeType == 0) return;
    provider.updateThemeDTO(e);
    _bloc.add(UpdateThemeEvent(e.type, provider.themes));
  }
}
