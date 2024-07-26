import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/create_store/create_store.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class InputCreateMerchantView extends StatefulWidget {
  final Function(String, String) callBack;
  final String storeName;

  const InputCreateMerchantView(
      {super.key, required this.callBack, required this.storeName});

  @override
  State<InputCreateMerchantView> createState() =>
      _InputCreateMerchantViewState();
}

class _InputCreateMerchantViewState extends State<InputCreateMerchantView> {
  late CreateStoreBloc bloc;
  bool isEnableButton = false;
  String _value = '';

  @override
  void initState() {
    super.initState();
    bloc = CreateStoreBloc(context);
    setState(() {
      _value = widget.storeName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateStoreBloc>(
      create: (context) => bloc,
      child: BlocListener<CreateStoreBloc, CreateStoreState>(
        listener: (context, state) {
          if (state.status == BlocStatus.LOADING_PAGE) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            Navigator.pop(context);
          }

          if (state.request == StoreType.CREATE_SUCCESS) {
            widget.callBack.call(_value, state.merchantId);
          }
        },
        child: GestureDetector(
          onTap: _hideKeyBoard,
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/ic-merchant-3D.png',
                  height: 100,
                ),
                const Text(
                  'Đầu tiên, vui lòng chọn\ndoanh nghiệp của bạn',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: AppColor.GREY_TEXT),
                    children: [
                      TextSpan(text: 'Một doanh nghiệp có nhiều cửa hàng.')
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                MTextFieldCustom(
                  isObscureText: false,
                  maxLines: 1,
                  showBorder: false,
                  fillColor: AppColor.TRANSPARENT,
                  value: _value,
                  autoFocus: true,
                  textFieldType: TextfieldType.DEFAULT,
                  title: '',
                  hintText: '',
                  inputType: TextInputType.text,
                  keyboardAction: TextInputAction.next,
                  onChange: (value) {
                    _value = value;
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    hintText: 'Nhập tên doanh nghiệp ở đây',
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
                  inputFormatter: [
                    LengthLimitingTextInputFormatter(50),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColor.BLACK,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(text: 'Lưu ý:'),
                        TextSpan(
                          text: ' Tên doanh nghiệp tối đa 50 ký tự.',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColor.BLACK,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                MButtonWidget(
                  title: 'Tiếp tục',
                  margin: EdgeInsets.zero,
                  isEnable: _value.isNotEmpty,
                  onTap: _onCreateMerchant,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _hideKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _onCreateMerchant() {
    _hideKeyBoard();
    Map<String, dynamic> body = {
      'name': _value,
      'type': 0,
      'userId': SharePrefUtils.getProfile().userId,
      'vsoCode': '',
      'address': '',
    };

    bloc.add(CreateMerchantEvent(body));
  }
}
