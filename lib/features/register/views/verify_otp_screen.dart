// import 'dart:async';
//
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:vierqr/commons/constants/configurations/theme.dart';
// import 'package:vierqr/commons/widgets/button_widget.dart';
// import 'package:vierqr/commons/widgets/divider_widget.dart';
// import 'package:vierqr/features/register/blocs/register_bloc.dart';
// import 'package:vierqr/features/register/events/register_event.dart';
// import 'package:vierqr/models/account_login_dto.dart';
// import 'package:vierqr/services/providers/register_provider.dart';
// import 'package:vierqr/services/providers/verify_otp_provider.dart';
//
// import 'pin_code_input.dart';
//
// class VerifyOTPView extends StatefulWidget {
//   final String phone;
//   final AccountLoginDTO dto;
//
//   const VerifyOTPView({
//     super.key,
//     required this.phone,
//     required this.dto,
//   });
//
//   @override
//   State<StatefulWidget> createState() => _VerifyOTPView();
// }
//
// class _VerifyOTPView extends State<VerifyOTPView> with WidgetsBindingObserver {
//   final otpController = TextEditingController();
//   late CountDownOTPNotifier countdownProvider;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     WidgetsBinding.instance.addPostFrameCallback((_) {});
//     countdownProvider = CountDownOTPNotifier(120);
//     countdownProvider.countDown();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     countdownProvider.onHideApp(state);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     return Consumer<VerifyOtpProvider>(
//       builder: (context, provider, child) {
//         return Stack(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: width,
//                   height: 50,
//                   child: Row(
//                     children: [
//                       const SizedBox(
//                         width: 80,
//                         height: 50,
//                       ),
//                       Expanded(
//                         child: Container(
//                           alignment: Alignment.center,
//                           child: const Text(
//                             'Xác thực OTP',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                           Provider.of<VerifyOtpProvider>(context, listen: false)
//                               .reset();
//                         },
//                         child: Container(
//                           width: 80,
//                           alignment: Alignment.centerRight,
//                           child: const Text(
//                             'Đóng',
//                             style: TextStyle(
//                               color: DefaultTheme.GREEN,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 DividerWidget(width: width),
//                 Expanded(
//                   child: ListView(
//                     shrinkWrap: true,
//                     children: [
//                       const Padding(padding: EdgeInsets.only(top: 30)),
//                       RichText(
//                         textAlign: TextAlign.center,
//                         text: TextSpan(
//                           style: TextStyle(
//                             color: Theme.of(context).hintColor,
//                             fontSize: 15,
//                           ),
//                           children: [
//                             const TextSpan(text: 'Mã OTP được gửi tới SĐT '),
//                             TextSpan(
//                               text: widget.phone,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const TextSpan(
//                                 text:
//                                     '. Vui lòng nhập mã để xác thực đăng ký tài khoản.'),
//                           ],
//                         ),
//                       ),
//                       //
//                       const Padding(padding: EdgeInsets.only(top: 30)),
//                       PinCodeInput(
//                         controller: otpController,
//                         onChanged: provider.onChangePinCode,
//                         clBorderErr: provider.otpError != null
//                             ? DefaultTheme.error700
//                             : null,
//                         error: provider.otpError != null ? true : false,
//                       ),
//                       Text(
//                         provider.otpError ?? '',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w400,
//                           height: 20 / 12,
//                           color: DefaultTheme.error700,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 ValueListenableBuilder(
//                   valueListenable: countdownProvider,
//                   builder: (_, value, child) {
//                     return (value != 0)
//                         ? RichText(
//                             textAlign: TextAlign.center,
//                             text: TextSpan(
//                               style: TextStyle(
//                                 color: Theme.of(context).hintColor,
//                                 fontSize: 15,
//                               ),
//                               children: [
//                                 const TextSpan(
//                                     text: 'Mã OTP có hiệu lực trong vòng '),
//                                 TextSpan(
//                                   text: value.toString(),
//                                   style: const TextStyle(
//                                       color: DefaultTheme.GREEN),
//                                 ),
//                                 const TextSpan(text: 's.'),
//                               ],
//                             ),
//                           )
//                         : RichText(
//                             textAlign: TextAlign.center,
//                             text: TextSpan(
//                               style: TextStyle(
//                                 color: Theme.of(context).hintColor,
//                                 fontSize: 15,
//                               ),
//                               children: [
//                                 const TextSpan(
//                                     text: 'Không nhận được mã OTP? '),
//                                 countdownProvider.resendOtp <= 0
//                                     ? const TextSpan()
//                                     : TextSpan(
//                                         text:
//                                             'Gửi lại (${countdownProvider.resendOtp})',
//                                         style: const TextStyle(
//                                           decoration: TextDecoration.underline,
//                                           color: DefaultTheme.GREEN,
//                                         ),
//                                         recognizer: TapGestureRecognizer()
//                                           ..onTap = () async {
//                                             countdownProvider.resendCountDown();
//                                             otpController.clear();
//                                             await Provider.of<RegisterProvider>(
//                                                     context,
//                                                     listen: false)
//                                                 .phoneAuthentication(
//                                                     widget.phone);
//                                           },
//                                       ),
//                               ],
//                             ),
//                           );
//                   },
//                 ),
//                 const Padding(padding: EdgeInsets.only(top: 10)),
//                 ButtonWidget(
//                   width: width,
//                   text: 'Xác thực',
//                   textColor: DefaultTheme.WHITE,
//                   bgColor: provider.isButton
//                       ? DefaultTheme.GREEN
//                       : DefaultTheme.GREY_444B56,
//                   function: () async {
//                     final data = await Provider.of<RegisterProvider>(context,
//                             listen: false)
//                         .verifyOTP(otpController.text, () {
//                       provider.updateLoading(true);
//                     });
//
//                     if (data is bool) {
//                       if (!mounted) return;
//                       provider.updateLoading(false);
//                       context
//                           .read<RegisterBloc>()
//                           .add(RegisterEventSubmit(dto: widget.dto));
//                     } else if (data is String) {
//                       provider.onOtpSubmit(data, () {
//                         countdownProvider.setValue(0);
//                       });
//                     }
//                   },
//                 ),
//                 const Padding(padding: EdgeInsets.only(bottom: 10)),
//               ],
//             ),
//             Visibility(
//               visible: provider.isLoading,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 alignment: Alignment.center,
//                 child: const Center(
//                   child: CircularProgressIndicator(
//                     color: DefaultTheme.GREEN,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }
// }
