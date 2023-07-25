// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/models/notification_transaction_success_dto.dart';
import 'package:rive/rive.dart' as rive;

class TransactionSuccessWidget extends StatefulWidget {
  final NotificationTransactionSuccessDTO dto;

  const TransactionSuccessWidget({super.key, required this.dto});

  @override
  State<StatefulWidget> createState() => _TransactionSuccessWidget();
}

class _TransactionSuccessWidget extends State<TransactionSuccessWidget> {
  //animation
  late final rive.StateMachineController _riveController;
  late rive.SMITrigger _action;
  bool _isRiveInit = false;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        (widget.dto.transType == 'C')
            ? SizedBox(
                width: width * 0.6,
                height: 150,
                child: rive.RiveAnimation.asset(
                  'assets/rives/success_ani.riv',
                  fit: BoxFit.fitWidth,
                  antialiasing: false,
                  animations: [Stringify.SUCCESS_ANI_INITIAL_STATE],
                  onInit: _onRiveInit,
                ),
              )
            : const SizedBox(),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              const Padding(padding: EdgeInsets.only(top: 30)),
              Align(
                alignment: Alignment.center,
                child: Text(
                  '${TransactionUtils.instance.getTransType(widget.dto.transType)} ${CurrencyUtils.instance.getCurrencyFormatted(widget.dto.amount)} VND',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: (widget.dto.transType.trim() == 'C')
                        ? AppColor.NEON
                        : AppColor.RED_CALENDAR,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Align(
                alignment: Alignment.center,
                child: Text(
                  (widget.dto.transType.trim() == 'C')
                      ? 'Giao dịch thành công'
                      : 'Biến động số dư',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              _buildElement(
                  width: width,
                  title: TransactionUtils.instance
                      .getPrefixBankAccount(widget.dto.transType),
                  description: widget.dto.bankAccount),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DividerWidget(width: width),
              ),
              _buildElement(
                  width: width,
                  title: 'Ngân hàng',
                  description:
                      '${widget.dto.bankCode} - ${widget.dto.bankName}'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DividerWidget(width: width),
              ),
              _buildElement(
                width: width,
                title: 'Thời gian',
                description: TimeUtils.instance
                    .formatDateFromInt(widget.dto.time, false),
              ),
              if (widget.dto.businessName.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DividerWidget(width: width),
                ),
                _buildElement(
                  width: width,
                  title: 'Công ty',
                  description: widget.dto.businessName,
                ),
              ],
              if (widget.dto.branchName.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DividerWidget(width: width),
                ),
                _buildElement(
                  width: width,
                  title: 'Chi nhánh',
                  description: widget.dto.branchName,
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DividerWidget(width: width),
              ),
              _buildElement(
                width: width,
                title: 'Nội dung',
                description: widget.dto.content,
                maxLines: 3,
              ),
            ],
          ),
        ),
        MButtonWidget(
            title: 'OK',
            colorEnableText: AppColor.WHITE,
            colorEnableBgr: AppColor.BLUE_TEXT,
            isEnable: true,
            onTap: () {
              if (widget.dto.transType == 'C') {
                _doEndAnimation();
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }
                });
              } else {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              }
            })
      ],
    );
  }

  Widget _buildElement({
    required double width,
    required String title,
    required String description,
    int? maxLines,
  }) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              textAlign: TextAlign.right,
              maxLines: (maxLines != null) ? maxLines : 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          )
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
}
