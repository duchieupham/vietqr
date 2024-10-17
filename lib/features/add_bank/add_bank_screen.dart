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
import 'package:vierqr/commons/widgets/button_gradient_border_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/switch_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/add_bank/blocs/add_bank_bloc.dart';
import 'package:vierqr/features/add_bank/blocs/add_bank_provider.dart';
import 'package:vierqr/features/add_bank/events/add_bank_event.dart';
import 'package:vierqr/features/add_bank/states/add_bank_state.dart';
import 'package:vierqr/features/add_bank/views/app_bar_add_bank.dart';
import 'package:vierqr/features/add_bank/views/close_connect_widget.dart';
import 'package:vierqr/features/add_bank/views/confirm_otp_view.dart';
import 'package:vierqr/features/add_bank/views/loading_account_bank_name_widget.dart';
import 'package:vierqr/features/add_bank/views/policy_view_widget.dart';
import 'package:vierqr/features/add_bank/views/save_connect_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/scan_qr/scan_qr_view_screen.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
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
  final bool isSaved;
  const AddBankScreen(
      {super.key,
      this.bankTypeDTO,
      this.qrGenerateDTO,
      this.isSaved = false,
      this.isInstantlyScan = false});

  static String routeName = '/add_bank_screen';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddBankProvider(),
      child: _AddBankScreenState(
        bankTypeDTO: bankTypeDTO,
        isInstantlyScan: isInstantlyScan,
        isSaved: isSaved,
      ),
    );
  }
}

class _AddBankScreenState extends StatefulWidget {
  final BankTypeDTO? bankTypeDTO;
  final bool? isInstantlyScan;
  final bool? isSaved;

  const _AddBankScreenState(
      {this.bankTypeDTO, this.isInstantlyScan, this.isSaved});

  @override
  State<_AddBankScreenState> createState() => _AddBankScreenStateState();
}

class _AddBankScreenStateState extends State<_AddBankScreenState>
    with DialogHelper {
  late AddBankBloc _bloc;
  late AddBankProvider _addBankProvider;

  final focusAccount = FocusNode();
  final focusName = FocusNode();
  final focusPhone = FocusNode();
  final focusCMT = FocusNode();

  final bankAccountController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cmtController = TextEditingController();
  final otpController = TextEditingController();

  bool loadingAccountBankName = false;
  bool saveAccountButton = false;

  @override
  void initState() {
    super.initState();
    _bloc = getIt.get<AddBankBloc>();
    _addBankProvider = Provider.of<AddBankProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(context);
      focusAccount.addListener(() {
        if (!focusAccount.hasFocus) {
          _onSearch();
        }
      });
      focusPhone.addListener(() {
        if (!focusPhone.hasFocus) {
          focusCMT.requestFocus();
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
        // _addBankProvider.updateStep(1);
      }

      _addBankProvider.updateSelectBankType(bankTypeDTO, update: true);
      _addBankProvider.updateEnableName(true);
    }
    if (!widget.isSaved!) {
      showDialogAddBankOptions(
        context,
        onScan: () {
          _onScanQR(isFromPopUp: true);
        },
        onInput: () {
          Navigator.pop(context);
        },
      );
    }
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
          bloc: _bloc,
          listener: (context, state) async {
            if (state.status == BlocStatus.LOADING) {
              DialogWidget.instance.openLoadingDialog();
            }

            if (state.status == BlocStatus.UNLOADING) {
              Navigator.pop(context);
            }

            if (state.request == AddBankType.SEARCH_BANK &&
                state.status == BlocStatus.NONE) {
              loadingAccountBankName = false;
              nameController.clear();
              nameController.value = nameController.value
                  .copyWith(text: state.informationDTO?.accountName ?? '');
              if (_addBankProvider.bankTypeDTO != null) {
                _addBankProvider.updateValidUserBankName(nameController.text);
              }
            }

            if (state.request == AddBankType.LOAD_SEARCH_BANK) {
              loadingAccountBankName = true;
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
              loadingAccountBankName = false;
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
              // ignore: use_build_context_synchronously
              // Navigator.of(context).pop();
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
                // ignore: avoid_print
                print(
                    '--------------------EWALLET TOKEN: ---------- ${state.ewalletToken}');
                _bloc.add(BankCardEventRegisterLinkBank(dto: dto));
              } else {
                String bankTypeId = _addBankProvider.bankTypeDTO!.id;
                String userId = SharePrefUtils.getProfile().userId;
                String formattedName = StringUtils.instance.removeDiacritic(
                    StringUtils.instance
                        .capitalFirstCharacter(nameController.text));
                // ignore: avoid_print
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
                    onPressed: () {
                      if (_addBankProvider.step == 0) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.of(context).pop();
                      } else if (_addBankProvider.step == 1) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _addBankProvider.updateStep(0);
                        _addBankProvider.updatePolicy(false);
                      } else {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _addBankProvider.updateStep(1);
                        _addBankProvider.updatePolicy(false);
                      }
                    },
                    actions: [
                      Image.asset(
                        'assets/images/ic-viet-qr.png',
                        height: 40,
                        width: 80,
                      ),
                      Consumer<AddBankProvider>(
                        builder: (ctx, provider, child) {
                          if (_addBankProvider.step == 0) {
                            return GestureDetector(
                              onTap: _onScanQR,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  gradient:
                                      VietQRTheme.gradientColor.lilyLinear,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                padding: const EdgeInsets.all(2),
                                child: Image.asset(
                                  'assets/images/ic-scan-content.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox(
                              width: 20,
                            );
                          }
                        },
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
                                    builder: (ctx, provider, child) {
                                      if (provider.step == 1) {
                                        // return AccountLinkView(
                                        //   bankTypeDTO: provider.bankTypeDTO!,
                                        //   bankAccount:
                                        //       bankAccountController.text,
                                        //   bankUserName: nameController.text,
                                        //   phone: phoneController,
                                        //   cmt: cmtController,
                                        //   onChangePhone: (value) {
                                        //     provider.onChangePhone(value,
                                        //         cmt: cmtController.text);
                                        //   },
                                        //   onChangeCMT: (value) {
                                        //     provider.onChangeCMT(value,
                                        //         phone: phoneController.text);
                                        //   },
                                        //   errorPhone: provider.errorSDT,
                                        //   errorCMT: provider.errorCMT,
                                        //   onScan: () {
                                        //     FocusManager.instance.primaryFocus
                                        //         ?.unfocus();
                                        //     // startBarcodeScanStream(context);
                                        //     scanBarcode();
                                        //   },
                                        //   onEdit: () {
                                        //     phoneController.clear();
                                        //     cmtController.clear();
                                        //     provider.updateStep(0);
                                        //     provider.updateEdit(false);
                                        //   },
                                        // );
                                        return PolicyViewWidget(
                                          onSelectPolicy: provider.updatePolicy,
                                          isAgreeWithPolicy:
                                              provider.isAgreeWithPolicy,
                                          bankAccount:
                                              bankAccountController.text,
                                          bankCode:
                                              provider.bankTypeDTO?.bankCode ??
                                                  '',
                                          onTap: () {
                                            if (provider.isAgreeWithPolicy) {
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
                                                    bankAccountController.text
                                                        .replaceAll(' ', ''),
                                                accountName: formattedName,
                                                applicationType: 'MOBILE',
                                                phoneNumber:
                                                    phoneController.text,
                                                bankCode: provider.bankTypeDTO
                                                        ?.bankCode ??
                                                    '',
                                              );
                                              context.read<AddBankBloc>().add(
                                                  BankCardEventRequestOTP(
                                                      dto: dto));
                                            }
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
                                            const SizedBox(
                                              height: 25,
                                            ),
                                            _buildSelectBankWidget(
                                                state, provider, height),
                                            const SizedBox(
                                              height: 25,
                                            ),
                                            _buildTextAccountBankField(
                                                provider),
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
                                            const SizedBox(
                                              height: 25,
                                            ),
                                            loadingAccountBankName
                                                ? const LoadingAccountBankNameWidget()
                                                : _buildTextAccountBankNameField(
                                                    provider),
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
                                                height: 25,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SwitchVietQRWidget(
                                                    onChanged: (value) {
                                                      provider
                                                          .updateOpenConnect(
                                                              value);
                                                    },
                                                    value:
                                                        provider.isOpenConnect,
                                                  ),
                                                  const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Liên kết tài khoản ngân hàng',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Nhập các thông tin xác thực để liên kết TK ngân hàng.',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: AppColor
                                                                .GREY_TEXT),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 25,
                                              ),
                                              if (provider.isOpenConnect) ...[
                                                TextFieldCustom(
                                                  height: 50,
                                                  titleSize: 15,
                                                  focusNode: focusPhone,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 0),
                                                  isObscureText: false,
                                                  maxLines: 1,
                                                  controller: phoneController,
                                                  textFieldType:
                                                      TextfieldType.LABEL,
                                                  title:
                                                      'Số điện thoại xác thực*',
                                                  hintText:
                                                      'Nhập SĐT đăng ký xác thực với ngân hàng',
                                                  hintFontWeight:
                                                      FontWeight.normal,
                                                  inputType:
                                                      TextInputType.number,
                                                  keyboardAction:
                                                      TextInputAction.next,
                                                  inputFormatter: [
                                                    LengthLimitingTextInputFormatter(
                                                        10),
                                                  ],
                                                  onChange: (value) {
                                                    provider.onChangePhone(
                                                        value,
                                                        cmt:
                                                            cmtController.text);
                                                  },
                                                  focusedBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: AppColor
                                                            .GREY_DADADA),
                                                  ),
                                                  disabledBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: AppColor
                                                            .GREY_DADADA),
                                                  ),
                                                  suffixIconConstraints:
                                                      const BoxConstraints(
                                                    minWidth: 2,
                                                    minHeight: 2,
                                                  ),
                                                  suffixIcon: phoneController
                                                          .value.text.isNotEmpty
                                                      ? InkWell(
                                                          onTap: () {
                                                            phoneController
                                                                .clear();
                                                            provider.onChangePhone(
                                                                phoneController
                                                                    .text,
                                                                cmt:
                                                                    cmtController
                                                                        .text);
                                                          },
                                                          child: const Icon(
                                                            Icons.close,
                                                            size: 20,
                                                            color: AppColor
                                                                .GREY_TEXT,
                                                          ),
                                                        )
                                                      : null,
                                                ),
                                                Visibility(
                                                  visible:
                                                      provider.errorSDT != null,
                                                  child: Container(
                                                    width: double.infinity,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                      provider.errorSDT ?? '',
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Styles.errorStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                TextFieldCustom(
                                                  height: 50,
                                                  titleSize: 15,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 0),
                                                  isObscureText: false,
                                                  focusNode: focusCMT,
                                                  maxLines: 1,
                                                  controller: cmtController,
                                                  textFieldType:
                                                      TextfieldType.LABEL,
                                                  title:
                                                      'Định danh CCCD/MST/DKKD/HC*',
                                                  hintText:
                                                      'Nhập thông tin định danh với ngân hàng',
                                                  hintFontWeight:
                                                      FontWeight.normal,
                                                  inputType: TextInputType.text,
                                                  keyboardAction:
                                                      TextInputAction.next,
                                                  onChange: (value) {
                                                    provider.onChangeCMT(value,
                                                        phone: phoneController
                                                            .text);
                                                  },
                                                  focusedBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: AppColor
                                                            .GREY_DADADA),
                                                  ),
                                                  disabledBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: AppColor
                                                            .GREY_DADADA),
                                                  ),
                                                  suffixIconConstraints:
                                                      const BoxConstraints(
                                                    minWidth: 2,
                                                    minHeight: 2,
                                                  ),
                                                  suffixIcon: cmtController
                                                          .value.text.isNotEmpty
                                                      ? InkWell(
                                                          onTap: () {
                                                            cmtController
                                                                .clear();
                                                            provider.onChangeCMT(
                                                                cmtController
                                                                    .text,
                                                                phone:
                                                                    phoneController
                                                                        .text);
                                                          },
                                                          child: const Icon(
                                                            Icons.close,
                                                            size: 20,
                                                            color: AppColor
                                                                .GREY_TEXT,
                                                          ),
                                                        )
                                                      : null,
                                                ),
                                                Visibility(
                                                  visible:
                                                      provider.errorCMT != null,
                                                  child: Container(
                                                    width: double.infinity,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                      provider.errorCMT ?? '',
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Styles.errorStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                              ] else
                                                const CloseConnectWidget()
                                            ],
                                            if (provider.bankTypeDTO?.status ==
                                                0) ...[
                                              const SizedBox(
                                                height: 25,
                                              ),
                                              SaveConnectWidget(
                                                list: state.listBanks ?? [],
                                                provider: provider,
                                                bankAccountController:
                                                    bankAccountController,
                                                nameController: nameController,
                                              )
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
                          builder: (ctx, provider, child) {
                            if (_addBankProvider.step == 0) {
                              return _buildSecurityWidget();
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                        //build button
                        Consumer<AddBankProvider>(
                          builder: (context, provider, child) {
                            return (provider.bankTypeDTO?.status == 1)
                                ? _buildButton(provider, state.requestId ?? '',
                                    state.responseDataOTP)
                                : GradientBorderButton(
                                    gradient: provider.isEnableButton
                                        ? VietQRTheme
                                            .gradientColor.brightBlueLinear
                                        : VietQRTheme.gradientColor
                                            .disableLightButtonLinear,
                                    borderRadius: BorderRadius.circular(5),
                                    margin: const EdgeInsets.only(
                                        top: 10,
                                        left: 20,
                                        right: 20,
                                        bottom: 20),
                                    borderWidth: 1,
                                    widget: InkWell(
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
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: AppColor.WHITE,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: ShaderMask(
                                          shaderCallback: (bounds) =>
                                              LinearGradient(
                                            colors: provider.isEnableButton
                                                ? [
                                                    const Color(0xFF00B8F5),
                                                    const Color(0xFF0A7AFF),
                                                  ]
                                                : [
                                                    AppColor.GREY_TEXT,
                                                    AppColor.GREY_TEXT
                                                  ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ).createShader(bounds),
                                          child: const Center(
                                            child: Text(
                                              'Lưu thông tin',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppColor.WHITE,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
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

  Widget _buildSecurityWidget() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        XImage(
          imagePath: 'assets/images/ic-security.png',
          width: 21,
          fit: BoxFit.cover,
        ),
        Text(
          'Thông tin của bạn được mã hoá và bảo mật an toàn.',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
        )
      ],
    );
  }

  Widget _buildTextAccountBankNameField(AddBankProvider provider) {
    return TextFieldCustom(
      height: 50,
      titleSize: 15,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      key: provider.keyAccount,
      controller: nameController,
      isObscureText: false,
      maxLines: 1,
      enable: provider.isEnableName,
      focusNode: focusName,
      fillColor: provider.isEnableName ? AppColor.WHITE : AppColor.BLUE_BGR,
      textFieldType: TextfieldType.LABEL,
      title: 'Chủ tài khoản*',
      hintText: 'Nhập tên chủ tài khoản ngân hàng',
      hintFontWeight: FontWeight.normal,
      inputType: TextInputType.text,
      keyboardAction: TextInputAction.next,
      inputFormatter: [
        UppercaseBankNameInputFormatter(),
      ],
      onChange: provider.updateValidUserBankName,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColor.GREY_DADADA),
      ),
      disabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColor.GREY_DADADA),
      ),
      suffixIconConstraints: const BoxConstraints(
        minWidth: 2,
        minHeight: 2,
      ),
      suffixIcon: nameController.value.text.isNotEmpty
          ? InkWell(
              onTap: () {
                nameController.clear();
                provider.updateValidUserBankName(nameController.text);
              },
              child: const Icon(
                Icons.close,
                size: 20,
                color: AppColor.GREY_TEXT,
              ),
            )
          : null,
    );
  }

  Widget _buildTextAccountBankField(AddBankProvider provider) {
    return TextFieldCustom(
      isObscureText: false,
      titleSize: 15,
      maxLines: 1,
      enable: provider.bankTypeDTO != null,
      fillColor: provider.bankTypeDTO != null ? null : AppColor.BLUE_BGR,
      controller: bankAccountController,
      inputFormatter: [BankAccountInputFormatter()],
      textFieldType: TextfieldType.LABEL,
      title: 'Số tài khoản*',
      focusNode: focusAccount,
      hintText: 'Nhập số tài khoản ngân hàng',
      hintFontWeight: FontWeight.normal,
      inputType: TextInputType.text,
      keyboardAction: TextInputAction.next,
      onChange: provider.updateValidBankAccount,
      height: 50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColor.GREY_DADADA),
      ),
      disabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColor.GREY_DADADA),
      ),
      suffixIconConstraints: const BoxConstraints(
        minWidth: 2,
        minHeight: 2,
      ),
      suffixIcon: bankAccountController.value.text.isNotEmpty
          ? InkWell(
              onTap: () {
                bankAccountController.clear();
                nameController.clear();
                provider.updateValidUserBankName(nameController.text);
              },
              child: const Icon(
                Icons.close,
                size: 20,
                color: AppColor.GREY_TEXT,
              ),
            )
          : null,
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
      onTapConnect: () {
        if (widget.isSaved!) {
          FocusManager.instance.primaryFocus?.unfocus();
          Future.delayed(const Duration(milliseconds: 500)).then(
            (value) {
              _addBankProvider.updateStep(1);
            },
          );
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
          provider.updateLinkBank(true);
          String bankTypeId = provider.bankTypeDTO!.id;
          _bloc.add(
            BankCardCheckExistedEvent(
              bankAccount: bankAccountController.text,
              bankTypeId: bankTypeId,
              type: ExitsType.LINKED.name,
            ),
          );
        }
      },
      isEnableBTSave: provider.isOpenConnect
          ? (provider.isValidForm())
          : (provider.isValidFormUnAuthentication()),
      isEnableBTConnect: provider.isValidForm(),
      provider: provider,
    );

    // final buttonStepSecond = MButtonWidget(
    //   title: 'Liên kết',
    //   isEnable: provider.isValidForm(),
    //   colorEnableText:
    //       provider.isValidForm() ? AppColor.WHITE : AppColor.GREY_TEXT,
    //   onTap: () async {
    //     FocusManager.instance.primaryFocus?.unfocus();
    //     await showGeneralDialog(
    //       context: context,
    //       barrierDismissible: true,
    //       barrierLabel:
    //           MaterialLocalizations.of(context).modalBarrierDismissLabel,
    //       barrierColor: Colors.black45,
    //       transitionDuration: const Duration(milliseconds: 200),
    //       pageBuilder: (BuildContext buildContext, Animation animation,
    //           Animation secondaryAnimation) {
    //         return PolicyView(
    //           onSelectPolicy: provider.updatePolicy,
    //           isAgreeWithPolicy: provider.isAgreeWithPolicy,
    //           bankAccount: bankAccountController.text,
    //           bankCode: provider.bankTypeDTO?.bankCode ?? '',
    //           onTap: () {
    //             if (provider.isAgreeWithPolicy) {
    //               String formattedName = StringUtils.instance.removeDiacritic(
    //                   StringUtils.instance
    //                       .capitalFirstCharacter(nameController.text));
    //               BankCardRequestOTP dto = BankCardRequestOTP(
    //                 nationalId: cmtController.text,
    //                 accountNumber:
    //                     bankAccountController.text.replaceAll(' ', ''),
    //                 accountName: formattedName,
    //                 applicationType: 'MOBILE',
    //                 phoneNumber: phoneController.text,
    //                 bankCode: provider.bankTypeDTO?.bankCode ?? '',
    //               );
    //               context
    //                   .read<AddBankBloc>()
    //                   .add(BankCardEventRequestOTP(dto: dto));
    //             }
    //           },
    //         );
    //       },
    //     );
    //   },
    // );

    final buttonSecondStep = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                checkColor: AppColor.WHITE,
                activeColor: AppColor.BLUE_TEXT,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: WidgetStateBorderSide.resolveWith(
                  (states) => const BorderSide(
                    width: 1.0,
                    color: AppColor.BLUE_TEXT,
                  ),
                ),
                value: provider.isAgreeWithPolicy,
                onChanged: (value) {
                  provider.updatePolicy(value);
                },
              ),
              const Text(
                'Tôi đã đọc và đồng ý với các điều khoản',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: AppColor.BLACK,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(
              20, 5, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: VietQRButton.gradient(
            onPressed: () {
              if (provider.isAgreeWithPolicy) {
                String formattedName = StringUtils.instance.removeDiacritic(
                    StringUtils.instance
                        .capitalFirstCharacter(nameController.text));
                BankCardRequestOTP dto = BankCardRequestOTP(
                  nationalId: cmtController.text,
                  accountNumber: bankAccountController.text.replaceAll(' ', ''),
                  accountName: formattedName,
                  applicationType: 'MOBILE',
                  phoneNumber: phoneController.text,
                  bankCode: provider.bankTypeDTO?.bankCode ?? '',
                );

                _bloc.add(BankCardEventRequestOTP(dto: dto));
              }
            },
            height: 50,
            isDisabled: !provider.isAgreeWithPolicy,
            child: Center(
              child: Text(
                'Xác nhận',
                style: TextStyle(
                  color: provider.isAgreeWithPolicy
                      ? AppColor.WHITE
                      : AppColor.BLACK,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    // final buttonThirdStep = MButtonWidget(
    //   title: 'Xác thực',
    //   isEnable: provider.isValidForm(),
    //   colorEnableText:
    //       provider.isValidForm() ? AppColor.WHITE : AppColor.GREY_TEXT,
    //   onTap: () async {
    //     if (provider.bankTypeDTO!.bankCode.contains('BIDV')) {
    //       ConfirmOTPBidvDTO otpBidvDTO = ConfirmOTPBidvDTO(
    //           bankCode: provider.bankTypeDTO!.bankCode,
    //           bankAccount: provider.bankTypeDTO!.bankAccount,
    //           merchantId: data!.merchantId,
    //           merchantName: data.merchantName,
    //           confirmId: data.confirmId,
    //           otpNumber: otpController.text);
    //       _bloc.add(BankCardEventConfirmOTP(dto: otpBidvDTO));
    //     } else {
    //       FocusManager.instance.primaryFocus?.unfocus();
    //       ConfirmOTPBankDTO confirmDTO = ConfirmOTPBankDTO(
    //         requestId: requestId,
    //         otpValue: otpController.text,
    //         applicationType: 'MOBILE',
    //         bankAccount: bankAccountController.text,
    //         bankCode: provider.bankTypeDTO?.bankCode ?? '',
    //       );
    //       _bloc.add(BankCardEventConfirmOTP(dto: confirmDTO));
    //     }
    //   },
    // );
    final buttonThirdStep = Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: VietQRButton.gradient(
        onPressed: () {
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
        height: 50,
        isDisabled: !provider.isValidForm(),
        child: Center(
          child: Text(
            'Xác thực',
            style: TextStyle(
              color: provider.isValidForm() ? AppColor.WHITE : AppColor.BLACK,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );

    return provider.step == 0
        ? buttonStepFirst
        : provider.step == 1
            ? buttonSecondStep
            : buttonThirdStep;
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
      phoneController.clear();
      cmtController.clear();
      provider.resetValidate();
      provider.updateSelectBankType(state.listBanks![data]);
      _addBankProvider.updateEnableName(true);
      _addBankProvider.updateOpenConnect(true);
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

  Widget _buildSelectBankWidget(
      AddBankState state, AddBankProvider provider, height) {
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
            padding: const EdgeInsets.only(bottom: 8, top: 10),
            decoration: const BoxDecoration(
              // borderRadius: BorderRadius.all(Radius.circular(5)),
              color: AppColor.WHITE,
              border: Border(
                bottom: BorderSide(
                  color: AppColor.GREY_DADADA,
                ),
              ),
            ),
            child: Row(
              children: [
                if (provider.bankTypeDTO != null)
                  Container(
                    width: 60,
                    height: 30,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppColor.GREY_DADADA),
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
                    provider.bankTypeDTO?.shortName ?? 'Chọn ngân hàng',
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

  void _onScanQR({bool isFromPopUp = false}) async {
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
        if (isFromPopUp) {
          Navigator.pop(context);
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
  final VoidCallback onTapSave;
  final VoidCallback onTapConnect;
  final bool isEnableBTConnect;
  final bool isEnableBTSave;
  final AddBankProvider provider;

  const _BuildButton(
      {required this.onTapConnect,
      required this.onTapSave,
      required this.provider,
      this.isEnableBTSave = false,
      this.isEnableBTConnect = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(
          20, 10, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        children: [
          if (provider.isOpenConnect)
            VietQRButton.gradient(
              onPressed: onTapConnect,
              height: 50,
              isDisabled: !isEnableBTConnect,
              child: Center(
                child: Text(
                  'Thực hiện liên kết',
                  style: TextStyle(
                    color: isEnableBTConnect ? AppColor.WHITE : AppColor.BLACK,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          const SizedBox(
            height: 8,
          ),
          GradientBorderButton(
            gradient: isEnableBTSave
                ? VietQRTheme.gradientColor.brightBlueLinear
                : VietQRTheme.gradientColor.disableLightButtonLinear,
            borderRadius: BorderRadius.circular(5),
            borderWidth: 1,
            widget: InkWell(
              onTap: onTapSave,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: isEnableBTSave
                        ? [
                            const Color(0xFF00B8F5),
                            const Color(0xFF0A7AFF),
                          ]
                        : [AppColor.GREY_TEXT, AppColor.GREY_TEXT],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: const Center(
                    child: Text(
                      'Lưu thông tin',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColor.WHITE,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // MButtonWidget(
    //   title: 'Thực hiện liên kết',
    //   height: 50,
    //   colorDisableBgr: AppColor.BLUE_BGR,
    //   colorDisableText: AppColor.BLACK,
    //   colorEnableBgr: AppColor.BLUE_TEXT,
    //   colorEnableText: AppColor.WHITE,
    //   margin: EdgeInsets.zero,
    //   isEnable: isEnableBTConnect,
    //   onTap: onTapConnect,
    // ),
    // const SizedBox(
    //   height: 8,
    // ),
    // MButtonWidget(
    //   title: 'Lưu thông tin',
    //   height: 50,
    //   colorDisableBgr: AppColor.WHITE,
    //   colorDisableText: AppColor.BLACK,
    //   colorEnableBgr: AppColor.BLUE_TEXT,
    //   colorEnableText: AppColor.WHITE,
    //   margin: EdgeInsets.zero,
    //   isEnable: isEnableBTSave,
    //   onTap: onTapSave,
    // ),
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
