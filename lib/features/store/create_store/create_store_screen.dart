import 'package:flutter/material.dart';
import 'package:vierqr/features/store/create_store/views/info_store_view.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/bank_account_terminal.dart';
import 'package:vierqr/models/detail_group_dto.dart';

import 'views/input_bank_store_view.dart';
import 'views/input_code_store_view.dart';
import 'views/input_name_store_view.dart';
import 'views/share_notify_member_view.dart';

enum StoreStep {
  INPUT_NAME_STORE,
  ADD_MEMBER,
  CODE_STORE,
  BANK_STORE,
  INFO_STORE,
}

class CreateStoreScreen extends StatefulWidget {
  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  StoreStep step = StoreStep.INPUT_NAME_STORE;
  bool isEnableButton = false;
  String _storeName = '';
  String _storeCode = '';
  String _storeAddress = '';
  BankAccountTerminal _dto = BankAccountTerminal();
  List<AccountMemberDTO> members = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        title: 'Trở về',
        centerTitle: false,
        onPressed: _handleBack,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    Widget _body = const SizedBox();

    switch (step) {
      case StoreStep.ADD_MEMBER:
        _body = ShareNotifyMemberView(
          callBack: _onHandleMember,
          nameStore: _storeName,
          members: members,
        );
        break;
      case StoreStep.BANK_STORE:
        _body = InputBankStoreView(
          callBack: _onHandleBankStore,
          nameStore: _storeName,
        );
        break;
      case StoreStep.CODE_STORE:
        _body = InputCodeStoreView(
          callBack: _onHandleCodeStore,
          nameStore: _storeName,
          codeStore: _storeCode,
          addressStore: _storeAddress,
        );
        break;
      case StoreStep.INFO_STORE:
        _body = InfoStoreView(
          storeName: _storeName,
          storeCode: _storeCode,
          storeAddress: _storeAddress,
          dto: _dto,
          members: members,
        );
        break;

      default:
        _body = InputNameStoreView(
          callBack: _onHandleNameStore,
          storeName: _storeName,
        );
    }

    return _body;
  }

  void _onHandleNameStore(String value) {
    setState(() {
      _storeName = value;
      step = StoreStep.BANK_STORE;
    });
  }

  void _onHandleBankStore(BankAccountTerminal dto) {
    setState(() {
      step = StoreStep.CODE_STORE;
      _dto = dto;
      _storeCode = '';
      _storeAddress = '';
    });
  }

  void _onHandleCodeStore(String code, String address) {
    setState(() {
      step = StoreStep.ADD_MEMBER;
      _storeCode = code;
      _storeAddress = address;
      members = [];
    });
  }

  void _onHandleMember(List<AccountMemberDTO> list) {
    setState(() {
      step = StoreStep.INFO_STORE;
      members = list;
    });
  }

  void _handleBack() {
    switch (step) {
      case StoreStep.INPUT_NAME_STORE:
        Navigator.pop(context);
        break;
      case StoreStep.BANK_STORE:
        setState(() {
          step = StoreStep.INPUT_NAME_STORE;
        });
        break;
      case StoreStep.CODE_STORE:
        setState(() {
          step = StoreStep.BANK_STORE;
        });
        break;
      case StoreStep.ADD_MEMBER:
        setState(() {
          step = StoreStep.CODE_STORE;
        });
        break;
      case StoreStep.INFO_STORE:
        setState(() {
          step = StoreStep.ADD_MEMBER;
        });
        break;
    }
  }
}
