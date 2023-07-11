import 'package:flutter/material.dart';
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
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class InputAuthInformationView extends StatefulWidget {
  final TextEditingController bankAccountController;
  final TextEditingController nameController;
  final TextEditingController nationalController;
  final TextEditingController phoneAuthenController;

  final Function(int)? callBack;

  const InputAuthInformationView({
    super.key,
    required this.bankAccountController,
    required this.nameController,
    required this.phoneAuthenController,
    required this.nationalController,
    this.callBack,
  });

  @override
  State<InputAuthInformationView> createState() =>
      _InputAuthInformationViewState();
}

class _InputAuthInformationViewState extends State<InputAuthInformationView> {
  late BankCardBloc bankCardBloc;

  void initialServices(BuildContext context) {
    Provider.of<AddBankProvider>(context, listen: false)
        .updateAgreeWithPolicy(false);
    if (widget.bankAccountController.text.isNotEmpty) {
      Provider.of<AddBankProvider>(context, listen: false)
          .updateValidBankAccount(widget.bankAccountController.text);
    }

    if (widget.nameController.text.isNotEmpty) {
      Provider.of<AddBankProvider>(context, listen: false)
          .updateValidUserBankName(true);
    }
  }

  @override
  void initState() {
    super.initState();
    bankCardBloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialServices(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BlocListener<BankCardBloc, BankCardState>(
      listener: (context, state) {
        if (state is BankCardLoadingState) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state is BankCardCheckNotExistedState) {
          if (Provider.of<AddBankProvider>(context, listen: false)
              .registerAuthentication) {
            Navigator.pop(context);
            FocusManager.instance.primaryFocus?.unfocus();
            widget.callBack!(4);
          } else {
            String bankTypeId =
                Provider.of<AddBankProvider>(context, listen: false)
                    .bankTypeDTO
                    .id;
            String userId = UserInformationHelper.instance.getUserId();
            String formattedName = StringUtils.instance.removeDiacritic(
                StringUtils.instance
                    .capitalFirstCharacter(widget.nameController.text));
            BankCardInsertUnauthenticatedDTO dto =
                BankCardInsertUnauthenticatedDTO(
              bankTypeId: bankTypeId,
              userId: userId,
              userBankName: formattedName,
              bankAccount: widget.bankAccountController.text,
            );

            bankCardBloc.add(BankCardEventInsertUnauthenticated(dto: dto));
          }
        }
        if (state is BankCardCheckFailedState) {
          Navigator.pop(context);
          DialogWidget.instance
              .openMsgDialog(title: 'Lỗi', msg: 'Vui lòng thử lại sau');
        }
        if (state is BankCardCheckExistedState) {
          Navigator.pop(context);
          DialogWidget.instance
              .openMsgDialog(title: 'Không thể thêm TK', msg: state.msg);
        }
        if (state is BankCardInsertUnauthenticatedSuccessState) {
          BankTypeDTO bankTypeDTO =
              Provider.of<AddBankProvider>(context, listen: false).bankTypeDTO;
          Navigator.pop(context);
          BankAccountDTO dto = BankAccountDTO(
            imgId: bankTypeDTO.imageId,
            bankCode: bankTypeDTO.bankCode,
            bankName: bankTypeDTO.bankName,
            bankAccount: widget.bankAccountController.text,
            userBankName: widget.nameController.text,
            id: '',
            type: Provider.of<AddBankProvider>(context, listen: false).type,
            branchId: '',
            branchName: '',
            businessId: '',
            businessName: '',
            isAuthenticated: false,
          );
          widget.phoneAuthenController.clear();
          widget.nameController.clear();
          widget.nationalController.clear();
          widget.bankAccountController.clear();
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
          Navigator.pop(context);
          DialogWidget.instance
              .openMsgDialog(title: 'Không thể thêm TK', msg: state.msg);
        }
      },
      child: GestureDetector(
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
                    padding: EdgeInsets.only(left: 20, top: 30, bottom: 10),
                    child: Text(
                      'Thông tin xác thực',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                              title: 'SĐT \u002A',
                              hintText: 'Số điện thoại xác thực OTP',
                              autoFocus: false,
                              fontSize: 15,
                              controller: widget.phoneAuthenController,
                              inputType: TextInputType.number,
                              keyboardAction: TextInputAction.done,
                              onChange: (text) {
                                provider.updateValidPhoneAuthenticated(
                                  (widget.phoneAuthenController.text
                                          .isNotEmpty &&
                                      StringUtils.instance.isNumeric(
                                          widget.phoneAuthenController.text)),
                                );
                              },
                            ),
                            DividerWidget(width: width),
                            TextFieldWidget(
                              textfieldType: TextfieldType.LABEL,
                              titleWidth: 100,
                              width: width,
                              isObscureText: false,
                              title: 'CCCD/CMT \u002A',
                              hintText: 'CCCD hoặc GPKD',
                              autoFocus: false,
                              fontSize: 15,
                              controller: widget.nationalController,
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.done,
                              onChange: (text) {
                                provider.updateValidNationalId(
                                    widget.nationalController.text.isNotEmpty);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 4)),
                  Consumer<AddBankProvider>(
                    builder: (context, provider, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (provider.registerAuthentication) ...[
                              const Padding(padding: EdgeInsets.only(top: 10)),
                              Visibility(
                                visible: provider.errorCMT != null,
                                child: Text(
                                  provider.errorCMT ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColor.RED_TEXT,
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 4)),
                              Visibility(
                                visible: provider.errorSDT != null,
                                child: Text(
                                  provider.errorSDT ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColor.RED_TEXT,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10, top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          Text(
                            'Lưu ý:',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '- Đối với loại tài khoản ngân hàng doanh nghiệp, “CCCD/CMT” tương ứng với Mã số Giấy phép kinh doanh (GPKD).',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColor.GREY_TEXT,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '- Số điện thoại phải trùng khớp với thông tin đăng ký tài khoản ngân hàng.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColor.GREY_TEXT,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '- CCCD/CMT và GPKD phải trùng khớp với thông tin đăng ký tài khoản ngân hàng.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColor.GREY_TEXT,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(
              width: width - 20,
              child: Consumer<AddBankProvider>(
                builder: (context, provider, child) {
                  return Row(
                    children: [
                      ButtonWidget(
                        width: width / 2 - 15,
                        text: 'Bỏ qua',
                        textColor: AppColor.GREEN,
                        bgColor: AppColor.WHITE,
                        function: () {
                          provider.updateRegisterAuthentication(false);
                          if (provider.isValidFormUnauthentication()) {
                            String bankTypeId = Provider.of<AddBankProvider>(
                                    context,
                                    listen: false)
                                .bankTypeDTO
                                .id;
                            bankCardBloc.add(BankCardCheckExistedEvent(
                                bankAccount: widget.bankAccountController.text,
                                bankTypeId: bankTypeId));
                          } else {
                            DialogWidget.instance.openMsgDialog(
                                title: 'Thông tin không hợp lệ',
                                msg:
                                    'Thông tin không hợp lệ. Vui lòng nhập đúng các dữ liệu.');
                          }
                        },
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      ButtonWidget(
                        width: width / 2 - 15,
                        text: 'Xác thực',
                        textColor: AppColor.WHITE,
                        bgColor: AppColor.GREEN,
                        function: () {
                          if (provider.isValidForm()) {
                            String bankTypeId = Provider.of<AddBankProvider>(
                                    context,
                                    listen: false)
                                .bankTypeDTO
                                .id;
                            bankCardBloc.add(BankCardCheckExistedEvent(
                                bankAccount: widget.bankAccountController.text,
                                bankTypeId: bankTypeId));
                          } else {
                            Provider.of<AddBankProvider>(context, listen: false)
                                .updateValidNationalId(false);
                            Provider.of<AddBankProvider>(context, listen: false)
                                .updateValidPhoneAuthenticated(false);
                            DialogWidget.instance.openMsgDialog(
                                title: 'Thông tin không hợp lệ',
                                msg:
                                    'Vui lòng nhập đầy đủ thông tin xác thực.');
                          }
                        },
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
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
            color: AppColor.WHITE,
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
}
