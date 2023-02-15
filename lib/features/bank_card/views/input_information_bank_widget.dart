import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
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
import 'package:vierqr/models/bank_card_generated_dto.dart';
import 'package:vierqr/models/bank_card_insert_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class InputInformationBankWidget extends StatelessWidget {
  final TextEditingController bankAccountController;
  final TextEditingController nameController;

  static late BankCardBloc _bankCardBloc;

  const InputInformationBankWidget({
    super.key,
    required this.bankAccountController,
    required this.nameController,
  });

  void _initialServices(BuildContext context) {
    _bankCardBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    _initialServices(context);
    return BlocListener<BankCardBloc, BankCardState>(
      listener: (context, state) {
        if (state is BankCardInsertSuccessfulState) {
          BankTypeDTO bankTypeDTO =
              Provider.of<AddBankProvider>(context, listen: false).bankTypeDTO;
          BankAccountDTO dto = BankAccountDTO(
            imgId: bankTypeDTO.imageId,
            bankCode: bankTypeDTO.bankCode,
            bankName: bankTypeDTO.bankName,
            bankAccount: bankAccountController.text,
            userBankName: nameController.text,
            role: Stringify.ROLE_CARD_MEMBER_ADMIN,
            bankStatus: 0,
            id: '',
            userId: '',
          );
          Navigator.of(context).pushReplacementNamed(
            Routes.BANK_CARD_GENERATED_VIEW,
            arguments: {'bankAccountDTO': dto},
          );
        }
        if (state is BankCardInsertFailedState) {
          DialogWidget.instance.openMsgDialog(
              title: 'Không thể thêm tài khoản', msg: state.message);
        }
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
                  padding: EdgeInsets.only(left: 20, top: 30, bottom: 10),
                  child: Text(
                    'Thông tin tài khoản',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                            titleWidth: 130,
                            width: width,
                            isObscureText: false,
                            title: 'Số thẻ/tài khoản*',
                            hintText: '',
                            fontSize: 13,
                            controller: bankAccountController,
                            inputType: TextInputType.number,
                            keyboardAction: TextInputAction.next,
                            onChange: (text) {
                              provider.updateValidBankAccount(
                                (bankAccountController.text.isEmpty ||
                                    !StringUtils.instance
                                        .isNumeric(bankAccountController.text)),
                              );
                            },
                          ),
                          DividerWidget(width: width),
                          TextFieldWidget(
                            textfieldType: TextfieldType.LABEL,
                            titleWidth: 130,
                            width: width,
                            isObscureText: false,
                            title: 'Chủ thẻ/tài khoản*',
                            hintText: '',
                            fontSize: 13,
                            controller: nameController,
                            inputType: TextInputType.text,
                            keyboardAction: TextInputAction.done,
                            onChange: (text) {
                              provider.updateValidUserBankName(
                                  nameController.text.isEmpty);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Consumer<AddBankProvider>(builder: (context, provider, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: provider.validBankAccount,
                          child: const Text(
                            'Số thẻ/tài khoản không hợp lệ.',
                            style: TextStyle(
                              fontSize: 12,
                              color: DefaultTheme.RED_TEXT,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Visibility(
                          visible: provider.validUserBankName,
                          child: const Text(
                            'Chủ thẻ/tài khoản không hợp lệ',
                            style: TextStyle(
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
            child: ButtonWidget(
              width: width,
              text: 'Thêm',
              textColor: DefaultTheme.WHITE,
              bgColor: DefaultTheme.GREEN,
              function: () {
                if (nameController.text.isNotEmpty &&
                    bankAccountController.text.isNotEmpty) {
                  if (!Provider.of<AddBankProvider>(context, listen: false)
                          .validBankAccount &&
                      !Provider.of<AddBankProvider>(context, listen: false)
                          .validUserBankName) {
                    BankTypeDTO bankTypeDTO =
                        Provider.of<AddBankProvider>(context, listen: false)
                            .bankTypeDTO;
                    String userId = UserInformationHelper.instance.getUserId();
                    BankCardInsertDTO dto = BankCardInsertDTO(
                      bankTypeId: bankTypeDTO.id,
                      userId: userId,
                      userBankName: nameController.text,
                      bankAccount: bankAccountController.text,
                      role: Stringify.ROLE_CARD_MEMBER_ADMIN,
                    );
                    _bankCardBloc.add(BankCardEventInsert(dto: dto));
                  }
                } else {
                  DialogWidget.instance.openMsgDialog(
                      title: 'Thông tin không hợp lệ',
                      msg: 'Vui lòng nhập thông tin.');
                }
              },
            ),
          ),
        ],
      ),
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
            child: _buildLogo(context, 70, dto.imageId),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context, double size, String imageId) {
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
                image: ImageUtils.instance.getImageNetWork(imageId)),
          ),
        ),
      ),
    );
  }
}
