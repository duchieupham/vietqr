import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/features/dashboard/widget/maintain_widget.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/shared_references/theme_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart' as rive;

class SplashScreen extends StatefulWidget {
  final bool isFromLogin;
  final bool isLogoutEnterHome;

  static String routeName = '/splash_screen';

  const SplashScreen({
    Key? key,
    this.isLogoutEnterHome = false,
    this.isFromLogin = false,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLogo = false;

  String get userId => UserHelper.instance.getUserId().trim();
  late DashBoardBloc _bloc;

  //animation
  late final rive.StateMachineController _riveController;
  late rive.SMITrigger _action;
  bool _isRiveInit = false;

  late AuthProvider _provider;

  bool isBanks = false;
  bool isThemes = false;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _provider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
      if (!widget.isFromLogin) _showLogo = true;
      updateState();
    });
  }

  _init() {
    _bloc.add(GetBanksEvent());
    _bloc.add(GetVersionAppEvent());
    _bloc.add(GetUserInformation());
  }

  //initial of animation
  _onRiveInit(rive.Artboard artboard) {
    _riveController = rive.StateMachineController.fromArtboard(
        artboard, Stringify.SUCCESS_ANI_STATE_MACHINE)!;
    artboard.addController(_riveController);
    _isRiveInit = true;
    _doInitAnimation();
  }

  void _doInitAnimation() {
    _action =
        _riveController.findInput<bool>(Stringify.SUCCESS_ANI_ACTION_DO_INIT)
            as rive.SMITrigger;
    _action.fire();
  }

  _openStartScreen() async {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => DashBoardScreen(
              isLogoutEnterHome: widget.isLogoutEnterHome,
              isFromLogin: widget.isFromLogin),
          settings: RouteSettings(name: DashBoardScreen.routeName),
        ),
        (route) => false);
  }

  static void saveImageTask(List<dynamic> args) async {
    SendPort sendPort = args[0];
    List<BankTypeDTO> list = args[1];

    for (var message in list) {
      String url = '${EnvConfig.getBaseUrl()}images/${message.imageId}';
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      sendPort
          .send(SaveImageData(progress: bytes, index: list.indexOf(message)));
    }
    sendPort.send(SaveImageData(progress: Uint8List(0), isDone: true));
  }

  void _saveImageTaskStreamReceiver(List<BankTypeDTO> list) async {
    final receivePort = ReceivePort();
    Isolate.spawn(saveImageTask, [receivePort.sendPort, list]);
    await for (var message in receivePort) {
      if (message is SaveImageData) {
        if (message.index != null) {
          BankTypeDTO dto = list[message.index!];

          String path = dto.imageId;
          if (!path.contains('.png')) {
            path = path + '.png';
          }

          String localPath = await saveImageToLocal(message.progress, path);
          dto.fileImage = localPath;
          await UserRepository.instance.updateBanks(dto);
        }

        if (message.isDone) {
          receivePort.close();
          if (!mounted) return;
          await UserRepository.instance.getBanks();
          isBanks = true;
          updateState();
          if (isBanks && isThemes) _openStartScreen();
          return;
        }
      }
    }
  }

  static void saveThemeTask(List<dynamic> args) async {
    SendPort sendPort = args[0];
    List<ThemeDTO> list = args[1];

    for (var message in list) {
      final response = await http.get(Uri.parse(message.imgUrl));
      final bytes = response.bodyBytes;
      sendPort
          .send(SaveImageData(progress: bytes, index: list.indexOf(message)));
    }
    sendPort.send(SaveImageData(progress: Uint8List(0), isDone: true));
  }

  Future<void> _saveThemeTaskStreamReceiver(List<ThemeDTO> list) async {
    List<ThemeDTO> listThemeLocal = [];
    final receivePort = ReceivePort();
    Isolate.spawn(saveThemeTask, [receivePort.sendPort, list]);
    await for (var message in receivePort) {
      if (message is SaveImageData) {
        if (message.index != null) {
          ThemeDTO dto = list[message.index!];

          String path = dto.imgUrl.split('/').last;
          if (path.contains('.png')) {
            path.replaceAll('.png', '');
          }

          String localPath = await saveImageToLocal(message.progress, path);
          dto.file = localPath;
          listThemeLocal.add(dto);
        }

        if (message.isDone) {
          receivePort.close();
          if (!mounted) return;
          _provider.updateListTheme(listThemeLocal, saveLocal: true);
          isThemes = true;
          updateState();
          if (isBanks && isThemes) _openStartScreen();
          return;
        }
      }
    }
  }

  @override
  void dispose() {
    if (_isRiveInit) {
      _riveController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints viewport) {
        return Scaffold(
          body: BlocListener<DashBoardBloc, DashBoardState>(
            listener: (context, state) async {
              if (state.status == BlocStatus.ERROR ||
                  state.request == DashBoardType.UPDATE_THEME_ERROR) {
                await DialogWidget.instance.showFullModalBottomContent(
                  isDissmiss: false,
                  widget: MaintainWidget(
                    onRetry: () {
                      _init();
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }

              if (state.request == DashBoardType.GET_USER_SETTING) {
                _provider
                    .updateSettingDTO(UserHelper.instance.getAccountSetting());
              }

              if (state.request == DashBoardType.GET_BANK) {
                _saveImageTaskStreamReceiver(state.listBanks);
              }

              if (isBanks && isThemes) {
                print('jehhehe');
                await Future.delayed(const Duration(milliseconds: 1000), () {
                  _openStartScreen();
                });
              }

              if (state.request == DashBoardType.GET_BANK_LOCAL) {
                isBanks = true;
                updateState();
              }

              if (state.request == DashBoardType.APP_VERSION) {
                if (state.appInfoDTO != null) {
                  _provider.updateThemeVer(state.appInfoDTO!.themeVer);
                  _provider.updateAppInfoDTO(state.appInfoDTO);
                }

                _bloc.add(GetListThemeEvent());
              }

              if (state.request == DashBoardType.THEMES) {
                List<ThemeDTO> list = [...state.themes];
                list.sort((a, b) => a.type.compareTo(b.type));

                _provider.updateListTheme(list);

                int themeVerLocal = ThemeHelper.instance.getThemeKey();
                int themeVerSetting = _provider.themeVer;
                List<ThemeDTO> listLocal =
                    await UserRepository.instance.getThemes();

                if (themeVerLocal != themeVerSetting || listLocal.isEmpty) {
                  _saveThemeTaskStreamReceiver(list);
                } else {
                  isThemes = true;
                  updateState();
                }
              }
            },
            child: Stack(
              children: [
                Positioned.fill(
                  bottom: 80,
                  child: Center(
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 2500),
                      opacity: widget.isFromLogin
                          ? 1.0
                          : _showLogo
                              ? 1.0
                              : 0.0,
                      child: Image.asset(
                        "assets/images/logo_vietgr_payment.png",
                        width: 160,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                if (widget.isFromLogin)
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 20,
                      width: 30,
                      child: rive.RiveAnimation.asset(
                        'assets/rives/loading_ani',
                        fit: BoxFit.contain,
                        antialiasing: false,
                        animations: [Stringify.SUCCESS_ANI_INITIAL_STATE],
                        onInit: _onRiveInit,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  updateState() {
    setState(() {});
  }
}

class JumpingDotsProgressIndicator extends StatefulWidget {
  final int numberOfDots;
  final double beginTweenValue = 0.0;
  final double endTweenValue = 8.0;

  JumpingDotsProgressIndicator({
    this.numberOfDots = 3,
  });

  _JumpingDotsProgressIndicatorState createState() =>
      _JumpingDotsProgressIndicatorState(
        numberOfDots: this.numberOfDots,
      );
}

class _JumpingDotsProgressIndicatorState
    extends State<JumpingDotsProgressIndicator> with TickerProviderStateMixin {
  int numberOfDots;
  List<AnimationController> controllers = <AnimationController>[];
  List<Animation<double>> animations = <Animation<double>>[];
  List<Widget> _widgets = <Widget>[];

  _JumpingDotsProgressIndicatorState({
    required this.numberOfDots,
  });

  initState() {
    super.initState();
    for (int i = 0; i < numberOfDots; i++) {
// adding controllers
      controllers.add(AnimationController(
          duration: Duration(milliseconds: 250), vsync: this));
// adding animation values
      animations.add(Tween(
              begin: widget.beginTweenValue, end: widget.endTweenValue)
          .animate(controllers[i])
        ..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) controllers[i].reverse();
          if (i == numberOfDots - 1 && status == AnimationStatus.dismissed) {
            controllers[0].forward();
          }
          if (animations[i].value > widget.endTweenValue / 2 &&
              i < numberOfDots - 1) {
            controllers[i + 1].forward();
          }
        }));
// adding list of widgets
      _widgets.add(Padding(
        padding: EdgeInsets.only(right: 1.0),
        child: JumpingDot(
          animation: animations[i],
        ),
      ));
    }
// animating first dot in the list
    controllers[0].forward();
  }

  dispose() {
    for (int i = 0; i < numberOfDots; i++) controllers[i].dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _widgets,
      ),
    );
  }
}

class JumpingDot extends AnimatedWidget {
  final Animation<double> animation;

  JumpingDot({Key? key, required this.animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    return Container(
      height: animation.value,
      child: Container(
        child: Icon(
          Icons.fiber_manual_record,
          size: 16,
          color: AppColor.BLUE_TEXT,
        ),
      ),
    );
  }
}
