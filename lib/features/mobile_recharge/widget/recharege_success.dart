import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:rive/rive.dart' as rive;
import 'package:vierqr/layouts/m_app_bar.dart';

class RechargeSuccess extends StatefulWidget {
  const RechargeSuccess({Key? key}) : super(key: key);

  @override
  State<RechargeSuccess> createState() => _RechargeSuccessState();
}

class _RechargeSuccessState extends State<RechargeSuccess> {
  late final rive.StateMachineController _riveController;
  late rive.SMITrigger _action;
  bool _isRiveInit = false;

  String money = '';
  String phoneNo = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final args = ModalRoute.of(context)!.settings.arguments as Map;
        phoneNo = args['phoneNo'];
        money = args['money'];
        setState(() {});
      }
    });
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
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const MAppBar(
        title: 'Nạp tiền điện thoại',
        isLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
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
            Expanded(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  const Text(
                    'Nạp điện thoại thành công',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '+ ${money} VND',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColor.BLUE_TEXT,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Text(
                    'Quý khách đã nạp thành công số tiền +${money} VND cho số điện thoại ${phoneNo}. Cảm ơn quý khách đã sử dụng dịch vụ của VietQR VN',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            MButtonWidget(
                title: 'Trang chủ',
                colorEnableText: AppColor.WHITE,
                colorEnableBgr: AppColor.BLUE_TEXT,
                isEnable: true,
                margin: const EdgeInsets.only(bottom: 20),
                onTap: () {
                  _doEndAnimation();
                  eventBus.fire(ReloadWallet());
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                })
          ],
        ),
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
}
