import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/merchant/merchant.dart';
import 'package:vierqr/features/merchant/widgets/header_merchant_widget.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class InfoConfirmView extends StatefulWidget {
  final Function(String, String, ResponseMessageDTO) callBack;
  final String nameStore;
  final String phone;
  final String national;
  final Map<String, dynamic> paramOTP;

  const InfoConfirmView({
    super.key,
    required this.callBack,
    required this.nameStore,
    required this.phone,
    required this.national,
    required this.paramOTP,
  });

  @override
  State<InfoConfirmView> createState() => _InputCodeStoreViewState();
}

class _InputCodeStoreViewState extends State<InfoConfirmView> {
  late MerchantBloc bloc;
  String national = '';
  String phone = '';
  Map<String, dynamic> paramOTP = {};

  @override
  void initState() {
    super.initState();
    bloc = MerchantBloc(context);
    setState(() {
      national = widget.national;
      phone = widget.phone;
      paramOTP.addAll(widget.paramOTP);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MerchantBloc>(
      create: (context) => bloc,
      child: BlocConsumer<MerchantBloc, MerchantState>(
        listener: (context, state) {
          if (state.status == BlocStatus.LOADING_PAGE) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            Navigator.pop(context);
          }

          if (state.request == MerchantType.REQUEST_OTP) {
            widget.callBack.call(phone, national, state.responseDTO);
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: _hideKeyBoard,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderMerchantWidget(
                            nameStore: widget.nameStore,
                            title:
                                'Tiếp theo, vui lòng cung cấp\nthông tin xác thực'),
                        const SizedBox(height: 40),
                        ...[
                          MTextFieldCustom(
                            isObscureText: false,
                            maxLines: 1,
                            enable: true,
                            value: national,
                            fillColor: Colors.white,
                            textFieldType: TextfieldType.DEFAULT,
                            title: 'Mã cửa hàng *',
                            hintText: 'Nhập Căn cước công dân/Mã số thuế *',
                            inputType: TextInputType.number,
                            keyboardAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Nhập Căn cước công dân/Mã số thuế *',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: AppColor.GREY_TEXT,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColor.BLUE_TEXT),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColor.BLUE_TEXT),
                              ),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColor.BLUE_TEXT),
                              ),
                            ),
                            onChange: (value) {
                              setState(() {
                                national = value;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          if (SharePrefUtils.getProfile().nationalId != null &&
                              SharePrefUtils.getProfile()
                                  .nationalId
                                  .trim()
                                  .isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  national =
                                      SharePrefUtils.getProfile().nationalId;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColor.BLUE_TEXT.withOpacity(0.25),
                                ),
                                child: Text(
                                  SharePrefUtils.getProfile().nationalId,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColor.BLUE_TEXT,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 12),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color: AppColor.GREY_TEXT, fontSize: 12),
                              children: [
                                TextSpan(
                                  text: 'Lưu ý:\n',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text:
                                        'Đối với tài khoản ngân hàng cá nhân, vui lòng cung cấp CCCD/CMND.\n'),
                                TextSpan(
                                    text:
                                        'Đối với tài khoản doanh nghiệp, vui lòng cung cấp mã số thuế.\n'),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 30),
                        MTextFieldCustom(
                          isObscureText: false,
                          maxLines: 1,
                          value: phone,
                          fillColor: Colors.white,
                          textFieldType: TextfieldType.DEFAULT,
                          title: '',
                          hintText: 'Nhập số điện thoại xác thực *',
                          inputType: TextInputType.phone,
                          keyboardAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Nhập số điện thoại xác thực *',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: AppColor.GREY_TEXT,
                            ),
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
                          onChange: (value) {
                            setState(() {
                              phone = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              phone = SharePrefUtils.getPhone();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColor.BLUE_TEXT.withOpacity(0.25),
                            ),
                            child: Text(
                              SharePrefUtils.getPhone(),
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.BLUE_TEXT,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                MButtonWidget(
                  title: 'Tiếp tục',
                  margin: EdgeInsets.zero,
                  isEnable: phone.isNotEmpty && national.isNotEmpty,
                  onTap: () {
                    paramOTP['nationalId'] = national;
                    paramOTP['phoneAuthenticated'] = phone;
                    bloc.add(RequestOTPEvent(paramOTP));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _hideKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
