import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/add_bank/blocs/add_bank_bloc.dart';
import 'package:vierqr/features/add_bank/blocs/add_bank_provider.dart';
import 'package:vierqr/features/add_bank/events/add_bank_event.dart';
import 'package:vierqr/features/add_bank/states/add_bank_state.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';

import 'views/bank_input_widget.dart';

class AddBankScreen extends StatelessWidget {
  const AddBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddBankBloc>(
      create: (BuildContext context) => AddBankBloc(context),
      child: ChangeNotifierProvider(
        create: (_) => AddBankProvider(),
        child: _AddBankScreenState(),
      ),
    );
  }
}

class _AddBankScreenState extends StatefulWidget {
  @override
  State<_AddBankScreenState> createState() => _AddBankScreenStateState();
}

class _AddBankScreenStateState extends State<_AddBankScreenState> {
  late AddBankBloc _bloc;

  final focusAccount = FocusNode();
  final focusName = FocusNode();

  final bankAccountController = TextEditingController();

  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(LoadDataBankEvent());
      focusAccount.addListener(() {
        if (!focusAccount.hasFocus) {
          // _bloc.add(BankCardEventSearchName(dto: ));
        }
      });
      focusName.addListener(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        _hideKeyboardBack(context);
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: BlocConsumer<AddBankBloc, AddBankState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: const MAppBar(title: 'Thêm tài khoản'),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Ngân hàng',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final data =
                            await DialogWidget.instance.showModelBottomSheet(
                          context: context,
                          padding: EdgeInsets.zero,
                          widget: ModelBottomSheetView(
                            tvTitle: 'Chọn ngân hàng',
                            list: state.listBanks ?? [],
                            isSearch: true,
                            data: state.bankSelected,
                          ),
                          height: height * 0.6,
                        );
                        if (data is int) {
                          _bloc.add(ChooseBankEvent(data));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: AppColor.WHITE,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                state.bankSelected?.bankName ??
                                    'Chọn ngân hàng',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: state.bankSelected?.bankName != null
                                        ? AppColor.BLACK
                                        : AppColor.GREY_TEXT),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColor.GREY_TEXT,
                            )
                          ],
                        ),
                      ),
                    ),
                    //
                    const SizedBox(height: 30),
                    TextFieldCustom(
                      isObscureText: false,
                      maxLines: 1,
                      enable: state.bankSelected != null,
                      fillColor: state.bankSelected != null
                          ? null
                          : AppColor.GREY_EBEBEB,
                      controller: bankAccountController,
                      textFieldType: TextfieldType.LABEL,
                      title: 'Số tài khoản',
                      focusNode: focusAccount,
                      hintText: 'Nhập số tài khoản',
                      // controller: provider.introduceController,
                      inputType: TextInputType.number,
                      keyboardAction: TextInputAction.next,
                      onChange: (value) {
                        _bloc.add(ChangeAccountBankEvent(value));
                      },
                    ),
                    //
                    const SizedBox(height: 30),
                    TextFieldCustom(
                      controller: nameController,
                      isObscureText: false,
                      maxLines: 1,
                      enable: false,
                      focusNode: focusName,
                      fillColor: AppColor.GREY_EBEBEB,
                      textFieldType: TextfieldType.LABEL,
                      title: 'Chủ tài khoản',
                      hintText: 'Nhập tên tài khoản',
                      inputType: TextInputType.text,
                      keyboardAction: TextInputAction.next,
                      onChange: (value) {
                        _bloc.add(ChangeNameEvent(value));
                      },
                    ),
                  ],
                ),
              ),
              bottomSheet: const MButtonWidget(title: 'Lưu tài khoản'),
            );
          },
        ),
      ),
    );
  }

  void _navigateBack(BuildContext context) {}

  void _hideKeyboardBack(BuildContext context, {bool isFirst = false}) {
    double bottom = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottom > 0.0) {
      FocusManager.instance.primaryFocus?.unfocus();
      Future.delayed(const Duration(milliseconds: 250), () {
        if (isFirst) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          _navigateBack(context);
        }
      });
    } else {
      if (isFirst) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        _navigateBack(context);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
