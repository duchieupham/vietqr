import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/numeral.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/pin_widget_register.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/services/providers/pin_provider.dart';

class OTPInputPage extends StatefulWidget {
  final TextEditingController otpController;
  final VoidCallback onContinue;
  final VoidCallback sendOTP;
  final String email;
  final bool confirmOTP;

  const OTPInputPage({
    Key? key,
    required this.onContinue,
    required this.sendOTP,
    required this.email,
    required this.otpController,
    required this.confirmOTP,
  }) : super(key: key);

  @override
  State<OTPInputPage> createState() => _OTPInputPageState();
}

class _OTPInputPageState extends State<OTPInputPage> {
  late Timer _timer;
  int _remainingSeconds = 600; // 10 minutes in seconds
  bool _isTimerExpired = false;
  final FocusNode passFocus = FocusNode();
  bool isFocus = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _resetPin();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestFocus();
      widget.otpController.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant OTPInputPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.confirmOTP == false) {
      _resetPin();
      _requestFocus();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isTimerExpired = true;
          });
        }
        _timer.cancel();
      }
    });
  }

  void _resetTimer() {
    if (mounted) {
      setState(() {
        _remainingSeconds = 600; // Reset to 10 minutes
        _isTimerExpired = false;
      });
    }
    _timer.cancel();
    _startTimer();
  }

  void _resetPin() {
    widget.otpController.clear();
    Provider.of<PinProvider>(context, listen: false).reset();
  }

  void _requestFocus() {
    passFocus.requestFocus();
  }

  @override
  void dispose() {
    widget.otpController.dispose();
    _timer.cancel();
    passFocus.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secondsRemaining = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secondsRemaining.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MButtonWidget(
          title: 'Xác thực',
          height: 50,
          margin: EdgeInsets.zero,
          isEnable: widget.otpController.text.length == 6,
          onTap: widget.onContinue,
          colorDisableBgr: AppColor.GREY_BUTTON,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(
                            text: 'Thông tin xác thực đã được gửi\nđến email '),
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mã OTP có hiệu lực trong vòng',
                    style: TextStyle(fontSize: 12),
                  ),
                  _isTimerExpired
                      ? GestureDetector(
                          onTap: () {
                            _resetTimer();
                            widget.sendOTP();
                          },
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF00C6FF),
                                Color(0xFF0072FF),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds),
                            child: Text(
                              'Gửi lại mã OTP?',
                              style: TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.transparent,
                                decorationThickness: 2,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [
                                      Color(0xFF00C6FF),
                                      Color(0xFF0072FF),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ).createShader(
                                      const Rect.fromLTWH(0, 0, 200, 30)),
                              ),
                            ),
                          ),
                        )
                      : ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF00C6FF),
                              Color(0xFF0072FF),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: Text(
                            _formatTime(_remainingSeconds),
                            style: TextStyle(
                              fontSize: 20,
                              decorationThickness: 2,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color(0xFF00C6FF),
                                    Color(0xFF0072FF),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 30)),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 12,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Focus(
            onFocusChange: (value) {
              setState(() {
                isFocus = value;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                      color: isFocus ? AppColor.BLUE_TEXT : AppColor.GREY_TEXT,
                      width: 0.5)),
              child: PinWidgetRegister(
                width: MediaQuery.of(context).size.width,
                pinSize: 15,
                pinLength: Numeral.DEFAULT_PIN_LENGTH,
                editingController: widget.otpController,
                focusNode: passFocus,
                autoFocus: true,
                onDone: (value) {
                  widget.onContinue();
                },
              ),
            ),
          ),
          if (widget.confirmOTP == false)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Mã OTP không hợp lệ. Vui lòng kiểm tra lại thông tin.',
                    style: TextStyle(fontSize: 11, color: AppColor.RED_TEXT),
                  )),
            ),
        ],
      ),
    );
  }
}
