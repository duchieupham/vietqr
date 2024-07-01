import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/account/account_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/qr_wallet/widgets/app_bar_widget.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class QrWalletScreen extends StatefulWidget {
  const QrWalletScreen({super.key});

  @override
  State<QrWalletScreen> createState() => _QrWalletScreenState();
}

class _QrWalletScreenState extends State<QrWalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          const SliverPersistentHeader(
            delegate: CustomSliverAppBarDelegate(expandedHeight: 200),
            pinned: true,
          ),
          // SliverAppBar(
          //   backgroundColor: AppColor.WHITE,
          //   elevation: 0.0,
          //   pinned: false,
          //   leadingWidth: 60,
          //   expandedHeight: 50,
          //   leading: _buildAvatar(),
          //   actions: [
          //     Padding(
          //       padding: const EdgeInsets.only(right: 20),
          //       child: Image.asset(
          //         AppImages.icLogoVietQr,
          //         width: 95,
          //         fit: BoxFit.fitWidth,
          //       ),
          //     )
          //   ],
          // ),
          // SliverAppBar(
          //   backgroundColor: AppColor.WHITE,
          //   elevation: 0.0,
          //   pinned: true,
          //   expandedHeight: 100,
          //   flexibleSpace: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       InkWell(
          //         onTap: () {},
          //         child: Container(
          //           width: 100,
          //           height: 30,
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(30),
          //               border: Border.all(color: AppColor.BLUE_TEXT)),
          //         ),
          //       ),
          //     ],
          //   ),

          // ),
          SliverList(
              delegate: SliverChildListDelegate(<Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(),
                  // productTitle(),

                  // _buidProductRecomend(),
                  // tabCompination()
                ],
              ),
            ),
          ]))
          // SliverToBoxAdapter(
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     // height: MediaQuery.of(context).size.height,
          //     // child: Column(
          //     //   children: [],
          //     // ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    String imgId = SharePrefUtils.getProfile().imgId;
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () => NavigatorUtils.navigatePage(
                context, const AccountScreen(),
                routeName: AccountScreen.routeName),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: provider.avatarUser.path.isEmpty
                      ? imgId.isNotEmpty
                          ? ImageUtils.instance.getImageNetWork(imgId)
                          : Image.asset('assets/images/ic-avatar.png').image
                      : Image.file(provider.avatarUser).image,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
