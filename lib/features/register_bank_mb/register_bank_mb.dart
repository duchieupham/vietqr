import 'package:flutter/material.dart';
import 'package:vierqr/layouts/m_app_bar.dart';

class RegisterBankMB extends StatefulWidget {
  const RegisterBankMB({super.key});

  @override
  State<RegisterBankMB> createState() => _RegisterBankMBState();
}

class _RegisterBankMBState extends State<RegisterBankMB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title: 'Mở Tk ngân hàng'),
    );
  }
}
