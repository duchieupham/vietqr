import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/customer_va/repositories/customer_va_repository.dart';
import 'package:vierqr/features/customer_va/widgets/customer_va_header_widget.dart';
import 'package:vierqr/features/merchant/create_merchant_screen.dart';
import 'package:vierqr/features/merchant/merchant_screen.dart';
import 'package:vierqr/models/customer_va_item_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class CustomerVaListView extends StatefulWidget {
  CustomerVaListView({super.key});

  @override
  State<StatefulWidget> createState() => _CustomerVaListView();
}

class _CustomerVaListView extends State<CustomerVaListView> {
  final CustomerVaRepository customerVaRepository =
      const CustomerVaRepository();

  List<CustomerVAItemDTO> _customerVas = [];

  @override
  void initState() {
    super.initState();
    _getCustomerVas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      appBar: CustomerVaHeaderWidget(),
      bottomNavigationBar: _bottom(),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              'Quản lý thu hộ\nqua tài khoản định danh',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: (_customerVas.isEmpty)
                ? ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      //
                    ],
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    shrinkWrap: true,
                    itemCount: _customerVas.length,
                    itemBuilder: (context, index) {
                      return _buildCustomerVaItem(_customerVas[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _bottom() {
    return ButtonWidget(
      text: 'Thêm mới doanh nghiệp',
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      textColor: AppColor.WHITE,
      bgColor: AppColor.BLUE_TEXT,
      borderRadius: 5,
      function: () {
        Navigator.pushReplacementNamed(
            context, Routes.INSERT_CUSTOMER_VA_MERCHANT);
      },
    );
  }

  Widget _buildCustomerVaItem(CustomerVAItemDTO dto) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color(0xFFDADADA),
        ),
      ),
      child: InkWell(
        onTap: () {
          NavigatorUtils.navigatePage(
              context,
              MerchantScreen(
                customerId: dto.customerId,
                bankId: dto.id,
              ),
              routeName: CreateMerchantScreen.routeName);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Doanh nghiệp / Tổ chức',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColor.BLUE_TEXT,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    dto.merchantName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Tài khoản liên kết',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'BIDV - ' + dto.bankAccount,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            if (dto.unpaidInvoiceAmount != 0) ...[
              const MySeparator(color: AppColor.GREY_DADADA),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 20),
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ic-invoice-black-v2.png',
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('01 hoá đơn chưa thanh toán'),
                    const Spacer(),
                    Text(
                      CurrencyUtils.instance.getCurrencyFormatted(
                          dto.unpaidInvoiceAmount.toString()),
                      style: const TextStyle(
                        color: AppColor.ORANGE_DARK,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text('VND'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _getCustomerVas() async {
    String userId = SharePrefUtils.getProfile().userId;
    _customerVas = await customerVaRepository.getCustomerVasByUserId(userId);
    setState(() {});
  }
}
