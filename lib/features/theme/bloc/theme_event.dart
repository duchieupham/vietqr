part of 'theme_bloc.dart';

abstract class ThemeEvent {}

class InitThemeEvent extends ThemeEvent {}

class GetListThemeEvent extends ThemeEvent {}

class LoadThemeFromSystemEvent extends ThemeEvent {}

class UpdateLogoAppEvent extends ThemeEvent {
  final String localPath;

  UpdateLogoAppEvent(this.localPath);
}

class UpdateBannerAppEvent extends ThemeEvent {
  final String path;

  UpdateBannerAppEvent(this.path);
}

class UpdateEventThemeEvent extends ThemeEvent {
  final bool isEventTheme;

  UpdateEventThemeEvent(this.isEventTheme);
}

class UpdateSettingAppEvent extends ThemeEvent {
  final SettingAccountDTO settingData;

  UpdateSettingAppEvent(this.settingData);
}

class UpdateAppThemeEvent extends ThemeEvent {
  final List<ThemeDTO> themesData;

  UpdateAppThemeEvent(this.themesData);
}

class UpdateAppBrightEvent extends ThemeEvent {
  final bool isKeepBright;

  UpdateAppBrightEvent(this.isKeepBright);
}

class LoadThemesEvent extends ThemeEvent {}

class UpdateThemeAppEvent extends ThemeEvent {
  final ThemeDTO? data;

  UpdateThemeAppEvent(this.data);
}
