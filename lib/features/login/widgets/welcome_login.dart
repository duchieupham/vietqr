import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/features/login/login_screen.dart';
import 'package:vierqr/navigator/app_navigator.dart';

class WelcomeLoginScreen extends StatefulWidget {
  const WelcomeLoginScreen({Key? key}) : super(key: key);

  @override
  _WelcomeLoginScreenState createState() => _WelcomeLoginScreenState();
}

class _WelcomeLoginScreenState extends State<WelcomeLoginScreen> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        _isAnimated = true;
      });
    });
    Future.delayed(const Duration(seconds: 2), () {
      NavigationService.pushAndRemoveUntil(Routes.LOGIN);
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //       builder: (context) => const LoginScreen(),
      //       settings: const RouteSettings(
      //         name: Routes.LOGIN,
      //       )),
      //   (Route<dynamic> route) => false,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            bottom: _isAnimated
                ? MediaQuery.of(context).size.height / 2
                : MediaQuery.of(context).size.height / 2.5,
            left: 0,
            right: 0,
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'VietQR VN xin chào',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // This will be the gradient color
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
