import 'package:flutter/material.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/bank_account_terminal.dart';
import 'package:vierqr/models/detail_group_dto.dart';

import 'create_store.dart';

enum StoreStep {
  INFO_MERCHANT,
  INPUT_NAME_MERCHANT,
  INPUT_NAME_STORE,
  ADD_MEMBER,
  CODE_STORE,
  BANK_STORE,
  INFO_STORE,
}

class CreateStoreScreen extends StatefulWidget {
  static String routeName = '/CreateStoreScreen';

  const CreateStoreScreen({super.key});

  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  StoreStep step = StoreStep.INFO_MERCHANT;
  bool isEnableButton = false;
  String _storeName = '';
  String _merchantName = '';
  String _merchantId = '';
  String _storeCode = '';
  String _storeAddress = '';
  BankAccountTerminal _dto = BankAccountTerminal();
  List<AccountMemberDTO> members = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MAppBar(
        title: 'Trở về',
        centerTitle: false,
        onPressed: _handleBack,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    Widget body = const SizedBox();

    switch (step) {
      case StoreStep.INFO_MERCHANT:
        body = InfoMerchantView(
          onAddMerchant: () {
            setState(() {
              step = StoreStep.INPUT_NAME_MERCHANT;
            });
          },
          callBack: (merchantId) {
            _merchantId = merchantId;
            step = StoreStep.INPUT_NAME_STORE;
            setState(() {});
          },
        );
        break;
      case StoreStep.INPUT_NAME_MERCHANT:
        body = InputCreateMerchantView(
          callBack: _onHandleCreateMerchant,
          storeName: _merchantName,
        );
        break;
      case StoreStep.ADD_MEMBER:
        body = ShareNotifyMemberView(
          callBack: _onHandleMember,
          nameStore: _storeName,
          members: members,
        );
        break;
      case StoreStep.BANK_STORE:
        body = InputBankStoreView(
          callBack: _onHandleBankStore,
          nameStore: _storeName,
        );
        break;
      case StoreStep.CODE_STORE:
        body = InputCodeStoreView(
          callBack: _onHandleCodeStore,
          nameStore: _storeName,
          codeStore: _storeCode,
          addressStore: _storeAddress,
        );
        break;
      case StoreStep.INFO_STORE:
        body = InfoStoreView(
          storeName: _storeName,
          storeCode: _storeCode,
          storeAddress: _storeAddress,
          merchantId: _merchantId,
          dto: _dto,
          members: members,
        );
        break;

      default:
        body = InputNameStoreView(
          callBack: _onHandleNameStore,
          storeName: _storeName,
        );
    }

    return body;
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

  _onHandleCreateMerchant(String merchantName, String merchantId) {
    setState(() {
      step = StoreStep.INPUT_NAME_STORE;
      _merchantName = merchantName;
      _merchantId = merchantId;
    });
  }

  void _handleBack() {
    switch (step) {
      case StoreStep.INFO_MERCHANT:
        Navigator.pop(context);
        break;
      case StoreStep.INPUT_NAME_MERCHANT:
        setState(() {
          step = StoreStep.INFO_MERCHANT;
          _merchantName = '';
          _merchantId = '';
        });
        break;
      case StoreStep.INPUT_NAME_STORE:
        setState(() {
          step = StoreStep.INFO_MERCHANT;
          _storeName = '';
          _merchantName = '';
          _merchantId = '';
        });
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
