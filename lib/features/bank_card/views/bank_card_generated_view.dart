// ignore_for_file: prefer_const_literals_to_create_immutables, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/bank_card_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/bank_card_position_provider.dart';

class BankCardGeneratedView extends StatefulWidget {
  const BankCardGeneratedView({super.key});

  @override
  State<StatefulWidget> createState() => _BankCardGeneratedView();
}

class _BankCardGeneratedView extends State<BankCardGeneratedView> {
  //animation
  late final rive.StateMachineController _riveController;
  late rive.SMITrigger _action;
  bool _isRiveInit = false;
  final BankCardPositionProvider _bankCardPositionProvider =
      BankCardPositionProvider(false);

  @override
  void initState() {
    super.initState();
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
    final double height = MediaQuery.of(context).size.height;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final BankAccountDTO dto = arg['bankAccountDTO'];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              child: SizedBox(
                width: width * 0.8,
                height: 200,
                child: rive.RiveAnimation.asset(
                  'assets/rives/success_ani.riv',
                  fit: BoxFit.fitWidth,
                  antialiasing: false,
                  animations: [Stringify.SUCCESS_ANI_INITIAL_STATE],
                  onInit: _onRiveInit,
                ),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: _bankCardPositionProvider,
                builder: (_, provider, child) {
                  return AnimatedPositioned(
                    top: (provider == true) ? 50 : 200,
                    curve: Curves.easeInOut,
                    duration: const Duration(
                      milliseconds: 800,
                    ),
                    child: BankCardWidget(dto: dto, width: width * 0.9),
                  );
                }),
            const Positioned(
              bottom: 90,
              child: Text(
                'Thêm tài khoản thành công',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ButtonWidget(
                  width: width * 0.9,
                  text: 'Trở về',
                  textColor: DefaultTheme.WHITE,
                  bgColor: DefaultTheme.GREEN,
                  function: () {
                    _doEndAnimation();
                    Future.delayed(const Duration(milliseconds: 800), () {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                ),
              ),
            ),
            //   const Padding(padding: EdgeInsets.only(bottom: 20)),
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
    _bankCardPositionProvider.transform();
    _action =
        _riveController.findInput<bool>(Stringify.SUCCESS_ANI_ACTION_DO_END)
            as rive.SMITrigger;
    _action.fire();
  }
}
