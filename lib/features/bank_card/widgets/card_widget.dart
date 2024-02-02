import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/features/popup_bank/popup_bank_screen.dart';
import 'package:vierqr/features/bank_detail/bank_card_detail_screen.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class CardWidget extends StatelessWidget {
  final List<BankAccountDTO> listBanks;
  final int index;
  final GestureTapCallback? onLinked;

  const CardWidget({
    super.key,
    required this.listBanks,
    required this.index,
    this.onLinked,
  });

  String get userId => UserHelper.instance.getUserId();

  double get heightCard => 120;

  double get paddingTop => 12;

  double get paddingIconCheck => 4;

  double get radius => 12;

  double get heightInfoCard => 50;

  double get widthInfoCard => 90;

  double get sizeIconCheck => 16;

  @override
  Widget build(BuildContext context) {
    bool isFirst = (index != 0);
    bool isLast = (index == listBanks.length - 1);
    BankAccountDTO e = listBanks[index];
    return Hero(
      tag: 'Card_$index',
      flightShuttleBuilder: (flightContext, animation, flightDirection,
          fromHeroContext, toHeroContext) {
        // Tạo và trả về một widget mới để tham gia vào hiệu ứng chuyển động
        const Curve curve = Curves.easeInOut;
        var opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve,
          ),
        );
        return Opacity(
          opacity: opacityAnimation.value,
          child: toHeroContext.widget,
        );
      },
      child: GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BankCardDetailScreen(bankId: e.id),
              settings: const RouteSettings(
                name: Routes.BANK_CARD_DETAIL_VEW,
              ),
            ),
          );
        },
        child: Container(
          height: isLast ? (heightCard - paddingTop) : heightCard,
          padding: EdgeInsets.only(top: paddingTop),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: isFirst ? Colors.white : Colors.transparent),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: e.bankColor,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: widthInfoCard,
                          height: heightInfoCard,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: widthInfoCard - 10,
                                  height: heightInfoCard - 10,
                                  decoration: BoxDecoration(
                                    color: AppColor.WHITE,
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: ImageUtils.instance
                                          .getImageNetWork(e.imgId),
                                    ),
                                  ),
                                ),
                              ),
                              if (e.isAuthenticated && e.isOwner)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Image.asset(
                                    'assets/images/ic-authenticated-bank.png',
                                    width: 28,
                                  ),
                                ),
                              if (!e.isOwner)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Image.asset(
                                    'assets/images/ic-shared-bank.png',
                                    width: 28,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Container(
                            height: heightInfoCard,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: heightInfoCard - 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.bankAccount,
                                        style: TextStyle(
                                            color: AppColor.WHITE,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        e.userBankName.toUpperCase(),
                                        style: TextStyle(
                                          color: AppColor.WHITE,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          allowSnapshotting: false,
                          builder: (context) => PopupBankScreen(
                              tag: 'Card_$index', dto: e, index: index),
                          settings: RouteSettings(name: ''),
                        ),
                      );
                    },
                    onLongPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          allowSnapshotting: false,
                          builder: (context) => PopupBankScreen(
                              tag: 'Card_$index', dto: e, index: index),
                          settings: RouteSettings(name: ''),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/ic-more-in-list.png'))),
                    ),
                  ),
                ),
                if (e.isLinked)
                  Positioned(
                    right: 8,
                    bottom: isLast ? (28 - paddingTop) : 28,
                    child: GestureDetector(
                      onTap: onLinked,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColor.BLUE_TEXT,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/ic-linked-bank-in-list.png',
                              width: 24,
                              height: 24,
                            ),
                            Text(
                              'Liên kết ngay',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColor.WHITE,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
