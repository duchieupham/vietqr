// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/notification/views/popup_trans_widget.dart';
import 'package:vierqr/features/trans_update/trans_update_screen.dart';
import 'package:vierqr/features/transaction_detail/transaction_detail_screen.dart';
import 'package:vierqr/layouts/button/m_button_icon_widget.dart';
import 'package:vierqr/layouts/dashedline/horizontal_dashed_line.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/notify_trans_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/services/providers/countdown_provider.dart';
import 'package:vierqr/services/socket_service/socket_service.dart';

class NotifyTransWidget extends StatefulWidget {
  final NotifyTransDTO dto;

  const NotifyTransWidget({super.key, required this.dto});

  @override
  State<StatefulWidget> createState() => _TransactionSuccessWidget();
}

class _TransactionSuccessWidget extends State<NotifyTransWidget> {
  late CountdownProvider countdownProvider;
  late AuthProvider authProvider;

  bool isOwner = false;
  MerchantRole role = MerchantRole();

  @override
  void initState() {
    super.initState();
    SocketService.instance.updateConnect(true);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    countdownProvider = CountdownProvider(30);
    countdownProvider.countDown(callback: () {
      if (!mounted) return;
      Navigator.pop(context);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      onRole();
    });
  }

  void onRole() {
    final banks = [...authProvider.listBank];
    BankAccountDTO bankDTO = banks.firstWhere(
        (element) => element.id == widget.dto.bankId,
        orElse: () => BankAccountDTO());
    setState(() {
      isOwner = bankDTO.isOwner;
      role.isOwner = isOwner;
    });
    if (isOwner) return;

    SettingAccountDTO settingDTO = authProvider.settingDTO;
    List<MerchantRole> merchantRoles = [...settingDTO.merchantRoles];
    MerchantRole merchantDTO = merchantRoles.firstWhere(
        (element) => element.bankId == bankDTO.id,
        orElse: () => MerchantRole())
      ..isOwner = isOwner;
    if (merchantDTO.bankId.isEmpty) return;
    role = merchantDTO;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(widget.dto.icon, width: 120),
        ...[
          Text(
            widget.dto.getAmount,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: widget.dto.colorAmount,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          Text(
            widget.dto.getTransStatus,
            style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
          ),
          const SizedBox(height: 24),
          CustomPaint(
            painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
            size: const Size(double.infinity, 1),
          ),
          const SizedBox(height: 24),
        ],
        if (widget.dto.isTerNotEmpty || widget.dto.orderId.isNotEmpty) ...[
          if (widget.dto.isTerNotEmpty)
            Text(
              widget.dto.terminalName.isNotEmpty
                  ? widget.dto.terminalName
                  : widget.dto.terminalCode,
              style: const TextStyle(
                  fontSize: 16,
                  color: AppColor.BLACK,
                  fontWeight: FontWeight.bold),
            ),
          if (widget.dto.orderId.isNotEmpty)
            Text(
              'Mã đơn ${widget.dto.orderId}',
              style: TextStyle(
                fontSize: widget.dto.isTerEmpty ? 16 : 12,
                color: AppColor.BLACK,
                fontWeight: widget.dto.isTerEmpty ? FontWeight.bold : null,
              ),
            ),
          const SizedBox(height: 40),
        ],
        if (widget.dto.isTransUnclassified &&
            widget.dto.transType.trim() == 'C') ...[
          MButtonIconWidget(
            pathIcon: AppImages.icUpdateTrans,
            iconColor: AppColor.BLUE_TEXT,
            title: 'Cập nhật cửa hàng',
            onTap: _onUpdateStore,
            border: Border.all(color: AppColor.BLUE_TEXT),
            bgColor: AppColor.TRANSPARENT,
            textColor: AppColor.BLUE_TEXT,
          ),
          const SizedBox(height: 30),
        ],
        _buildInfo(),
        const SizedBox(height: 30),
        _buildAction(),
        const Spacer(),
        CustomPaint(
          painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
          size: const Size(double.infinity, 1),
        ),
        const SizedBox(height: 16),
        _buildButtonBottom(),
        const SizedBox(height: 12),
        ValueListenableBuilder<int>(
          valueListenable: countdownProvider,
          builder: (_, value, child) {
            return RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12, color: Colors.black),
                children: [
                  const TextSpan(text: 'Thông báo tự động đóng sau '),
                  TextSpan(
                    text: value.toString(),
                    style: const TextStyle(
                        fontSize: 12, color: AppColor.BLUE_TEXT),
                  ),
                  const TextSpan(text: 's'),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
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
            title: 'Thời gian TT:',
            content: widget.dto.timePayment,
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
          title: 'Nội dung TT:',
          content: widget.dto.content,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildAction() {
    return Row(
      children: [
        Expanded(
          child: MButtonIconWidget(
            pathIcon: AppImages.icSaveImage,
            iconColor: AppColor.WHITE,
            title: 'Lưu ảnh',
            onTap: _onSaveImage,
            borderRadius: 25,
            border: Border.all(color: AppColor.BLUE_TEXT),
            bgColor: AppColor.WHITE,
            textColor: AppColor.BLUE_TEXT,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: MButtonIconWidget(
            pathIcon: AppImages.icShare,
            title: 'Chia sẻ',
            onTap: _onShare,
            borderRadius: 25,
            border: Border.all(color: AppColor.BLUE_TEXT),
            bgColor: AppColor.WHITE,
            textColor: AppColor.BLUE_TEXT,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonBottom() {
    return Row(
      children: [
        MButtonIconWidget(
          pathIcon: AppImages.icDetailTrans,
          iconColor: AppColor.WHITE,
          title: 'Chi tiết GD',
          onTap: _onDetail,
          border: Border.all(color: AppColor.BLUE_TEXT),
          bgColor: AppColor.WHITE,
          textColor: AppColor.BLUE_TEXT,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: MButtonIconWidget(
            icon: Icons.check,
            iconSize: 14,
            iconColor: AppColor.WHITE,
            title: 'Hoàn thành',
            onTap: () => Navigator.pop(context),
            border: Border.all(color: AppColor.BLUE_TEXT),
            bgColor: AppColor.BLUE_TEXT,
            textColor: AppColor.WHITE,
          ),
        ),
      ],
    );
  }

  void _onUpdateStore() {
    NavigatorUtils.navigatePageReplacement(
        context, TransUpdateScreen(dto: widget.dto, role: role),
        routeName: TransUpdateScreen.routeName);
  }

  void _onDetail() {
    NavigatorUtils.navigatePageReplacement(context,
        TransactionDetailScreen(transactionId: widget.dto.transactionReceiveId),
        routeName: TransactionDetailScreen.routeName);
  }

  void _onSaveImage() {
    NavigatorUtils.navigatePage(
        context, PopupTransWidget(dto: widget.dto, type: TypeImage.SAVE),
        routeName: PopupTransWidget.routeName);
  }

  void _onShare() {
    NavigatorUtils.navigatePage(
        context, PopupTransWidget(dto: widget.dto, type: TypeImage.SHARE),
        routeName: PopupTransWidget.routeName);
  }

  Widget _buildItem(
      {String title = '', String content = '', int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppColor.GREY_TEXT.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            child: Text(
              content.isEmpty ? '-' : content,
              textAlign: TextAlign.right,
              maxLines: maxLines,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    SocketService.instance.updateConnect(false);
    super.dispose();
  }
}
