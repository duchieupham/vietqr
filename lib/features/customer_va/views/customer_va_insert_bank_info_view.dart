import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/customer_va/blocs/customer_va_bloc.dart';
import 'package:vierqr/features/customer_va/events/customer_va_event.dart';
import 'package:vierqr/features/customer_va/repositories/customer_va_repository.dart';
import 'package:vierqr/features/customer_va/states/customer_va_state.dart';
import 'package:vierqr/features/customer_va/widgets/customer_va_header_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/services/providers/customer_va/customer_va_insert_provider.dart';

import '../../../models/bank_name_search_dto.dart';

class CustomerVaInsertBankInfoView extends StatelessWidget {
  const CustomerVaInsertBankInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerVaBloc>(
      create: (BuildContext context) => CustomerVaBloc(context),
      child: ChangeNotifierProvider(
        create: (_) => CustomerVaInsertProvider(),
        child: const _CustomerVaInsertBankInfoViewState(),
      ),
    );
  }
}

class _CustomerVaInsertBankInfoViewState extends StatefulWidget {
  const _CustomerVaInsertBankInfoViewState();

  @override
  State<StatefulWidget> createState() =>
      _CustomerVaInsertBankInfoViewStateState();
}

class _CustomerVaInsertBankInfoViewStateState
    extends State<_CustomerVaInsertBankInfoViewState> {
  final focusAccount = FocusNode();
  final bankAccountController = TextEditingController();
  final nameController = TextEditingController();

  late CustomerVaBloc _bloc;
  late CustomerVaInsertProvider _customerVaInserProvider;

  final CustomerVaRepository customerVaRepository =
      const CustomerVaRepository();
  String _bankAccount = '';
  String _userBankName = '';

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _customerVaInserProvider =
        Provider.of<CustomerVaInsertProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusAccount.addListener(() {
        if (!focusAccount.hasFocus) {
          _onSearch();
        }
      });
    });
  }

  void _onSearch() {
    bool isEdit = _customerVaInserProvider.isEdit;
    if (bankAccountController.text.isNotEmpty &&
        bankAccountController.text.length > 5 &&
        isEdit) {
      //default BIDV
      String transferType = 'NAPAS';
      String caiValue = '970418';

      BankNameSearchDTO bankNameSearchDTO = BankNameSearchDTO(
        accountNumber: bankAccountController.text,
        accountType: 'ACCOUNT',
        transferType: transferType,
        bankCode: caiValue,
      );
      _bloc.add(BankCardSearchNameEvent(dto: bankNameSearchDTO));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColor.WHITE,
        appBar: const CustomerVaHeaderWidget(),
        bottomNavigationBar: _bottom(),
        body: Consumer<CustomerVaInsertProvider>(
          builder: (context, provider, child) {
            return BlocConsumer<CustomerVaBloc, CustomerVaState>(
              listener: (context, state) {
                if (state.request == AddBankType.SEARCH_BANK) {
                  nameController.clear();
                  nameController.value = nameController.value
                      .copyWith(text: state.informationDTO?.accountName ?? '');
                  _customerVaInserProvider
                      .updateUserBankName(nameController.text);
                }

                // if (state.request == AddBankType.ERROR_SEARCH_NAME) {
                //   if (!mounted) return;
                //   _customerVaInserProvider.updateEnableName(true);
                // }
              },
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    shrinkWrap: false,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: const Color(0XFFDADADA), width: 1),
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image: NetworkImage(
                                      _customerVaInserProvider.bidvLogoUrl,
                                      scale: 1.0,
                                    ))),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Tiếp theo, nhập thông tin\ntài khoản BIDV của bạn',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Số tài khoản*',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      MTextFieldCustom(
                        isObscureText: false,
                        focusNode: focusAccount,
                        controller: bankAccountController,
                        maxLines: 1,
                        showBorder: false,
                        fillColor: AppColor.TRANSPARENT,
                        value: _bankAccount,
                        autoFocus: true,
                        textFieldType: TextfieldType.DEFAULT,
                        title: '',
                        hintText: '',
                        inputType: TextInputType.text,
                        keyboardAction: TextInputAction.next,
                        maxLength: 20,
                        onChange: (value) {
                          _bankAccount = value;
                          setState(() {});
                          _customerVaInserProvider.updateBankAccount(value);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Nhập số tài khoản ở đây*',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: AppColor.GREY_TEXT,
                          ),
                          counterText: '',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                          ),
                        ),
                        inputFormatter: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                      ),
                      (provider.bankAccountErr)
                          ? Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text(
                                'Số tài khoản không đúng định dạng.',
                                style: TextStyle(
                                  color: AppColor.RED_CALENDAR,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Tên chủ tài khoản*',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      MTextFieldCustom(
                        key: provider.keyAccount,
                        controller: nameController,
                        isObscureText: false,
                        maxLines: 1,
                        showBorder: false,
                        fillColor: AppColor.TRANSPARENT,
                        value: _userBankName,
                        autoFocus: true,
                        textFieldType: TextfieldType.DEFAULT,
                        title: '',
                        hintText: '',
                        inputType: TextInputType.text,
                        keyboardAction: TextInputAction.next,
                        maxLength: 20,
                        onChange: (value) {
                          _userBankName = value;
                          setState(() {});
                          _customerVaInserProvider.updateUserBankName(value);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Nhập tên chủ tài khoản ở đây*',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: AppColor.GREY_TEXT,
                          ),
                          counterText: '',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                          ),
                        ),
                        inputFormatter: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                      ),
                      (provider.userBankNameErr)
                          ? Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text(
                                'Tên chủ tài khoản không đúng định dạng',
                                style: TextStyle(
                                  color: AppColor.RED_CALENDAR,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Lưu ý:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        '- Tên chủ tài khoản không dấu tiếng Việt.\n- Không chứa ký tự đặc biệt.',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _bottom() {
    return Consumer<CustomerVaInsertProvider>(
      builder: (context, provider, child) {
        bool isValidButton = (!provider.bankAccountErr &&
            provider.bankAccount.toString().trim().isNotEmpty &&
            !provider.userBankNameErr &&
            provider.userBankName.toString().trim().isNotEmpty);
        return Container(
          color: AppColor.WHITE,
          child: ButtonWidget(
            margin: EdgeInsets.only(
                left: 30,
                right: 30,
                top: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 15),
            text: 'Tiếp tục',
            textColor: (!isValidButton) ? AppColor.BLACK : AppColor.WHITE,
            bgColor: (!isValidButton) ? AppColor.GREY_VIEW : AppColor.BLUE_TEXT,
            borderRadius: 5,
            function: () async {
              if (isValidButton) {
                await _checkExistedLinkedBankAccountVa(provider.bankAccount);
              }
            },
          ),
        );
      },
    );
  }

  //
  Future<void> _checkExistedLinkedBankAccountVa(String bankAccount) async {
    //default BIDV
    String bankCode = 'BIDV';
    DialogWidget.instance.openLoadingDialog();
    await customerVaRepository
        .checkExistedBankAccountVa(bankAccount, bankCode)
        .then(
      (value) {
        String status = value.status;
        String msg = '';
        if (status == 'CHECK' || status == 'CHECKED') {
          msg = CheckUtils.instance.getCheckMessage(value.message);
        } else if (status == 'FAILED') {
          msg = ErrorUtils.instance.getErrorMessage(value.message);
        }
        Navigator.pop(context);
        if (status == 'SUCCESS') {
          Navigator.pushNamed(context, Routes.INSERT_CUSTOMER_VA_BANK_AUTH);
        } else {
          DialogWidget.instance
              .openMsgDialog(title: 'Không thể đăng ký dịch vụ', msg: msg);
        }
      },
    );
  }
}
