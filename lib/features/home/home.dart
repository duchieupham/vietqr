import 'package:flutter/material.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/features/dashboard/widget/background_app_bar_home.dart';
import 'package:vierqr/features/home/widget/card_wallet.dart';
import 'package:vierqr/features/home/widget/service_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          eventBus.fire(ReloadWallet());
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: const [
            // BackgroundAppBarHome(),
            CardWallet(),
            SizedBox(height: 30),
            ServiceSection(),
          ],
        ),
      ),
    );
  }
}
