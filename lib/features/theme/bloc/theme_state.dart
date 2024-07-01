part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  final ThemeDTO themeNotEvent;
  final List<ThemeDTO> themes;
  final List<File> files;
  final File bannerApp;
  final File logoApp;
  final bool isEventTheme;
  final SettingAccountDTO settingDTO;

  const ThemeState({
    required this.themeNotEvent,
    required this.themes,
    required this.files,
    required this.bannerApp,
    required this.logoApp,
    required this.isEventTheme,
    required this.settingDTO,
  });

  @override
  List<Object?> get props => [
        themeNotEvent,
        themes,
        files,
        bannerApp,
        settingDTO,
        logoApp,
        isEventTheme
      ];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial({
    required super.themeNotEvent,
    required super.themes,
    required super.files,
    required super.bannerApp,
    required super.logoApp,
    required super.isEventTheme,
    required super.settingDTO,
  });
}

class UpdateBannerSuccess extends ThemeState {
  UpdateBannerSuccess({
    required ThemeState state,
    required super.bannerApp,
  }) : super(
          themes: state.themes,
          themeNotEvent: state.themeNotEvent,
          files: state.files,
          logoApp: state.logoApp,
          isEventTheme: state.isEventTheme,
          settingDTO: state.settingDTO,
        );
}

class UpdateThemeSuccess extends ThemeState {
  final ThemeDTO? themeDTO;
  final List<ThemeDTO>? themesData;
  final List<File>? filesData;
  final File? logoAppData;

  UpdateThemeSuccess({
    required ThemeState state,
    this.themeDTO,
    this.themesData,
    this.filesData,
    this.logoAppData,
  }) : super(
          themes: themesData ?? state.themes,
          themeNotEvent: themeDTO ?? state.themeNotEvent,
          bannerApp: state.bannerApp,
          files: filesData ?? state.files,
          logoApp: logoAppData ?? state.logoApp,
          isEventTheme: state.isEventTheme,
          settingDTO: state.settingDTO,
        );
}

class GetThemesSuccess extends ThemeState {
  GetThemesSuccess({
    required ThemeState state,
    required super.themes,
  }) : super(
          themeNotEvent: state.themeNotEvent,
          files: state.files,
          logoApp: state.logoApp,
          isEventTheme: state.isEventTheme,
          settingDTO: state.settingDTO,
          bannerApp: state.bannerApp,
        );
}

class UpdateValueIsEventTheme extends ThemeState {
  UpdateValueIsEventTheme({
    required ThemeState state,
    required super.isEventTheme,
  }) : super(
          themes: state.themes,
          themeNotEvent: state.themeNotEvent,
          bannerApp: state.bannerApp,
          files: state.files,
          logoApp: state.logoApp,
          settingDTO: state.settingDTO,
        );
}

class UpdateLogoApp extends ThemeState {
  UpdateLogoApp({
    required ThemeState state,
    required super.logoApp,
  }) : super(
          themes: state.themes,
          themeNotEvent: state.themeNotEvent,
          bannerApp: state.bannerApp,
          files: state.files,
          isEventTheme: state.isEventTheme,
          settingDTO: state.settingDTO,
        );
}

class UpdateSetting extends ThemeState {
  UpdateSetting({
    required ThemeState state,
    required super.settingDTO,
  }) : super(
          themes: state.themes,
          themeNotEvent: state.themeNotEvent,
          bannerApp: state.bannerApp,
          files: state.files,
          logoApp: state.logoApp,
          isEventTheme: state.isEventTheme,
        );
}

class UpdateFilesSuccess extends ThemeState {
  UpdateFilesSuccess({
    required ThemeState state,
  }) : super(
          themes: state.themes,
          themeNotEvent: state.themeNotEvent,
          bannerApp: state.bannerApp,
          files: state.files,
          logoApp: state.logoApp,
          isEventTheme: state.isEventTheme,
          settingDTO: state.settingDTO,
        );
}
