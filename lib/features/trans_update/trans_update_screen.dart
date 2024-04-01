import 'package:flutter/material.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/notify_trans_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';

import 'views/not_per_update_trans_view.dart';
import 'views/update_trans_view.dart';

class TransUpdateScreen extends StatefulWidget {
  final NotifyTransDTO dto;
  final MerchantRole role;
  static String routeName = '/TransUpdateScreen';

  const TransUpdateScreen({super.key, required this.dto, required this.role});

  @override
  State<TransUpdateScreen> createState() => _TransUpdateScreenState();
}

class _TransUpdateScreenState extends State<TransUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title: 'Trở về', centerTitle: false, showBG: false),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (widget.role.isAdmin) {
      return UpdateTransView(dto: widget.dto, role: widget.role, type: 1);
    } else if (widget.role.isRequestTrans) {
      return UpdateTransView(dto: widget.dto, role: widget.role);
    }
    return NotPerUpdateTransView();
  }
}
