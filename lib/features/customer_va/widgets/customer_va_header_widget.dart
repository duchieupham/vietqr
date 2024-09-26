import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/services/providers/customer_va/customer_va_insert_provider.dart';

class CustomerVaHeaderWidget extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const CustomerVaHeaderWidget({
    super.key,
  }) : preferredSize = const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        leadingWidth: 120,
        leading: SizedBox(
          width: 120,
          child: InkWell(
            onTap: () => _handleBack(context),
            child: const Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: AppColor.BLACK,
                ),
                Text(
                  'Trở về',
                  style: TextStyle(
                    color: AppColor.BLACK,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Provider.of<CustomerVaInsertProvider>(context, listen: false)
                  .doInit();
            },
            child: Container(
              width: 80,
              height: 40,
              margin: const EdgeInsets.only(right: 20),
              child: CachedNetworkImage(
                imageUrl: Provider.of<AuthenProvider>(context, listen: false)
                    .settingDTO
                    .logoUrl,
                height: 40,
              ),
            ),
          ),
        ],
      ),
      //
    );
  }

  _handleBack(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }
}
