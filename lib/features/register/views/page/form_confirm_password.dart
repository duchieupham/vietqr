import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/widgets/pin_code_input.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/register/events/register_event.dart';
import 'package:vierqr/features/register/states/register_state.dart';

import '../../../../commons/constants/configurations/numeral.dart';
import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/widgets/pin_widget_register.dart';
import '../../../../services/providers/register_provider.dart';

class FormConfirmPassword extends StatefulWidget {
  final Function(int) onEnterIntro;
  bool isFocus;

  FormConfirmPassword({
    super.key,
    required this.onEnterIntro,
    required this.isFocus,
  });

  @override
  State<FormConfirmPassword> createState() => _FormConfirmPasswordState();
}

class _FormConfirmPasswordState extends State<FormConfirmPassword> {
  final RegisterBloc _registerBloc = getIt.get<RegisterBloc>();
  final repassFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Provider.of<RegisterProvider>(context, listen: false)
    //     .confirmPassController
    //     .text = '';
    _registerBloc.add(const RegisterEventResetConfirmPassword());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      bloc: _registerBloc,
      builder: (context, state) {
        return Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Xác nhận lại ',
                    style: TextStyle(
                      color: AppColor.BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'mật khẩu ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(
                          const Rect.fromLTWH(0, 0, 200, 40),
                        ),
                    ),
                  ),
                  const TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: AppColor.BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'cho tài khoản ${state.phoneNumber}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 40),
              child: Focus(
                onFocusChange: (value) {
                  setState(() {
                    widget.isFocus = value;
                  });
                },
                child: PinCodeInput(
                  obscureText: true,
                  // controller: provider.passwordController,
                  focusNode: repassFocus,
                  autoFocus: widget.isFocus,
                  onChanged: (text) {
                    if (text.isEmpty) {
                      _registerBloc.add(RegisterEventUpdateConfirmPassword(
                          confirmPassword: text, password: state.password));
                    }
                  },
                  onCompleted: (value) {
                     _registerBloc.add(RegisterEventUpdateConfirmPassword(
                          confirmPassword: value, password: state.password));
                  },
                ),
              ),
            ),
            // Focus(
            //   onFocusChange: (value) {
            //     setState(() {
            //       widget.isFocus = value;
            //     });
            //   },
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: 50,
            //     margin: const EdgeInsets.only(left: 20, right: 20),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(50),
            //         border: Border.all(
            //             color: widget.isFocus
            //                 ? AppColor.BLUE_TEXT
            //                 : AppColor.GREY_TEXT,
            //             width: 0.5)),
            //     child: Center(
            //       child: PinWidgetRegister(
            //         width: MediaQuery.of(context).size.width,
            //         pinSize: 15,
            //         pinLength: Numeral.DEFAULT_PIN_LENGTH,
            //         focusNode: repassFocus,
            //         autoFocus: widget.isFocus,
            //         onDone: (value) {
            //           provider.updateConfirmPassword(value);
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            Visibility(
              visible: state.isConfirmPassErr,
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(top: 0, right: 40),
                child: const Text(
                  'Mật khẩu xác nhận không trùng khớp',
                  style: TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () async {
            //     if (provider.isEnableButton()) {
            //       widget.onEnterIntro(1);
            //     } else {
            //       provider.updatePhone(provider.phoneNoController.text);
            //       provider.updatePassword(provider.passwordController.text);
            //       provider.updateConfirmPassword(
            //           provider.confirmPassController.text);
            //     }
            //   },
            //   child: Container(
            //     width: 350,
            //     height: 50,
            //     decoration: BoxDecoration(
            //       border: Border.all(color: AppColor.BLUE_TEXT),
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     alignment: Alignment.center,
            //     child: const Text(
            //       'Tôi được giới thiệu đăng ký',
            //       style: TextStyle(
            //         color: AppColor.BLUE_TEXT,
            //         fontSize: 13,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
