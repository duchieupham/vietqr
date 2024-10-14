import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/helper/dialog_helper.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/input_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/add_bank/blocs/add_bank_bloc.dart';
import 'package:vierqr/features/add_bank/blocs/add_bank_provider.dart';
import 'package:vierqr/features/add_bank/events/add_bank_event.dart';
import 'package:vierqr/features/add_bank/states/add_bank_state.dart';
import 'package:vierqr/features/add_bank/views/account_link_view.dart';
import 'package:vierqr/features/add_bank/views/app_bar_add_bank.dart';
import 'package:vierqr/features/add_bank/views/confirm_otp_view.dart';
import 'package:vierqr/features/add_bank/views/policy_view.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/scan_qr/scan_qr_view_screen.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/bank_card_insert_dto.dart';
import 'package:vierqr/models/bank_card_insert_unauthenticated.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/confirm_otp_bank_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/register_authentication_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';


class AddBankScreen extends StatelessWidget {
  final BankTypeDTO? bankTypeDTO;
  final QRGeneratedDTO? qrGenerateDTO;
  final bool isInstantlyScan;
  const AddBankScreen(
      {super.key,
      this.bankTypeDTO,
      this.qrGenerateDTO,
      this.isInstantlyScan = false});

  static String routeName = '/add_bank_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddBankBloc>(
      create: (BuildContext context) => AddBankBloc(context),
      child: ChangeNotifierProvider(
        create: (_) => AddBankProvider(),
        child: _AddBankScreenState(
            bankTypeDTO: bankTypeDTO, isInstantlyScan: isInstantlyScan),
      ),
    );
  }
}

class _AddBankScreenState extends StatefulWidget {
  final BankTypeDTO? bankTypeDTO;
  final bool? isInstantlyScan;

  const _AddBankScreenState({this.bankTypeDTO, this.isInstantlyScan});

  @override
  State<_AddBankScreenState> createState() => _AddBankScreenStateState();
}

class _AddBankScreenStateState extends State<_AddBankScreenState>
    with DialogHelper {
  late AddBankBloc _bloc;
  late AddBankProvider _addBankProvider;

  final focusAccount = FocusNode();
  final focusName = FocusNode();

  final bankAccountController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cmtController = TextEditingController();
  final otpController = TextEditingController();

  bool saveAccountButton = false;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _addBankProvider = Provider.of<AddBankProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(context);
      focusAccount.addListener(() {
        if (!focusAccount.hasFocus) {
          _onSearch();
        }
      });
      if (widget.isInstantlyScan != null && widget.isInstantlyScan!) {
        _onScanQR();
      }
    });
  }

  void initData(BuildContext context) async {
    BankTypeDTO? bankTypeDTO = widget.bankTypeDTO;

    if (bankTypeDTO == null) {
      _bloc.add(const LoadDataAddBankEvent());
    } else {
      _bloc.add(const LoadDataAddBankEvent(isLoading: false));
      String bankAccount = bankTypeDTO.bankAccount;
      String userName = bankTypeDTO.userBankName;
      String bankId = bankTypeDTO.bankId;

      if (userName.isNotEmpty) {
        _addBankProvider.updateEdit(false);
        nameController.value = nameController.value.copyWith(text: userName);
      }

      if (bankId.isNotEmpty) {
        _addBankProvider.updateBankId(bankId);
      }

      if (bankAccount.isNotEmpty) {
        bankAccountController.value =
            bankAccountController.value.copyWith(text: bankAccount);
      }

      if (bankAccount.isNotEmpty && bankId.isNotEmpty && userName.isNotEmpty) {
        _addBankProvider.updateStep(1);
      }

      _addBankProvider.updateSelectBankType(bankTypeDTO, update: true);
      _addBankProvider.updateEnableName(true);
    }
    showDialogAddBankOptions(
      context,
      onScan: () {
        _onScanQR();
      },
      onInput: () {
        Navigator.pop(context);
      },
    );
  }

  void _onSearch() {
    bool isEdit = _addBankProvider.isEdit;
    if (bankAccountController.text.isNotEmpty &&
        bankAccountController.text.length > 5 &&
        isEdit) {
      String transferType = '';
      String caiValue = '';
      String bankCode = '';
      BankTypeDTO? bankTypeDTO = _addBankProvider.bankTypeDTO;
      if (bankTypeDTO != null) {
        caiValue = bankTypeDTO.caiValue;
        bankCode = bankTypeDTO.bankCode;
      }

      if (bankCode == 'MB') {
        transferType = 'INHOUSE';
      } else {
        transferType = 'NAPAS';
      }
      BankNameSearchDTO bankNameSearchDTO = BankNameSearchDTO(
        accountNumber: bankAccountController.text.replaceAll(' ', ''),
        accountType: 'ACCOUNT',
        transferType: transferType,
        bankCode: caiValue,
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
              if (_addBankProvider.bankTypeDTO != null) {
                _addBankProvider.updateValidUserBankName(nameController.text);
              }
            }

            if (state.request == AddBankType.EXIST_BANK) {
              if (_addBankProvider.isLinkBank && state.isSaveButton == false) {
                _addBankProvider.updateStep(1);
              } else {
                String bankTypeId = _addBankProvider.bankTypeDTO!.id;
                String userId = SharePrefUtils.getProfile().userId;
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
              getIt.get<BankBloc>().add(const BankCardEventGetList(
                  isGetOverview: true, isLoadInvoice: true));
              // eventBus.fire(GetListBankScreen());
              Navigator.of(context).pop(true);
            }

            if (state.request == AddBankType.ERROR_SEARCH_NAME) {
              if (!mounted) return;
              _addBankProvider.updateEnableName(true);
            }

            if (state.request == AddBankType.ERROR) {
              await DialogWidget.instance.openMsgDialog(
                  title: state.titleMsg ?? 'Không thể thêm TK',
                  msg: state.msg ?? '');
            }

            if (state.request == AddBankType.ERROR_OTP) {
              await DialogWidget.instance.openMsgDialog(
                  title: state.titleMsg ?? 'Thông báo',
                  msg: 'Mã OTP không chính xác, vui lòng thử lại');
            }

            if (state.request == AddBankType.ERROR_EXIST) {
              await DialogWidget.instance.openMsgDialog(
                  title: state.titleMsg ?? 'Không thể thêm TK',
                  msg: state.msg ?? '');
            }

            if (state.request == AddBankType.ERROR_SYSTEM) {
              await DialogWidget.instance.openMsgDialog(
                  title: 'Không thể liên kết TK', msg: state.msg ?? '');
              if (!mounted) return;
              _addBankProvider.updateEnableName(true);
            }

            if (state.request == AddBankType.REQUEST_BANK) {
              if (!mounted) return;
              Navigator.of(context).pop();
              _addBankProvider.updateStep(2);
            }
            if (state.request == AddBankType.RESENT_REQUEST_BANK) {}

            if (state.request == AddBankType.OTP_BANK) {
              if (!mounted) return;
              String bankId = _addBankProvider.bankId;
              if (bankId.trim().isNotEmpty) {
                final dto = RegisterAuthenticationDTO(
                  bankId: bankId,
                  bankCode: _addBankProvider.bankTypeDTO!.bankCode,
                  merchantId: state.responseDataOTP != null
                      ? state.responseDataOTP!.merchantId
                      : '',
                  merchantName: state.responseDataOTP != null
                      ? state.responseDataOTP!.merchantName
                      : '',
                  vaNumber: state.ewalletToken!,
                  nationalId: cmtController.text,
                  phoneAuthenticated: phoneController.text,
                  bankAccountName: nameController.text,
                  bankAccount: bankAccountController.text,
                  ewalletToken: state.ewalletToken ?? '',
                );
                print(
                    '--------------------EWALLET TOKEN: ---------- ${state.ewalletToken}');
                _bloc.add(BankCardEventRegisterLinkBank(dto: dto));
              } else {
                String bankTypeId = _addBankProvider.bankTypeDTO!.id;
                String userId = SharePrefUtils.getProfile().userId;
                String formattedName = StringUtils.instance.removeDiacritic(
                    StringUtils.instance
                        .capitalFirstCharacter(nameController.text));
                print(
                    '--------------------EWALLET TOKEN: ---------- ${state.ewalletToken}');
                BankCardInsertDTO dto = BankCardInsertDTO(
                  bankTypeId: bankTypeId,
                  userId: userId,
                  userBankName: formattedName,
                  bankAccount: bankAccountController.text,
                  bankCode: _addBankProvider.bankTypeDTO!.bankCode,
                  type: _addBankProvider.type,
                  branchId: '',
                  nationalId: cmtController.text,
                  phoneAuthenticated: phoneController.text,
                  ewalletToken: '',
                  merchantId: state.responseDataOTP != null
                      ? state.responseDataOTP!.merchantId
                      : '',
                  merchantName: state.responseDataOTP != null
                      ? state.responseDataOTP!.merchantName
                      : '',
                  vaNumber: state.ewalletToken!,
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
                _addBankProvider.onChangeCMT(cmtController.text,
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
                  backgroundColor: AppColor.WHITE,
                  appBar:
                      // MAppBar(
                      //   title: 'Thêm tài khoản',
                      //   actions: [
                      //     GestureDetector(
                      //       onTap: _onScanQR,
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Image.asset(
                      //           'assets/images/ic-scan-content.png',
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      AppBarAddBank(
                    actions: [
                      Image.asset(
                        'assets/images/ic-viet-qr.png',
                        height: 40,
                        width: 80,
                      ),
                      GestureDetector(
                        onTap: _onScanQR,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColor.BLUE_TEXT.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(2),
                          child: Image.asset(
                            'assets/images/ic-scan-content.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            height: constraint.maxHeight,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
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
                                            // startBarcodeScanStream(context);
                                            scanBarcode();
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
                                          dto: provider.bankTypeDTO!,
                                          phone: phoneController.text,
                                          otpController: otpController,
                                          onChangeOTP: (value) {},
                                          onResend: _onResend,
                                        );
                                      }

                                      return SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Thêm tài khoản ngân hàng',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 20),
                                            _buildSelectBankWidget(
                                                state, provider, height),
                                            const SizedBox(height: 30),
                                            TextFieldCustom(
                                              isObscureText: false,
                                              titleSize: 15,
                                              maxLines: 1,
                                              enable:
                                                  provider.bankTypeDTO != null,
                                              fillColor:
                                                  provider.bankTypeDTO != null
                                                      ? null
                                                      : AppColor.BLUE_BGR,
                                              controller: bankAccountController,
                                              inputFormatter: [
                                                BankAccountInputFormatter()
                                              ],
                                              textFieldType:
                                                  TextfieldType.LABEL,
                                              title: 'Số tài khoản*',
                                              focusNode: focusAccount,
                                              hintText:
                                                  'Nhập số tài khoản ngân hàng',
                                              inputType: TextInputType.text,
                                              keyboardAction:
                                                  TextInputAction.next,
                                              onChange: provider
                                                  .updateValidBankAccount,
                                              height: 50,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        AppColor.GREY_DADADA),
                                              ),
                                              disabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        AppColor.GREY_DADADA),
                                              ),
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
                                              height: 50,
                                              titleSize: 15,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              key: provider.keyAccount,
                                              controller: nameController,
                                              isObscureText: false,
                                              maxLines: 1,
                                              enable: provider.isEnableName,
                                              focusNode: focusName,
                                              fillColor: provider.isEnableName
                                                  ? AppColor.WHITE
                                                  : AppColor.BLUE_BGR,
                                              textFieldType:
                                                  TextfieldType.LABEL,
                                              title: 'Chủ tài khoản*',
                                              hintText:
                                                  'Nhập tên chủ tài khoản ngân hàng',
                                              inputType: TextInputType.text,
                                              keyboardAction:
                                                  TextInputAction.next,
                                              inputFormatter: [
                                                UppercaseBankNameInputFormatter(),
                                              ],
                                              onChange: provider
                                                  .updateValidUserBankName,
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        AppColor.GREY_DADADA),
                                              ),
                                              disabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        AppColor.GREY_DADADA),
                                              ),
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            XImage(
                              imagePath: 'assets/images/ic-security.png',
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              'Thông tin của bạn được mã hoá và bảo mật an toàn.',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                        Consumer<AddBankProvider>(
                          builder: (context, provider, child) {
                            return (provider.bankTypeDTO?.status == 1)
                                ? _buildButton(provider, state.requestId ?? '',
                                    state.responseDataOTP)
                                : MButtonWidget(
                                    title: 'Lưu thông tin',
                                    height: 50,
                                    radius: 5,
                                    isEnable: provider.isEnableButton,
                                    colorEnableText: provider.isEnableButton
                                        ? AppColor.GREY_TEXT
                                        : AppColor.WHITE,
                                    colorDisableBgr: AppColor.WHITE,
                                    colorEnableBgr: AppColor.BLUE_TEXT,
                                    border: Border.all(
                                      color: AppColor.GREY_DADADA,
                                    ),
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      String bankTypeId =
                                          provider.bankTypeDTO!.id;
                                      _bloc.add(
                                        BankCardCheckExistedEvent(
                                          bankAccount:
                                              bankAccountController.text,
                                          bankTypeId: bankTypeId,
                                          type: ExitsType.ADD.name,
                                          isSaveButton: true,
                                        ),
                                      );
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

  Widget _buildButton(
      AddBankProvider provider, String requestId, DataObject? data) {
    final buttonStepFirst = _BuildButton(
      onTapSave: () {
        FocusManager.instance.primaryFocus?.unfocus();
        String bankTypeId = provider.bankTypeDTO!.id;
        _bloc.add(BankCardCheckExistedEvent(
          bankAccount: bankAccountController.text,
          bankTypeId: bankTypeId,
          type: ExitsType.ADD.name,
          isSaveButton: true,
        ));
      },
      onTapLK: () {
        provider.updateLinkBank(true);
        String bankTypeId = provider.bankTypeDTO!.id;
        _bloc.add(BankCardCheckExistedEvent(
          bankAccount: bankAccountController.text,
          bankTypeId: bankTypeId,
          type: ExitsType.LINKED.name,
        ));
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
              bankAccount: bankAccountController.text,
              bankCode: provider.bankTypeDTO?.bankCode ?? '',
              onTap: () {
                if (provider.isAgreeWithPolicy) {
                  String formattedName = StringUtils.instance.removeDiacritic(
                      StringUtils.instance
                          .capitalFirstCharacter(nameController.text));
                  BankCardRequestOTP dto = BankCardRequestOTP(
                    nationalId: cmtController.text,
                    accountNumber:
                        bankAccountController.text.replaceAll(' ', ''),
                    accountName: formattedName,
                    applicationType: 'MOBILE',
                    phoneNumber: phoneController.text,
                    bankCode: provider.bankTypeDTO?.bankCode ?? '',
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
        if (provider.bankTypeDTO!.bankCode.contains('BIDV')) {
          ConfirmOTPBidvDTO otpBidvDTO = ConfirmOTPBidvDTO(
              bankCode: provider.bankTypeDTO!.bankCode,
              bankAccount: provider.bankTypeDTO!.bankAccount,
              merchantId: data!.merchantId,
              merchantName: data.merchantName,
              confirmId: data.confirmId,
              otpNumber: otpController.text);
          _bloc.add(BankCardEventConfirmOTP(dto: otpBidvDTO));
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
          ConfirmOTPBankDTO confirmDTO = ConfirmOTPBankDTO(
            requestId: requestId,
            otpValue: otpController.text,
            applicationType: 'MOBILE',
            bankAccount: bankAccountController.text,
            bankCode: provider.bankTypeDTO?.bankCode ?? '',
          );
          _bloc.add(BankCardEventConfirmOTP(dto: confirmDTO));
        }
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

  Future<void> scanBarcode() async {
    Map<String, dynamic> param = {};
    param['typeScan'] = TypeScan.ADD_BANK;
    final data = await NavigationService.push(Routes.SCAN_QR_VIEW_SCREEN,
        arguments: param);
    if (data is Map<String, dynamic>) {
      if (data['isScaned']) {
        _bloc.add(
          ScanQrEventGetBankType(
            code: data['code'],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSelectBankType(AddBankState state, provider, height) async {
    final data = await showDialogSelectBankType(
      context,
      list: state.listBanks ?? [],
      isSearch: true,
      data: provider.bankTypeDTO,
    );
    if (data is int) {
      bankAccountController.clear();
      nameController.clear();
      provider.resetValidate();
      provider.updateSelectBankType(state.listBanks![data]);
      _addBankProvider.updateEnableName(true);
    }
  }
  // void onSelectBankType(AddBankState state, provider, height) async {
  //   final data = await DialogWidget.instance.showModelBottomSheet(
  //     context: context,
  //     padding: EdgeInsets.zero,
  //     widget: ModelBottomSheetView(
  //       tvTitle: 'Chọn ngân hàng',
  //       ctx: context,
  //       list: state.listBanks ?? [],
  //       isSearch: true,
  //       data: provider.bankTypeDTO,
  //     ),
  //     height: height * 0.8,
  //   );
  //   if (data is int) {
  //     bankAccountController.clear();
  //     nameController.clear();
  //     provider.resetValidate();
  //     provider.updateSelectBankType(state.listBanks![data]);
  //     _addBankProvider.updateEnableName(true);
  //   }
  // }

  _onResend() {
    String formattedName = StringUtils.instance.removeDiacritic(
        StringUtils.instance.capitalFirstCharacter(nameController.text));
    BankCardRequestOTP dto = BankCardRequestOTP(
      nationalId: cmtController.text,
      accountNumber: bankAccountController.text,
      accountName: formattedName,
      applicationType: 'MOBILE',
      phoneNumber: phoneController.text,
      bankCode: _addBankProvider.bankTypeDTO?.bankCode ?? '',
    );
    _bloc.add(ResendRequestOTPEvent(dto: dto));
  }

  _buildSelectBankWidget(AddBankState state, AddBankProvider provider, height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Ngân hàng*',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () => onSelectBankType(state, provider, height),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
                // borderRadius: BorderRadius.all(Radius.circular(5)),
                color: AppColor.WHITE,
                border:
                    Border(bottom: BorderSide(color: AppColor.GREY_DADADA))),
            child: Row(
              children: [
                if (provider.bankTypeDTO != null)
                  Container(
                    width: 60,
                    height: 50,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      image: provider.bankTypeDTO!.fileBank != null
                          ? DecorationImage(
                              image: FileImage(provider.bankTypeDTO!.fileBank!))
                          : DecorationImage(
                              image: ImageUtils.instance.getImageNetWork(
                                  provider.bankTypeDTO?.imageId ?? '')),
                    ),
                  )
                else
                  const SizedBox(width: 0),
                Expanded(
                  child: Text(
                    provider.bankTypeDTO?.name ?? 'Chọn ngân hàng',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: provider.bankTypeDTO != null
                            ? AppColor.BLACK
                            : AppColor.GREY_TEXT),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColor.GREY_TEXT,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onScanQR() async {
    Map<String, dynamic> param = {};
    param['typeScan'] = TypeScan.ADD_BANK_SCAN_QR;
    final data = await NavigationService.push(Routes.SCAN_QR_VIEW_SCREEN,
        arguments: param);

    // final data = await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW,
    //     arguments: {'isScanAll': false});
    if (data is Map<String, dynamic>) {
      if (!mounted) return;
      final type = data['type'];
      final value = data['data'];
      final bankTypeDTO = data['bankTypeDTO'];
      if (type == TypeContact.Bank) {
        if (value != null && value is QRGeneratedDTO) {
          bankAccountController.value =
              bankAccountController.value.copyWith(text: value.bankAccount);
          nameController.value =
              nameController.value.copyWith(text: value.userBankName);
          if (nameController.text.isNotEmpty && !value.isNaviAddBank) {
            Provider.of<AddBankProvider>(context, listen: false)
                .updateEdit(false);
          }
          if (bankTypeDTO != null && bankTypeDTO is BankTypeDTO) {
            Provider.of<AddBankProvider>(context, listen: false)
                .updateSelectBankType(bankTypeDTO,
                    update: bankAccountController.text.isNotEmpty &&
                        nameController.text.isNotEmpty);
            Provider.of<AddBankProvider>(context, listen: false)
                .updateValidUserBankName(nameController.text);
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
