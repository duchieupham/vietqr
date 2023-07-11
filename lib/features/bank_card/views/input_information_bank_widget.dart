import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
import 'package:vierqr/features/bank_card/states/bank_card_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_card_insert_unauthenticated.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class InputInformationBankWidget extends StatefulWidget {
  final Function(int)? callBack;
  final TextEditingController bankAccountController;

  final TextEditingController nameController;

  const InputInformationBankWidget({
    super.key,
    required this.callBack,
    required this.bankAccountController,
    required this.nameController,
  });

  @override
  State<InputInformationBankWidget> createState() =>
      _InputInformationBankWidgetState(bankAccountController, nameController);
}

class _InputInformationBankWidgetState
    extends State<InputInformationBankWidget> {
  final TextEditingController bankAccountController;

  final TextEditingController nameController;

  late BankCardBloc bankCardBloc;

  final _focusNode = FocusNode();

  final _focusNodeName = FocusNode();

  _InputInformationBankWidgetState(
      this.bankAccountController, this.nameController);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialServices(context);
    });
  }

  void initialServices(BuildContext context) {
    bankCardBloc = BlocProvider.of(context);
    Provider.of<AddBankProvider>(context, listen: false).resetValidate();

    if (bankAccountController.text.isNotEmpty) {
      Provider.of<AddBankProvider>(context, listen: false)
          .updateValidBankAccount(bankAccountController.text);
      Provider.of<AddBankProvider>(context, listen: false)
          .updateValidUserBankName(true);

      if (nameController.text.isEmpty) {
        _onSearch();
      }
    } else {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return BlocConsumer<BankCardBloc, BankCardState>(
      listener: (context, state) async {
        if (state is BankCardSearchingNameState) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state is BankCardSearchNameSuccessState) {
          Provider.of<AddBankProvider>(context, listen: false)
              .updateValidUserBankName(true);
          nameController.clear();
          nameController.value =
              nameController.value.copyWith(text: state.dto.accountName);
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          Navigator.pop(context);
        }
        if (state is BankCardLoadingState) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state is BankCardSearchNameFailedState) {
          nameController.clear();
          Provider.of<AddBankProvider>(context, listen: false)
              .setEnableNameTK(true);
          Navigator.pop(context);
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          _focusNode.unfocus();
          await DialogWidget.instance.openMsgDialog(
            title: 'Thông báo',
            msg: state.msg,
          );

          if (!mounted) return;

          _focusNodeName.requestFocus();
        }
        if (state is BankCardCheckNotExistedState) {
          if (!mounted) return;
          if (Provider.of<AddBankProvider>(context, listen: false)
              .registerAuthentication) {
            Navigator.pop(context);
            widget.callBack!(3);
          } else {
            String bankTypeId =
                Provider.of<AddBankProvider>(context, listen: false)
                    .bankTypeDTO
                    .id;
            String userId = UserInformationHelper.instance.getUserId();
            String formattedName = StringUtils.instance.removeDiacritic(
                StringUtils.instance
                    .capitalFirstCharacter(nameController.text));
            BankCardInsertUnauthenticatedDTO dto =
                BankCardInsertUnauthenticatedDTO(
              bankTypeId: bankTypeId,
              userId: userId,
              userBankName: formattedName,
              bankAccount: bankAccountController.text,
            );
            bankCardBloc.add(BankCardEventInsertUnauthenticated(dto: dto));
          }
        }
        if (state is BankCardCheckFailedState) {
          if (!mounted) return;
          Navigator.pop(context);
          DialogWidget.instance
              .openMsgDialog(title: 'Lỗi', msg: 'Vui lòng thử lại sau');
        }
        if (state is BankCardCheckExistedState) {
          if (!mounted) return;
          Navigator.pop(context);
          DialogWidget.instance
              .openMsgDialog(title: 'Không thể thêm TK', msg: state.msg);
        }
        if (state is BankCardInsertUnauthenticatedSuccessState) {
          if (!mounted) return;
          BankTypeDTO bankTypeDTO =
              Provider.of<AddBankProvider>(context, listen: false).bankTypeDTO;
          Navigator.pop(context);
          BankAccountDTO dto = BankAccountDTO(
            imgId: bankTypeDTO.imageId,
            bankCode: bankTypeDTO.bankCode,
            bankName: bankTypeDTO.bankName,
            bankAccount: bankAccountController.text,
            userBankName: nameController.text,
            id: '',
            type: Provider.of<AddBankProvider>(context, listen: false).type,
            branchId: '',
            branchName: '',
            businessId: '',
            businessName: '',
            isAuthenticated: false,
          );
          nameController.clear();
          bankAccountController.clear();
          Navigator.of(context).pushReplacementNamed(
            Routes.BANK_CARD_GENERATED_VIEW,
            arguments: {
              'bankAccountDTO': dto,
              'bankId': state.bankId,
              'qr': state.qr,
            },
          );
        }
        if (state is BankCardInsertUnauthenticatedFailedState) {
          if (!mounted) return;
          Navigator.pop(context);
          DialogWidget.instance
              .openMsgDialog(title: 'Không thể thêm TK', msg: state.msg);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Consumer<AddBankProvider>(
                      builder: (context, provider, child) {
                        return _buildSelectedBankType(
                            context, width, provider.bankTypeDTO);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 30, bottom: 5),
                      child: Text(
                        'Thông tin tài khoản',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Text(
                        'Lưu ý: Đối với loại tài khoản ngân hàng doanh nghiệp, "Chủ TK" ứng với tên của doanh nghiệp',
                        style: TextStyle(
                          fontSize: 13,
                          color: DefaultTheme.GREY_TEXT,
                        ),
                      ),
                    ),
                    Consumer<AddBankProvider>(
                      builder: (context, provider, child) {
                        return BoxLayout(
                          width: width,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                            children: [
                              TextFieldWidget(
                                textfieldType: TextfieldType.LABEL,
                                titleWidth: 100,
                                width: width,
                                isObscureText: false,
                                title: 'Số TK \u002A',
                                hintText: 'Nhập số tài khoản',
                                fontSize: 15,
                                controller: bankAccountController,
                                inputType: TextInputType.number,
                                keyboardAction: TextInputAction.done,
                                focusNode: _focusNode,
                                onSubmitted: (txt) {
                                  _onSubmitted(txt, context);
                                },
                                onTapOutside: (event) {
                                  if (_focusNode.hasFocus) {
                                    _focusNode.unfocus();
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    _onSearch();
                                  }
                                },
                                onChange: (text) {
                                  provider.updateValidBankAccount(
                                      bankAccountController.text);
                                },
                              ),
                              DividerWidget(width: width),
                              TextFieldWidget(
                                textfieldType: TextfieldType.LABEL,
                                titleWidth: 100,
                                width: width,
                                isObscureText: false,
                                title: 'Chủ TK \u002A',
                                hintText: 'Chủ TK/Tên doanh nghiệp',
                                fontSize: 15,
                                focusNode: _focusNodeName,
                                enable: provider.enableNameTK,
                                controller: nameController,
                                inputType: TextInputType.text,
                                keyboardAction: TextInputAction.done,
                                onChange: (text) {
                                  provider.updateValidUserBankName(StringUtils
                                      .instance
                                      .isValidFullName(nameController.text));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Consumer<AddBankProvider>(
                        builder: (context, provider, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: provider.errorTk != null,
                              child: Text(
                                provider.errorTk ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: DefaultTheme.RED_TEXT,
                                ),
                              ),
                            ),
                            if (provider.validBankAccount &&
                                provider.validUserBankName)
                              const Padding(padding: EdgeInsets.only(top: 10)),
                            Visibility(
                              visible: provider.errorNameTK != null,
                              child: Text(
                                provider.errorNameTK ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: DefaultTheme.RED_TEXT,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Consumer<AddBankProvider>(
                  builder: (context, provider, child) {
                    return (provider.registerAuthentication)
                        ? ButtonWidget(
                            width: width,
                            text: 'Tiếp theo',
                            textColor: DefaultTheme.WHITE,
                            bgColor: DefaultTheme.GREEN,
                            function: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (provider.isValidFormUnauthentication()) {
                                String bankTypeId =
                                    Provider.of<AddBankProvider>(context,
                                            listen: false)
                                        .bankTypeDTO
                                        .id;
                                bankCardBloc.add(BankCardCheckExistedEvent(
                                    bankAccount: bankAccountController.text,
                                    bankTypeId: bankTypeId));
                              } else {
                                await DialogWidget.instance.openMsgDialog(
                                    title: 'Thông tin không hợp lệ',
                                    msg:
                                        'Thông tin không hợp lệ. Vui lòng nhập đúng các dữ liệu.');
                              }
                            },
                          )
                        : ButtonWidget(
                            width: width,
                            text: 'Thêm',
                            textColor: DefaultTheme.WHITE,
                            bgColor: DefaultTheme.GREEN,
                            function: () {
                              if (provider.isValidFormUnauthentication()) {
                                String bankTypeId =
                                    Provider.of<AddBankProvider>(context,
                                            listen: false)
                                        .bankTypeDTO
                                        .id;
                                bankCardBloc.add(BankCardCheckExistedEvent(
                                    bankAccount: bankAccountController.text,
                                    bankTypeId: bankTypeId));
                              } else {
                                DialogWidget.instance.openMsgDialog(
                                    title: 'Thông tin không hợp lệ',
                                    msg:
                                        'Thông tin không hợp lệ. Vui lòng nhập đúng các dữ liệu.');
                              }
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedBankType(
      BuildContext context, double width, BankTypeDTO dto) {
    return Container(
      width: width,
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  dto.bankCode,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 2)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Text(
                    dto.bankName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: _buildLogo(context, 70, dto.imageId, BoxFit.contain),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(
      BuildContext context, double size, String imageId, BoxFit fit) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: UnconstrainedBox(
        child: Container(
          width: size - 10,
          height: size - 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size - 10),
            color: DefaultTheme.WHITE,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(1, 2),
              ),
            ],
            image: DecorationImage(
                fit: fit, image: ImageUtils.instance.getImageNetWork(imageId)),
          ),
        ),
      ),
    );
  }

  void _onSubmitted(Object value, BuildContext context) {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      if (bankAccountController.text.isNotEmpty &&
          bankAccountController.text.length > 5) {
        String transferType = '';
        String bankCode = Provider.of<AddBankProvider>(context, listen: false)
            .bankTypeDTO
            .caiValue;
        if (Provider.of<AddBankProvider>(context, listen: false)
                .bankTypeDTO
                .bankCode ==
            'MB') {
          transferType = 'INHOUSE';
        } else {
          transferType = 'NAPAS';
        }
        BankNameSearchDTO bankNameSearchDTO = BankNameSearchDTO(
          accountNumber: bankAccountController.text,
          accountType: 'ACCOUNT',
          transferType: transferType,
          bankCode: bankCode,
        );
        bankCardBloc.add(BankCardEventSearchName(dto: bankNameSearchDTO));
      }
    }
  }

  void _onSearch() {
    if (bankAccountController.text.isNotEmpty &&
        bankAccountController.text.length > 5) {
      String transferType = '';
      String bankCode = Provider.of<AddBankProvider>(context, listen: false)
          .bankTypeDTO
          .caiValue;
      if (Provider.of<AddBankProvider>(context, listen: false)
              .bankTypeDTO
              .bankCode ==
          'MB') {
        transferType = 'INHOUSE';
      } else {
        transferType = 'NAPAS';
      }
      BankNameSearchDTO bankNameSearchDTO = BankNameSearchDTO(
        accountNumber: bankAccountController.text,
        accountType: 'ACCOUNT',
        transferType: transferType,
        bankCode: bankCode,
      );
      bankCardBloc.add(BankCardEventSearchName(dto: bankNameSearchDTO));
    }
  }

  @override
  void dispose() {
    // bankAccountController.clear();
    // nameController.clear();
    // nationalController.clear();
    // phoneAuthController.clear();
    super.dispose();
  }
}
