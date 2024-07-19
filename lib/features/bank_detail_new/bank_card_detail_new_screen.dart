import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/helper/app_data_helper.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/measure_size.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/states/bank_card_state.dart';
import 'package:vierqr/features/bank_detail_new/views/detail_bank_card_screen.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/qr_bank_detail.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/account_bank_detail_provider.dart';

import 'widgets/index.dart';

class BankCardDetailNewScreen extends StatefulWidget {
  final String bankId;
  final bool isLoading;

  static String routeName = '/bank_card_detail_screen';

  const BankCardDetailNewScreen({
    super.key,
    required this.bankId,
    this.isLoading = true,
  });

  @override
  State<BankCardDetailNewScreen> createState() =>
      _BankCardDetailNewStateState();
}

class _BankCardDetailNewStateState extends State<BankCardDetailNewScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context) => AccountBankDetailProvider(),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            DetailBankCardScreen(
              selectedIndex: _selectedIndex,
              onSelectTab: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              bankId: widget.bankId,
              isLoading: widget.isLoading,
            ),
            BottomBarWidget(width: width),
          ],
        ),
      ),
    );
  }
}
