import 'package:dudv_base/themes/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/add_bank/blocs/add_bank_bloc.dart';
import 'package:vierqr/features/add_bank/events/add_bank_event.dart';
import 'package:vierqr/features/add_bank/states/add_bank_state.dart';
import 'package:vierqr/features/add_bank/views/bank_input_widget.dart';
import 'package:vierqr/features/register_new_bank/provider/register_new_bank_provider.dart';
import 'package:vierqr/features/register_new_bank/widget/bottom_sheet_type_account.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class RegisterNewBank extends StatefulWidget {
  const RegisterNewBank({super.key});

  @override
  State<RegisterNewBank> createState() => _RegisterMbBankState();
}

class _RegisterMbBankState extends State<RegisterNewBank> {
  late AddBankBloc _bloc;

  final focusAccount = FocusNode();
  final focusName = FocusNode();
  final focusPhone = FocusNode();
  final focusMST = FocusNode();
  final focusCCCD = FocusNode();
  final focusAddress = FocusNode();
  final bankAccountController = TextEditingController();
  final nameController = TextEditingController();
  final MSTController = TextEditingController();
  final CCCDController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final otpController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    _bloc = AddBankBloc(context)
      ..add(const LoadDataBankEvent(isLoading: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: MAppBar(
        title: 'Mở TK ngân hàng',
      ),
      body: BlocProvider<AddBankBloc>(
        create: (context) => _bloc,
        child:
            BlocConsumer<AddBankBloc, AddBankState>(listener: (context, state) {
          if (state.request == AddBankType.REQUEST_REGISTER) {
            if (state.status == BlocStatus.LOADING) {
              DialogWidget.instance.openLoadingDialog();
            } else if (state.status == BlocStatus.SUCCESS) {
              Navigator.pop(context);
              DialogWidget.instance.openMsgSuccessDialog(
                  title: 'Đăng ký thành công',
                  msg:
                      'Chúng tôi ghi nhận thông tin đăng ký của bạn. Bộ phận hỗ trợ sẽ liên hệ với bạn trong thời gian sớm nhất.');
            } else if (state.status == BlocStatus.ERROR) {
              Navigator.pop(context);
              DialogWidget.instance.openMsgDialog(
                  title: 'Thất bại',
                  msg: state.msg ?? 'Đã có lỗi xảy ra, vui lòng thử lại sau');
            }
          }
        }, builder: (context, state) {
          return ChangeNotifierProvider<RegisterNewBankProvider>(
            create: (context) => RegisterNewBankProvider(),
            child: Consumer<RegisterNewBankProvider>(
                builder: (context, provider, child) {
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      children: [
                        const Text(
                          'Ngân hàng thụ hưởng*',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            final data = await DialogWidget.instance
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
                              provider
                                  .updateSelectBankType(state.listBanks![data]);
                              provider.updateEnableName(true);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: AppColor.WHITE,
                            ),
                            child: Row(
                              children: [
                                if (provider.bankTypeDTO != null)
                                  Container(
                                    width: 60,
                                    height: 30,
                                    margin: const EdgeInsets.only(left: 4),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: ImageUtils.instance
                                              .getImageNetWork(provider
                                                      .bankTypeDTO?.imageId ??
                                                  '')),
                                    ),
                                  )
                                else
                                  const SizedBox(width: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    provider.bankTypeDTO?.name ??
                                        'Chọn ngân hàng thụ hưởng',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
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
                        const SizedBox(height: 20),
                        const Text(
                          'Loại tài khoản',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            DialogWidget.instance.showModelBottomSheet(
                              context: context,
                              padding: EdgeInsets.zero,
                              widget: BottomSheetTypeAccount(
                                list: provider.accountTypes,
                                onChange: provider.updateAccountType,
                                initData: provider.typeAccount,
                              ),
                              height: 200,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: AppColor.WHITE,
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    provider.typeAccount.tile,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
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
                        const SizedBox(height: 20),
                        TextFieldCustom(
                          height: 50,
                          colorBG: AppColor.WHITE,
                          isObscureText: false,
                          maxLines: 1,
                          controller: bankAccountController,
                          textFieldType: TextfieldType.LABEL,
                          title: 'Số tài khoản*',
                          focusNode: focusAccount,
                          hintText: 'Nhập số tài khoản ngân hàng',
                          inputType: TextInputType.number,
                          keyboardAction: TextInputAction.next,
                          onChange: provider.updateValidBankAccount,
                        ),
                        if (provider.errorTk != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              provider.errorTk ?? '',
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.errorStyle(fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 20),
                        TextFieldCustom(
                          height: 50,
                          colorBG: AppColor.WHITE,
                          key: provider.keyAccount,
                          controller: nameController,
                          isObscureText: false,
                          maxLines: 1,
                          focusNode: focusName,
                          textFieldType: TextfieldType.LABEL,
                          unTitle:
                              'Tên tài khoản không dấu, không bao gồm ký tự đặc biệt',
                          title: 'Tên tài khoản*',
                          hintText: 'Nhập đầy đủ họ và tên',
                          inputType: TextInputType.text,
                          keyboardAction: TextInputAction.next,
                          inputFormatter: [
                            UpperCaseTextFormatter(),
                          ],
                          onChange: provider.updateValidUserBankName,
                        ),
                        if (provider.errorNameTK != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              provider.errorNameTK ?? '',
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.errorStyle(fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 20),
                        if (provider.typeAccount.type == 0) ...[
                          TextFieldCustom(
                            height: 50,
                            colorBG: AppColor.WHITE,
                            // key: provider.keyAccount,
                            controller: CCCDController,
                            isObscureText: false,
                            maxLines: 1,
                            focusNode: focusCCCD,
                            textFieldType: TextfieldType.LABEL,
                            unTitle: 'Căn cước công dân/Chứng minh thư',
                            title: 'CCCD/CMT*',
                            hintText: 'Nhập căn cước công dân/Chứng minh thư',
                            inputType: TextInputType.number,
                            keyboardAction: TextInputAction.next,
                            inputFormatter: [
                              UpperCaseTextFormatter(),
                            ],
                            onChange: provider.onChangeCMT,
                          ),
                          if (provider.errorCMT != null)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                provider.errorCMT ?? '',
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.errorStyle(fontSize: 12),
                              ),
                            ),
                        ] else ...[
                          TextFieldCustom(
                            height: 50,
                            colorBG: AppColor.WHITE,
                            // key: provider.keyAccount,
                            controller: MSTController,
                            isObscureText: false,
                            maxLines: 1,
                            focusNode: focusMST,
                            textFieldType: TextfieldType.LABEL,
                            unTitle: 'Mã số thuế doanh nghiệp',
                            title: 'Mã số thuế*',
                            hintText: 'Nhập mã số thuế',
                            inputType: TextInputType.number,
                            keyboardAction: TextInputAction.next,
                            inputFormatter: [
                              UpperCaseTextFormatter(),
                            ],
                            onChange: provider.onChangeMST,
                          ),
                          if (provider.errorMST != null)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                provider.errorMST ?? '',
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.errorStyle(fontSize: 12),
                              ),
                            ),
                        ],
                        const SizedBox(height: 20),
                        TextFieldCustom(
                          height: 50,
                          colorBG: AppColor.WHITE,
                          controller: phoneController,
                          isObscureText: false,
                          maxLines: 1,
                          focusNode: focusPhone,
                          textFieldType: TextfieldType.LABEL,
                          unTitle:
                              'Số điện thoại để xác thực tài khoản ngân hàng',
                          title: 'Số điện thoại xác thực*',
                          hintText: 'Nhập số điện thoại',
                          inputType: TextInputType.number,
                          keyboardAction: TextInputAction.next,
                          inputFormatter: [
                            UpperCaseTextFormatter(),
                          ],
                          onChange: provider.onChangePhone,
                        ),
                        if (provider.errorSDT != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              provider.errorSDT ?? '',
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.errorStyle(fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 20),
                        TextFieldCustom(
                          height: 50,
                          colorBG: AppColor.WHITE,
                          controller: addressController,
                          isObscureText: false,
                          maxLines: 1,
                          focusNode: focusAddress,
                          textFieldType: TextfieldType.LABEL,
                          title: 'Địa chỉ*',
                          hintText: 'Nhập địa chỉ',
                          inputType: TextInputType.text,
                          keyboardAction: TextInputAction.next,
                          onChange: provider.onChangeAddress,
                        ),
                        if (provider.errorAddress != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              provider.errorAddress ?? '',
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.errorStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: ButtonWidget(
                        text: 'Đăng ký',
                        borderRadius: 5,
                        textColor: provider.bankTypeDTO != null
                            ? AppColor.WHITE
                            : AppColor.GREY_TEXT,
                        bgColor: provider.bankTypeDTO != null
                            ? AppColor.BLUE_TEXT
                            : AppColor.GREY_BUTTON,
                        function: () {
                          if (provider.isValidForm()) {
                            Map<String, dynamic> param = {};
                            param['bankAccount'] =
                                bankAccountController.text.trim();
                            param['userBankName'] = nameController.text.trim();
                            param['bankCode'] =
                                provider.bankTypeDTO?.bankCode ?? '';
                            param['nationalId'] = provider.typeAccount.type == 0
                                ? CCCDController.text.trim()
                                : MSTController.text.trim();
                            param['phoneAuthenticated'] =
                                phoneController.text.trim();
                            param['requestType'] = provider.typeAccount.type;
                            param['address'] = addressController.text.trim();
                            param['userId'] =
                                UserInformationHelper.instance.getUserId();
                            print('--------------------------$param');
                            _bloc.add(RequestRegisterBankAccount(dto: param));
                          } else {
                            if (addressController.text.isEmpty ||
                                phoneController.text.isEmpty) {
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                              if (phoneController.text.isEmpty) {
                                focusPhone.requestFocus();
                              } else if (addressController.text.isEmpty) {
                                focusAddress.requestFocus();
                              }
                            }

                            DialogWidget.instance.openMsgDialog(
                                title: 'Chưa đúng thông tin',
                                msg:
                                    'Vui lòng nhập đầy đủ thông tin trên form!');
                          }
                        }),
                  )
                ],
              );
            }),
          );
        }),
      ),
    );
  }
}
