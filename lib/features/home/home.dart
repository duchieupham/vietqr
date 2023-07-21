import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/services/providers/account_balance_home_provider.dart';

import 'blocs/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  //page controller
  late PageController _pageController;

  //list page
  final List<Widget> _homeScreens = [];

  //focus node
  final FocusNode focusNode = FocusNode();

  //blocs
  late HomeBloc _homeBloc;

  NationalScannerDTO? identityDTO;

  //providers
  final AccountBalanceHomeProvider accountBalanceHomeProvider =
      AccountBalanceHomeProvider('');

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text('home page'),
    );
  }
}
