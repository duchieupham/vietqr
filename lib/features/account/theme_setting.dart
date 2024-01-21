import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/account/blocs/account_bloc.dart';
import 'package:vierqr/features/account/events/account_event.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_provider.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/widget/custom_switch_view.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/theme_dto_local.dart';

class ThemeSettingView extends StatefulWidget {
  ThemeSettingView({super.key});

  static String routeName = '/theme_setting';

  //asset UI list
  static final List<String> _assetList = [
    'assets/images/ic-light-theme.png',
    'assets/images/ic-dark-theme.png',
    'assets/images/ic-system-theme.png',
  ];

  @override
  State<ThemeSettingView> createState() => _ThemeSettingViewState();
}

class _ThemeSettingViewState extends State<ThemeSettingView> {
  final StreamController<List<File>> _imageListStreamController =
      StreamController<List<File>>();

  Future<void> _loadImage(List<ThemeDTO> listDto) async {
    if (_imageListStreamController.hasListener) {
      _imageListStreamController.close();
    }
    List<File> listFile = [];
    listDto.forEach((element) async {
      File file = await element.getImageFile();
      listFile.add(file);
    });

    _imageListStreamController.add(listFile);
  }

  @override
  void initState() {
    super.initState();
    List<ThemeDTO> listDto =
        Provider.of<DashBoardProvider>(context, listen: false).themes;
    _loadImage(listDto);
  }

  @override
  void dispose() {
    if (_imageListStreamController.hasListener) {
      _imageListStreamController.close();
    }
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
              Text(
                'Hiển thị',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildContainer(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Giữ màn hình sáng khi hiện QR',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text(
                              'Hệ thống giữ thiết bị của bạn luôn sáng ở những màn hình có thông tin mã QR.',
                              style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Bật',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Consumer<DashBoardProvider>(
                          builder: (context, provider, _) {
                            return CustomSwitch(
                              value: provider.settingDTO.keepScreenOn,
                              onChanged: (value) {
                                context
                                    .read<DashBoardBloc>()
                                    .add(UpdateKeepBrightEvent(value));
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            ...[
              Text(
                'Chủ đề',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildContainer(
                child: Consumer<DashBoardProvider>(
                    builder: (context, provider, _) {
                  return StreamBuilder(
                    stream: _imageListStreamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<File> imageList = snapshot.data as List<File>;
                        return Column(
                          children: List.generate(imageList.length, (index) {
                            ThemeDTO e = provider.themes[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: imageList[index].path.isNotEmpty
                                        ? Image.file(
                                            imageList[index],
                                            width: 90,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: e.imgUrl,
                                            width: 90,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(e.name),
                                  const Spacer(),
                                  Radio(
                                    value: provider.themeDTO.type,
                                    activeColor: AppColor.BLUE_TEXT,
                                    groupValue: e.type,
                                    onChanged: (value) {
                                      if (provider.settingDTO.themeType == 0)
                                        return;
                                      ThemeDTOLocal dto = ThemeDTOLocal(
                                        id: e.id,
                                        type: e.type,
                                        imgUrl: e.imgUrl,
                                        name: e.name,
                                        file: e.file,
                                      );

                                      provider.updateThemeDTO(dto);
                                      context
                                          .read<DashBoardBloc>()
                                          .add(UpdateThemeEvent(e.type));
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return const SizedBox(
                          height: 50,
                          width: 90,
                        );
                      }
                    },
                  );
                }),
              ),
            ],
          ],
        ),
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

  Widget _buildContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.WHITE,
      ),
      child: child,
    );
  }
}
