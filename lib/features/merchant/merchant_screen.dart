import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/customer_va/widgets/customer_va_header_widget.dart';
import 'package:vierqr/features/merchant/merchant.dart';
import 'package:vierqr/features/merchant/tab_merchant/tab_info_merchant.dart';
import 'package:vierqr/layouts/m_app_bar.dart';

import '../../commons/utils/navigator_utils.dart';
import '../create_order_merchant/create_oder.dart';
import 'tab_merchant/tab_order_merchant.dart';

class MerchantScreen extends StatefulWidget {
  final String customerId;
  final String bankId;

  const MerchantScreen({
    super.key,
    required this.customerId,
    required this.bankId,
  });

  @override
  State<MerchantScreen> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  final List<MerchantTab> listTab = [
    MerchantTab('Thông tin', 0),
    MerchantTab('Danh sách hóa đơn', 1),
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
      appBar: CustomerVaHeaderWidget(),
      backgroundColor: AppColor.WHITE,
      floatingActionButton: _createInvoiceButton(),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  // width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      listTab.length,
                      (index) {
                        MerchantTab tab = listTab[index];
                        return Row(
                          children: [
                            _buildItemTab(tab, tabSelect == tab.type),
                            const SizedBox(width: 8)
                          ],
                        );
                      },
                    ),
                  ),
                ),
                // Center(
                //   child: Container(
                //     padding:
                //         const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(8),
                //       border: Border.all(color: AppColor.BLUE_TEXT),
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: List.generate(
                //         listTab.length,
                //         (index) {
                //           MerchantTab tab = listTab[index];
                //           return _buildItemTab(tab, tabSelect == tab.type);
                //         },
                //       ),
                //     ),
                //   ),
                // ),
                Expanded(child: _buildBody()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _createInvoiceButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: 150,
      height: 50,
      margin: const EdgeInsets.only(bottom: 10, right: 5),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 4,
        onPressed: () {
          NavigatorUtils.navigatePage(
              context, CreateOrderScreen(customerId: widget.customerId),
              routeName: CreateOrderScreen.routeName);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          // side: BorderSide(color: Colors.red),
        ),
        child: Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.BLUE_TEXT,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_sharp,
                color: AppColor.WHITE,
                size: 15,
              ),
              const SizedBox(width: 2),
              Text(
                'Tạo hóa đơn',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.WHITE,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (tabSelect == 0) {
      return TabInfoMerchant(
        customerId: widget.customerId,
        bankId: widget.bankId,
      );
    }
    return TabOrderMerchant(customerId: widget.customerId);
  }

  Widget _buildItemTab(MerchantTab tab, bool select) {
    return InkWell(
      onTap: () {
        setState(() {
          tabSelect = tab.type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color:
                select ? AppColor.BLUE_TEXT.withOpacity(0.2) : AppColor.WHITE,
            border: Border.all(
              color: select ? AppColor.WHITE : AppColor.GREY_DADADA,
            ),
            borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: Text(tab.name,
              style: TextStyle(
                  color: select ? AppColor.BLUE_TEXT : AppColor.BLACK)),
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
