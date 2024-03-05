import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/create_order_merchant/create_oder.dart';
import 'package:vierqr/features/merchant/merchant.dart';
import 'package:vierqr/features/merchant/tab_merchant/tab_info_merchant.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/merchant_dto.dart';

import 'tab_merchant/tab_order_merchant.dart';

class MerchantScreen extends StatefulWidget {
  final MerchantDTO? merchantDTO;

  const MerchantScreen({super.key, this.merchantDTO});

  @override
  State<MerchantScreen> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  final List<MerchantTab> listTab = [
    MerchantTab('Thông tin', 0),
    MerchantTab('Hoá đơn', 1),
  ];

  int tabSelect = 0;

  late MerchantBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = MerchantBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title: 'Đại lý'),
      body: BlocProvider<MerchantBloc>(
        create: (context) => bloc,
        child: BlocConsumer<MerchantBloc, MerchantState>(
          listener: (context, state) {
            if (state.status == BlocStatus.LOADING_PAGE) {
              DialogWidget.instance.openLoadingDialog();
            }

            if (state.status == BlocStatus.UNLOADING) {
              Navigator.pop(context);
            }

            if (state.request == MerchantType.UNREGISTER_MERCHANT) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.BLUE_TEXT),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        listTab.length,
                        (index) {
                          MerchantTab tab = listTab[index];
                          return _buildItemTab(tab, tabSelect == tab.type);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(child: _buildBody()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (tabSelect == 0) {
      return TabInfoMerchant(
        merchantDTO: widget.merchantDTO,
        onCreateOder: onCreateOrder,
        onUnRegister: () {},
      );
    }
    return TabOrderMerchant(customerId: widget.merchantDTO?.customerId ?? '');
  }

  void onCreateOrder() {
    NavigatorUtils.navigatePage(context,
        CreateOrderScreen(customerId: widget.merchantDTO?.customerId ?? ''),
        routeName: CreateOrderScreen.routeName);
  }

  Widget _buildItemTab(MerchantTab tab, bool select) {
    return GestureDetector(
      onTap: () => setState(() {
        tabSelect = tab.type;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              select ? AppColor.BLUE_TEXT.withOpacity(0.3) : Colors.transparent,
        ),
        child: Text(
          tab.name,
          style: TextStyle(color: AppColor.BLUE_TEXT),
        ),
      ),
    );
  }
}

class MerchantTab {
  final String name;
  final int type;

  MerchantTab(this.name, this.type);
}
