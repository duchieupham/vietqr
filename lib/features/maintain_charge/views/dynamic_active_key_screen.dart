import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/maintain_charge/blocs/maintain_charge_bloc.dart';

import '../../../commons/constants/configurations/app_images.dart';
import '../../../commons/constants/configurations/route.dart';
import '../states/maintain_charge_state.dart';

class DynamicActiveKeyScreen extends StatelessWidget {
  const DynamicActiveKeyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaintainChargeBloc>(
      create: (context) => MaintainChargeBloc(context),
      child: Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MaintainChargeBloc, MaintainChargeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.WHITE,
          resizeToAvoidBottomInset: false,
          body: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: false,
                leadingWidth: 100,
                leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.DASHBOARD, (route) => false);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.black,
                          size: 25,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          "Trở về",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.asset(
                      AppImages.icLogoVietQr,
                      width: 95,
                      fit: BoxFit.fitWidth,
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
