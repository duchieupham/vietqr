import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/add_bank/blocs/add_bank_bloc.dart';
import 'package:vierqr/features/add_bank/blocs/add_bank_provider.dart';
import 'package:vierqr/features/add_bank/events/add_bank_event.dart';
import 'package:vierqr/features/add_bank/states/add_bank_state.dart';
import 'package:vierqr/features/add_bank/views/account_link_view.dart';
import 'package:vierqr/features/add_bank/views/confirm_otp_view.dart';
import 'package:vierqr/features/add_bank/views/policy_view.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/bank_card_insert_dto.dart';
import 'package:vierqr/models/bank_card_insert_unauthenticated.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/confirm_otp_bank_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/register_authentication_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

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
  final phoneController = TextEditingController();
  final cmtController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(context);
      focusAccount.addListener(() {
        if (!focusAccount.hasFocus) {
          _onSearch();
        }
      });
    });
  }

  void initData(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      _bloc.add(const LoadDataBankEvent(isLoading: false));
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      int step = args['step'] ?? 0;
      String bankAccount = args['bankAccount'] ?? '';
      String userName = args['name'] ?? '';
      BankTypeDTO? bankTypeDTO = args['bankDTO'];
      String? bankId = args['bankId'];

      if (userName.isNotEmpty) {
        Provider.of<AddBankProvider>(context, listen: false).updateEdit(false);
      }

      if (bankId != null) {
        Provider.of<AddBankProvider>(context, listen: false)
            .updateBankId(bankId);
      }

      if (bankAccount.isNotEmpty) {
        bankAccountController.value =
            bankAccountController.value.copyWith(text: bankAccount);
      }
      if (userName.isNotEmpty) {
        nameController.value = nameController.value.copyWith(text: userName);
      }

      if (step != 0) {
        Provider.of<AddBankProvider>(context, listen: false).updateStep(step);
      }

      if (bankTypeDTO != null) {
        Provider.of<AddBankProvider>(context, listen: false)
            .updateSelectBankType(bankTypeDTO, update: true);
      }
    } else {
      _bloc.add(const LoadDataBankEvent());
    }
  }

  void _onSearch() {
    bool isEdit = Provider.of<AddBankProvider>(context, listen: false).isEdit;
    if (bankAccountController.text.isNotEmpty &&
        bankAccountController.text.length > 5 &&
        isEdit) {
      String transferType = '';
      String bankCode = '';
      BankTypeDTO? bankTypeDTO =
          Provider.of<AddBankProvider>(context, listen: false).bankTypeDTO;
      if (bankTypeDTO != null) {
        bankCode = bankTypeDTO.caiValue;
      }

      if (bankCode == 'MB') {
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
      _bloc.add(BankCardEventSearchName(dto: bankNameSearchDTO));
    }
  }

  @override
  Widget build(BuildContext context) {
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
          listener: (context, state) async {
            if (state.status == BlocStatus.LOADING) {
              DialogWidget.instance.openLoadingDialog();
            }

            if (state.status == BlocStatus.UNLOADING) {
              Navigator.pop(context);
            }

            if (state.request == AddBankType.SEARCH_BANK) {
              nameController.clear();
              nameController.value = nameController.value
                  .copyWith(text: state.informationDTO?.accountName ?? '');
              if (Provider.of<AddBankProvider>(context, listen: false)
                      .bankTypeDTO !=
                  null) {
                Provider.of<AddBankProvider>(context, listen: false)
                    .updateValidUserBankName(nameController.text);
              }
            }

            if (state.request == AddBankType.EXIST_BANK) {
              if (Provider.of<AddBankProvider>(context, listen: false)
                  .isLinkBank) {
                Provider.of<AddBankProvider>(context, listen: false)
                    .updateStep(1);
              } else {
                String bankTypeId =
                    Provider.of<AddBankProvider>(context, listen: false)
                        .bankTypeDTO!
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
                _bloc.add(BankCardEventInsertUnauthenticated(dto: dto));
              }
            }

            if (state.request == AddBankType.INSERT_BANK) {
              if (!mounted) return;
              Navigator.of(context).pop(true);
            }

            if (state.request == AddBankType.ERROR) {
              await DialogWidget.instance.openMsgDialog(
                  title: 'Không thể thêm TK', msg: state.msg ?? '');
              if (!mounted) return;
              Provider.of<AddBankProvider>(context, listen: false)
                  .updateEnableName(true);
            }

            if (state.request == AddBankType.ERROR_SYSTEM) {
              await DialogWidget.instance.openMsgDialog(
                  title: 'Không thể liên kết TK', msg: state.msg ?? '');
              if (!mounted) return;
              Provider.of<AddBankProvider>(context, listen: false)
                  .updateEnableName(true);
            }

            if (state.request == AddBankType.REQUEST_BANK) {
              if (!mounted) return;
              Navigator.of(context).pop();
              Provider.of<AddBankProvider>(context, listen: false)
                  .updateStep(2);
            }

            if (state.request == AddBankType.OTP_BANK) {
              if (!mounted) return;
              String bankId =
                  Provider.of<AddBankProvider>(context, listen: false).bankId;
              if (bankId.trim().isNotEmpty) {
                final dto = RegisterAuthenticationDTO(
                  bankId: bankId,
                  nationalId: cmtController.text,
                  phoneAuthenticated: phoneController.text,
                  bankAccountName: nameController.text,
                  bankAccount: bankAccountController.text,
                );

                _bloc.add(BankCardEventRegisterLinkBank(dto: dto));
              } else {
                String bankTypeId =
                    Provider.of<AddBankProvider>(context, listen: false)
                        .bankTypeDTO!
                        .id;
                String userId = UserInformationHelper.instance.getUserId();
                String formattedName = StringUtils.instance.removeDiacritic(
                    StringUtils.instance
                        .capitalFirstCharacter(nameController.text));
                BankCardInsertDTO dto = BankCardInsertDTO(
                  bankTypeId: bankTypeId,
                  userId: userId,
                  userBankName: formattedName,
                  bankAccount: bankAccountController.text,
                  type:
                      Provider.of<AddBankProvider>(context, listen: false).type,
                  branchId: '',
                  nationalId: cmtController.text,
                  phoneAuthenticated: phoneController.text,
                );
                _bloc.add(BankCardEventInsert(dto: dto));
              }
            }

            if (state.request == AddBankType.SCAN_QR) {
              if (state.barCode != '-1') {
                cmtController.clear();
                cmtController.value =
                    cmtController.value.copyWith(text: state.barCode);
                if (!mounted) return;
                Provider.of<AddBankProvider>(context, listen: false)
                    .onChangeCMT(cmtController.text,
                        phone: phoneController.text);
              }
            }

            if (state.request == AddBankType.SCAN_NOT_FOUND) {
              DialogWidget.instance.openMsgDialog(
                title: 'Không thể xác nhận mã QR',
                msg:
                    'Không tìm thấy thông tin trong đoạn mã QR. Vui lòng kiểm tra lại thông tin.',
                function: () {
                  Navigator.pop(context);
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              );
            }

            if (state.status != BlocStatus.NONE ||
                state.request != AddBankType.NONE) {
              _bloc.add(UpdateAddBankEvent());
            }
          },
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraint) {
                return Scaffold(
                  appBar: MAppBar(
                    title: 'Thêm tài khoản',
                    actions: [
                      GestureDetector(
                        onTap: () async {
                          final data = await Navigator.pushNamed(
                              context, Routes.SCAN_QR_VIEW,
                              arguments: {'isScanAll': false});
                          if (data is Map<String, dynamic>) {
                            if (!mounted) return;
                            final type = data['type'];
                            final value = data['data'];
                            final bankTypeDTO = data['bankTypeDTO'];
                            if (type == TypeContact.Bank) {
                              if (value != null && value is QRGeneratedDTO) {
                                bankAccountController.value =
                                    bankAccountController.value
                                        .copyWith(text: value.bankAccount);
                                nameController.value = nameController.value
                                    .copyWith(text: value.userBankName);
                                if (nameController.text.isNotEmpty &&
                                    !value.isNaviAddBank) {
                                  Provider.of<AddBankProvider>(context,
                                          listen: false)
                                      .updateEdit(false);
                                }
                                if (bankTypeDTO != null &&
                                    bankTypeDTO is BankTypeDTO) {
                                  Provider.of<AddBankProvider>(context,
                                          listen: false)
                                      .updateSelectBankType(bankTypeDTO,
                                          update: bankAccountController
                                                  .text.isNotEmpty &&
                                              nameController.text.isNotEmpty);
                                  Provider.of<AddBankProvider>(context,
                                          listen: false)
                                      .updateValidUserBankName(
                                          nameController.text);
                                }
                              }
                            } else {
                              DialogWidget.instance.openMsgDialog(
                                title: 'Không thể xác nhận mã QR',
                                msg:
                                    'Không tìm thấy thông tin trong đoạn mã QR. Vui lòng kiểm tra lại thông tin.',
                                function: () {
                                  Navigator.pop(context);
                                },
                              );
                            }
                          }
                          // _bloc.add(ContactEventGetList());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/ic-tb-qr.png',
                          ),
                        ),
                      )
                    ],
                  ),
                  body: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            height: constraint.maxHeight,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Consumer<AddBankProvider>(
                                      builder: (context, provider, child) {
                                    return Column(
                                      children: [
                                        if (provider.bankTypeDTO?.status ==
                                            1) ...[
                                          _BuildHeader(select: provider.step),
                                          const SizedBox(height: 20),
                                        ],
                                      ],
                                    );
                                  }),
                                  Consumer<AddBankProvider>(
                                    builder: (ctx, provider, child) {
                                      if (provider.step == 1) {
                                        return AccountLinkView(
                                          bankTypeDTO: provider.bankTypeDTO!,
                                          bankAccount:
                                              bankAccountController.text,
                                          bankUserName: nameController.text,
                                          phone: phoneController,
                                          cmt: cmtController,
                                          onChangePhone: (value) {
                                            provider.onChangePhone(value,
                                                cmt: cmtController.text);
                                          },
                                          onChangeCMT: (value) {
                                            provider.onChangeCMT(value,
                                                phone: phoneController.text);
                                          },
                                          errorPhone: provider.errorSDT,
                                          errorCMT: provider.errorCMT,
                                          onScan: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            startBarcodeScanStream(context);
                                          },
                                          onEdit: () {
                                            phoneController.clear();
                                            cmtController.clear();
                                            provider.updateStep(0);
                                            provider.updateEdit(false);
                                          },
                                        );
                                      } else if (provider.step == 2) {
                                        return ConfirmOTPView(
                                          phone: phoneController.text,
                                          otpController: otpController,
                                          onChangeOTP: (value) {},
                                          onResend: () {
                                            String formattedName = StringUtils
                                                .instance
                                                .removeDiacritic(StringUtils
                                                    .instance
                                                    .capitalFirstCharacter(
                                                        nameController.text));
                                            BankCardRequestOTP dto =
                                                BankCardRequestOTP(
                                              nationalId: cmtController.text,
                                              accountNumber:
                                                  bankAccountController.text,
                                              accountName: formattedName,
                                              applicationType: 'MOBILE',
                                              phoneNumber: phoneController.text,
                                            );
                                            _bloc.add(BankCardEventRequestOTP(
                                                dto: dto));
                                          },
                                        );
                                      }

                                      return SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const Text(
                                              'Ngân hàng',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 10),
                                            GestureDetector(
                                              onTap: () async {
                                                final data = await DialogWidget
                                                    .instance
                                                    .showModelBottomSheet(
                                                  context: context,
                                                  padding: EdgeInsets.zero,
                                                  widget: ModelBottomSheetView(
                                                    tvTitle: 'Chọn ngân hàng',
                                                    ctx: context,
                                                    list: state.listBanks ?? [],
                                                    isSearch: true,
                                                    data: provider.bankTypeDTO,
                                                  ),
                                                  height: height * 0.6,
                                                );
                                                if (data is int) {
                                                  bankAccountController.clear();
                                                  nameController.clear();
                                                  provider.resetValidate();
                                                  provider.updateSelectBankType(
                                                      state.listBanks![data]);
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: AppColor.WHITE,
                                                ),
                                                child: Row(
                                                  children: [
                                                    if (provider.bankTypeDTO !=
                                                        null)
                                                      Container(
                                                        width: 60,
                                                        height: 30,
                                                        margin: const EdgeInsets
                                                            .only(left: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: ImageUtils
                                                                  .instance
                                                                  .getImageNetWork(provider
                                                                          .bankTypeDTO
                                                                          ?.imageId ??
                                                                      '')),
                                                        ),
                                                      )
                                                    else
                                                      const SizedBox(width: 16),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        provider.bankTypeDTO
                                                                ?.name ??
                                                            'Chọn ngân hàng',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: provider
                                                                        .bankTypeDTO !=
                                                                    null
                                                                ? AppColor.BLACK
                                                                : AppColor
                                                                    .GREY_TEXT),
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: AppColor.GREY_TEXT,
                                                    ),
                                                    const SizedBox(width: 20),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            TextFieldCustom(
                                              isObscureText: false,
                                              maxLines: 1,
                                              enable:
                                                  provider.bankTypeDTO != null,
                                              fillColor:
                                                  provider.bankTypeDTO != null
                                                      ? null
                                                      : AppColor.GREY_EBEBEB,
                                              controller: bankAccountController,
                                              textFieldType:
                                                  TextfieldType.LABEL,
                                              title: 'Số tài khoản',
                                              focusNode: focusAccount,
                                              hintText: 'Nhập số tài khoản',
                                              inputType: TextInputType.text,
                                              keyboardAction:
                                                  TextInputAction.next,
                                              onChange: provider
                                                  .updateValidBankAccount,
                                            ),
                                            Visibility(
                                              visible: provider.errorTk != null,
                                              child: Container(
                                                width: double.infinity,
                                                margin: const EdgeInsets.only(
                                                    top: 8),
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  provider.errorTk ?? '',
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Styles.errorStyle(
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
//
                                            const SizedBox(height: 30),
                                            TextFieldCustom(
                                              key: provider.keyAccount,
                                              controller: nameController,
                                              isObscureText: false,
                                              maxLines: 1,
                                              enable: provider.isEnableName,
                                              focusNode: focusName,
                                              fillColor: provider.isEnableName
                                                  ? AppColor.WHITE
                                                  : AppColor.GREY_EBEBEB,
                                              textFieldType:
                                                  TextfieldType.LABEL,
                                              title: 'Chủ tài khoản',
                                              hintText: 'Nhập tên tài khoản',
                                              inputType: TextInputType.text,
                                              keyboardAction:
                                                  TextInputAction.next,
                                              inputFormatter: [
                                                UpperCaseTextFormatter(),
                                              ],
                                              onChange: provider
                                                  .updateValidUserBankName,
                                            ),
                                            Visibility(
                                              visible:
                                                  provider.errorNameTK != null,
                                              child: Container(
                                                width: double.infinity,
                                                margin: const EdgeInsets.only(
                                                    top: 8),
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  provider.errorNameTK ?? '',
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Styles.errorStyle(
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            if (provider.bankTypeDTO?.status ==
                                                1) ...[
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              _BuildNoteWidget()
                                            ],
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Consumer<AddBankProvider>(
                          builder: (context, provider, child) {
                            return (provider.bankTypeDTO?.status == 1)
                                ? _buildButton(provider, state.requestId ?? '')
                                : MButtonWidget(
                                    title: 'Lưu tài khoản',
                                    isEnable: provider.isEnableButton,
                                    colorEnableText: provider.isEnableButton
                                        ? AppColor.WHITE
                                        : AppColor.GREY_TEXT,
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      String bankTypeId =
                                          provider.bankTypeDTO!.id;
                                      _bloc.add(BankCardCheckExistedEvent(
                                          bankAccount:
                                              bankAccountController.text,
                                          bankTypeId: bankTypeId));
                                    },
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildButton(AddBankProvider provider, String requestId) {
    final buttonStepFirst = _BuildButton(
      onTapSave: () {
        FocusManager.instance.primaryFocus?.unfocus();
        String bankTypeId = provider.bankTypeDTO!.id;
        _bloc.add(BankCardCheckExistedEvent(
            bankAccount: bankAccountController.text, bankTypeId: bankTypeId));
      },
      onTapLK: () {
        provider.updateLinkBank(true);
        String bankTypeId = provider.bankTypeDTO!.id;
        _bloc.add(BankCardCheckExistedEvent(
            bankAccount: bankAccountController.text, bankTypeId: bankTypeId));
      },
      isEnableBTSave: provider.isEnableButton,
      isEnableBTLK: provider.isValidFormUnAuthentication(),
    );

    final buttonStepSecond = MButtonWidget(
      title: 'Liên kết',
      isEnable: provider.isValidForm(),
      colorEnableText:
          provider.isValidForm() ? AppColor.WHITE : AppColor.GREY_TEXT,
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        await showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation,
              Animation secondaryAnimation) {
            return PolicyView(
              onSelectPolicy: provider.updatePolicy,
              isAgreeWithPolicy: provider.isAgreeWithPolicy,
              onTap: () {
                if (provider.isAgreeWithPolicy) {
                  String formattedName = StringUtils.instance.removeDiacritic(
                      StringUtils.instance
                          .capitalFirstCharacter(nameController.text));
                  BankCardRequestOTP dto = BankCardRequestOTP(
                    nationalId: cmtController.text,
                    accountNumber: bankAccountController.text,
                    accountName: formattedName,
                    applicationType: 'MOBILE',
                    phoneNumber: phoneController.text,
                  );
                  context
                      .read<AddBankBloc>()
                      .add(BankCardEventRequestOTP(dto: dto));
                }
              },
            );
          },
        );
      },
    );

    final buttonStepThree = MButtonWidget(
      title: 'Xác thực',
      isEnable: provider.isValidForm(),
      colorEnableText:
          provider.isValidForm() ? AppColor.WHITE : AppColor.GREY_TEXT,
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        ConfirmOTPBankDTO confirmDTO = ConfirmOTPBankDTO(
          requestId: requestId,
          otpValue: otpController.text,
          applicationType: 'MOBILE',
        );
        _bloc.add(BankCardEventConfirmOTP(dto: confirmDTO));
      },
    );

    return provider.step == 0
        ? buttonStepFirst
        : provider.step == 1
            ? buttonStepSecond
            : buttonStepThree;
  }

  void _navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

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

  Future<void> startBarcodeScanStream(BuildContext context) async {
    String data = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    if (data.isNotEmpty) {
      if (data == TypeQR.NEGATIVE_ONE.value) {
        return;
      } else if (data == TypeQR.NEGATIVE_TWO.value) {
        DialogWidget.instance.openMsgDialog(
          title: 'Không thể xác nhận mã QR',
          msg: 'Ảnh QR không đúng định dạng, vui lòng chọn ảnh khác.',
          function: () {
            Navigator.pop(context);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      } else {
        if (!mounted) return;
        _bloc.add(ScanQrEventGetBankType(code: data));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _BuildHeader extends StatelessWidget {
  final int select;

  const _BuildHeader({this.select = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildItem(1, select),
              Expanded(
                child: Container(
                  height: 2,
                  color: select > 0 ? AppColor.BLUE_TEXT : AppColor.grey979797,
                ),
              ),
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: select >= 1
                            ? AppColor.TRANSPARENT
                            : AppColor.grey979797),
                    color:
                        select >= 1 ? AppColor.BLUE_TEXT : AppColor.GREY_EBEBEB,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  '2',
                  style: TextStyle(
                    color: select >= 1 ? AppColor.WHITE : AppColor.GREY_TEXT,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 2,
                  color: select > 1 ? AppColor.BLUE_TEXT : AppColor.grey979797,
                ),
              ),
              _buildItem(3, select),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 75,
                child: Text(
                  'Tạo tài khoản',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: select >= 0 ? AppColor.BLACK : AppColor.GREY_TEXT),
                ),
              ),
              SizedBox(
                width: 75,
                child: Text(
                  'Nhập thông tin liên kết',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: select >= 1 ? AppColor.BLACK : AppColor.GREY_TEXT),
                ),
              ),
              SizedBox(
                width: 75,
                child: Text(
                  'Xác thực OTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: select >= 2 ? AppColor.BLACK : AppColor.GREY_TEXT),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildItem(int title, int select) {
    return SizedBox(
      width: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title == 3)
            Expanded(
              child: Container(
                height: 2,
                color: select >= 2 ? AppColor.BLUE_TEXT : AppColor.grey979797,
              ),
            )
          else
            const Expanded(child: SizedBox()),
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: select >= title - 1
                    ? AppColor.BLUE_TEXT
                    : AppColor.GREY_EBEBEB,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: select >= title - 1
                        ? AppColor.TRANSPARENT
                        : AppColor.grey979797)),
            child: Text(
              '$title',
              style: TextStyle(
                color:
                    select >= (title - 1) ? AppColor.WHITE : AppColor.GREY_TEXT,
              ),
            ),
          ),
          if (title == 1)
            Expanded(
              child: Container(
                height: 2,
                color: select > 0 ? AppColor.BLUE_TEXT : AppColor.grey979797,
              ),
            )
          else
            const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class _BuildNoteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        Text(
          'Lưu ý',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Thực hiện liên kết Tài khoản ngân hàng để nhận thông tin biến động số dư, chia sẻ biến động số dư với mọi người.Hệ thống giúp việc đối soát giao dịch của bạn trở nên dễ dàng hơn.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColor.GREY_TEXT,
          ),
        )
      ],
    );
  }
}

class _BuildButton extends StatelessWidget {
  final GestureTapCallback? onTapSave;
  final GestureTapCallback? onTapLK;
  final bool isEnableBTLK;
  final bool isEnableBTSave;

  const _BuildButton(
      {this.onTapLK,
      this.onTapSave,
      this.isEnableBTSave = false,
      this.isEnableBTLK = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: MButtonWidget(
              title: 'Lưu tài khoản',
              isEnable: isEnableBTSave,
              colorEnableBgr: AppColor.WHITE,
              colorEnableText: AppColor.BLUE_TEXT,
              margin: EdgeInsets.zero,
              onTap: onTapSave,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: MButtonWidget(
              title: 'Liên kết',
              colorDisableBgr: AppColor.GREY_EBEBEB,
              colorDisableText: AppColor.GREY_TEXT,
              colorEnableBgr: AppColor.BLUE_TEXT,
              colorEnableText: AppColor.WHITE,
              margin: EdgeInsets.zero,
              isEnable: isEnableBTLK,
              onTap: onTapLK,
            ),
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
