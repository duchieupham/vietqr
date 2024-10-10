import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/register/events/register_event.dart';
import 'package:vierqr/features/register/states/register_state.dart';
import 'package:vierqr/features/register/utils/register_utils.dart';
import 'package:vierqr/layouts/pin_code_input.dart';

import '../../../../commons/widgets/phone_widget.dart';

class FormAccount extends StatefulWidget {
  final TextEditingController phoneController;
  final bool isFocus;
  final Function(int) onEnterIntro;
  final RegisterBloc registerBloc;

  const FormAccount(
      {super.key,
      required this.phoneController,
      required this.isFocus,
      required this.onEnterIntro,
      required this.registerBloc});

  @override
  State<FormAccount> createState() => _FormAccountState();
}

class _FormAccountState extends State<FormAccount> {
  // final RegisterBloc _registerBloc = getIt.get<RegisterBloc>();
  final repassFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      bloc: widget.registerBloc,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Số điện thoại*',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.BLACK,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Số điện thoại được dùng để đăng nhập vào hệ thống VietQR VN',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColor.BLACK,
                  ),
                ),
              ),
              PhoneWidget(
                onChanged: (value) {
                  widget.registerBloc.add(RegisterEventUpdatePhone(phone: value));
                },
                phoneController: widget.phoneController,
                autoFocus: widget.isFocus,
              ),
              Visibility(
                visible: state.isPhoneErr,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 5, top: 5, right: 30),
                  child: const Text(
                    'Số điện thoại không đúng định dạng.',
                    style: TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Đặt mật khẩu*',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.BLACK,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                'Mật khẩu có độ dài 6 ký tự số, không bao gồm chữ và ký tự đặc biệt',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColor.BLACK,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                width: 280,
                child: PinCodeInput(
                  autoFocus: true,
                  obscureText: true,
                  onChanged: (value) {
                    widget.registerBloc
                        .add(RegisterEventUpdatePassword(password: value));
                    Future.delayed(const Duration(seconds: 1), () {
                      if (value.length == 6) {
                        repassFocus.requestFocus();
                      }
                    });
                  },
                ),
              ),
              Visibility(
                visible: state.isPasswordErr,
                child: const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    'Mật khẩu bao gồm 6 số.',
                    style: TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Xác nhận lại mật khẩu*',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.BLACK,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                'Nhập lại mật khẩu ở trên để xác nhận',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColor.BLACK,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                width: 280,
                child: PinCodeInput(
                  autoFocus: true,
                  obscureText: true,
                  focusNode: repassFocus,
                  onChanged: (value) {
                    // provider.updateConfirmPassword(value);
                    widget.registerBloc.add(RegisterEventUpdateConfirmPassword(
                        confirmPassword: value, password: state.password));
                  },
                ),
              ),
              Visibility(
                visible: state.isConfirmPassErr,
                child: const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    'Mật khẩu không trùng khớp',
                    style: TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    if (RegisterUtils.instance.isEnableButton(
                        state.phoneNumber,
                        state.password,
                        state.confirmPassword,
                        state.isPhoneErr,
                        state.isPasswordErr,
                        state.isConfirmPassErr)) {
                      widget.onEnterIntro(1);
                    } else {
                      // provider.updatePhone(provider.phoneNoController.text);
                      widget.registerBloc.add(
                          RegisterEventUpdatePhone(phone: state.phoneNumber));
                      widget.registerBloc.add(RegisterEventUpdatePassword(
                          password: state.password));
                      widget.registerBloc.add(RegisterEventUpdateConfirmPassword(
                          confirmPassword: state.confirmPassword,
                          password: state.password));
                      // provider.updatePassword(provider.passwordController.text);
                      // provider.updateConfirmPassword(
                      //     provider.confirmPassController.text);
                    }
                  },
                  child: const Text(
                    'Nhập thông tin người giới thiệu (Không bắt buộc)',
                    style: TextStyle(
                        color: AppColor.BLUE_TEXT,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
