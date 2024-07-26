import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/verify_email/blocs/verify_email_bloc.dart';
import 'package:vierqr/features/verify_email/events/verify_email_event.dart';
import 'package:vierqr/features/verify_email/states/verify_email_state.dart';
import 'package:vierqr/features/verify_email/views/confirm_email.dart';
import 'package:vierqr/features/verify_email/views/confirm_otp.dart';
import 'package:vierqr/features/verify_email/views/verify_email_success.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/user_profile.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
  static String routeName = '/verify_email';
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final EmailBloc _bloc = getIt.get<EmailBloc>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool showBlueContainer = false;
  final PageController _pageController = PageController();
  bool _confirmOTP = true;

  void initialServices(BuildContext context) {
    final UserProfile accountInformationDTO = SharePrefUtils.getProfile();
    if (accountInformationDTO.email.isNotEmpty &&
        _emailController.text.isEmpty) {
      _emailController.value =
          _emailController.value.copyWith(text: accountInformationDTO.email);
    }
  }

  @override
  void initState() {
    super.initState();
    initialServices(context);
    _pageController.addListener(() {
      setState(() {
        showBlueContainer = _pageController.page == 1;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailBloc, EmailState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is SendOTPSuccessfulState && _pageController.page == 0) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (state is SendOTPSuccessfulState && _pageController.page == 1) {
          Fluttertoast.showToast(
            msg: 'Gửi mã OTP thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }
        if (state is SendOTPFailedState) {
          Fluttertoast.showToast(
            msg: 'Gửi mã OTP thất bại',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }
        if (state is ConfirmOTPStateSuccessfulState) {
          Fluttertoast.showToast(
            msg: 'Xác nhận OTP thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          getIt.get<DashBoardBloc>().add(GetUserInformation());
          // getIt.get<BankBloc>().add(GetVerifyEmail());
          // print(SharePrefUtils.getProfile().verify);
        }
        if (state is ConfirmOTPStateFailedState) {
          setState(() {
            _confirmOTP = false;
          });
          Fluttertoast.showToast(
            msg: 'Xác nhận OTP thất bại',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }

        if (state is ConfirmOTPStateFailedTimeOutState) {
          setState(() {
            _confirmOTP = false;
          });
          Fluttertoast.showToast(
            msg: 'Mã OTP đã hết hiệu lực',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 120,
            elevation: 0,
            backgroundColor:
                _pageController.hasClients && _pageController.page == 2
                    ? Colors.white
                    : null,
            flexibleSpace:
                _pageController.hasClients && _pageController.page == 2
                    ? null
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
            leading: GestureDetector(
              onTap: () {
                // if (_pageController.page == 1) {
                //   _pageController.previousPage(
                //     duration: const Duration(milliseconds: 300),
                //     curve: Curves.easeInOut,
                //   );
                // } else if (_pageController.page == 0) {
                //   Navigator.of(context).pop();
                // }
                Navigator.of(context).pop();
              },
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  Text('Trở về'),
                ],
              ),
            ),
            actions: [
              if (showBlueContainer)
                const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: XImage(
                    imagePath: 'assets/images/logo-email.png',
                    width: 40,
                  ),
                ),
            ],
          ),
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              EmailInputPage(
                emailController: _emailController,
                onContinue: () {
                  Map<String, dynamic> param = {
                    'recipient': _emailController.text,
                    'userId': SharePrefUtils.getProfile().userId,
                  };
                  _bloc.add(SendOTPEvent(param: param));
                  // _pageController.nextPage(
                  //   duration: const Duration(milliseconds: 300),
                  //   curve: Curves.easeInOut,
                  // );
                },
              ),
              OTPInputPage(
                confirmOTP: _confirmOTP,
                otpController: _otpController,
                email: _emailController.text,
                sendOTP: () {
                  Map<String, dynamic> param = {
                    'recipient': _emailController.text,
                    'userId': SharePrefUtils.getProfile().userId,
                  };
                  _bloc.add(SendOTPEvent(param: param));
                },
                onContinue: () {
                  Map<String, dynamic> param = {
                    'otp': _otpController.text,
                    'userId': SharePrefUtils.getProfile().userId,
                    'email': _emailController.text,
                  };
                  _bloc.add(ConfirmOTPEvent(param: param));
                  // _pageController.nextPage(
                  //   duration: const Duration(milliseconds: 300),
                  //   curve: Curves.easeInOut,
                  // );
                },
              ),
              VerifyEmailSuccessScreen(
                email: _emailController.text,
                onContinue: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
