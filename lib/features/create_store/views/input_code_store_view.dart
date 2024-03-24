import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/features/create_store/create_store.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';

class InputCodeStoreView extends StatefulWidget {
  final Function(String, String) callBack;
  final String nameStore;
  final String codeStore;
  final String addressStore;

  const InputCodeStoreView({
    super.key,
    required this.callBack,
    required this.nameStore,
    required this.codeStore,
    required this.addressStore,
  });

  @override
  State<InputCodeStoreView> createState() => _InputCodeStoreViewState();
}

class _InputCodeStoreViewState extends State<InputCodeStoreView> {
  late CreateStoreBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = CreateStoreBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.addressStore.isNotEmpty) {
        bloc.add(UpdateAddressStoreEvent(widget.addressStore));
      }
      if (widget.codeStore.isNotEmpty) {
        bloc.add(UpdateCodeStoreEvent(widget.codeStore));
      } else {
        bloc.add(RandomCodeStoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateStoreBloc>(
      create: (context) => bloc,
      child: BlocConsumer<CreateStoreBloc, CreateStoreState>(
          listener: (context, state) {},
          builder: (context, state) {
            return GestureDetector(
              onTap: _hideKeyBoard,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderStoreWidget(
                              nameStore: widget.nameStore,
                              title:
                                  'Thiết lập thông tin để\ntạo mã VietQR cho cửa hàng',
                              desTitle:
                                  'Nhận thông tin thanh toán và quản lý tiền bán hàng tiện lợi ngay trên ứng dụng VietQR.',
                            ),
                            const SizedBox(height: 40),
                            ...[
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: MTextFieldCustom(
                                        isObscureText: false,
                                        maxLines: 1,
                                        showBorder: true,
                                        enable: false,
                                        value: state.codeStore,
                                        styles:
                                            TextStyle(color: AppColor.GREY_TEXT),
                                        fillColor: Colors.grey.withOpacity(0.2),
                                        textFieldType: TextfieldType.LABEL,
                                        title: 'Mã cửa hàng *',
                                        autoFocus: true,
                                        hintText: '',
                                        maxLength: 13,
                                        inputType: TextInputType.number,
                                        keyboardAction: TextInputAction.next,
                                        onChange: (value) {},
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      child: GestureDetector(
                                        onTap: () =>
                                            _onChangedCode(state.codeStore),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: AppColor.BLUE_TEXT
                                                  .withOpacity(0.35)),
                                          child: Icon(Icons.edit,
                                              color: AppColor.BLUE_TEXT),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: AppColor.GREY_TEXT, fontSize: 15),
                                  children: [
                                    TextSpan(
                                        text:
                                            'Dùng để phân biệt loại giao dịch theo cửa hàng.\n'),
                                    TextSpan(
                                        text: 'Mã cửa hàng tối đa 13 ký tự.\n'),
                                    TextSpan(
                                        text:
                                            'Mã cửa hàng không chứa tiếng việt và ký tự đặc biệt.\n'),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 30),
                            MTextFieldCustom(
                              isObscureText: false,
                              maxLines: 1,
                              showBorder: true,
                              value: state.addressStore,
                              fillColor: Colors.white,
                              textFieldType: TextfieldType.LABEL,
                              title: 'Địa chỉ cửa hàng *',
                              hintText: 'Nhập địa chỉ cửa hàng',
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.next,
                              onChange: (value) {
                                bloc.add(UpdateAddressStoreEvent(value));
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    MButtonWidget(
                      title: 'Tiếp tục',
                      margin: EdgeInsets.zero,
                      isEnable: state.addressStore.isNotEmpty &&
                          state.codeStore.isNotEmpty,
                      onTap: () => widget.callBack
                          .call(state.codeStore, state.addressStore),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  void _onChangedCode(String code) async {
    final data = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogCodeStore(codeStore: code);
      },
    );

    if (data is String && data.isNotEmpty) {
      bloc.add(UpdateCodeStoreEvent(data));
    }
  }

  void _hideKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
