import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/customer_va/repositories/customer_va_repository.dart';
import 'package:vierqr/models/customer_va_item_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class CustomerVaSplashView extends StatefulWidget {
  const CustomerVaSplashView({super.key});

  @override
  State<StatefulWidget> createState() => _CustomerVaSplashView();
}

class _CustomerVaSplashView extends State<CustomerVaSplashView> {
  final CustomerVaRepository customerVaRepository =
      const CustomerVaRepository();

  @override
  void initState() {
    super.initState();
    _navigateScreen();
  }

  void _navigateScreen() async {
    String userId = SharePrefUtils.getProfile().userId;
    List<CustomerVAItemDTO> customerVas =
        await customerVaRepository.getCustomerVasByUserId(userId);
    if (customerVas.isEmpty) {
      await Future.delayed((const Duration(milliseconds: 1000)), () {
        Navigator.pushReplacementNamed(
            context, Routes.INSERT_CUSTOMER_VA_MERCHANT);
      });
    } else {
      await Future.delayed((const Duration(milliseconds: 1000)), () {
        Navigator.pushReplacementNamed(context, Routes.CUSTOMER_VA_LIST);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      // appBar: CustomerVaHeaderWidget(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/ic-invoice-3D.png',
              width: 150,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 50)),
          const Center(
            child: Text(
              'Đang tải dữ liệu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
