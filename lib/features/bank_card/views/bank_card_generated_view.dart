// ignore_for_file: prefer_const_literals_to_create_immutables, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/widgets/bank_card_widget.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';
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
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final BankAccountDTO dto = args['bankAccountDTO'];
    final String qr = args['qr'] ?? '';
    final String bankId = args['bankId'] ?? '';
    QRGeneratedDTO qrGeneratedDTO = QRGeneratedDTO(
      bankCode: dto.bankCode,
      bankName: dto.bankName,
      bankAccount: dto.bankAccount,
      userBankName: dto.userBankName,
      amount: '',
      content: '',
      qrCode: qr,
      imgId: dto.imgId,
    );
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
            ),
            ValueListenableBuilder(
                valueListenable: _bankCardPositionProvider,
                builder: (_, provider, child) {
                  return AnimatedPositioned(
                    top: (provider == true) ? 50 : 150,
                    curve: Curves.easeInOut,
                    duration: const Duration(
                      milliseconds: 800,
                    ),
                    child: VietQr(
                      qrGeneratedDTO: qrGeneratedDTO,
                      content: '',
                      isSmallWidget: (height <= 800),
                    ),
                    //  BankCardWidget(dto: dto, width: width * 0.9),
                  );
                }),
            Visibility(
              visible: height > 700,
              child: const Positioned(
                bottom: 80,
                child: Text(
                  'Thêm tài khoản thành công',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonIconWidget(
                            width: width * 0.5 - 35,
                            height: 40,
                            icon: Icons.home_rounded,
                            title: 'Trang chủ',
                            textColor: AppColor.GREEN,
                            bgColor: AppColor.WHITE,
                            function: () {
                              _doEndAnimation();
                              Provider.of<AddBankProvider>(context,
                                      listen: false)
                                  .reset();
                              Future.delayed(const Duration(milliseconds: 0),
                                  () {
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              });
                              eventBus.fire(ChangeThemeEvent());
                            },
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          ButtonIconWidget(
                            width: width * 0.5 - 35,
                            height: 40,
                            icon: Icons.info_outline_rounded,
                            title: 'Chi tiết',
                            textColor: AppColor.WHITE,
                            bgColor: AppColor.GREEN,
                            function: () {
                              _doEndAnimation();
                              Provider.of<AddBankProvider>(context,
                                      listen: false)
                                  .reset();
                              Future.delayed(const Duration(milliseconds: 800),
                                  () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  Routes.BANK_CARD_DETAIL_VEW,
                                  arguments: {
                                    'bankId': bankId,
                                  },
                                );
                              });
                            },
                          ),
                        ],
                      ))),
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
