import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/models/top_up_sucsess_dto.dart';

class PopupTopUpSuccess extends StatefulWidget {
  final TopUpSuccessDTO dto;
  const PopupTopUpSuccess({Key? key, required this.dto}) : super(key: key);

  @override
  State<PopupTopUpSuccess> createState() => _PopupTopUpSuccessState();
}

class _PopupTopUpSuccessState extends State<PopupTopUpSuccess> {
  //animation
  late final rive.StateMachineController _riveController;
  late rive.SMITrigger _action;
  bool _isRiveInit = false;

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
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          width: width * 0.6,
          height: 150,
          child: rive.RiveAnimation.asset(
            'assets/rives/success_ani.riv',
            fit: BoxFit.fitWidth,
            antialiasing: false,
            animations: [Stringify.SUCCESS_ANI_INITIAL_STATE],
            onInit: _onRiveInit,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 30)),
        Align(
          alignment: Alignment.center,
          child: Text(
            '+ ${CurrencyUtils.instance.getCurrencyFormatted(widget.dto.amount)} VND',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: AppColor.NEON,
            ),
          ),
        ),
        const Text(
          'Giao dịch thành công',
          style: TextStyle(
            fontSize: 16,
            color: AppColor.NEON,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 8)),
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Mã giao dịch ',
              ),
              Text(
                widget.dto.billNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        MButtonWidget(
            title: 'OK',
            colorEnableText: AppColor.WHITE,
            colorEnableBgr: AppColor.BLUE_TEXT,
            isEnable: true,
            onTap: () {
              eventBus.fire(ReloadWallet());
              Navigator.of(context).pop();
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            })
      ],
    );
  }
}
