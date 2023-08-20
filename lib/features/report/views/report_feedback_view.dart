import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:rive/rive.dart' as rive;

class ReportFeedbackView extends StatefulWidget {
  const ReportFeedbackView({super.key});

  @override
  State<ReportFeedbackView> createState() => _ReportFeedbackViewState();
}

class _ReportFeedbackViewState extends State<ReportFeedbackView> {
  late final rive.StateMachineController _riveController;
  late rive.SMITrigger _action;
  bool _isRiveInit = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          SizedBox(
            width: width * 0.6,
            height: 150,
            child: rive.RiveAnimation.asset(
              'assets/rives/success_ani.riv',
              fit: BoxFit.fitWidth,
              antialiasing: false,
              animations: const [Stringify.SUCCESS_ANI_INITIAL_STATE],
              onInit: _onRiveInit,
            ),
          ),
          const Spacer(),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                color: AppColor.BLACK,
                fontSize: 16,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: 'Cảm ơn bạn!\n',
                  style: TextStyle(
                    color: AppColor.BLACK,
                    fontSize: 18,
                    height: 2,
                  ),
                ),
                TextSpan(
                  text: 'Chúng tôi xin ghi nhận đóng góp của bạn.\n',
                ),
                TextSpan(
                  text:
                      'Ý kiến của bạn góp phần cải thiện VietQR VN trở nên tốt hơn.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          MButtonWidget(
            title: 'Trang chủ',
            isEnable: true,
            margin: EdgeInsets.zero,
            onTap: () {
              _doEndAnimation();
              Future.delayed(const Duration(milliseconds: 400)).then((value) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
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

  void _doEndAnimation() {
    _action =
        _riveController.findInput<bool>(Stringify.SUCCESS_ANI_ACTION_DO_END)
            as rive.SMITrigger;
    _action.fire();
  }

  @override
  void dispose() {
    if (_isRiveInit) {
      _riveController.dispose();
    }
    super.dispose();
  }
}
