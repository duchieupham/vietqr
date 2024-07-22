import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/verify_email/blocs/verify_email_bloc.dart';
import 'package:vierqr/features/verify_email/events/verify_email_event.dart';
import 'package:vierqr/features/verify_email/views/confirm_email.dart';
import 'package:vierqr/features/verify_email/views/confirm_otp.dart';
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
  late EmailBloc emailBloc;
  final _emailController = TextEditingController();
  bool showBlueContainer = false;
  final PageController _pageController = PageController();

  // Future<bool> _onWillPop() async {
  //   if (_pageController.page == 1) {
  //     _pageController.previousPage(
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeInOut,
  //     );
  //     return false;
  //   }
  //   return true;
  // }

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
    emailBloc = BlocProvider.of(context);
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
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
        elevation: 0,
        flexibleSpace: Container(
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
                'recipient': _emailController,
                'userId': SharePrefUtils.getProfile().userId,
              };
              emailBloc.add(SendOTPEvent(param: param));
              // _pageController.nextPage(
              //   duration: const Duration(milliseconds: 300),
              //   curve: Curves.easeInOut,
              // );
            },
          ),
          OTPInputPage(
            email: _emailController.text,
            onContinue: () {},
          ),
        ],
      ),
    );
  }
}
