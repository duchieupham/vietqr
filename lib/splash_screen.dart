import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:rive/rive.dart' as rive;

class SplashScreen extends StatefulWidget {
  final bool isFromLogin;

  static String routeName = '/splash_screen';

  const SplashScreen({
    super.key,
    this.isFromLogin = false,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLogo = false;

  //animation
  late final rive.StateMachineController _riveController;
  late rive.SMITrigger _action;
  bool _isRiveInit = false;

  bool isBanks = false;
  bool isThemes = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!widget.isFromLogin) _showLogo = true;
      updateState();
    });
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

  @override
  void dispose() {
    if (_isRiveInit) {
      print('rive');
      _riveController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints viewport) {
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                bottom: 80,
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 2500),
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
                      animations: const [Stringify.SUCCESS_ANI_INITIAL_STATE],
                      onInit: _onRiveInit,
                    ),
                  ),
                ),
            ],
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

  const JumpingDotsProgressIndicator({super.key, 
    this.numberOfDots = 3,
  });

  @override
  _JumpingDotsProgressIndicatorState createState() =>
      _JumpingDotsProgressIndicatorState(
        numberOfDots: numberOfDots,
      );
}

class _JumpingDotsProgressIndicatorState
    extends State<JumpingDotsProgressIndicator> with TickerProviderStateMixin {
  int numberOfDots;
  List<AnimationController> controllers = <AnimationController>[];
  List<Animation<double>> animations = <Animation<double>>[];
  final List<Widget> _widgets = <Widget>[];

  _JumpingDotsProgressIndicatorState({
    required this.numberOfDots,
  });

  @override
  initState() {
    super.initState();
    for (int i = 0; i < numberOfDots; i++) {
// adding controllers
      controllers.add(AnimationController(
          duration: const Duration(milliseconds: 250), vsync: this));
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
        padding: const EdgeInsets.only(right: 1.0),
        child: JumpingDot(
          animation: animations[i],
        ),
      ));
    }
// animating first dot in the list
    controllers[0].forward();
  }

  @override
  dispose() {
    for (int i = 0; i < numberOfDots; i++) {
      controllers[i].dispose();
    }
    super.dispose();
  }

  @override
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

  const JumpingDot({super.key, required this.animation})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: animation.value,
      child: Container(
        child: const Icon(
          Icons.fiber_manual_record,
          size: 16,
          color: AppColor.BLUE_TEXT,
        ),
      ),
    );
  }
}
