import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

class OTPInputPage extends StatefulWidget {
  final VoidCallback onContinue;
  final String email;

  const OTPInputPage({
    Key? key,
    required this.onContinue,
    required this.email,
  }) : super(key: key);

  @override
  State<OTPInputPage> createState() => _OTPInputPageState();
}

class _OTPInputPageState extends State<OTPInputPage> {
  final _otpController = TextEditingController();
  late Timer _timer;
  int _remainingSeconds = 6; // 10 minutes in seconds
  bool _isTimerExpired = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() {
      setState(() {});
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _isTimerExpired = true;
        });
        _timer.cancel();
      }
    });
  }

  void _resetTimer() {
    setState(() {
      _remainingSeconds = 6; // Reset to 10 minutes
      _isTimerExpired = false;
    });
    _timer.cancel();
    _startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer.cancel();
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
          isEnable: _otpController.text.isNotEmpty,
          onTap: widget.onContinue,
          colorDisableBgr: AppColor.GREY_BUTTON,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            // height: 130,
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
                            // Handle OTP resend here
                            _resetTimer();
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
                                  ).createShader(const Rect.fromLTWH(0, 0, 200,
                                      30)), // Adjust size to cover text
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
        ],
      ),
    );
  }
}
