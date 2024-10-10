import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
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
  const VerifyEmailScreen(
      {super.key, required this.email, this.isUpdate = false});

  final String email;
  final bool isUpdate;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
  static String routeName = '/verify_email';
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final EmailBloc _bloc = getIt.get<EmailBloc>();
  final _emailController = TextEditingController();

  bool showBlueContainer = false;
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  UserProfile get userProfile => SharePrefUtils.getProfile();
  bool _confirmOTP = true;

  void initialServices() {
    if (widget.email.isNotEmpty) {
      _emailController.text = widget.email;
    } else {
      if (userProfile.email.isNotEmpty && _emailController.text.isEmpty) {
        _emailController.value =
            _emailController.value.copyWith(text: userProfile.email);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        initialServices();
      },
    );
  }

  @override
  void dispose() {
    // _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailBloc, EmailState>(
      bloc: _bloc,
      listener: (context, state) async {
        if (state is SendOTPState) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state is SendOTPSuccessfulState) {
          _confirmOTP = true;
          if (_pageIndex == 0) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
          Navigator.of(context).pop();
        }
        if (state is SendOTPSuccessfulState && _pageIndex == 1) {
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
          //  if (widget.isUpdate) {
          //   UserProfile profile = SharePrefUtils.getProfile();
          //   profile.email = _emailController.text;
          //   await SharePrefUtils.saveProfileToCache(profile);
          //   NavigatorUtils.navigateToRoot(context);
          // } else {
          //   Navigator.of(context).pop();
          // }
        }
        if (state is ConfirmOTPStateFailedState) {
          _confirmOTP = false;
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
          _confirmOTP = false;
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
            backgroundColor: _pageIndex == 2 ? Colors.white : null,
            flexibleSpace: _pageIndex == 2
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
                if (_pageIndex == 1) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else if (_pageIndex == 0 || _pageIndex == 2) {
                  Navigator.of(context).pop();
                }
                // Navigator.of(context).pop();
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
            onPageChanged: (value) {
              setState(() {
                _pageIndex = value;
                showBlueContainer = value == 1;
              });
            },
            children: [
              EmailInputPage(
                emailController: _emailController,
                onContinue: () {
                  Map<String, dynamic> param = {
                    'recipient': _emailController.text,
                    'userId': SharePrefUtils.getProfile().userId,
                  };
                  _bloc.add(SendOTPEvent(param: param));
                },
              ),
              OTPInputPage(
                confirmOTP: _confirmOTP,
                // otpController: _otpController,
                email: _emailController.text,
                sendOTP: () {
                  Map<String, dynamic> param = {
                    'recipient': _emailController.text,
                    'userId': SharePrefUtils.getProfile().userId,
                  };
                  _bloc.add(SendOTPEvent(param: param));
                },
                onContinue: (otp) {
                  Map<String, dynamic> param = {
                    'otp': otp,
                    'userId': SharePrefUtils.getProfile().userId,
                    'email': _emailController.text,
                  };
                  _bloc.add(ConfirmOTPEvent(param: param));
                },
              ),
              VerifyEmailSuccessScreen(
                email: _emailController.text,
                onContinue: () {
                  NavigatorUtils.navigateToRoot(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
