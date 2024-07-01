import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/extensions/string_extension.dart';
import 'package:vierqr/features/account/blocs/account_bloc.dart';

import '../../../commons/utils/error_utils.dart';
import '../../../commons/utils/log.dart';
import '../../../main.dart';
import '../../../models/response_message_dto.dart';
import '../../../models/setting_account_sto.dart';
import '../../../models/theme_dto.dart';
import '../../../models/user_repository.dart';
import '../../../services/local_storage/shared_preference/shared_pref_utils.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeInitial(
          themeNotEvent: ThemeDTO(),
          themes: const [],
          files: const [],
          bannerApp: File(''),
          logoApp: File(''),
          isEventTheme: false,
          settingDTO: SettingAccountDTO(),
        )) {
    on<InitThemeEvent>((event, emit) async {
      await _initThemeDTO(emit);
    });
    on<LoadThemesEvent>((event, emit) async {
      List<File> files = await _loadThemes();
      emit(UpdateThemeSuccess(
        state: state,
        filesData: files,
      ));
    });
    on<UpdateSettingAppEvent>(_updateSettingDTO);
    on<GetListThemeEvent>(_getListTheme);
    on<UpdateThemeAppEvent>(_updateThemeDTO);
    on<LoadThemeFromSystemEvent>(_loadThemeFromSystem);
    on<UpdateAppThemeEvent>(_updateThemes);
    on<UpdateAppBrightEvent>(_updateKeepBright);
    on<UpdateEventThemeEvent>((event, emit) {
      bool isEventTheme = _updateEventTheme(event.isEventTheme);
      emit(UpdateValueIsEventTheme(
        state: state,
        isEventTheme: isEventTheme,
      ));
    });
    on<UpdateBannerAppEvent>(_updateBannerApp);
    on<UpdateLogoAppEvent>((event, emit) async {
      File logoApp = await _updateLogoApp(event.localPath);
      emit(UpdateLogoApp(
        state: state,
        logoApp: logoApp,
      ));
    });
  }

  UserRepository get userRes => UserRepository.instance;

  void _loadThemeFromSystem(
      LoadThemeFromSystemEvent event, Emitter<ThemeState> emit) async {
    bool isEventTheme = _updateEventTheme(null);
    List<ThemeDTO> themes = userRes.themes;
    emit(UpdateValueIsEventTheme(
      state: state,
      isEventTheme: isEventTheme,
    ));
    emit(UpdateThemeSuccess(state: state, themesData: themes));

    File logoApp = await _updateLogoApp('');
    emit(UpdateLogoApp(
      state: state,
      logoApp: logoApp,
    ));

    _initThemeDTO(emit);
  }

  bool _updateEventTheme(value) {
    if (value == null) {
      return SharePrefUtils.getBannerEvent();
    }
    return value;
  }

  Future<File> _updateLogoApp(String file) async {
    if (file.isNotEmpty) {
      return await file.getImageFile;
    } else {
      String url = SharePrefUtils.getLogoApp();
      return await url.getImageFile;
    }
  }

  Future<void> _initThemeDTO(Emitter<ThemeState> emit) async {
    ThemeDTO? theme = await userRes.getSingleTheme();
    if (theme == null) return;
    ThemeDTO themeNotEvent = theme;
    emit(UpdateThemeSuccess(state: state, themeDTO: themeNotEvent));

    File bannerApp = await themeNotEvent.photoPath.getImageFile;
    emit(UpdateBannerSuccess(state: state, bannerApp: bannerApp));
  }

  Future<List<File>> _loadThemes({List<ThemeDTO>? themes}) async {
    List<File> listFile = [];

    for (var element in (themes ?? state.themes)) {
      File file = await element.photoPath.getImageFile;
      listFile.add(file);
    }

    return listFile;
  }

  Future<void> _updateBannerApp(
      UpdateBannerAppEvent event, Emitter<ThemeState> emit) async {
    File bannerApp = File('');
    if (event.path.isNotEmpty) {
      bannerApp = await event.path.getImageFile;
    } else {
      String url = SharePrefUtils.getBannerApp();
      bannerApp = await url.getImageFile;
    }

    emit(UpdateBannerSuccess(state: state, bannerApp: bannerApp));
  }

  void _updateThemeDTO(
      UpdateThemeAppEvent event, Emitter<ThemeState> emit) async {
    if (event.data == null) return;
    try {
      ThemeDTO themeData = event.data!;

      final result = await accRepository.updateTheme(
        SharePrefUtils.getProfile().userId,
        themeData.type,
      );

      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        File bannerApp = await themeData.photoPath.getImageFile;
        await userRes.saveSingleTheme(themeData);

        emit(UpdateBannerSuccess(state: state, bannerApp: bannerApp));
      } else {
        ErrorUtils.instance.getErrorMessage(result.message);
      }
    } catch (e) {
      const dto = ResponseMessageDTO(status: 'FAILED', message: 'E05');
      ErrorUtils.instance.getErrorMessage(dto.message);
    }
  }

  void _updateThemes(
      UpdateAppThemeEvent event, Emitter<ThemeState> emit) async {
    List<ThemeDTO> themes = event.themesData;
    themes.sort((a, b) => a.type.compareTo(b.type));

    List<File> files = await _loadThemes(themes: themes);
    emit(UpdateThemeSuccess(
      state: state,
      themesData: themes,
      filesData: files,
    ));
  }

  void _updateSettingDTO(
      UpdateSettingAppEvent event, Emitter<ThemeState> emit) async {
    SettingAccountDTO settingDTO = event.settingData;
    ThemeDTO? local = await userRes.getSingleTheme();

    if (local == null || settingDTO.themeType != local.type) {
      await onSaveThemToLocal(settingDTO, emit);
    } else {
      File bannerApp = await state.themeNotEvent.photoPath.getImageFile;
      emit(UpdateBannerSuccess(state: state, bannerApp: bannerApp));
    }
  }

  Future onSaveThemToLocal(
      SettingAccountDTO settingDTO, Emitter<ThemeState> emit) async {
    String path = settingDTO.themeImgUrl.split('/').last;
    if (path.contains('.png')) {
      path.replaceAll('.png', '');
    }

    String localPath = await downloadAndSaveImage(settingDTO.themeImgUrl, path);
    emit(UpdateSetting(state: state, settingDTO: settingDTO));

    if (localPath.isNotEmpty) {
      ThemeDTO themeNotEvent = state.themeNotEvent;

      themeNotEvent.setFile(localPath);
      themeNotEvent.setType(settingDTO.themeType);

      await userRes.saveSingleTheme(themeNotEvent);
      File bannerApp = await themeNotEvent.photoPath.getImageFile;
      emit(UpdateBannerSuccess(state: state, bannerApp: bannerApp));
    }
  }

  Future<void> _updateKeepBright(
      UpdateAppBrightEvent event, Emitter<ThemeState> emit) async {
    try {
      SettingAccountDTO settingDTO = state.settingDTO;
      settingDTO.keepScreenOn = event.isKeepBright;

      final result = await accRepository.updateKeepBright(
        SharePrefUtils.getProfile().userId,
        event.isKeepBright,
      );

      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(UpdateSetting(state: state, settingDTO: settingDTO));
      } else {
        ErrorUtils.instance.getErrorMessage(result.message);
      }
    } catch (e) {
      final res = ResponseMessageDTO(status: 'FAILED', message: 'E05');
      ErrorUtils.instance.getErrorMessage(res.message);
    }
  }

  Future<void> _getListTheme(
      GetListThemeEvent event, Emitter<ThemeState> emit) async {
    try {
      List<ThemeDTO> result = await accRepository.getListTheme();

      result.sort((a, b) => a.type.compareTo(b.type));
      emit(GetThemesSuccess(state: state, themes: result));
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
