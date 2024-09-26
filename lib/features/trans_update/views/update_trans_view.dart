import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/repositories/bank_card_repository.dart';
import 'package:vierqr/features/transaction_detail/repositories/transaction_repository.dart';
import 'package:vierqr/layouts/dashedline/horizontal_dashed_line.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/notify_trans_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/models/terminal_qr_dto.dart';
import 'package:vierqr/models/trans/trans_request_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import 'trans_success_view.dart';

class UpdateTransView extends StatefulWidget {
  final NotifyTransDTO dto;
  final MerchantRole role;
  final int type; // = 0: yêu cầu xác nhận, =1 là update luôn

  const UpdateTransView(
      {super.key, required this.dto, this.type = 0, required this.role});

  @override
  State<UpdateTransView> createState() => _UpdateTransViewState();
}

class _UpdateTransViewState extends State<UpdateTransView> {
  final bankCardRepository = BankCardRepository();
  final transRepository = getIt.get<TransactionRepository>();

  final controller = TextEditingController();

  String get userId => SharePrefUtils().userId;
  List<TerminalQRDTO> terminals = [];
  List<TerminalQRDTO> listDefault = [];
  TerminalQRDTO _terminalQRDTO = TerminalQRDTO();
  bool isLoading = true;

  void _getTerminals() async {
    try {
      List<TerminalQRDTO> list =
          await bankCardRepository.getTerminals(userId, widget.dto.bankId);
      if (!mounted) return;
      terminals = [...list];
      listDefault = [...list];
      isLoading = false;
      setState(() {});
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void _updateTerminal() async {
    try {
      DialogWidget.instance.openLoadingDialog();

      final result = await transRepository.updateTerminal(
          widget.dto.transactionReceiveId, _terminalQRDTO.terminalCode);
      Navigator.pop(context);

      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        NotifyTransDTO dto = widget.dto;
        dto.terminalCode = _terminalQRDTO.terminalCode;
        dto.terminalName = _terminalQRDTO.terminalName;
        NavigatorUtils.navigatePage(
            context, TransSuccessView(dto: dto, type: widget.type),
            routeName: TransSuccessView.routeName);
      } else {
        await DialogWidget.instance.openMsgDialog(
            title: 'Thông báo', msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau.');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void _onRequestTrans() async {
    try {
      DialogWidget.instance.openLoadingDialog();
      TransRequest dto = TransRequest(
        transactionId: widget.dto.transactionReceiveId,
        requestType: 0,
        terminalCode: _terminalQRDTO.terminalCode,
        terminalId: _terminalQRDTO.terminalId,
      );

      final result = await transRepository.transRequest(dto);
      Navigator.pop(context);

      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        NotifyTransDTO dto = widget.dto;
        dto.terminalCode = _terminalQRDTO.terminalCode;
        dto.terminalName = _terminalQRDTO.terminalName;
        NavigatorUtils.navigatePage(
            context, TransSuccessView(dto: dto, type: widget.type),
            routeName: TransSuccessView.routeName);
      } else {
        await DialogWidget.instance.openMsgDialog(
            title: 'Thông báo', msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau.');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTerminals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cập nhật thông tin\ncửa hàng cho giao dịch',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.BLACK,
                  ),
                ),
                const SizedBox(height: 30),
                _buildInfo(),
                const SizedBox(height: 24),
                ...[
                  const Text(
                    'Danh sách cửa hàng',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.BLACK,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  MTextFieldCustom(
                    isObscureText: false,
                    maxLines: 1,
                    showBorder: true,
                    controller: controller,
                    fillColor: AppColor.GREY_BG,
                    textFieldType: TextfieldType.DEFAULT,
                    title: '',
                    hintText: 'Tìm kiếm cửa hàng',
                    inputType: TextInputType.text,
                    keyboardAction: TextInputAction.next,
                    onChange: _onChange,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  const SizedBox(height: 16),
                  if (terminals.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.GREY_DADADA),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: List.generate(terminals.length, (index) {
                          TerminalQRDTO dto = terminals[index];
                          return _buildItemTerminal(
                            dto,
                            last: index == terminals.length - 1,
                          );
                        }),
                      ),
                    )
                  else
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 30),
                      child: const Text(
                        'Danh sách trống',
                        style: TextStyle(
                          color: AppColor.BLACK,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
        MButtonWidget(
          title: widget.type == 0 ? 'Yêu cầu xác nhận' : 'Xác nhận',
          onTap: _onHandle,
          margin: EdgeInsets.zero,
          isEnable: _terminalQRDTO.terminalCode.isNotEmpty,
          colorDisableBgr: AppColor.GREY_DADADA,
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...[
          _buildItem(
            title: 'Tài khoản nhận:',
            content: '${widget.dto.bankCode} - ${widget.dto.bankAccount}',
          ),
          CustomPaint(
            painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
            size: const Size(double.infinity, 1),
          ),
        ],
        ...[
          _buildItem(
            title: 'Số tiền',
            content: widget.dto.getAmount,
            textColor: AppColor.BLUE_TEXT,
          ),
          CustomPaint(
            painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
            size: const Size(double.infinity, 1),
          ),
        ],
        ...[
          _buildItem(
            title: 'Mã GD:',
            content: widget.dto.referenceNumber,
          ),
          CustomPaint(
            painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
            size: const Size(double.infinity, 1),
          ),
        ],
        _buildItem(
          title: 'Thời gian TT:',
          content: widget.dto.timePayment,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildItem(
      {String title = '',
      String content = '',
      int maxLines = 1,
      Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: AppColor.GREY_TEXT.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            child: Text(
              content.isEmpty ? '-' : content,
              textAlign: TextAlign.right,
              maxLines: maxLines,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
                color: textColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemTerminal(TerminalQRDTO dto, {bool last = false}) {
    bool isSelect = dto.terminalId == _terminalQRDTO.terminalId;
    return GestureDetector(
      onTap: () {
        setState(() {
          _terminalQRDTO = dto;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: isSelect
            ? AppColor.BLUE_TEXT.withOpacity(0.2)
            : AppColor.TRANSPARENT,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.terminalName,
                    style: TextStyle(
                      color: isSelect ? AppColor.BLUE_TEXT : AppColor.BLACK,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    dto.terminalCode,
                    style: TextStyle(
                      color: isSelect ? AppColor.BLUE_TEXT : AppColor.BLACK,
                    ),
                  ),
                ],
              ),
            ),
            if (!last)
              CustomPaint(
                painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
                size: const Size(double.infinity, 1),
              ),
          ],
        ),
      ),
    );
  }

  void _onChange(String value) {
    List<TerminalQRDTO> values = [];
    List<TerminalQRDTO> listMaps = [...listDefault];
    if (value.trim().isNotEmpty) {
      values.addAll(listMaps
          .where((dto) =>
              dto.terminalCode.toUpperCase().contains(value.toUpperCase()) ||
              dto.terminalName.toUpperCase().contains(value.toUpperCase()))
          .toList());
    } else {
      values = listMaps;
    }
    setState(() {
      terminals = values;
    });
  }

  void _onHandle() {
    if (widget.type == 1) {
      _updateTerminal();
      return;
    }

    _onRequestTrans();
  }
}
